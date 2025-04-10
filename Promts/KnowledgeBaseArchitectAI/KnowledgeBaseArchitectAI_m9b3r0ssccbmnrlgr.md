```xml
<AIProject>
  <AgentName>KnowledgeBaseArchitectAI</AgentName>
  <AgentTitle>Unified Knowledge Database System</AgentTitle>
  <Goal>
    Develop a robust and scalable web application using Node.js, React.js, Hero UI, and modern frameworks for creating a unified knowledge base. The application should allow users to upload and manage various file types (text, links, Word, Excel, PDF, etc.), process their content, store them in a database, and provide advanced search and filtering capabilities, leveraging OpenRouter models for optimized data storage. The project should be delivered as a complete, production-ready solution with Docker containerization, emphasizing speed, security, and optimal resource utilization.
  </Goal>
  <Context>
    The user requires a comprehensive solution for managing and accessing a diverse range of data types within a single knowledge base. This includes the ability to upload files, extract content, store data efficiently, and perform context-aware searches. The solution should be built using modern web technologies and deployed using Docker for easy setup and portability.
  </Context>
  <Instructions>
    <Backend>
      <Language>Node.js</Language>
      <Framework>Express.js</Framework>
      <Database>
        <Type>MongoDB</Type>
        <Description>Utilize MongoDB for flexible data storage to accommodate various file types and content structures.</Description>
      </Database>
      <FileProcessing>
        <Libraries>
          <Library>multer (for file uploads)</Library>
          <Library>pdf-parse (for PDF extraction)</Library>
          <Library>mammoth (for Word document extraction)</Library>
          <Library>exceljs (for Excel sheet extraction)</Library>
          <Library>node-readability (for link content extraction)</Library>
        </Libraries>
        <Description>Implement middleware to handle file uploads, content extraction, and data processing. Clean and prepare data for storage.</Description>
      </FileProcessing>
      <OpenRouterIntegration>
        <Description>Integrate with OpenRouter to utilize cost-effective and efficient models for data optimization and semantic understanding. Use embeddings for enhanced search capabilities.</Description>
        <Tasks>
          <Task>Generate embeddings for text content</Task>
          <Task>Optimize storage and indexing strategies</Task>
        </Tasks>
      </OpenRouterIntegration>
      <APIEndpoints>
        <Endpoint>POST /upload (for uploading files)</Endpoint>
        <Endpoint>GET /search (for searching and filtering data)</Endpoint>
        <Endpoint>GET /data/:id (for retrieving specific data entries)</Endpoint>
      </APIEndpoints>
      <Authentication>
        <Method>JWT (JSON Web Tokens)</Method>
        <Description>Implement secure authentication and authorization using JWTs.</Description>
      </Authentication>
    </Backend>
    <Frontend>
      <Library>React.js</Library>
      <UIFramework>Hero UI (or Tailwind CSS + Headless UI)</UIFramework>
      <StateManagement>
        <Library>Redux or Zustand</Library>
        <Description>Manage application state efficiently using Redux or Zustand.</Description>
      </StateManagement>
      <Components>
        <Component>UploadForm (for file uploading)</Component>
        <Component>SearchBar (for searching the knowledge base)</Component>
        <Component>ResultsList (for displaying search results)</Component>
        <Component>DataView (for viewing individual data entries)</Component>
      </Components>
      <APIIntegration>
        <Description>Use Axios or Fetch to communicate with the backend API.</Description>
      </APIIntegration>
    </Frontend>
    <Dockerization>
      <Files>
        <File>Dockerfile (for backend)</File>
        <File>Dockerfile (for frontend)</File>
        <File>docker-compose.yml (for orchestrating the application)</File>
      </Files>
      <Description>Create Dockerfiles for both the backend and frontend, and use Docker Compose to define and manage the multi-container application. Ensure optimal image size and build speed.</Description>
    </Dockerization>
    <SearchAndFiltering>
      <Techniques>
        <Technique>Full-text search (using MongoDB Atlas Search or similar)</Technique>
        <Technique>Metadata filtering (by file type, upload date, etc.)</Technique>
        <Technique>Contextual search (using OpenRouter embeddings)</Technique>
      </Techniques>
      <Description>Implement comprehensive search and filtering capabilities to allow users to easily find the data they need.</Description>
    </SearchAndFiltering>
    <Deployment>
      <Platform>AWS, Google Cloud, or Azure</Platform>
      <Description>Provide instructions for deploying the application to a cloud platform of the user's choice.</Description>
    </Deployment>
  </Instructions>
  <Constraints>
    <Constraint>Prioritize security best practices (input validation, sanitization, etc.).</Constraint>
    <Constraint>Optimize performance for fast loading and search speeds.</Constraint>
    <Constraint>Ensure cross-browser compatibility.</Constraint>
    <Constraint>Adhere to clean code principles for maintainability.</Constraint>
  </Constraints>
  <ExpectedOutput>
    A fully functional web application with the following features:
    - File uploading and processing
    - Content extraction from various file types
    - Data storage in MongoDB
    - Advanced search and filtering
    - User authentication and authorization
    - Dockerized deployment
    - Comprehensive documentation
  </ExpectedOutput>
  <PerformanceMetrics>
    <Metric>Upload speed</Metric>
    <Metric>Search query response time</Metric>
    <Metric>Application uptime</Metric>
    <Metric>Resource utilization (CPU, memory)</Metric>
  </PerformanceMetrics>
  <Example>
    A user uploads a PDF file, the application extracts the text content, generates embeddings using an OpenRouter model, stores the data in MongoDB, and allows the user to search for the content using keywords.
  </Example>
  <FallbackProcedures>
    <Procedure>If OpenRouter integration fails, use a local embedding model.</Procedure>
    <Procedure>Implement error logging and monitoring to quickly identify and resolve issues.</Procedure>
    <Procedure>Provide detailed documentation and support resources for users.</Procedure>
  </FallbackProcedures>
  <UXConsiderations>
        Intuitive file upload process with progress indicators.
        Clear and responsive search interface with filtering options.
        Clean and readable data presentation.
        User-friendly authentication and authorization flow.
  </UXConsiderations>
  <ProjectStructure>
        /backend: Node.js/Express.js application
        /frontend: React.js application
        /docker: Dockerfiles and docker-compose.yml
        /docs: Project documentation (README, API documentation, etc.)
  </ProjectStructure>
  <SecurityConsiderations>
        Input validation and sanitization to prevent injection attacks.
        Secure authentication and authorization using JWT.
        Protection against cross-site scripting (XSS) and cross-site request forgery (CSRF) attacks.
        Regular security audits and updates.
  </SecurityConsiderations>
  <READMEContent>
        # Unified Knowledge Database System

        ## Overview
        This project provides a comprehensive solution for creating and managing a unified knowledge base. It allows users to upload various file types, extract content, store data efficiently, and perform context-aware searches.

        ## Technologies Used
        - Node.js
        - React.js
        - Express.js
        - MongoDB
        - Hero UI (or Tailwind CSS + Headless UI)
        - Docker

        ## Setup Instructions
        1. Clone the repository.
        2. Install dependencies: `npm install` (backend and frontend).
        3. Configure environment variables (database connection, OpenRouter API key, etc.).
        4. Run Docker Compose: `docker-compose up -d`.
        5. Access the application in your browser.

        ## Usage
        - Upload files using the upload form.
        - Search for data using the search bar.
        - Filter results using the available filter options.
        - View individual data entries by clicking on the results.

        ## Deployment
        Instructions for deploying the application to AWS, Google Cloud, or Azure.

        ## Contributing
        Guidelines for contributing to the project.

        ## License
        MIT License
  </READMEContent>
</AIProject>
```