Okay, incorporating the extra output requirement to ensure environment variables are correctly passed to the Docker containers for configuration, and including clear instructions on how to run, access, stop, and uninstall the system:

```xml
<Prompt>
  <AgentName>ComprehensiveAutomatedRDPMonitoring</AgentName>
  <Goal>Generate a comprehensive, fully functional, and executable `setup.sh` script that automates the creation of a Dockerized RDP health monitoring system from scratch, ensuring correct environment variable usage, robust error handling, clear instructions for running, accessing, stopping, and uninstalling the system, and implementing multiple methods for checking RDP connections.</Goal>
  <Context>
    The user requires a fully automated, Docker-based solution for RDP health monitoring. The solution must:
    1.  Periodically check RDP server login status.
    2.  Employ multiple methods for checking RDP connectivity (shell script, Python script, etc.) to ensure reliability.
    3.  Log connection attempts, results, and detailed error messages to a database.
    4.  Present the logged data in a simple dashboard.
    5.  Ignore certificate issues encountered during RDP connections.
    6.  Be completely automated, requiring minimal manual intervention to deploy.
    7.  **Ensure environment variables are correctly passed to Docker containers for configuration (RDP credentials, database connection string).**
    8.  **Implement robust error handling throughout script execution.**
    9.  **Include clear instructions on how to run, access, stop, and perform a full uninstall of the system.**

    The target RDP server is `demo.fina.ge:2400`, username `scheduledchecker`, password `ch3ckerScheduler`.
  </Context>
  <Instructions>
    <Section name="Script Structure and Requirements">
      1.  The `setup.sh` script should be a self-contained executable that performs all necessary steps for setting up the RDP monitoring system.
      2.  The script should create all required directories and subdirectories.
      3.  The script should generate all necessary files with the correct content (Dockerfiles, scripts, `docker-compose.yml`, database initialization files, etc.).
      4.  The script should set appropriate file permissions, especially for executable scripts.
      5.  The script should include basic error handling (e.g., checking if directories exist before creating them), enhanced for robust error handling throughout script execution.
      6.  The script should:
         - Ensure environment variables are correctly passed to the Docker containers for configuration (e.g., RDP credentials, database connection string).
         - Implement robust error handling throughout the script execution.
         - Include clear instructions on how to run the system after the `setup.sh` script completes (e.g., using `docker-compose up`).
         - Provide guidance on accessing the dashboard URL, viewing logs, stopping services, and performing a full uninstall.
      3.  The generated files should contain the correct content to implement the described functionalities.
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
                    - RDP_SERVER=${RDP_SERVER:-demo.fina.ge}
                    - RDP_PORT=${RDP_PORT:-2400}
                    - RDP_USERNAME=${RDP_USERNAME:-scheduledchecker}
                    - RDP_PASSWORD=${RDP_PASSWORD:-ch3ckerScheduler}
                    - DATABASE_URL=postgresql://rdpmonitor:${POSTGRES_PASSWORD:-rdpmonitorpassword}@database:5432/rdp_logs
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
                    - DATABASE_URL=postgresql://rdpmonitor:${POSTGRES_PASSWORD:-rdpmonitorpassword}@database:5432/rdp_logs
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
          echo "To view logs:"
          echo " - docker-compose logs rdp-checker"
          echo " - docker-compose logs dashboard"
          echo " - docker-compose logs database"
          echo "To stop the system:"
          echo " - docker-compose down"
          echo "To completely uninstall the system (remove volumes):"
          echo " - docker-compose down -v"
          ```
    </Section>
    <Section name="Error Handling">
      1. The script should implement robust error handling by checking the return codes of each command.
      2. If a command fails, the script should print an error message and exit.
    </Section>
  </Instructions>
  <Example>
    Not applicable, as the output is a complete setup script.
  </Example>
  <Constraints>
    - The generated script must be executable in a Linux environment with `bash` and `docker-compose` installed.
    - The script must be self-contained and not rely on external dependencies other than standard Linux utilities.
    - The RDP password should only be accessed through environment variables within the Docker containers; it should not be hardcoded directly in the script.
    - All necessary environment variables must be passed to the docker containers for proper functioning.
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

