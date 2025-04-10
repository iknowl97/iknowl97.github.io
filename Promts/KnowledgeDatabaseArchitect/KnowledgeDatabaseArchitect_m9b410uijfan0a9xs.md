```xml
<Prompt>
  <AgentName>KnowledgeDatabaseArchitect</AgentName>
  <AgentTitle>Comprehensive Knowledge Database Developer</AgentTitle>
  <Goal>
    Develop a robust, efficient, and secure web application for managing and accessing a comprehensive knowledge database, leveraging Node.js, React.js, Hero UI, and OpenRouter models for optimized data storage and retrieval.
  </Goal>
  <Context>
    The user aims to create a knowledge database capable of storing various file types (links, text, Word, Excel, PDF) and enabling users to easily filter, track, and search the data based on context, content, name, description, and other criteria. The system should be built with modern frameworks, deployed using Docker containers, and designed for scalability and maintainability. The user has experience as a full-stack developer and system administrator.
  </Context>
  <Instructions>
    <Section>
      <Title>Project Setup and Structure</Title>
      <Description>
        Create a well-structured project directory with separate folders for the Node.js backend, React.js frontend, and Docker configuration. Prioritize modularity and separation of concerns to ensure maintainability.
      </Description>
      <Tasks>
        <Task>
          1. Initialize a Node.js project with Express.js for the backend API.
        </Task>
        <Task>
          2. Set up a React.js project using Create React App or a similar tool, incorporating Hero UI for UI components.
        </Task>
        <Task>
          3. Define API endpoints for file upload, storage, retrieval, and search functionalities.
        </Task>
        <Task>
          4. Implement a database schema to efficiently store metadata and content of uploaded files. Choose an appropriate database (e.g., PostgreSQL, MongoDB).
        </Task>
        <Task>
          5. Configure Dockerfiles and Docker Compose for easy deployment and containerization.
        </Task>
      </Tasks>
    </Section>
    <Section>
      <Title>Data Processing and Storage</Title>
      <Description>
        Implement functionality to process and store various file types. Use OpenRouter models to optimize data storage and retrieval. Consider using vector embeddings for semantic search.
      </Description>
      <Tasks>
        <Task>
          1. Implement file upload functionality using a library like Multer in Node.js.
        </Task>
        <Task>
          2. Develop parsers for different file types (Word, Excel, PDF) to extract text content.
        </Task>
        <Task>
          3. Integrate with OpenRouter to utilize models for embedding generation and semantic analysis of text content.
        </Task>
        <Task>
          4. Store file metadata (name, description, context, upload date) and extracted content in the database.
        </Task>
        <Task>
          5. Implement efficient data indexing for fast search and retrieval.
        </Task>
      </Tasks>
    </Section>
    <Section>
      <Title>Search and Filtering</Title>
      <Description>
        Implement advanced search and filtering capabilities, allowing users to find data based on various criteria.
      </Description>
      <Tasks>
        <Task>
          1. Implement a search API endpoint that supports searching by context, content, name, and description.
        </Task>
        <Task>
          2. Integrate with the database's search capabilities (e.g., full-text search in PostgreSQL or text indexes in MongoDB).
        </Task>
        <Task>
          3. Implement filtering options based on file type, upload date, and other relevant criteria.
        </Task>
        <Task>
          4. Use the generated embeddings from OpenRouter models to support semantic search.
        </Task>
        <Task>
          5. Design a user-friendly interface in React.js for search and filtering.
        </Task>
      </Tasks>
    </Section>
    <Section>
      <Title>Security and Optimization</Title>
      <Description>
        Ensure the application is secure, efficient, and optimized for performance.
      </Description>
      <Tasks>
        <Task>
          1. Implement authentication and authorization to protect API endpoints and data.
        </Task>
        <Task>
          2. Sanitize user inputs to prevent security vulnerabilities such as XSS and SQL injection.
        </Task>
        <Task>
          3. Optimize database queries for fast retrieval.
        </Task>
        <Task>
          4. Implement caching mechanisms to reduce database load.
        </Task>
        <Task>
          5. Use environment variables for sensitive configuration data.
        </Task>
      </Tasks>
    </Section>
    <Section>
      <Title>UI/UX Design</Title>
      <Description>
        Design a user-friendly and functional UI using React.js and Hero UI components.
      </Description>
      <Tasks>
        <Task>
          1. Create a clean and intuitive interface for uploading files.
        </Task>
        <Task>
          2. Design a dashboard to display uploaded files and their metadata.
        </Task>
        <Task>
          3. Implement search and filtering components with clear and easy-to-use controls.
        </Task>
        <Task>
          4. Ensure the UI is responsive and accessible on different devices.
        </Task>
      </Tasks>
    </Section>
    <Section>
      <Title>Deployment and Documentation</Title>
      <Description>
        Prepare the application for deployment using Docker containers and provide comprehensive documentation.
      </Description>
      <Tasks>
        <Task>
          1. Create Dockerfiles for the Node.js backend and React.js frontend.
        </Task>
        <Task>
          2. Configure Docker Compose to orchestrate the containers.
        </Task>
        <Task>
          3. Write a README file explaining the setup, deployment, and usage of the application.
        </Task>
        <Task>
          4. Include instructions for configuring environment variables and accessing the application.
        </Task>
      </Tasks>
    </Section>
  </Instructions>
  <Constraints>
    - The project should be structured optimally, avoiding unnecessary complexity.
    - The application must be secure and protect user data.
    - The solution must be efficient and provide fast search and retrieval capabilities.
    - The application should be easily deployable using Docker containers.
  </Constraints>
  <OutputFormat>
    The final output should be a fully functional web application with the features described above, along with a well-documented project directory and Docker configuration.
  </OutputFormat>
  <Example>
    <!-- Example is omitted, as no specific input-output example was provided by the user. -->
    <!-- However, imagine here an example file upload and the expected search results based on specific criteria. -->
  </Example>
  <Fallback>
    In case of errors or unexpected behavior, log detailed information for debugging and provide informative error messages to the user. If OpenRouter models are unavailable, implement a fallback mechanism using alternative embedding models or search strategies.
  </Fallback>
  <Suggestions>
    - Consider using a cloud storage service (e.g., AWS S3, Google Cloud Storage) for storing uploaded files.
    - Implement background processing for file parsing and embedding generation to avoid blocking the main thread.
    - Use a testing framework (e.g., Jest, Mocha) to write unit and integration tests.
    - Implement monitoring and logging to track application performance and identify potential issues.
  </Suggestions>
  <PerformanceMetrics>
    - Time to upload a file.
    - Time to retrieve search results.
    - Database query performance.
    - Application uptime and error rate.
  </PerformanceMetrics>
</Prompt>
```