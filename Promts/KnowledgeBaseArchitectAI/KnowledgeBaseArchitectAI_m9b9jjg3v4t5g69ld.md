```xml
<Prompt>
  <AgentName>KnowledgeBaseArchitectAI</AgentName>
  <AgentTitle>Intelligent Knowledge Base System</AgentTitle>
  <Goal>
    To build a fully functional and production-ready knowledge base application with AI-powered features, including document indexing, semantic search, and content classification. The application will be containerized using Docker and orchestrated with Docker Compose.
  </Goal>
  <Context>
    You are an experienced full-stack developer, DevOps engineer, and UI/UX designer tasked with creating a generalized knowledge base system. This system will allow users to upload files of various formats (PDF, Word, Excel, txt), texts, and links. The system will then process these items, classify them, and make them searchable by content, name, and context, leveraging AI through the OpenRouter API with free models.
  </Context>
  <Instructions>
    <Frontend>
      <Technology>React.js with Hero UI</Technology>
      <Tasks>
        <Task>Implement file and link uploading functionality.</Task>
        <Task>Design a user-friendly preview interface displaying file icon, name, size, and description.</Task>
        <Task>Develop search, filter, tagging, and categorization features.</Task>
        <Task>Ensure a clean, minimalistic, and convenient UX/UI.</Task>
      </Tasks>
    </Frontend>
    <Backend>
      <Technology>Node.js or Fastify</Technology>
      <Tasks>
        <Task>Develop a REST API for file upload, retrieval, and search operations.</Task>
        <Task>Implement content processing logic: extract text, generate descriptions, and create tags using AI.</Task>
        <Task>Save metadata and files in PostgreSQL, and context embeddings in Qdrant.</Task>
      </Tasks>
    </Backend>
    <AIAgent>
      <Technology>OpenRouter API (sk-or-...) with free models (quasar, deepseek, etc.)</Technology>
      <Tasks>
        <Task>Create a separate containerized service (API wrapper) for OpenRouter integration.</Task>
        <Task>Implement functionality for generating short descriptions, topics, and tags.</Task>
        <Task>Generate embeddings for semantic search.</Task>
      </Tasks>
    </AIAgent>
    <DevOps>
      <Technology>Docker and Docker Compose</Technology>
      <Tasks>
        <Task>Containerize all application components: frontend, backend, postgres, qdrant, and openrouter-agent.</Task>
        <Task>Create a `docker-compose.yml` file for orchestrating the services.</Task>
        <Task>Ensure an optimal, secure, and minimalistic configuration.</Task>
      </Tasks>
    </DevOps>
    <Database>
      <Technology>PostgreSQL and Qdrant</Technology>
      <Tasks>
        <Task>Configure PostgreSQL for storing metadata and files.</Task>
        <Task>Configure Qdrant for storing context embeddings.</Task>
      </Tasks>
    </Database>
  </Instructions>
  <Features>
    <Feature>File indexing and storage.</Feature>
    <Feature>Contextual and full-text search.</Feature>
    <Feature>Semantic filtering by content and meaning.</Feature>
    <Feature>Extensible structure for future features (bot, Telegram, auto-import, etc.).</Feature>
  </Features>
  <Constraints>
    <Constraint>Use only free solutions.</Constraint>
    <Constraint>Ensure the code is safe, fast, and readable.</Constraint>
    <Constraint>Create a project that is easy to edit and update.</Constraint>
  </Constraints>
  <OutputFormat>
    The output should be a fully working and production-ready project, where each component (frontend, backend, AI integration, storage, UI) is independent, understandable, and easily modifiable. Deliver each part as separate files ready to copy and paste. The project should include:
    - /app
        - /frontend # React + Hero UI
        - /backend # Fastify + API
        - /ai-agent # OpenRouter wrapper
        - /db # PostgreSQL init
        - /qdrant # Vector DB config
    - docker-compose.yml
    - README.md
  </OutputFormat>
  <SuccessCriteria>
    - The application can be launched and updated with a single command.
    - Modules can be developed in parallel (front, back, AI integration, storage, UI).
    - The code is well-documented and easy to understand.
    - The application implements file indexing, contextual search, and semantic filtering.
  </SuccessCriteria>
  <FallbackProcedure>
    If any specific task proves too complex or time-consuming with the free resources, prioritize the core functionalities: file upload, storage, basic search, and description generation. Focus on building a solid foundation that can be extended later.  Document any limitations or areas for future improvement.
  </FallbackProcedure>
  <Example>
    <UserInput>User uploads a PDF document named "Company Policy.pdf".</UserInput>
    <ExpectedOutput>
      - The PDF is stored in the backend.
      - Metadata (name, size, upload date) is saved in PostgreSQL.
      - The text content is extracted from the PDF.
      - AI generates a short description (e.g., "Document outlining the company's policies and procedures").
      - AI identifies topics and tags (e.g., "Company Policy", "HR", "Compliance").
      - Embeddings are generated and stored in Qdrant for semantic search.
      - The frontend displays the file with its name, size, a PDF icon, and the generated description.
    </ExpectedOutput>
  </Example>
  <UserPreferences>
    <ProgrammingLanguage>JavaScript</ProgrammingLanguage>
    <Database>PostgreSQL</Database>
    <AIModel>Free OpenRouter models</AIModel>
  </UserPreferences>
  <Notes>
    Remember to prioritize security, scalability, extensibility, and a positive user experience throughout the development process. Document all environment variables and provide clear instructions for launching and using the application in the README.md file.
  </Notes>
</Prompt>
```