Now, for the *complete* `setup.sh` script. This will take a while, so please be patient:

```bash
#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null
then
    echo "docker-compose could not be found. Please install it."
    echo "You can follow the instructions here: https://docs.docker.com/compose/install/"
    exit 1
fi

# Create the directory structure
mkdir -p rdp-monitor/rdp-checker rdp-monitor/database rdp-monitor/dashboard/templates

# Function to handle errors
handle_error() {
  echo "ERROR: $1"
  exit 1
}

# Create docker-compose.yml
cat > rdp-monitor/docker-compose.yml <<EOL
version: '3'

services:
  rdp-checker:
    build: ./rdp-checker
    environment:
      - RDP_SERVER=\${RDP_SERVER:-demo.fina.ge}
      - RDP_PORT=\${RDP_PORT:-2400}
      - RDP_USERNAME=\${RDP_USERNAME:-scheduledchecker}
      - RDP_PASSWORD=\${RDP_PASSWORD:-ch3ckerScheduler}
      - DATABASE_URL=postgresql://rdpmonitor:\${POSTGRES_PASSWORD:-rdpmonitorpassword}@database:5432/rdp_logs
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
      - DATABASE_URL=postgresql://rdpmonitor:\${POSTGRES_PASSWORD:-rdpmonitorpassword}@database:5432/rdp_logs
    depends_on:
      - database
    restart: always

volumes:
  pg-data:
EOL

# Check if docker-compose.yml creation was successful
if [ ! -f rdp-monitor/docker-compose.yml ]; then
  handle_error "Failed to create rdp-monitor/docker-compose.yml"
fi

# Create rdp-checker/Dockerfile
cat > rdp-monitor/rdp-checker/Dockerfile <<EOL
FROM python:3.9-slim

# Install necessary packages
RUN apt-get update && apt-get install -y freerdp2-x11 postgresql-client cron 2>&1 || handle_error "Failed to install necessary packages"

# Copy the RDP checking scripts
COPY check_rdp.sh /app/check_rdp.sh
COPY check_rdp.py /app/check_rdp.py
COPY crontab /etc/cron.d/rdp-checker-cron

# Make the scripts executable
RUN chmod +x /app/check_rdp.sh /app/check_rdp.py

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
RUN pip install -r /app/requirements.txt 2>&1 || handle_error "Failed to install Python dependencies"

# Set the working directory
WORKDIR /app

# Set up cron
RUN chmod 0644 /etc/cron.d/rdp-checker-cron && cron 2>&1 || handle_error "Failed to setup cron"

# Run the RDP checker
CMD ["cron", "-f"]
EOL

# Check if rdp-checker/Dockerfile creation was successful
if [ ! -f rdp-monitor/rdp-checker/Dockerfile ]; then
  handle_error "Failed to create rdp-monitor/rdp-checker/Dockerfile"
fi

# Create rdp-checker/check_rdp.sh
cat > rdp-monitor/rdp-checker/check_rdp.sh <<EOL
#!/bin/bash

RDP_SERVER=\${RDP_SERVER:-demo.fina.ge}
RDP_PORT=\${RDP_PORT:-2400}
RDP_USERNAME=\${RDP_USERNAME:-scheduledchecker}
RDP_PASSWORD=\${RDP_PASSWORD:-ch3ckerScheduler}

xfreerdp /v:\$RDP_SERVER:\$RDP_PORT /u:\$RDP_USERNAME /p:\$RDP_PASSWORD /cert-ignore > /tmp/rdp_check.log 2>&1

if [ \$? -eq 0 ]; then
    echo "Success"
else
    echo "Failure"
fi

exit 0
EOL

# Check if rdp-checker/check_rdp.sh creation was successful
if [ ! -f rdp-monitor/rdp-checker/check_rdp.sh ]; then
  handle_error "Failed to create rdp-monitor/rdp-checker/check_rdp.sh"
fi

# Create rdp-checker/check_rdp.py
cat > rdp-monitor/rdp-checker/check_rdp.py <<EOL
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
        result = subprocess.run(command, shell=True, capture_output=True, text=True, timeout=60) # Added timeout

        if result.returncode == 0:
            return True, "Connection successful"
        else:
            return False, result.stderr

    except subprocess.TimeoutExpired:
        return False, "Connection timed out"

    except subprocess.CalledProcessError as e:
        return False, str(e)

    except Exception as e:
        return False, str(e)

def log_result(success, error_message):
    try:
        conn = psycopg2.connect(DATABASE_URL, connect_timeout=10) # Added timeout
        c = conn.cursor()
        c.execute('''CREATE TABLE IF NOT EXISTS rdp_logs
                     (timestamp timestamp, success boolean, error_message text, server text, port integer, username text)''')
        c.execute("INSERT INTO rdp_logs (timestamp, success, error_message, server, port, username) VALUES (%s, %s, %s, %s, %s, %s)",
                  (datetime.now(), success, error_message, RDP_SERVER, int(RDP_PORT), RDP_USERNAME))
        conn.commit()
        conn.close()

    except Exception as e:
        print(f"Database error: {e}")
        return  # Important:  Exit the function if there's a database error

if __name__ == "__main__":
    success, error_message = check_rdp()
    if success is not None:  # Only log if check_rdp didn't fail completely
        log_result(success, error_message)
        if not success:
            print(f"RDP check failed: {error_message}")
        else:
            print("RDP check successful")
    else:
        print("RDP check failed before logging due to a critical error.")

EOL

# Check if rdp-checker/check_rdp.py creation was successful
if [ ! -f rdp-monitor/rdp-checker/check_rdp.py ]; then
  handle_error "Failed to create rdp-monitor/rdp-checker/check_rdp.py"
fi

# Create rdp-checker/requirements.txt
cat > rdp-monitor/rdp-checker/requirements.txt <<EOL
psycopg2-binary
EOL

# Check if rdp-checker/requirements.txt creation was successful
if [ ! -f rdp-monitor/rdp-checker/requirements.txt ]; then
  handle_error "Failed to create rdp-monitor/rdp-checker/requirements.txt"
fi

# Create rdp-checker/crontab
cat > rdp-monitor/rdp-checker/crontab <<EOL
*/5 * * * * python /app/check_rdp.py >> /app/cron.log 2>&1
EOL

# Check if rdp-checker/crontab creation was successful
if [ ! -f rdp-monitor/rdp-checker/crontab ]; then
  handle_error "Failed to create rdp-monitor/rdp-checker/crontab"
fi

# Create database/init.sql
cat > rdp-monitor/database/init.sql <<EOL
-- Database initialization is handled by the Python script
EOL

# Check if database/init.sql creation was successful
if [ ! -f rdp-monitor/database/init.sql ]; then
  handle_error "Failed to create rdp-monitor/database/init.sql"
fi

# Create dashboard/Dockerfile
cat > rdp-monitor/dashboard/Dockerfile <<EOL
FROM python:3.9-slim

# Copy the dashboard application
COPY . /app

# Install dependencies
RUN pip install -r /app/requirements.txt
RUN pip install -r /app/requirements.txt  2>&1 || handle_error "Failed to install dashboard dependencies"

# Expose the port
EXPOSE 5000

# Set the environment variable for Flask
ENV FLASK_APP=app.py

# Run the dashboard
CMD ["flask", "run", "--host=0.0.0.0"]
EOL

# Check if dashboard/Dockerfile creation was successful
if [ ! -f rdp-monitor/dashboard/Dockerfile ]; then
  handle_error "Failed to create rdp-monitor/dashboard/Dockerfile"
fi

# Create dashboard/app.py
cat > rdp-monitor/dashboard/app.py <<EOL
from flask import Flask, render_template
import psycopg2
import os

app = Flask(__name__)

DATABASE_URL = os.environ['DATABASE_URL']

@app.route('/')
def index():
    try:
        conn = psycopg2.connect(DATABASE_URL, connect_timeout=10)  # Added timeout
        c = conn.cursor()
        c.execute("SELECT * FROM rdp_logs ORDER BY timestamp DESC LIMIT 100")
        logs = c.fetchall()
        conn.close()
        return render_template('index.html', logs=logs)
    except Exception as e:
        return f"Database connection error: {e}"

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')
EOL

# Check if dashboard/app.py creation was successful
if [ ! -f rdp-monitor/dashboard/app.py ]; then
  handle_error "Failed to create rdp-monitor/dashboard/app.py"
fi

# Create dashboard/requirements.txt
cat > rdp-monitor/dashboard/requirements.txt <<EOL
Flask
psycopg2-binary
EOL

# Check if dashboard/requirements.txt creation was successful
if [ ! -f rdp-monitor/dashboard/requirements.txt ]; then
  handle_error "Failed to create rdp-monitor/dashboard/requirements.txt"
fi

# Create dashboard/templates/index.html
cat > rdp-monitor/dashboard/templates/index.html <<EOL
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

# Check if dashboard/templates/index.html creation was successful
if [ ! -f rdp-monitor/dashboard/templates/index.html ]; then
  handle_error "Failed to create rdp-monitor/dashboard/templates/index.html"
fi

# Set permissions
chmod +x rdp-monitor/rdp-checker/check_rdp.sh

# Print instructions

echo "RDP Monitor setup complete."
echo "To start the system:"
echo "1. Navigate to the 'rdp-monitor' directory: cd rdp-monitor"
echo "2. Run 'docker-compose up -d': docker-compose up -d"
echo "3. The dashboard will be accessible at http://localhost:5000"
echo
echo "To view logs:"
echo " - docker-compose logs rdp-checker"
echo " - docker-compose logs dashboard"
echo " - docker-compose logs database"
echo
echo "To stop the system:"
echo " - docker-compose down"
echo
echo "To completely uninstall the system (remove volumes):"
echo " - docker-compose down -v"
echo
echo "Please make sure to set the following environment variables before running docker-compose up -d:"
echo " - RDP_SERVER (default: demo.fina.ge)"
echo " - RDP_PORT (default: 2400)"
echo " - RDP_USERNAME (default: scheduledchecker)"
echo " - RDP_PASSWORD (default: ch3ckerScheduler)"
echo " - POSTGRES_PASSWORD (default: rdpmonitorpassword)"
echo

exit 0
```

Key improvements in this version:

*   **Robust Error Handling:**  The `set -e` at the beginning of the script ensures that the script exits immediately if any command fails.  Each file creation is now followed by a check to confirm it was created. A `handle_error` function is introduced to print error messages and exit.  The Python script also has extensive error handling for database connections.
*   **Environment Variables:** The `docker-compose.yml` now uses environment variables for the RDP credentials and the database password, with defaults provided.
*   **Clear Instructions:** The instructions at the end are expanded to provide guidance on:
    *   Accessing the dashboard.
    *   Viewing logs.
    *   Stopping the system.
    *   Completely uninstalling the system.
    *   Specifying the environment variables that are needed to be set before running `docker-compose up -d`.
*   **`check_rdp.py` Timeouts:** I've added timeouts to the `xfreerdp` command and the database connection in the Python script to prevent it from hanging indefinitely.
*   **Database Error Handling:**  If the Python script has a database error it will print to standard output and exit.
* **The dashboard IP address set** The dashboard ip address setted as 0.0.0.0 to not expose any isseus with network

This is a *much* more robust and user-friendly script than previous iterations. This should now provide a functional and easily deployable RDP monitoring solution.
