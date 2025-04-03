```xml
<Prompt>
  <Task>
    <Title>Develop IT Team Simplification Tools with Full-Stack and Docker Support</Title>
    <Description>Design, develop, and implement a suite of tools to streamline the daily tasks of an IT team. This includes both backend and frontend components, each containerized with Docker for easy deployment and scaling. The backend should use C# and ASP.NET, while the frontend technology stack can be determined based on project needs and IT team familiarity (e.g., React, Angular, Vue.js). Ensure comprehensive documentation is provided for setup, usage, and maintenance.</Description>
  </Task>

  <Context>
    <Domain>Information Technology</Domain>
    <TargetAudience>IT Professionals</TargetAudience>
    <Purpose>Improve efficiency and reduce workload for IT staff by automating and simplifying common tasks.</Purpose>
    <Background>The IT team currently faces challenges with repetitive manual tasks, leading to inefficiencies and potential errors. Automated tools are needed to improve productivity and accuracy.</Background>
  </Context>

  <Requirements>
    <Backend>
      <Language>C#</Language>
      <Framework>ASP.NET</Framework>
      <Database>
        <Description>Choose an appropriate database based on the data complexity and volume (e.g., SQL Server, PostgreSQL, MongoDB).</Description>
        <Suggestion>Consider using Entity Framework Core for ORM to simplify database interactions.</Suggestion>
      </Database>
      <APIs>
        <Description>Design RESTful APIs for frontend interaction.</Description>
        <Authentication>Implement secure authentication and authorization mechanisms.</Authentication>
      </APIs>
      <Docker>
        <Dockerfile>Create a Dockerfile for containerizing the ASP.NET backend application.</Dockerfile>
        <DockerCompose>Optionally, use Docker Compose for multi-container setup (e.g., backend, database).</DockerCompose>
      </Docker>
    </Backend>
    <Frontend>
      <Technology>
        <Description>Select a suitable frontend framework/library (e.g., React, Angular, Vue.js).</Description>
        <Considerations>Consider IT team's existing skills and project complexity.</Considerations>
      </Technology>
      <UI>
        <Description>Develop an intuitive and user-friendly interface.</Description>
        <Guidelines>Follow UI/UX best practices.</Guidelines>
      </UI>
      <Communication>
        <Description>Consume backend APIs to display and manipulate data.</Description>
      </Communication>
      <Docker>
        <Dockerfile>Create a Dockerfile for containerizing the frontend application.</Dockerfile>
      </Docker>
    </Frontend>
    <Functionality>
      <ToolExamples>
        <Example>
          <Name>Automated Server Monitoring</Name>
          <Description>Monitor server health metrics (CPU, memory, disk space) and provide alerts for potential issues.</Description>
          <Components>Backend API to collect server data, Frontend dashboard to visualize metrics, Alerting system.</Components>
        </Example>
        <Example>
          <Name>Script Deployment Tool</Name>
          <Description>Centralized tool for deploying scripts across multiple servers.</Description>
          <Components>Backend API to manage and execute scripts, Frontend interface to upload and schedule deployments, Version control.</Components>
        </Example>
        <Example>
          <Name>Network Configuration Management</Name>
          <Description>Manage and track network configurations, automate configuration backups and rollbacks.</Description>
          <Components>Backend API to interact with network devices, Frontend interface to view and modify configurations, Audit logging.</Components>
        </Example>
      </ToolExamples>
    </Functionality>
    <Documentation>
      <Types>
        <Type>Setup Guide</Type>
        <Type>User Manual</Type>
        <Type>API Documentation (using Swagger/OpenAPI)</Type>
        <Type>Development Guide</Type>
      </Types>
    </Documentation>
  </Requirements>

  <Constraints>
    <ResourceLimits>Consider the available resources (budget, team size, infrastructure) when selecting technologies and planning the development process.</ResourceLimits>
    <Security>Prioritize security best practices in both backend and frontend development.</Security>
    <Scalability>Design the application to be scalable to accommodate future growth.</Scalability>
    <Maintainability>Write clean, well-documented code to ensure long-term maintainability.</Maintainability>
  </Constraints>

  <Example>
    <UserRequest>Develop a tool to automate the creation of user accounts in Active Directory.</UserRequest>
    <ExpectedOutput>
      Backend C# ASP.NET API that interfaces with Active Directory to create user accounts.
      Frontend React application with a form for entering user details.
      Dockerfiles for both backend and frontend for easy deployment.
    </ExpectedOutput>
  </Example>

  <Enhancements>
    <Suggestion>
      Incorporate logging and monitoring throughout the application to track performance and identify potential issues.
    </Suggestion>
    <Placeholder>
      [Specify additional tools or functionalities based on the IT team's specific needs.]
    </Placeholder>
  </Enhancements>

  <Fallback>
    If a specific functionality is too complex to implement within the given timeframe, prioritize core features and consider breaking down the complex functionality into smaller, manageable tasks for future iterations.
  </Fallback>

  <SuccessCriteria>
    <Criterion>The developed tools are successfully deployed and containerized with Docker.</Criterion>
    <Criterion>The IT team reports a significant improvement in efficiency and a reduction in manual effort.</Criterion>
    <Criterion>The application is stable, secure, and easy to maintain.</Criterion>
    <Criterion>Comprehensive documentation is available for all components.</Criterion>
  </SuccessCriteria>

  <Version>1.0</Version>
  <Author>IdealPromptGenerator</Author>
</Prompt>
```