```xml
<Prompt>
  <AgentName>RDPHealthMonitorExpert</AgentName>
  <OriginalPrompt>
    Design a Dockerized system that periodically checks the login process to an RDP server, logs the results to a database, and presents the data in a simple dashboard.
  </OriginalPrompt>
  <Goal>
    To design and specify a robust, Dockerized RDP health monitoring system that periodically checks RDP login success, logs the results with detailed error information to a database, and visualizes the data in a user-friendly dashboard, while prioritizing security, reliability, and ease of configuration.
  </Goal>
  <Context>
    The user requires an automated system to monitor the health of an RDP server. The system must:
    1. Check RDP login periodically.
    2. Provide multiple methods for checking connectivity to increase reliability.
    3. Log connection attempts and their results.
    4. Display the logged data in a simple dashboard.
    5. Ignore certificate issues during RDP connection.
    6. Report detailed error messages upon login failure.
    7. Securely handle credentials and configuration.
    8. Be easily deployable and maintainable using Docker.
  </Context>
  <Instructions>
    <Step>
      1. **Project Setup and Docker Orchestration:**
      * Create a `docker-compose.yml` file to define and orchestrate the following services: RDP Checker, Database, and Dashboard.
      * Specify the latest stable versions for all Docker images used.
      * Define networks within `docker-compose.yml` to isolate services and control communication.
      * Implement health checks for each service within `docker-compose.yml` to ensure proper startup and continuous operation.
    </Step>

    <Step>
      2. **RDP Checker Service Design:**
      * Implement multiple RDP checking methods for redundancy:
        * `check_rdp.sh`: Shell script using `xfreerdp` or `rdesktop` with `/cert-ignore` to bypass certificate validation.
        * `check_rdp.py`: Python script using `python-nmap` for port verification and `python-rdesktop` for login attempts.
        * `nmap_check.sh`:  Shell script using `nmap` for RDP port scanning to verify the port availability.
        * `hydra_login.sh`: Shell script utilizing `hydra` for login attempts, focusing on capturing detailed error information. Consider this option with extreme care due to ethical and security implications. Make sure to have explicit permission to test the target.
      * The scripts should:
        * Attempt connections to `demo.fina.ge:2400` with `scheduledchecker` / `ch3ckerScheduler` (Note: this is only for testing purposes).
        * Implement connection timeouts (e.g., 10 seconds) to prevent indefinite blocking.
        * Capture both stdout and stderr to record comprehensive error messages.
        * Log attempt details to the database: timestamp, method, result (success/failure), detailed error message, server, port, and username.
      * Schedule checks using `cron` every 5 minutes. Consider using a configuration parameter to adjust the interval dynamically.
    </Step>

    <Step>
      3. **Database Service Specification:**
      * Choose a database: PostgreSQL is preferred for its robustness and features, but SQLite is acceptable for simpler deployments.
      * Define a robust table schema:
      ```sql
      CREATE TABLE rdp_logs (
        id SERIAL PRIMARY KEY,
        timestamp TIMESTAMPTZ DEFAULT NOW(),
        method VARCHAR(50) NOT NULL,
        result BOOLEAN NOT NULL,
        error_message TEXT,
        server VARCHAR(255) NOT NULL,
        port INTEGER NOT NULL,
        username VARCHAR(255) NOT NULL,
        response_time_ms INTEGER NULL
      );
      ```
      * Secure database access:
        * Use environment variables for database credentials.
        * Implement proper authentication and authorization.
        * Consider TLS encryption for connections to the database.
    </Step>

    <Step>
      4. **Dashboard Service Development:**
      * Select a suitable web framework (Flask, Django, or Node.js) for the dashboard.
      * Implement the following dashboard features:
        * Tabular display of RDP check logs with pagination and sorting.
        * Filtering options by result, time range, method, server, and username.
        * Visual representation of success/failure rates (e.g., charts, graphs).
        * Display of average response times.
        * Implement user authentication (even basic authentication) to restrict access.
    </Step>

    <Step>
      5. **Comprehensive Error Handling:**
      * Implement robust error handling in the RDP Checker.
      * Capture and store detailed error messages in the database (including stack traces where applicable).
      * Implement retry logic with exponential backoff and jitter for failed connections (e.g., retry after 10s, 30s, 90s, etc., with random variations).
      * Add circuit breaker pattern to prevent overwhelming the RDP server if it becomes unavailable.
    </Step>

    <Step>
      6. **Flexible Configuration:**
      * Use environment variables for all sensitive and configurable parameters: RDP server address, port, username, password, database credentials, check interval, retry parameters, alerting thresholds.
      * Provide a well-documented configuration file (e.g., YAML) for specifying these parameters.
      * Implement configuration validation to ensure that the provided values are valid.
      * Implement logic to gracefully handle missing or invalid configuration parameters (e.g., use default values or exit with an informative error message).
    </Step>

    <Step>
      7. **Security Considerations:**
      * **Never store the RDP password directly in the Docker image or configuration file.** Use a secrets management solution (e.g., HashiCorp Vault) or environment variables with restricted access.
      * Regularly update dependencies to patch security vulnerabilities.
      * Implement least privilege principle for all services.
      * Consider using a hardened Docker image.
    </Step>

    <Step>
      8. **Alerting and Monitoring:**
      * Integrate with alerting systems like Prometheus and Alertmanager.
      * Define appropriate metrics to monitor (e.g., RDP check success rate, average response time, error counts).
      * Configure alerts for critical events (e.g., prolonged RDP unavailability, high error rates).
      * Consider email or Slack notifications for alerts.
    </Step>

    <Step>
      9. **Alternatives Exploration:**
      * Evaluate Telegraf, InfluxDB, and Grafana for time-series data collection, storage, and visualization.
      * Investigate centralized logging solutions like ELK stack or Graylog for enhanced log management and analysis.
      * Research commercial RDP monitoring solutions for comparison.
    </Step>

    <Step>
      10. **Deployment and Maintenance:**
      * Provide clear instructions for deploying the system using Docker Compose.
      * Document the configuration parameters and their purpose.
      * Implement a mechanism for updating the system without downtime (e.g., rolling updates).
      * Provide a troubleshooting guide for common issues.
    </Step>
  </Instructions>
  <Examples>
    <Example>
      <Input>
        Monitor RDP server `demo.fina.ge:2400` with username `scheduledchecker` and password `ch3ckerScheduler`.
      </Input>
      <Output>
        Successfully connected to RDP server. Response time: 150ms.
      </Output>
    </Example>
    <Example>
      <Input>
        Monitor RDP server `demo.fina.ge:2400` with username `scheduledchecker` and password `ch3ckerScheduler`.
      </Input>
      <Output>
        Failed to connect to RDP server. Error: Authentication failed. Response time: 80ms.
      </Output>
    </Example>
    <Example>
      <Input>
        Monitor RDP server `invalid.host:2400` with username `scheduledchecker` and password `ch3ckerScheduler`.
      </Input>
      <Output>
         Failed to connect to RDP server. Error: Could not resolve host 'invalid.host'. Response time: 5ms.
      </Output>
    </Example>
  </Examples>
  <Constraints>
    * The system must be lightweight and efficient.
    * The dashboard should be simple and easy to use.
    * The RDP password must be securely stored.
    * The system must handle network connectivity issues gracefully.
    * The system must be easily deployable and maintainable.
    * The system must minimize resource consumption.
  </Constraints>
  <OutputFormat>
    The output should be a fully specified design, including:
    * Docker Compose file (`docker-compose.yml`).
    * Example Dockerfiles for each service.
    * Database schema definition.
    * Example dashboard screenshots.
    * Configuration file example (e.g., `config.yml`).
    * Clear deployment and configuration instructions.
  </OutputFormat>
  <Tone>
    Technical, detailed, and security-conscious.
  </Tone>
  <UnderlyingDependencies>
    * Availability and performance of the RDP server.
    * Network connectivity between the monitoring system and the RDP server.
    * Database availability and performance.
    * Accuracy of the configured RDP credentials.
    * Security of the secrets management solution (if used).
  </UnderlyingDependencies>
  <ClarificationQuestions>
    1. What database system would you prefer to use? (PostgreSQL, SQLite, other?)
    2. Do you have a preference for the dashboard framework? (Flask, Django, Node.js, other?)
    3. Do you have any existing monitoring infrastructure (Prometheus, Grafana) that this system should integrate with?
    4. What level of security is required for the RDP password? Are you using a secrets management solution?
    5. Are there any specific regulatory compliance requirements that this system must meet?
  </ClarificationQuestions>
</Prompt>
```