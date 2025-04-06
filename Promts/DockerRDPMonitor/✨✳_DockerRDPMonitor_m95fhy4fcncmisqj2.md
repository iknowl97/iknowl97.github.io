```xml
<Prompt>
  <AgentName>DockerRDPMonitorPromptOptimizer</AgentName>
  <OriginalPrompt>
    ```xml
    <Prompt>
      <AgentName>DockerRDPMonitor</AgentName>
      <Goal>Generate a complete and executable `setup.sh` script that creates a fully functional, Dockerized RDP health monitoring system from scratch. The script should create the required directory structure, populate all files with the necessary content (including Dockerfiles, scripts, and configuration files), set appropriate permissions, and provide clear instructions for running the solution. The focus is on automation and ease of deployment.</Goal>
      <Context>
        The user needs an automated RDP health monitoring solution using Docker. The solution must:
        1.  Periodically check RDP server login.
        2.  Implement multiple RDP connection check methods (shell script, Python script, etc.).
        3.  Log connection attempts and results to a database.
        4.  Display the logs in a simple dashboard.
        5.  Ignore certificate issues during RDP connection.
        6.  Report detailed error messages on login failure.
        7.  Automate the entire setup process with a single `setup.sh` script.
        8.  Provide a simplified guide on how to run the system after setup.
        The target RDP server is `demo.fina.ge:2400` with username `scheduledchecker` and password `ch3ckerScheduler`.
      </Context>
      <Instructions>
        <Section name="Script Structure">
          1.  The `setup.sh` script should:
              *   Create the required directory structure.
              *   Create and populate all necessary files (Dockerfiles, scripts, `docker-compose.yml`, etc.).
              *   Set execute permissions on scripts where necessary.
              *   Print instructions for running the system after setup.
          2.  The script should handle potential errors during the setup process (e.g., checking if directories exist before creating them).
        </Section>

        <Section name="Directory and File Generation">
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
          2.  Populate the files with the following content:
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

        <Section name="Script Execution Instructions">
          1.  The script should print the following instructions at the end:
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
        - The script must be executable in a Linux environment with `bash` and `docker-compose` installed.
        - The script must be self-contained and not rely on external dependencies other than the standard Linux utilities.
        - The RDP password should only be accessed through environment variables within the Docker containers.
      </Constraints>
      <Enhancements>
        - Add command-line arguments to configure the RDP server details.
        - Implement error handling to check for the existence of `docker-compose` and prompt the user to install it if missing.
        - Improve the dashboard with more advanced features like filtering and sorting.
      </Enhancements>
      <Fallback>
        If the script fails at any point, it should print a clear error message and instructions on how to proceed manually.
      </Fallback>
    </Prompt>
    ```
  </OriginalPrompt>
  <Goal>Refine the original prompt to ensure the generated `setup.sh` script is robust, secure, and user-friendly. Focus on improving error handling, security practices, configurability, and documentation within the script. The goal is to make the deployment and maintenance of the RDP monitoring system as seamless as possible.</Goal>
  <Context>The existing prompt aims to generate a `setup.sh` script for a Dockerized RDP health monitoring system. This refined prompt builds upon the original by addressing potential weaknesses and incorporating best practices in scripting and Docker deployment. Considerations include:
    - **Security:** Protecting sensitive information like passwords.
    - **Error Handling:** Ensuring the script handles various failure scenarios gracefully.
    - **Configurability:** Allowing users to easily customize settings without modifying the script directly.
    - **User Experience:** Providing clear and helpful messages throughout the setup process.
    - **Maintainability:** Structuring the script for easy modification and updates in the future.</Context>
  <Instructions>
    <Step>1. **Analyze the Original Prompt:** Review the original XML prompt and identify areas for improvement in terms of security, error handling, configurability, and clarity.</Step>
    <Step>2. **Enhance Security:**
      *  **Password Handling:** Replace hardcoded passwords with environment variables that can be passed through command-line arguments or a `.env` file.  Avoid storing passwords directly within the script or Dockerfiles.
      *   **User Isolation:** Suggest using a non-root user within the Docker containers to minimize the impact of potential security breaches.
    </Step>
    <Step>3. **Improve Error Handling:**
      *   **Comprehensive Checks:** Add checks for command-line arguments, file creation, and Docker commands.  Provide informative error messages with troubleshooting steps.
      *   **Idempotency:** Ensure the script can be run multiple times without causing errors or unexpected behavior (e.g., checking if directories exist before attempting to create them).
      *   **Logging:**  Incorporate logging to a file for debugging purposes.  Include timestamps and context in log messages.
    </Step>
    <Step>4. **Increase Configurability:**
      *   **Command-Line Arguments:** Implement `getopts` to handle command-line arguments for configuring the RDP server, port, username, password, database URL, and other relevant settings.
      *   **.env File Support:**  Include logic to read configuration from a `.env` file, allowing users to easily set environment variables without modifying the script directly.
    </Step>
    <Step>5. **Enhance User Experience:**
      *   **Progress Indicators:**  Provide visual progress indicators during long-running operations (e.g., building Docker images).
      *   **Informative Messages:**  Display clear and concise messages to the user throughout the setup process, explaining what is happening and providing instructions.
      *   **Validation:**  Validate user inputs (e.g., checking if the RDP port is a valid integer).
    </Step>
    <Step>6. **Improve Maintainability:**
      *   **Modularization:**  Break down the script into smaller, more manageable functions.
      *   **Comments:**  Add comprehensive comments to explain the purpose of each section of the script.
      *   **Version Control:**  Add a comment at the beginning of the script indicating the version number and date of last modification.
    </Step>
    <Step>7. **Update Instructions and Documentation:**
      *   **Detailed Instructions:**  Provide clear and detailed instructions for running the `setup.sh` script, including how to pass command-line arguments or use a `.env` file.
      *   **Troubleshooting Guide:**  Include a basic troubleshooting guide in the script comments or a separate README file, addressing common issues and providing solutions.
    </Step>
    <Step>8. **Revised `setup.sh` Script:** Generate a revised `setup.sh` script based on the improved instructions and considerations.</Step>
    <Step>9. **XML Formatting:** Present the revised `setup.sh` script, along with all other relevant information, in the specified XML format.</Step>
  </Instructions>
  <Example>
    <UserInput>N/A - This is a prompt improvement task.</UserInput>
    <GeneratedPrompt>N/A - The expected output is the optimized XML prompt.</GeneratedPrompt>
  </Example>
  <Constraints>
    - The generated `setup.sh` script must be compatible with standard Linux distributions and `bash`.
    - The script should minimize reliance on external dependencies beyond standard Linux utilities and `docker-compose`.
    - The improved prompt should prioritize security best practices and user-friendliness.
  </Constraints>
  <OutputFormat>
    ```xml
    <Prompt>
      <AgentName>[Descriptive Name of AI Agent]</AgentName>
      <OriginalPrompt>[The Original User-Provided Prompt]</OriginalPrompt>
      <Goal>[The Clearly Articulated Goal of the Prompt]</Goal>
      <Context>[Relevant Background Information and Contextual Details]</Context>
      <Instructions>
        <Step>[Step 1: Detailed Instruction]</Step>
        <Step>[Step 2: Detailed Instruction]</Step>
        ...
      </Instructions>
      <Examples>
        <Example>
          <Input>[Example Input]</Input>
          <Output>[Example Output]</Output>
        </Example>
        ...
      </Examples>
      <Constraints>[Limitations and Restrictions on the AI's Output]</Constraints>
      <OutputFormat>[Explicit Description of the Desired Output Format]</OutputFormat>
      <Tone>[Desired Tone and Style of the AI's Output]</Tone>
      <UnderlyingDependencies>[Explanations of Deeper Dependencies Uncovered During Analysis]</UnderlyingDependencies>
      <ClarificationQuestions>[Questions for User to Clarify Prompt]</ClarificationQuestions>
    </Prompt>
    ```
  </OutputFormat>
  <UnderlyingDependencies>The success of this prompt relies on understanding bash scripting best practices, Docker and Docker Compose concepts, and security principles for handling sensitive information in scripts and containers. The ability to generate a functional `setup.sh` script depends on accurate interpretation of the original prompt and the effective integration of the suggested enhancements.</UnderlyingDependencies>
  <ClarificationQuestions>Should the logging be configurable? Should the database initialization also be handled by a docker entrypoint rather than the python script? Should default values for RDP server/port/username be configurable via environment variables (and therefore command line arguments)?</ClarificationQuestions>
</Prompt>
```