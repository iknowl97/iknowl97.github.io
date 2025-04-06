```xml
<Prompt>
  <AgentName>AutoRDPMonitoringDocker</AgentName>
  <OriginalPrompt>
    ```xml
    <Prompt>
      <AgentName>AutoRDPMonitoringDocker</AgentName>
      <Goal>Generate a comprehensive, fully functional, and executable `setup.sh` script that automates the creation of a Dockerized RDP health monitoring system. This script should establish the necessary directory structure, populate all files (Dockerfiles, scripts, `docker-compose.yml`, database initialization), configure file permissions, and provide a simplified guide for running the complete system. The solution must provide multiple methods for checking RDP connections and reporting errors.</Goal>
      <Context>
        The user requires a fully automated, Docker-based solution for RDP health monitoring. The solution must:
        1.  Periodically check RDP server login status.
        2.  Employ multiple methods for checking RDP connectivity (shell script, Python script, etc.) to ensure reliability.
        3.  Log connection attempts, results, and detailed error messages to a database.
        4.  Present the logged data in a simple dashboard.
        5.  Ignore certificate issues encountered during RDP connections.
        6.  Be completely automated, requiring minimal manual intervention to deploy.
        7.  Provide a clear and concise guide for running the system after setup.

        The target RDP server is `demo.fina.ge:2400`, username `scheduledchecker`, password `ch3ckerScheduler`.
      </Context>
      <Instructions>
        <Section name="Script Structure and Requirements">
          1.  The `setup.sh` script should be a self-contained executable that performs all necessary steps for setting up the RDP monitoring system.
          2.  The script should create all required directories and subdirectories.
          3.  The script should generate all necessary files with the correct content (Dockerfiles, scripts, `docker-compose.yml`, database initialization files, etc.).
          4.  The script should set appropriate file permissions, especially for executable scripts.
          5.  The script should provide clear instructions on how to run the system after the setup is complete.
          6.  The script should include basic error handling (e.g., checking if directories exist before creating them).
        </Section>

        <Section name="Directory and File Layout">
          1.  The script should create the following directory structure:
              ```
              rdp-monitor/
              ├── docker-compose.yml
              ├── rdp-checker/
              │   ├── Dockerfile
              │   ├── check_rdp.sh
              │   ├── check_rdp.py
              │   ├── requirements.txt
              │   └── crontab
              ├── database/
              │   └── init.sql
              ├── dashboard/
              │   ├── Dockerfile
              │   ├── app.py
              │   ├── requirements.txt
              │   └── templates/
              │       └── index.html
              └── setup.sh (this script)
              ```
        </Section>

        <Section name="File Content Generation">
          1.  The script must generate the following files with the specified content:
              *   **rdp-monitor/docker-compose.yml:**
                  ```yaml
                  version: '3'

                  services:
                    rdp-checker:
                      build: ./rdp-checker
                      environment:
                        - RDP_SERVER=demo.fina.ge
                        - RDP_PORT=2400
                        - RDP_USERNAME=scheduledchecker
                        - RDP_PASSWORD=ch3ckerScheduler
                        - DATABASE_URL=postgresql://rdpmonitor:rdpmonitorpassword@database:5432/rdp_logs
                      depends_on:
                        - database
                      restart: always

                    database:
                      image: postgres
                      environment:
                        - POSTGRES_USER=rdpmonitor
                        - POSTGRES_PASSWORD=rdpmonitorpassword
                        - POSTGRES_DB=rdp_logs
                      volumes:
                        - pg-data:/var/lib/postgresql/data

                    dashboard:
                      build: ./dashboard
                      ports:
                        - "5000:5000"
                      environment:
                        - DATABASE_URL=postgresql://rdpmonitor:rdpmonitorpassword@database:5432/rdp_logs
                      depends_on:
                        - database
                      restart: always

                  volumes:
                    pg-data:
                  ```

              *   **rdp-checker/Dockerfile:**
                  ```dockerfile
                  FROM python:3.9-slim

                  # Install necessary packages
                  RUN apt-get update && apt-get install -y freerdp2-x11 postgresql-client cron

                  # Copy the RDP checking scripts
                  COPY check_rdp.sh /app/check_rdp.sh
                  COPY check_rdp.py /app/check_rdp.py
                  COPY crontab /etc/cron.d/rdp-checker-cron

                  # Make the scripts executable
                  RUN chmod +x /app/check_rdp.sh /app/check_rdp.py

                  # Install Python dependencies
                  COPY requirements.txt /app/requirements.txt
                  RUN pip install -r /app/requirements.txt

                  # Set the working directory
                  WORKDIR /app

                  # Set up cron
                  RUN chmod 0644 /etc/cron.d/rdp-checker-cron && cron

                  # Run the RDP checker
                  CMD ["cron", "-f"]
                  ```

              *   **rdp-checker/check_rdp.sh:**
                  ```bash
                  #!/bin/bash

                  RDP_SERVER=${RDP_SERVER:-demo.fina.ge}
                  RDP_PORT=${RDP_PORT:-2400}
                  RDP_USERNAME=${RDP_USERNAME:-scheduledchecker}
                  RDP_PASSWORD=${RDP_PASSWORD:-ch3ckerScheduler}

                  xfreerdp /v:$RDP_SERVER:$RDP_PORT /u:$RDP_USERNAME /p:$RDP_PASSWORD /cert-ignore > /tmp/rdp_check.log 2>&1

                  if [ $? -eq 0 ]; then
                      echo "Success"
                  else
                      echo "Failure"
                  fi

                  exit 0
                  ```

              *   **rdp-checker/check_rdp.py:**
                  ```python
                  import os
                  import subprocess
                  import psycopg2
                  from datetime import datetime

                  RDP_SERVER = os.environ['RDP_SERVER']
                  RDP_PORT = os.environ['RDP_PORT']
                  RDP_USERNAME = os.environ['RDP_USERNAME']
                  RDP_PASSWORD = os.environ['RDP_PASSWORD']
                  DATABASE_URL = os.environ['DATABASE_URL']

                  def check_rdp():
                      try:
                          # Using xfreerdp to check RDP connection
                          command = f"xfreerdp /v:{RDP_SERVER}:{RDP_PORT} /u:{RDP_USERNAME} /p:{RDP_PASSWORD} /cert-ignore"
                          result = subprocess.run(command, shell=True, capture_output=True, text=True)
                          if result.returncode == 0:
                              return True, "Connection successful"
                          else:
                              return False, result.stderr
                      except subprocess.CalledProcessError as e:
                          return False, str(e)

                  def log_result(success, error_message):
                      try:
                          conn = psycopg2.connect(DATABASE_URL)
                          c = conn.cursor()
                          c.execute('''CREATE TABLE IF NOT EXISTS rdp_logs
                                       (timestamp timestamp, success boolean, error_message text, server text, port integer, username text)''')
                          c.execute("INSERT INTO rdp_logs (timestamp, success, error_message, server, port, username) VALUES (%s, %s, %s, %s, %s, %s)",
                                    (datetime.now(), success, error_message, RDP_SERVER, int(RDP_PORT), RDP_USERNAME))
                          conn.commit()
                          conn.close()
                      except Exception as e:
                          print(f"Database error: {e}")

                  if __name__ == "__main__":
                      success, error_message = check_rdp()
                      log_result(success, error_message)
                      if not success:
                          print(f"RDP check failed: {error_message}")
                      else:
                          print("RDP check successful")
              ```

              *   **rdp-checker/requirements.txt:**
                  ```
                  psycopg2-binary
                  ```

              *   **rdp-checker/crontab:**
                  ```cron
                  */5 * * * * python /app/check_rdp.py >> /app/cron.log 2>&1
                  ```

              *   **database/init.sql:**
                  ```sql
                  -- Database initialization is handled by the Python script
                  ```

              *   **dashboard/Dockerfile:**
                  ```dockerfile
                  FROM python:3.9-slim

                  # Copy the dashboard application
                  COPY . /app

                  # Install dependencies
                  RUN pip install -r /app/requirements.txt

                  # Expose the port
                  EXPOSE 5000

                  # Set the environment variable for Flask
                  ENV FLASK_APP=app.py

                  # Run the dashboard
                  CMD ["flask", "run", "--host=0.0.0.0"]
                  ```

              *   **dashboard/app.py:**
                  ```python
                  from flask import Flask, render_template
                  import psycopg2
                  import os

                  app = Flask(__name__)

                  DATABASE_URL = os.environ['DATABASE_URL']

                  @app.route('/')
                  def index():
                      try:
                          conn = psycopg2.connect(DATABASE_URL)
                          c = conn.cursor()
                          c.execute("SELECT * FROM rdp_logs ORDER BY timestamp DESC LIMIT 100")
                          logs = c.fetchall()
                          conn.close()
                          return render_template('index.html', logs=logs)
                      except Exception as e:
                          return f"Database connection error: {e}"

                  if __name__ == "__main__":
                      app.run(debug=True)
              ```

              *   **dashboard/requirements.txt:**
                  ```
                  Flask
                  psycopg2-binary
                  ```

              *   **dashboard/templates/index.html:**
                  ```html
                  <!DOCTYPE html>
                  <html>
                  <head>
                      <title>RDP Monitor Dashboard</title>
                  </head>
                  <body>
                      <h1>RDP Monitor Logs</h1>
                      <table>
                          <thead>
                              <tr>
                                  <th>Timestamp</th>
                                  <th>Success</th>
                                  <th>Error Message</th>
                                  <th>Server</th>
                                  <th>Port</th>
                                  <th>Username</th>
                              </tr>
                          </thead>
                          <tbody>
                              {% for log in logs %}
                                  <tr>
                                      <td>{{ log[0] }}</td>
                                      <td>{{ log[1] }}</td>
                                      <td>{{ log[2] }}</td>
                                      <td>{{ log[3] }}</td>
                                      <td>{{ log[4] }}</td>
                                      <td>{{ log[5] }}</td>
                                  </tr>
                              {% endfor %}
                          </tbody>
                      </table>
                  </body>
                  </html>
              ```
        </Section>

        <Section name="Script Execution and Usage Guide">
          1.  The `setup.sh` script should print the following instructions upon successful completion:
              ```
              echo "RDP Monitor setup complete."
              echo "To start the system:"
              echo "1. Navigate to the 'rdp-monitor' directory: cd rdp-monitor"
              echo "2. Run 'docker-compose up -d': docker-compose up -d"
              echo "The dashboard will be accessible at http://localhost:5000"
              ```
        </Section>
      </Instructions>
      <Example>
        Not applicable, as the output is a complete setup script.
      </Example>
      <Constraints>
        - The generated script must be executable in a Linux environment with `bash` and `docker-compose` installed.
        - The script must be self-contained and not rely on external dependencies other than standard Linux utilities.
        - The RDP password should only be accessed through environment variables within the Docker containers; it should not be hardcoded directly in the script.
      </Constraints>
      <Enhancements>
        - Add command-line arguments to allow configuration of RDP server details.
        - Implement more comprehensive error handling within the script, including checking for the existence of `docker-compose` and prompting the user to install it if missing.
        - Enhance the dashboard with additional features, such as filtering, sorting, and historical trends.
        - Add automated testing to verify the functionality of the RDP monitoring system after setup.
      </Enhancements>
      <Fallback>
        If the script encounters an error during execution, it should print a clear error message and provide instructions on how to proceed manually.
      </Fallback>
    </Prompt>
    ```
  </OriginalPrompt>
  <Goal>To generate a refined `setup.sh` script based on the provided prompt, enhancing error handling, configurability, and robustness while maintaining the core functionality of automating the setup of a Dockerized RDP health monitoring system.</Goal>
  <Context>This agent will refine the provided prompt, which describes the generation of a `setup.sh` script for automated Docker-based RDP health monitoring. The refined script will incorporate improved error handling, command-line argument parsing for configurability, and added robustness. The RDP server details (demo.fina.ge:2400, scheduledchecker, ch3ckerScheduler) will still be the defaults but can be overridden via command-line arguments.</Context>
  <Instructions>
    <Step>1. **Analyze the Original Prompt:** Thoroughly examine the original prompt to understand the desired functionality, file structure, and content of the `setup.sh` script. Identify areas where improvements can be made, specifically focusing on error handling, configurability, and robustness.</Step>
    <Step>2. **Implement Command-Line Argument Parsing:** Add functionality to the `setup.sh` script to accept command-line arguments for configuring the RDP server, port, username, and password. Use `getopts` for this purpose, providing default values if arguments are not supplied. Examples:
      *   `-s <server>`: Specifies the RDP server address.
      *   `-p <port>`: Specifies the RDP port number.
      *   `-u <username>`: Specifies the RDP username.
      *   `-w <password>`: Specifies the RDP password.
      *   `-d`: Specifies if docker-compose should be detached (add -d to docker-compose up).

      Display a help message if an invalid option is provided.</Step>
    <Step>3. **Enhance Error Handling:** Implement more comprehensive error handling throughout the `setup.sh` script. This includes:
      *   Checking if directories exist before attempting to create them and handling potential errors.
      *   Checking if files exist before attempting to overwrite them and providing a warning to the user.
      *   Capturing and displaying error messages from `docker-compose` commands.
      *   Adding a check for the availability of the Docker daemon before proceeding.
      *   Ensuring that environment variables are properly set within the Docker containers.</Step>
    <Step>4. **Improve Robustness:** Add checks and safeguards to ensure the script runs reliably.
      *   Verify that the necessary tools (e.g., `docker`, `docker-compose`) are installed and functional before proceeding.  Provide specific installation instructions if they are missing (using appropriate package manager commands like `apt-get install` or `yum install` based on the detected OS).
      *   Ensure that file permissions are set correctly for executable scripts and other files.
      *   Include retry logic for network-dependent operations (e.g., downloading dependencies, connecting to the database).</Step>
    <Step>5. **Update File Content Generation:** Incorporate the command-line arguments into the generated files, ensuring that the RDP server details are configurable.  Modify the `docker-compose.yml` and relevant scripts to use the command-line provided values or defaults if those are not set.</Step>
    <Step>6. **Refine User Instructions:** Update the instructions printed at the end of the script to reflect the new command-line options and any changes to the setup process.</Step>
    <Step>7. **Automated Testing (Optional):** While full automated testing is outside the scope of simply *generating* the setup script, consider providing a basic health check script that can be run after setup to verify that the RDP monitoring system is functioning correctly. This script could check the database connection and query the dashboard's API.</Step>
    <Step>8. **Generate the Improved `setup.sh` Script:** Generate the complete `setup.sh` script with all the implemented enhancements, incorporating the command-line argument parsing, improved error handling, and increased robustness.</Step>
    <Step>9. **XML Formatting:** Return the complete improved `setup.sh` script as a string within the `<Script>` element of the XML output.</Step>
  </Instructions>
  <Examples>
    <Example>
      <Input>N/A - This is a transformation of a prior result</Input>
      <Output>
        ```xml
        <Prompt>
          <AgentName>AutoRDPMonitoringDocker</AgentName>
          <OriginalPrompt>See above.</OriginalPrompt>
          <Goal>Generate a comprehensive, fully functional, and executable `setup.sh` script that automates the creation of a Dockerized RDP health monitoring system. Incorporates improved error handling, configurable RDP server details via command-line arguments, and enhanced robustness.</Goal>
          <Context>The script will automate the setup of a Docker-based RDP health monitoring system, providing enhanced error handling, configurable RDP server details via command-line arguments, and increased robustness. Default RDP server details are demo.fina.ge:2400, scheduledchecker, ch3ckerScheduler, but these can be overridden.</Context>
          <Instructions>
            <Step>1. **Shebang and Initial Checks:** Start the script with `#!/bin/bash`. Check if `docker` and `docker-compose` are installed. If not, provide installation instructions based on the detected operating system (Debian/Ubuntu or RedHat/CentOS). Exit with an error if the tools are missing.</Step>
            <Step>2. **Command-Line Argument Parsing:** Use `getopts` to parse command-line arguments for server (`-s`), port (`-p`), username (`-u`), password (`-w`), and detached mode (`-d`). Set default values if arguments are not provided. Add a help message for invalid options.</Step>
            <Step>3. **Directory Creation:** Create the `rdp-monitor` directory structure. Add error handling to check if directories already exist before creating them. If they exist, prompt the user to confirm overwriting or skip creation.</Step>
            <Step>4. **File Generation with Variable Substitution:** Generate all necessary files (`docker-compose.yml`, Dockerfiles, scripts, etc.) using `cat > file <<EOL`. Substitute the command-line arguments (or default values) for RDP server details in the generated files using `${SERVER}`, `${PORT}`, `${USERNAME}`, and `${PASSWORD}`.</Step>
            <Step>5. **File Permissions:** Set appropriate file permissions for executable scripts (e.g., `chmod +x`).</Step>
            <Step>6. **Database Initialization:** Create the `database/init.sql` file (even if it's empty, as specified). The Python script will handle database table creation.</Step>
            <Step>7. **Final Instructions:** Print clear instructions on how to run the system, including the command-line options and the dashboard URL.</Step>
            <Step>8. **Health Check Script (Optional):** Provide a simple Python health check script (e.g., `health_check.py`) that can be run after setup to verify basic functionality. This script can test the database connection and make a simple request to the dashboard.</Step>
            <Step>9. **Error Handling:** Add comprehensive error handling throughout the script. Check return codes of commands and print informative error messages. Implement a fallback mechanism if errors occur (e.g., suggest manual steps).</Step>
          </Instructions>
          <Constraints>The generated script must be executable in a Linux environment with `bash`, `docker`, and `docker-compose` installed. The script must be self-contained and not rely on external dependencies other than standard Linux utilities.</Constraints>
          <OutputFormat>A complete `setup.sh` script formatted as a string, ready to be saved to a file and executed.</OutputFormat>
          <Tone>Technical and informative.</Tone>
          <UnderlyingDependencies>The script relies on the availability of `docker` and `docker-compose` and a working network connection to download dependencies. It also depends on the RDP server being accessible.</UnderlyingDependencies>
          <ClarificationQuestions>Should the script prompt the user before overwriting existing files/directories? Should the health check script be included?  Should it detect the OS and adapt package manager commands accordingly (apt vs yum)?</ClarificationQuestions>
          <Script>
            ```bash
            #!/bin/bash

            # Default values
            SERVER="demo.fina.ge"
            PORT="2400"
            USERNAME="scheduledchecker"
            PASSWORD="ch3ckerScheduler"
            DETACHED=""

            # Check if docker and docker-compose are installed
            if ! command -v docker &> /dev/null; then
                echo "docker is not installed.  Please install it."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    if [[ -f /etc/debian_version ]]; then
                        echo "Try: sudo apt-get update && sudo apt-get install -y docker.io"
                    elif [[ -f /etc/redhat-release ]]; then
                        echo "Try: sudo yum install -y docker"
                        echo "sudo systemctl start docker"
                        echo "sudo systemctl enable docker"
                    else
                        echo "Please install docker manually."
                    fi
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    echo "Please install Docker Desktop for Mac."
                    echo "https://www.docker.com/products/docker-desktop"
                else
                    echo "Please install docker manually."
                fi
                exit 1
            fi

            if ! command -v docker-compose &> /dev/null; then
                echo "docker-compose is not installed.  Please install it."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    echo "Try: sudo apt-get install -y docker-compose"
                elif [[ -f /etc/redhat-release ]]; then
                    echo "Try: sudo yum install -y docker-compose"
                else
                    echo "Please install docker-compose manually."
                fi
                exit 1
            fi

            # Parse command-line arguments
            while getopts "s:p:u:w:d" opt; do
                case $opt in
                    s)
                        SERVER="$OPTARG"
                        ;;
                    p)
                        PORT="$OPTARG"
                        ;;
                    u)
                        USERNAME="$OPTARG"
                        ;;
                    w)
                        PASSWORD="$OPTARG"
                        ;;
                    d)
                        DETACHED="-d"
                        ;;
                    \?)
                        echo "Invalid option: -$OPTARG" >&2
                        echo "Usage: $0 [-s server] [-p port] [-u username] [-w password] [-d]"
                        exit 1
                        ;;
                    :)
                        echo "Option -$OPTARG requires an argument." >&2
                        exit 1
                        ;;
                esac
            done

            # Directory structure
            DIR="rdp-monitor"
            SUBDIRS="rdp-checker database dashboard dashboard/templates"

            # Check if the main directory exists.  Prompt if it does.
            if [ -d "$DIR" ]; then
                read -p "Directory '$DIR' already exists. Overwrite? (y/n): " -n 1 -r
                echo    # (optional) move to a new line
                if [[ $REPLY =~ ^[Yy]$ ]]
                then
                    echo "Overwriting existing directory."
                    rm -rf "$DIR" #WARNING: DELETES EVERYTHING IN THE DIR
                else
                    echo "Skipping directory creation."
                    exit 1
                fi
            fi

            mkdir -p "$DIR"
            for subdir in $SUBDIRS; do
                mkdir -p "$DIR/$subdir" || { echo "Failed to create directory $DIR/$subdir"; exit 1; }
            done

            # docker-compose.yml
            cat > "$DIR/docker-compose.yml" <<EOL
            version: '3'

            services:
              rdp-checker:
                build: ./rdp-checker
                environment:
                  - RDP_SERVER=\${SERVER}
                  - RDP_PORT=\${PORT}
                  - RDP_USERNAME=\${USERNAME}
                  - RDP_PASSWORD=\${PASSWORD}
                  - DATABASE_URL=postgresql://rdpmonitor:rdpmonitorpassword@database:5432/rdp_logs
                depends_on:
                  - database
                restart: always

              database:
                image: postgres
                environment:
                  - POSTGRES_USER=rdpmonitor
                  - POSTGRES_PASSWORD=rdpmonitorpassword
                  - POSTGRES_DB=rdp_logs
                volumes:
                  - pg-data:/var/lib/postgresql/data

              dashboard:
                build: ./dashboard
                ports:
                  - "5000:5000"
                environment:
                  - DATABASE_URL=postgresql://rdpmonitor:rdpmonitorpassword@database:5432/rdp_logs
                depends_on:
                  - database
                restart: always

            volumes:
              pg-data:
            EOL

            # rdp-checker/Dockerfile
            cat > "$DIR/rdp-checker/Dockerfile" <<EOL
            FROM python:3.9-slim

            # Install necessary packages
            RUN apt-get update && apt-get install -y freerdp2-x11 postgresql-client cron

            # Copy the RDP checking scripts
            COPY check_rdp.sh /app/check_rdp.sh
            COPY check_rdp.py /app/check_rdp.py
            COPY crontab /etc/cron.d/rdp-checker-cron

            # Make the scripts executable
            RUN chmod +x /app/check_rdp.sh /app/check_rdp.py

            # Install Python dependencies
            COPY requirements.txt /app/requirements.txt
            RUN pip install -r /app/requirements.txt

            # Set the working directory
            WORKDIR /app

            # Set up cron
            RUN chmod 0644 /etc/cron.d/rdp-checker-cron && cron

            # Run the RDP checker
            CMD ["cron", "-f"]
            EOL

            # rdp-checker/check_rdp.sh
            cat > "$DIR/rdp-checker/check_rdp.sh" <<EOL
            #!/bin/bash

            RDP_SERVER=\${RDP_SERVER:-$SERVER}
            RDP_PORT=\${RDP_PORT:-$PORT}
            RDP_USERNAME=\${RDP_USERNAME:-$USERNAME}
            RDP_PASSWORD=\${RDP_PASSWORD:-$PASSWORD}

            xfreerdp /v:\$RDP_SERVER:\$RDP_PORT /u:\$RDP_USERNAME /p:\$RDP_PASSWORD /cert-ignore > /tmp/rdp_check.log 2>&1

            if [ \$? -eq 0 ]; then
                echo "Success"
            else
                echo "Failure"
            fi

            exit 0
            EOL

            # rdp-checker/check_rdp.py
            cat > "$DIR/rdp-checker/check_rdp.py" <<EOL
            import os
            import subprocess
            import psycopg2
            from datetime import datetime

            RDP_SERVER = os.environ['RDP_SERVER']
            RDP_PORT = os.environ['RDP_PORT']
            RDP_USERNAME = os.environ['RDP_USERNAME']
            RDP_PASSWORD = os.environ['RDP_PASSWORD']
            DATABASE_URL = os.environ['DATABASE_URL']

            def check_rdp():
                try:
                    # Using xfreerdp to check RDP connection
                    command = f"xfreerdp /v:{RDP_SERVER}:{RDP_PORT} /u:{RDP_USERNAME} /p:{RDP_PASSWORD} /cert-ignore"
                    result = subprocess.run(command, shell=True, capture_output=True, text=True)
                    if result.returncode == 0:
                        return True, "Connection successful"
                    else:
                        return False, result.stderr
                except subprocess.CalledProcessError as e:
                    return False, str(e)

            def log_result(success, error_message):
                try:
                    conn = psycopg2.connect(DATABASE_URL)
                    c = conn.cursor()
                    c.execute('''CREATE TABLE IF NOT EXISTS rdp_logs
                                 (timestamp timestamp, success boolean, error_message text, server text, port integer, username text)''')
                    c.execute("INSERT INTO rdp_logs (timestamp, success, error_message, server, port, username) VALUES (%s, %s, %s, %s, %s, %s)",
                              (datetime.now(), success, error_message, RDP_SERVER, int(RDP_PORT), RDP_USERNAME))
                    conn.commit()
                    conn.close()
                except Exception as e:
                    print(f"Database error: {e}")

            if __name__ == "__main__":
                success, error_message = check_rdp()
                log_result(success, error_message)
                if not success:
                    print(f"RDP check failed: {error_message}")
                else:
                    print("RDP check successful")
            EOL

            # rdp-checker/requirements.txt
            cat > "$DIR/rdp-checker/requirements.txt" <<EOL
            psycopg2-binary
            EOL

            # rdp-checker/crontab
            cat > "$DIR/rdp-checker/crontab" <<EOL
            */5 * * * * python /app/check_rdp.py >> /app/cron.log 2>&1
            EOL

            # database/init.sql
            cat > "$DIR/database/init.sql" <<EOL
            -- Database initialization is handled by the Python script
            EOL

            # dashboard/Dockerfile
            cat > "$DIR/dashboard/Dockerfile" <<EOL
            FROM python:3.9-slim

            # Copy the dashboard application
            COPY . /app

            # Install dependencies
            RUN pip install -r /app/requirements.txt

            # Expose the port
            EXPOSE 5000

            # Set the environment variable for Flask
            ENV FLASK_APP=app.py

            # Run the dashboard
            CMD ["flask", "run", "--host=0.0.0.0"]
            EOL

            # dashboard/app.py
            cat > "$DIR/dashboard/app.py" <<EOL
            from flask import Flask, render_template
            import psycopg2
            import os

            app = Flask(__name__)

            DATABASE_URL = os.environ['DATABASE_URL']

            @app.route('/')
            def index():
                try:
                    conn = psycopg2.connect(DATABASE_URL)
                    c = conn.cursor()
                    c.execute("SELECT * FROM rdp_logs ORDER BY timestamp DESC LIMIT 100")
                    logs = c.fetchall()
                    conn.close()
                    return render_template('index.html', logs=logs)
                except Exception as e:
                    return f"Database connection error: {e}"

            if __name__ == "__main__":
                app.run(debug=True)
            EOL

            # dashboard/requirements.txt
            cat > "$DIR/dashboard/requirements.txt" <<EOL
            Flask
            psycopg2-binary
            EOL

            # dashboard/templates/index.html
            cat > "$DIR/dashboard/templates/index.html" <<EOL
            <!DOCTYPE html>
            <html>
            <head>
                <title>RDP Monitor Dashboard</title>
            </head>
            <body>
                <h1>RDP Monitor Logs</h1>
                <table>
                    <thead>
                        <tr>
                            <th>Timestamp</th>
                            <th>Success</th>
                            <th>Error Message</th>
                            <th>Server</th>
                            <th>Port</th>
                            <th>Username</th>
                        </tr>
                    </thead>
                    <tbody>
                        {% for log in logs %}
                            <tr>
                                <td>{{ log[0] }}</td>
                                <td>{{ log[1] }}</td>
                                <td>{{ log[2] }}</td>
                                <td>{{ log[3] }}</td>
                                <td>{{ log[4] }}</td>
                                <td>{{ log[5] }}</td>
                            </tr>
                        {% endfor %}
                    </tbody>
                </table>
            </body>
            </html>
            EOL

            # Set permissions
            chmod +x "$DIR/rdp-checker/check_rdp.sh"

            # Final instructions
            echo "RDP Monitor setup complete."
            echo "To start the system:"
            echo "1. Navigate to the 'rdp-monitor' directory: cd rdp-monitor"
            echo "2. Run 'docker-compose up $DETACHED': docker-compose up $DETACHED"
            echo "The dashboard will be accessible at http://localhost:5000"
            echo ""
            echo "You can customize the RDP server details using the following options:"
            echo "  -s <server>  : Specifies the RDP server address (default: demo.fina.ge)"
            echo "  -p <port>    : Specifies the RDP port number (default: 2400)"
            echo "  -u <username> : Specifies the RDP username (default: scheduledchecker)"
            echo "  -w <password> : Specifies the RDP password (default: ch3ckerScheduler)"
            echo "  -d           : Run docker-compose in detached mode"
            exit 0
            ```
          </Script>
        </Prompt>
        ```
      </Output>
    </Example>
  </Examples>
  <Constraints>The refined `setup.sh` script must be executable in a Linux environment with `bash`, `docker`, and `docker-compose` installed. The script must be self-contained and should not rely on external dependencies beyond standard Linux utilities.</Constraints>
  <OutputFormat>The improved `setup.sh` script formatted as a string within the `<Script>` element of the XML output.</OutputFormat>
  <Tone>Technical and informative.</Tone>
  <UnderlyingDependencies>The script relies on the availability of `docker` and `docker-compose` and a working network connection to download dependencies. It also depends on the target RDP server being accessible.</UnderlyingDependencies>
  <ClarificationQuestions>Should the generated script include a health check script? If so, where should it be located, and what should its dependencies be? Should I add prompts to confirm before overwriting existing files?</ClarificationQuestions>
  <Script>
    ```bash
    #!/bin/bash

    # Default values
    SERVER="demo.fina.ge"
    PORT="2400"
    USERNAME="scheduledchecker"
    PASSWORD="ch3ckerScheduler"
