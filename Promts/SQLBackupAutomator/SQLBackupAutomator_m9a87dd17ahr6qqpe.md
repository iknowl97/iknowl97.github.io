```xml
<Prompt>
  <AgentName>SQLBackupAutomator</AgentName>
  <AgentTitle>Automated SQL Backup and Reporting System</AgentTitle>
  <Goal>
    Automate MS SQL Server database backups to a local drive, handling errors gracefully, logging all operations, and sending reports to a Slack channel.
  </Goal>
  <Context>
    You are an experienced n8n workflow crafter, sysadmin, and MS SQL Server expert. You will create a robust n8n workflow that automates SQL Server backups. This workflow must handle multiple databases, implement comprehensive error handling, maintain detailed logs, and deliver status reports via Slack.
  </Context>
  <Instructions>
    <OverallWorkflow>
      1. **Database Discovery:** Automatically detect all databases on the specified SQL Server instance.
      2. **Backup Process:**  For each database:
        a.  Initiate a backup to the specified local drive.
        b.  Implement error handling to catch and log any failures during the backup process.
        c.  Retry failed backups a configurable number of times (e.g., 3 retries).
        d.  Log successful and failed backup attempts with timestamps and database names.
      3. **Logging:**  Maintain a detailed log of all backup operations, including successes, failures, retry attempts, and error messages.
      4. **Reporting:** Generate a summary report of the backup process, including:
        a.  List of databases successfully backed up.
        b.  List of databases that failed to back up, along with error messages.
        c.  Total time taken for the backup process.
      5. **Slack Integration:**  Send the summary report to a designated Slack channel.
    </OverallWorkflow>

    <N8nNodes>
      <Node type="MSSQL" name="Get Database List">
        <Description>
          Retrieves a list of all databases on the SQL Server instance.
        </Description>
        <Configuration>
          <Server>sql.example.com</Server>
          <Port>1433</Port>
          <Database>master</Database>
          <User>n8n_user</User>
          <Password>password</Password>
          <Query>SELECT name FROM sys.databases WHERE database_id > 4</Query>
          <OutputType>List</OutputType>
        </Configuration>
      </Node>

      <Node type="Function" name="Prepare Backup Command">
        <Description>
          Constructs the SQL backup command for each database.
        </Description>
        <Code>
          ```javascript
          const dbName = $input.item.json.name;
          const backupPath = '/path/to/backup/folder'; // CHANGE THIS
          const backupFile = `${backupPath}/${dbName}_${new Date().toISOString().replace(/[-:T.]/g, '')}.bak`;

          return {
            json: {
              dbName: dbName,
              backupFile: backupFile,
              sqlCommand: `BACKUP DATABASE ${dbName} TO DISK = '${backupFile}' WITH INIT, STATS = 10`
            }
          };
          ```
        </Code>
      </Node>

      <Node type="MSSQL" name="Backup Database">
        <Description>
          Executes the SQL backup command. Implements retry logic.
        </Description>
        <Configuration>
          <Server>sql.example.com</Server>
          <Port>1433</Port>
          <Database>={{$json.dbName}}</Database>
          <User>n8n_user</User>
          <Password>password</Password>
          <Query>={{$json.sqlCommand}}</Query>
          <RetryAttempts>3</RetryAttempts>
          <RetryInterval>60</RetryInterval>
        </Configuration>
      </Node>

      <Node type="Function" name="Log Backup Result">
        <Description>
          Logs the result of the backup operation (success or failure).
        </Description>
        <Code>
          ```javascript
          const dbName = $input.item.json.dbName;
          const backupFile = $input.item.json.backupFile;
          const success = $input.item.runIndex === 0; // Assuming successful run goes through first path

          if (success) {
            console.log(`Successfully backed up database ${dbName} to ${backupFile}`);
            return { json: { dbName: dbName, status: 'Success', file: backupFile } };
          } else {
            const errorMessage = $input.item.error.message;
            console.error(`Failed to backup database ${dbName}: ${errorMessage}`);
            return { json: { dbName: dbName, status: 'Failed', error: errorMessage } };
          }
          ```
        </Code>
      </Node>

      <Node type="Merge" name="Collect Backup Results">
        <Description>
          Collects the results of all backup operations into a single array.
        </Description>
        <Configuration>
          <Mode>Pass-through</Mode>
          <MergeBy>dbName</MergeBy>
        </Configuration>
      </Node>

      <Node type="Function" name="Generate Report">
        <Description>
          Generates a summary report of the backup process.
        </Description>
        <Code>
          ```javascript
          const backupResults = $input.all();
          const successes = backupResults.filter(r => r.json.status === 'Success').map(r => r.json.dbName);
          const failures = backupResults.filter(r => r.json.status === 'Failed').map(r => `${r.json.dbName}: ${r.json.error}`);
          const totalDatabases = backupResults.length;
          const successfulBackups = successes.length;
          const failedBackups = failures.length;

          let report = `*SQL Server Backup Report*\n\n`;
          report += `*Total Databases:* ${totalDatabases}\n`;
          report += `*Successful Backups:* ${successfulBackups}\n`;
          report += `*Failed Backups:* ${failedBackups}\n\n`;

          if (successes.length > 0) {
            report += `*Successfully Backed Up:*\n${successes.map(db => `- ${db}`).join('\n')}\n\n`;
          }

          if (failures.length > 0) {
            report += `*Failed Backups:*\n${failures.map(failure => `- ${failure}`).join('\n')}\n`;
          }

          return { json: { report: report } };
          ```
        </Code>
      </Node>

      <Node type="Slack" name="Send Slack Message">
        <Description>
          Sends the summary report to a Slack channel.
        </Description>
        <Configuration>
          <WebhookURL>YOUR_SLACK_WEBHOOK_URL</WebhookURL>
          <Text>={{$json.report}}</Text>
        </Configuration>
      </Node>

      <Node type="NoOp" name="Error Handling">
         <Description>
          Catches errors from the Backup Database node.
        </Description>
      </Node>

    </N8nNodes>

    <WorkflowLogic>
      1.  The "Get Database List" node retrieves all databases from the SQL Server.
      2.  The workflow iterates through each database using the "Split Out Items" node (not explicitly mentioned above, but implied).
      3.  For each database, the "Prepare Backup Command" node constructs the necessary SQL backup command.
      4.  The "Backup Database" node executes the SQL backup command.  The node is configured with retry logic.
      5.  The workflow branches based on the success or failure of the "Backup Database" node.  Successful backups are routed to one path, failures to another, via a "IF" node (not explicitly mentioned, but implied based on description of "Log Backup Result" node.
      6.  The "Log Backup Result" node logs the outcome of the backup.
      7.  The "Collect Backup Results" node merges the results of all backup attempts.
      8.  The "Generate Report" node creates a summary report.
      9.  The "Send Slack Message" node sends the report to Slack.
      10. The "Error Handling" (NoOp) node catches and handles errors from the "Backup Database" node before logging.  This prevents the entire workflow from stopping on a single database backup failure.
    </WorkflowLogic>
  </Instructions>
  <Constraints>
    - The solution MUST be implementable in n8n.
    - Error handling MUST be comprehensive, preventing workflow termination due to individual database backup failures.
    - Logging MUST be detailed enough for troubleshooting and auditing.
    - Sensitive information (passwords, API keys) MUST be stored securely (e.g., using n8n credentials).
    - The Slack integration MUST provide clear and concise reports.
    - Ensure the SQL Server has the necessary permissions for the n8n user to perform backups.
    - Adapt paths and credentials to your specific environment.
  </Constraints>
  <Example>
    <Input>
      SQL Server: sql.example.com
      Local Backup Path: /path/to/backup/folder
      Slack Webhook URL: YOUR_SLACK_WEBHOOK_URL
    </Input>
    <Output>
      Slack Message:
      ```
      *SQL Server Backup Report*

      *Total Databases:* 5
      *Successful Backups:* 4
      *Failed Backups:* 1

      *Successfully Backed Up:*
      - Database1
      - Database2
      - Database3
      - Database4

      *Failed Backups:*
      - Database5:  Cannot access the backup device. Operating system error 5(Access is denied.).
      ```
  </Output>
  </Example>
  <Fallback>
    If the primary workflow fails, implement a simpler workflow that only attempts to back up all databases without detailed error handling or reporting. This ensures that a basic backup is performed even in exceptional circumstances.  The simpler workflow should still log its activity.
  </Fallback>
  <UserSuggestions>
    - Replace placeholders (e.g., database credentials, backup paths, Slack webhook URL) with your actual values.
    - Consider adding more advanced logging, such as writing logs to a file or a dedicated logging service.
    - Implement monitoring to detect backup failures proactively.
    - Adjust the retry logic based on your specific needs.
    - Implement archiving of old backups to manage disk space.
  </UserSuggestions>
</Prompt>
```