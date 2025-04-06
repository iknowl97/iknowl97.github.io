```xml
<Prompt>
  <AgentName>RDPHealthMonitor</AgentName>
  <Goal>Design a Dockerized system that periodically checks the login process to an RDP server, logs the results to a database, and presents the data in a simple dashboard.</Goal>
  <Context>
    The user requires an automated system to monitor the health of an RDP server. The system must:
    1.  Check RDP login periodically.
    2.  Provide multiple methods for checking connectivity to increase reliability.
    3.  Log connection attempts and their results.
    4.  Display the logged data in a simple dashboard.
    5.  Ignore certificate issues during RDP connection.
    6.  Report detailed error messages upon login failure.
  </Context>
  <Instructions>
    <Section name="Docker Setup">
      1.  Create a `docker-compose.yml` file to orchestrate the different services:
          *   RDP Checker Service: Contains scripts to test RDP login.
          *   Database Service: Stores the logs of RDP checks.
          *   Dashboard Service: Provides a simple UI for visualizing the logs.
      2.  Define Dockerfiles for each service, ensuring they include necessary dependencies.
    </Section>

    <Section name="RDP Checker Service">
      1.  Implement multiple methods for checking RDP login:
          *   `check_rdp.sh`: A shell script that uses `xfreerdp` or `rdesktop` to attempt a connection.  Configure it to ignore certificate errors using the `/cert-ignore` option.
          *   `check_rdp.py`: A Python script using the `pypython-nmap` library to verify the availability of the RDP port and then attempt login using `python-rdesktop`.
          *   Alternative: Consider `nmap` for port scanning and `hydra` for login attempts as additional methods.
      2.  The scripts should:
          *   Attempt to connect to the RDP server (`demo.fina.ge:2400`) using the provided credentials (`scheduledchecker` / `ch3ckerScheduler`).
          *   Capture the output and exit code of the RDP connection attempt.
          *   Log the attempt details (timestamp, method used, result, error message) to the database.
      3.  Schedule the RDP checks to run every 5 minutes using `cron`.
    </Section>

    <Section name="Database Service">
      1.  Use a lightweight database like SQLite or PostgreSQL.
      2.  Define a table schema to store the RDP check logs:
          ```sql
          CREATE TABLE rdp_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            method VARCHAR(255) NOT NULL,
            result VARCHAR(255) NOT NULL,
            error_message TEXT,
            server VARCHAR(255) NOT NULL,
            port INTEGER NOT NULL,
            username VARCHAR(255) NOT NULL
          );
          ```
      3.  Ensure the RDP Checker Service can connect to the database to log results.
    </Section>

    <Section name="Dashboard Service">
      1.  Develop a simple web dashboard using a framework like Flask (Python) or Node.js.
      2.  The dashboard should:
          *   Fetch the RDP check logs from the database.
          *   Display the logs in a tabular format.
          *   Include filtering options (e.g., by result, time range).
          *   Show the overall success/failure rate.
    </Section>

    <Section name="Error Handling">
      1.  Implement robust error handling in the RDP Checker Service.
      2.  Capture detailed error messages from the RDP connection attempts (e.g., using `stderr` redirection).
      3.  Store the error messages in the database for analysis.
      4.  Implement retry logic with exponential backoff for failed connection attempts.
    </Section>

    <Section name="Configuration">
      1.  Use environment variables for sensitive information (RDP password, database credentials).
      2.  Provide a configuration file for specifying the RDP server address, port, username, and check interval.
      3.  Ensure that all configurations are externalized so the Docker container is configurable without rebuilding.
    </Section>

    <Section name="Alternatives">
      1.  Consider using Telegraf for collecting metrics from the RDP checks and InfluxDB for storing the time-series data, paired with Chronograf or Grafana for visualization.
      2.  Explore centralized logging solutions like ELK stack or Graylog for better log management and analysis.
    </Section>
  </Instructions>
  <Example>
    <Request>
      Monitor RDP server `demo.fina.ge:2400` with username `scheduledchecker` and password `ch3ckerScheduler`.
    </Request>
    <Response>
      Successfully connected to RDP server.
    </Response>
    <Request>
      Monitor RDP server `demo.fina.ge:2400` with username `scheduledchecker` and password `ch3ckerScheduler`.
    </Request>
    <Response>
      Failed to connect to RDP server. Error: Authentication failed.
    </Response>
  </Example>
  <Constraints>
    - The system must be lightweight and efficient.
    - The dashboard should be simple and easy to use.
    - The RDP password must be securely stored.
    - The system must handle network connectivity issues gracefully.
  </Constraints>
  <Enhancements>
    - Add alerting capabilities (e.g., email notifications) for failed RDP checks.
    - Implement more sophisticated dashboard features (e.g., historical trends, anomaly detection).
    - Integrate with a monitoring system like Prometheus for comprehensive monitoring.
    - Implement TLS encryption for database connections.
  </Enhancements>
  <Fallback>
    If the primary RDP check method fails, the system should automatically attempt the alternative methods. If all methods fail, an error message should be logged, and a retry attempt should be scheduled after a specified delay.
  </Fallback>
</Prompt>
```