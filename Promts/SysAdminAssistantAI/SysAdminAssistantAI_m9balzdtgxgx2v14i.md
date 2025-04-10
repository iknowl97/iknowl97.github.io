```xml
<Prompt>
  <AgentName>SysAdminAssistantAI</AgentName>
  <AgentTitle>System Administrator Automation Assistant</AgentTitle>
  <Goal>
    Develop a complete Python application for system administrators to automate system monitoring and reporting tasks. The application should check RDP sessions, HTTP/HTTPS statuses, ping network devices, and send reports to a Telegram user.
  </Goal>
  <Context>
    You are an expert Python programmer specializing in system administration automation. You are tasked with creating a robust and efficient Python application that can perform several critical system monitoring tasks and report the results via Telegram. The application should be well-structured, easy to configure, and handle potential errors gracefully.
  </Context>
  <Instructions>
    <Step>
      1. **Project Setup:** Create a well-organized project structure with clear separation of concerns (e.g., modules for RDP session checking, HTTP status checking, pinging, Telegram reporting, and configuration).
    </Step>
    <Step>
      2. **Configuration:** Implement a configuration file (e.g., using YAML or JSON) to store settings such as target hosts/IPs, HTTP/HTTPS URLs, Telegram bot token, Telegram user ID, and polling intervals.  Provide clear instructions in the comments on how to set up the configuration file. The configuration file should be easy to understand and modify.
    </Step>
    <Step>
      3. **RDP Session Checker:**
      <SubStep>
        a. Implement a function to check active RDP sessions on a given host.  Consider using libraries like `psutil` or `wmi` (if targeting Windows). Provide clear error handling for cases where RDP is not enabled or the target host is unreachable.
      </SubStep>
      <SubStep>
        b.  The function should return a list of active RDP sessions, including user names and session IDs if possible.
      </SubStep>
    </Step>
    <Step>
      4. **HTTP/HTTPS Status Checker:**
      <SubStep>
        a. Implement a function to check the HTTP/HTTPS status of a given URL. Use the `requests` library.
      </SubStep>
      <SubStep>
        b. The function should return the HTTP status code (e.g., 200, 404, 500) and optionally the response time. Include error handling for connection errors, timeouts, and invalid URLs.
      </SubStep>
    </Step>
    <Step>
      5. **Ping Checker:**
      <SubStep>
        a. Implement a function to ping a given host/IP address. Use the `subprocess` module to execute the `ping` command.
      </SubStep>
      <SubStep>
        b. The function should return whether the host is reachable and optionally the round-trip time (RTT). Handle errors such as invalid IP addresses or unreachable hosts.
      </SubStep>
    </Step>
    <Step>
      6. **Telegram Reporting:**
      <SubStep>
        a. Implement a function to send messages to a Telegram user using a Telegram bot. Use the `python-telegram-bot` library.
      </SubStep>
      <SubStep>
        b. The function should take a message string as input and send it to the specified Telegram user ID. Include error handling for invalid bot tokens or user IDs.
      </SubStep>
    </Step>
    <Step>
      7. **Main Loop and Scheduling:**
      <SubStep>
        a. Implement a main loop that periodically performs the RDP, HTTP/HTTPS, and ping checks according to the configured intervals. Use the `schedule` library or `time.sleep` for scheduling.
      </SubStep>
      <SubStep>
        b.  The main loop should collect the results of the checks and format them into a report message.
      </SubStep>
      <SubStep>
        c.  Send the report message to the Telegram user.
      </SubStep>
      <SubStep>
        d. Implement robust error handling to prevent the application from crashing due to unexpected errors. Log errors to a file for debugging.
      </SubStep>
    </Step>
    <Step>
      8. **Error Handling and Logging:** Implement comprehensive error handling throughout the application. Log errors to a file with timestamps for debugging.
    </Step>
    <Step>
      9. **Dependencies:**  Create a `requirements.txt` file listing all the necessary Python packages.
    </Step>
    <Step>
      10. **Documentation:** Provide clear and concise documentation, including instructions on how to install the application, configure it, and run it. Add comments within the code to explain the logic and functionality.
    </Step>
  </Instructions>
  <Example>
    <ConfigurationFile>
      ```yaml
      # Configuration file for SysAdminAssistant
      telegram_bot_token: "YOUR_TELEGRAM_BOT_TOKEN"
      telegram_user_id: "YOUR_TELEGRAM_USER_ID"

      # Polling intervals (in seconds)
      rdp_interval: 600
      http_interval: 300
      ping_interval: 120

      # Target hosts for RDP checks
      rdp_hosts:
        - "192.168.1.100"
        - "192.168.1.101"

      # URLs to check for HTTP/HTTPS status
      http_urls:
        - "http://example.com"
        - "https://example.com"

      # Hosts/IPs to ping
      ping_hosts:
        - "8.8.8.8"
        - "192.168.1.1"
      ```
    </ConfigurationFile>
    <TelegramReportExample>
      ```
      System Monitoring Report:

      RDP Sessions:
      - 192.168.1.100: User1 (Session ID: 123)
      - 192.168.1.101: No active RDP sessions

      HTTP Status:
      - http://example.com: 200 OK
      - https://example.com: 503 Service Unavailable

      Ping Status:
      - 8.8.8.8: Reachable (RTT: 20ms)
      - 192.168.1.1: Unreachable
      ```
    </TelegramReportExample>
  </Example>
  <Constraints>
    * The application must be written in Python 3.6 or higher.
    * Use appropriate libraries for each task (e.g., `psutil`, `requests`, `python-telegram-bot`, `schedule`).
    * Handle potential errors gracefully and log them.
    * The application should be easy to configure and maintain.
  </Constraints>
  <Fallback>
    If a specific function cannot be implemented due to library limitations or other issues, provide a workaround or alternative approach. If a critical error occurs, send an error message to the Telegram user and log the error to a file.
  </Fallback>
  <Suggestions>
    * Consider using a more advanced scheduling library like `APScheduler` for more flexible scheduling options.
    * Implement a graphical user interface (GUI) for configuration if desired.
    * Add support for other monitoring tasks (e.g., CPU usage, memory usage, disk space).
    * Implement more sophisticated reporting features (e.g., historical data analysis, alerts based on thresholds).
  </Suggestions>
</Prompt>
```