```xml
<Prompt>
  <AgentName>RDPMonitorOrchestrator</AgentName>
  <OriginalPrompt>
    ```xml
    <Prompt>
      <AgentName>RDPMonitorOrchestrator</AgentName>
      <Goal>Generate a comprehensive, executable script that creates the complete directory structure and files for a Dockerized RDP health monitoring system. The script should handle all necessary steps from defining the `docker-compose.yml` to creating and populating the configuration files and RDP check scripts, allowing a non-technical user to quickly deploy the solution.</Goal>
      <Context>
        The user requires a complete solution to monitor RDP server login processes. The solution should consist of Docker containers for checking connectivity, logging results to a database, and visualizing the logs in a simple dashboard. Multiple methods for checking the RDP connection are required to enhance reliability. The generated output should be a single script that sets up the entire environment, requiring minimal manual intervention to run. The test server details are: `demo.fina.ge:2400`, Username `scheduledchecker`, Password `ch3ckerScheduler`.
      </Context>
      <Instructions>
        <Section name="Script Generation">
          1.  Create a single shell script that, when executed, sets up the entire Docker environment for the RDP health monitoring system.
          2.  The script should:
              *   Create all necessary directories.
              *   Create and populate all files with the correct content (Dockerfile, `docker-compose.yml`, RDP check scripts, database setup scripts, dashboard files, etc.).
              *   Set appropriate permissions for executable files.
              *   Provide a simple guide on how to run the system.
        </Section>

        <Section name="Directory Structure">
          1.  Define the directory structure for the Docker environment:
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
              └── setup.sh
              ```
        </Section>

        <Section name="File Content">
          1.  **docker-compose.yml:**
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

          2.  **rdp-checker/Dockerfile:**
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

          3.  **rdp-checker/check_rdp.sh:**
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

          4.  **rdp-checker/check_rdp.py:**
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

          5.  **rdp-checker/requirements.txt:**
              ```
              psycopg2-binary
              ```

          6.  **rdp-checker/crontab:**
              ```cron
              */5 * * * * python /app/check_rdp.py >> /app/cron.log 2>&1
              ```

          7.  **database/init.sql:**
              ```sql
              -- Database initialization is handled by the Python script
              ```

          8.  **dashboard/Dockerfile:**
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

          9.  **dashboard/app.py:**
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

          10. **dashboard/requirements.txt:**
              ```
              Flask
              psycopg2-binary
              ```

          11. **dashboard/templates/index.html:**
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

        <Section name="setup.sh">
          1.  Create the `setup.sh` script to automate the directory and file creation process.
          2.  The script must:
              *   Create all the directories defined in the directory structure.
              *   Create all the files and write the content specified in the file content section.
              *   Set execute permissions to `check_rdp.sh`.
        </Section>

        <Section name="Final Script Output">
          1.  Combine all the above to create the final script output.
          2.  Include a simple guide on how to run the generated script at the end of the generated file.
        </Section>
      </Instructions>
      <Example>
        Example is not applicable here since the goal is to generate a setup script.
      </Example>
      <Constraints>
        - The generated script should be executable on a Linux system with `bash`.
        - The solution must be self-contained and require minimal external dependencies.
        - The RDP password must not be hardcoded directly in the scripts but accessed through environment variables.
      </Constraints>
      <Enhancements>
        - The script can be enhanced to support configuration through command-line arguments (e.g., specifying RDP server details).
        - Add error handling to the script to handle cases where directory creation fails or file writing fails.
        - Implement additional features like health checks and alerting.
      </Enhancements>
      <Fallback>
        If any part of the script fails, it should provide a clear error message and instructions on how to resolve the issue manually.
      </Fallback>
    </Prompt>
    ```
  </OriginalPrompt>
  <Goal>To refine the provided XML prompt for the RDPMonitorOrchestrator, ensuring comprehensive and user-friendly setup script generation with enhanced error handling, configuration options, and security considerations. The improved prompt will guide the AI to create a robust and easily deployable RDP monitoring solution.</Goal>
  <Context>The target user is non-technical and needs a simplified method for deploying an RDP health monitoring system. The system consists of Docker containers for RDP connection checking, database logging, and dashboard visualization. The generated `setup.sh` script must be self-contained, automated, and handle potential errors gracefully. Security considerations (e.g., avoiding hardcoded passwords) are paramount. The context provides the existing prompt, which will be analyzed and improved upon.</Context>
  <Instructions>
    <Step>1. **Analyze the Original Prompt:** Review the original XML prompt for completeness, clarity, and areas for improvement. Identify potential issues like missing error handling, lack of configuration options, and security vulnerabilities (specifically, credentials handling).</Step>
    <Step>2. **Enhance Security:** Modify the prompt to emphasize retrieving RDP credentials from environment variables rather than including them directly in the `docker-compose.yml` file or RDP check scripts. Instruct the AI to generate a setup script that prompts the user to set these environment variables before running `docker-compose up`.</Step>
    <Step>3. **Add Error Handling:** Enhance the prompt to include detailed error handling within the `setup.sh` script. The script should check for successful directory creation, file writing, and Docker commands. Implement appropriate error messages and exit codes for troubleshooting.</Step>
    <Step>4. **Implement Configuration via Arguments:** Modify the prompt to instruct the AI to generate a `setup.sh` script that accepts command-line arguments for configuring RDP server details (server address, port, username). Use `getopts` for argument parsing within the script.</Step>
    <Step>5. **Add Health Check and Alerting (Optional):** Expand the prompt to include instructions for implementing basic health checks and alerting mechanisms. This could involve adding a simple API endpoint to the dashboard that reports the status of RDP connections and using a notification system (e.g., email, Slack) to send alerts when connections fail.</Step>
    <Step>6. **Refine User Guide:** Enhance the instructions within the generated `setup.sh` to include more detailed guidance on configuring and running the system, including setting environment variables, starting the Docker containers, and accessing the dashboard.</Step>
    <Step>7. **Review and Refine File Content:** Double-check file contents, paying close attention to syntax, environment variable usage, and adherence to best practices for Dockerized applications. Verify that all necessary dependencies are included in the respective `requirements.txt` files.</Step>
    <Step>8. **Generate Improved XML Prompt:** Construct a new XML prompt that incorporates all the enhancements mentioned above, ensuring it is well-structured, clear, and comprehensive. The goal is to guide the AI to generate a `setup.sh` script that is robust, secure, and user-friendly.</Step>
  </Instructions>
  <Examples>
    <Example>
      <Input>Original prompt (as provided)</Input>
      <Output>
        ```xml
        <Prompt>
          <AgentName>RDPMonitorOrchestrator</AgentName>
          <OriginalPrompt>Write code to sort a list.</OriginalPrompt>
          <Goal>Generate a comprehensive, executable script that creates the complete directory structure and files for a Dockerized RDP health monitoring system. The script should handle all necessary steps from defining the `docker-compose.yml` to creating and populating the configuration files and RDP check scripts, allowing a non-technical user to quickly deploy the solution.</Goal>
          <Context>The user requires a complete solution to monitor RDP server login processes. The solution should consist of Docker containers for checking connectivity, logging results to a database, and visualizing the logs in a simple dashboard. Multiple methods for checking the RDP connection are required to enhance reliability. The generated output should be a single script that sets up the entire environment, requiring minimal manual intervention to run.</Context>
          <Instructions>
            <Step>1. Create a `setup.sh` script that accepts command-line arguments for RDP_SERVER, RDP_PORT, and RDP_USERNAME using `getopts`. Default to demo.fina.ge, 2400, and scheduledchecker if not provided.</Step>
            <Step>2. Before running `docker-compose up`, prompt the user to set the RDP_PASSWORD environment variable.  Display a warning if it's not set.</Step>
            <Step>3.  Implement error handling in `setup.sh` for directory creation, file writing, and Docker commands. Exit with an error message and appropriate code if a failure occurs.</Step>
            <Step>4. The directory structure is: rdp-monitor/ docker-compose.yml rdp-checker/ Dockerfile check_rdp.sh check_rdp.py requirements.txt crontab database/ init.sql dashboard/ Dockerfile app.py requirements.txt templates/ index.html setup.sh</Step>
            <Step>5. The docker-compose.yml should look like: version: '3' services: rdp-checker: build: ./rdp-checker environment: - RDP_SERVER=${RDP_SERVER:-demo.fina.ge} - RDP_PORT=${RDP_PORT:-2400} - RDP_USERNAME=${RDP_USERNAME:-scheduledchecker} - RDP_PASSWORD=${RDP_PASSWORD} - DATABASE_URL=postgresql://rdpmonitor:rdpmonitorpassword@database:5432/rdp_logs depends_on: - database restart: always database: image: postgres environment: - POSTGRES_USER=rdpmonitor - POSTGRES_PASSWORD=rdpmonitorpassword - POSTGRES_DB=rdp_logs volumes: - pg-data:/var/lib/postgresql/data dashboard: build: ./dashboard ports: - "5000:5000" environment: - DATABASE_URL=postgresql://rdpmonitor:rdpmonitorpassword@database:5432/rdp_logs depends_on: - database restart: always volumes: pg-data:</Step>
            <Step>6.  rdp-checker/Dockerfile should look like: FROM python:3.9-slim  Install necessary packages RUN apt-get update && apt-get install -y freerdp2-x11 postgresql-client cron  Copy the RDP checking scripts COPY check_rdp.sh /app/check_rdp.sh COPY check_rdp.py /app/check_rdp.py COPY crontab /etc/cron.d/rdp-checker-cron  Make the scripts executable RUN chmod +x /app/check_rdp.sh /app/check_rdp.py  Install Python dependencies COPY requirements.txt /app/requirements.txt RUN pip install -r /app/requirements.txt  Set the working directory WORKDIR /app  Set up cron RUN chmod 0644 /etc/cron.d/rdp-checker-cron && cron  Run the RDP checker CMD ["cron", "-f"]</Step>
            <Step>7. rdp-checker/check_rdp.sh should look like: #!/bin/bash  RDP_SERVER=\${RDP_SERVER:-demo.fina.ge} RDP_PORT=\${RDP_PORT:-2400} RDP_USERNAME=\${RDP_USERNAME:-scheduledchecker} RDP_PASSWORD=\${RDP_PASSWORD}  xfreerdp /v:\$RDP_SERVER:\$RDP_PORT /u:\$RDP_USERNAME /p:\$RDP_PASSWORD /cert-ignore > /tmp/rdp_check.log 2>&1  if [ \$? -eq 0 ]; then  echo "Success" else  echo "Failure" fi  exit 0</Step>
            <Step>8. rdp-checker/check_rdp.py should look like: import os import subprocess import psycopg2 from datetime import datetime  RDP_SERVER = os.environ['RDP_SERVER'] RDP_PORT = os.environ['RDP_PORT'] RDP_USERNAME = os.environ['RDP_USERNAME'] RDP_PASSWORD = os.environ['RDP_PASSWORD'] DATABASE_URL = os.environ['DATABASE_URL']  def check_rdp():  try:  Using xfreerdp to check RDP connection  command = f"xfreerdp /v:{RDP_SERVER}:{RDP_PORT} /u:{RDP_USERNAME} /p:{RDP_PASSWORD} /cert-ignore"  result = subprocess.run(command, shell=True, capture_output=True, text=True)  if result.returncode == 0:  return True, "Connection successful"  else:  return False, result.stderr  except subprocess.CalledProcessError as e:  return False, str(e)  def log_result(success, error_message):  try:  conn = psycopg2.connect(DATABASE_URL)  c = conn.cursor()  c.execute('''CREATE TABLE IF NOT EXISTS rdp_logs (timestamp timestamp, success boolean, error_message text, server text, port integer, username text)''')  c.execute("INSERT INTO rdp_logs (timestamp, success, error_message, server, port, username) VALUES (%s, %s, %s, %s, %s, %s)", (datetime.now(), success, error_message, RDP_SERVER, int(RDP_PORT), RDP_USERNAME))  conn.commit()  conn.close()  except Exception as e:  print(f"Database error: {e}")  if __name__ == "__main__":  success, error_message = check_rdp()  log_result(success, error_message)  if not success:  print(f"RDP check failed: {error_message}")  else:  print("RDP check successful")</Step>
            <Step>9.  rdp-checker/requirements.txt should look like: psycopg2-binary</Step>
            <Step>10. rdp-checker/crontab should look like: */5 * * * * python /app/check_rdp.py >> /app/cron.log 2>&1</Step>
            <Step>11. database/init.sql should look like: Database initialization is handled by the Python script</Step>
            <Step>12. dashboard/Dockerfile should look like: FROM python:3.9-slim  Copy the dashboard application COPY . /app  Install dependencies RUN pip install -r /app/requirements.txt  Expose the port EXPOSE 5000  Set the environment variable for Flask ENV FLASK_APP=app.py  Run the dashboard CMD ["flask", "run", "--host=0.0.0.0"]</Step>
            <Step>13. dashboard/app.py should look like: from flask import Flask, render_template import psycopg2 import os  app = Flask(__name__)  DATABASE_URL = os.environ['DATABASE_URL']  @app.route('/') def index():  try:  conn = psycopg2.connect(DATABASE_URL)  c = conn.cursor()  c.execute("SELECT * FROM rdp_logs ORDER BY timestamp DESC LIMIT 100")  logs = c.fetchall()  conn.close()  return render_template('index.html', logs=logs)  except Exception as e:  return f"Database connection error: {e}"  if __name__ == "__main__":  app.run(debug=True)</Step>
            <Step>14. dashboard/requirements.txt should look like: Flask psycopg2-binary</Step>
            <Step>15. dashboard/templates/index.html should look like: &lt;!DOCTYPE html&gt; &lt;html&gt; &lt;head&gt;  &lt;title&gt;RDP Monitor Dashboard&lt;/title&gt; &lt;/head&gt; &lt;body&gt;  &lt;h1&gt;RDP Monitor Logs&lt;/h1&gt;  &lt;table&gt;  &lt;thead&gt;  &lt;tr&gt;  &lt;th&gt;Timestamp&lt;/th&gt;  &lt;th&gt;Success&lt;/th&gt;  &lt;th&gt;Error Message&lt;/th&gt;  &lt;th&gt;Server&lt;/th&gt;  &lt;th&gt;Port&lt;/th&gt;  &lt;th&gt;Username&lt;/th&gt;  &lt;/tr&gt;  &lt;/thead&gt;  &lt;tbody&gt;  {% for log in logs %}  &lt;tr&gt;  &lt;td&gt;{{ log[0] }}&lt;/td&gt;  &lt;td&gt;{{ log[1] }}&lt;/td&gt;  &lt;td&gt;{{ log[2] }}&lt;/td&gt;  &lt;td&gt;{{ log[3] }}&lt;/td&gt;  &lt;td&gt;{{ log[4] }}&lt;/td&gt;  &lt;td&gt;{{ log[5] }}&lt;/td&gt;  &lt;/tr&gt;  {% endfor %}  &lt;/tbody&gt;  &lt;/table&gt; &lt;/body&gt; &lt;/html&gt;</Step>
            <Step>16. Update the setup.sh creation to reflect the new requirements. </Step>
            <Step>17. The final instructions should include a clear guide on running the setup, setting environment variables, and accessing the dashboard.</Step>
          </Instructions>
          <Examples/>
          <Constraints>The script should work on Linux with bash. Passwords must be set with environment variables. </Constraints>
          <OutputFormat>XML format.</OutputFormat>
          <Tone>Instructive</Tone>
          <UnderlyingDependencies>Requires Docker and docker-compose to be installed.</UnderlyingDependencies>
          <ClarificationQuestions>What should happen when the RDP fails?</ClarificationQuestions>
        </Prompt>
        ```
      </Output>
    </Example>
  </Examples>
  <Constraints>
    - The improved prompt must guide the AI to generate a secure and user-friendly setup script.
    - The `setup.sh` script should handle errors gracefully and provide informative messages.
    - RDP credentials should not be hardcoded in any files; instead, environment variables must be used.
  </Constraints>
  <OutputFormat>An XML-formatted prompt designed to elicit a robust and secure `setup.sh` script for RDP monitoring deployment.</OutputFormat>
  <Tone>Professional, instructive, and security-conscious.</Tone>
  <UnderlyingDependencies>The generated setup script depends on Docker and docker-compose being installed on the target system.</UnderlyingDependencies>
  <ClarificationQuestions>Should the generated script include options for sending alerts on failed RDP connections? If so, what notification methods (e.g., email, Slack) should be supported?</ClarificationQuestions>
</Prompt>
```