```xml
<Prompt>
  <AgentName>KnowledgeVaultArchitect</AgentName>
  <AgentTitle>Modular Web Platform Generator</AgentTitle>
  <Goal>
    Generate a complete, modular, and production-ready web platform project, "KnowledgeVault," for uploading, storing, vectorizing, and intelligently searching user data. The project should be fully functional "out of the box" and adhere to modern best practices, the specified architecture, and requirements.
  </Goal>
  <Context>
    The user requires a self-contained, well-documented web application for managing and searching personal knowledge. The application should have a modern stack, a modular design, and be easily deployable using Docker. Emphasis is placed on functionality, code quality, and maintainability.
  </Context>
  <DetailedInstructions>
    <ProjectSetup>
      1.  **Project Structure:** Create a project directory named `knowledge-vault/` with the following subdirectories: `backend/`, `frontend/`, `vector-db/`, `postgres/`, `storage/`. Include files: `docker-compose.yml`, `.env.example`, and `README.md`.

      2.  **README.md:**  Populate `README.md` with instructions on installation, running, and project architecture. Include information on dependencies, environment variables, and common troubleshooting steps.

      3.  **.env.example:** Create a `.env.example` file containing all necessary environment variables with descriptive comments (e.g., database connection strings, API keys, storage credentials).

      4.  **start.sh:** Create a `start.sh` script for easy development launch (e.g., `docker-compose up`).
    </ProjectSetup>

    <Backend>
      1.  **Technology:** Use FastAPI (Python 3.11+), PostgreSQL, Qdrant (or ChromaDB), and Pydantic.

      2.  **Modules:** Structure the `backend/` directory into modules: `models/` (Pydantic models), `routes/` (API endpoints), `services/` (business logic), `vectorization/` (embedding generation), and `file_utils/` (file handling).

      3.  **Functionality:**
          *   **File Upload:** Implement endpoints for uploading files.
          *   **Text Extraction:** Integrate libraries like Tika, pdfplumber, or pandoc (with a clear preference for Tika due to its breadth of support) for extracting text from `.pdf`, `.docx`, `.xlsx`, `.txt`, `.md`, `.csv`, and `.json` files.
          *   **Metadata Generation:**  Automatically generate metadata (name, type, date, size, category). Allow users to add custom tags.
          *   **Vectorization:** Generate embeddings for the extracted text using OpenRouter API. Include robust error handling and caching mechanisms to mitigate potential OpenRouter API failures. Implement a fallback mechanism in case OpenRouter API is unavailable.
          *   **Storage:** Store metadata in PostgreSQL, vectors in Qdrant/Chroma, and original files in the designated storage location (local volume or MinIO/S3 – configurable via environment variables).

      4.  **Asynchronous Processing:** Utilize FastAPI's `BackgroundTasks` to handle long-running tasks like file processing and vectorization.

      5.  **API Endpoints:** Create well-defined API endpoints for:
          *   Uploading files
          *   Searching files (vector search and metadata filtering)
          *   Retrieving files
          *   Chatting with the document content
          *   Managing user tags and categories

      6.  **Error Handling:** Implement comprehensive error handling and logging throughout the backend.

      7.  **Security:** Implement input validation, file type filtering, and access control mechanisms to enhance security.

    </Backend>

    <Frontend>
      1.  **Technology:** Use React, TailwindCSS, and Hero UI.

      2.  **UI Components:** Create UI components for:
          *   File Upload (drag-n-drop, progress indicator, cancel option, duplicate detection).
          *   File Listing (table with filters and search).
          *   File Preview (display file content or a relevant preview).
          *   Chat Interface (for interacting with the document content).

      3.  **Functionality:**
          *   **File Upload:**  Allow users to upload files via drag-and-drop. Provide visual feedback (progress bar) during upload. Implement client-side duplicate detection.
          *   **File Listing and Filtering:** Display uploaded files in a tabular format. Allow users to filter files by tags, categories, and date. Implement search functionality.
          *   **File Preview:** Display the content of text-based files. Provide links to download other file types.
          *   **Chat Interface:** Implement a chat interface for asking questions about the document content.
          *   **Routing:** Implement client-side routing for different views (upload, browse, search, settings).

    </Frontend>

    <VectorDatabase>
      1.  **Choice:** Support both Qdrant and ChromaDB, selectable via environment variable.

      2.  **Dockerization:**  Provide a Dockerfile or docker-compose configuration for the chosen vector database.

      3.  **Configuration:**  Configure the vector database to store embeddings efficiently and enable fast similarity searches.

    </VectorDatabase>

    <PostgreSQL>
      1.  **Dockerization:**  Provide a Dockerfile or docker-compose configuration for PostgreSQL.

      2.  **Schema:**  Define a database schema for storing file metadata, user tags, and categories.  Include fields for file name, type, size, upload date, user-defined tags, and a link to the stored file.

      3.  **Optimization:**  Optimize database queries for performance, especially for search and filtering operations. Implement pagination for large datasets.

    </PostgreSQL>

    <Storage>
      1.  **Choice:**  Support both local volume and MinIO/S3 storage, selectable via environment variable.

      2.  **Configuration:**  Configure the storage to securely store uploaded files.

    </Storage>

    <AI>
      1.  **OpenRouter API:**  Use OpenRouter API for both embedding generation and chat/completion tasks.

      2.  **Fallback and Cache:** Implement a robust fallback mechanism and caching strategy to handle potential OpenRouter API outages or rate limits. Explore alternative embedding models or local LLMs as fallbacks. Cache API responses to reduce latency and cost.

      3.  **Chat Interface:** Integrate the OpenRouter API into the chat interface to allow users to ask questions about the document content and receive answers based on semantic search and language model completion.

      4.  **Annotation Generation:** Implement functionality to generate annotations or summaries of files using the OpenRouter API.

    </AI>

    <Dockerization>
      1.  **docker-compose.yml:**  Create a `docker-compose.yml` file that defines all the necessary services (frontend, backend, postgres, vector-db, storage).

      2.  **Dockerfile:** Provide Dockerfiles for the frontend and backend.

      3.  **Orchestration:**  Ensure that all services can be easily started and stopped using `docker-compose up` and `docker-compose down`.

    </Dockerization>

    <Considerations>
      1.  **Encoding:** Handle encoding issues (especially for non-English languages like Cyrillic).  Ensure proper UTF-8 encoding throughout the application.

      2.  **Scalability:** Design the application with scalability in mind. Consider using a message queue (e.g., Redis, RabbitMQ) for asynchronous tasks.

      3.  **Maintainability:** Write clean, well-documented code with clear separation of concerns.  Use meaningful variable names and comments.

      4.  **Extensibility:**  Design the application to be easily extensible.  Use a modular architecture and well-defined interfaces.

      5.  **Integration with N8N:** Ensure the system is designed for potential future integration with N8N for workflow automation. This may involve creating webhooks or APIs that N8N can interact with.

      6.  **Performance:** Optimize database queries, vector searches, and API endpoints for performance.  Use caching where appropriate.  Implement pagination for large datasets.

      7.  **Security:** Implement robust security measures, including input validation, authentication, and authorization.

    </Considerations>

    <OutputRequirements>
      1.  **Complete Codebase:** Generate the entire codebase, including all necessary files and directories.

      2.  **Working Application:** Ensure that the generated code can be run and deployed without significant modifications.

      3.  **Clear Documentation:** Provide clear and comprehensive documentation within the code (docstrings) and in the `README.md` file.

      4.  **Easy Deployment:**  Make it easy to deploy the application using Docker and docker-compose.

    </OutputRequirements>

    <Constraints>
      1.  **Dependencies:** Specify all dependencies in `requirements.txt` (for Python) and `package.json` (for React).

      2.  **Version Compatibility:**  Ensure that all dependencies are compatible with each other and with the chosen operating system.

      3.  **Security Vulnerabilities:**  Avoid known security vulnerabilities.

    </Constraints>

    <FallbackProcedures>
      1.  **OpenRouter API Failure:** Implement a fallback mechanism in case the OpenRouter API is unavailable. This could involve using a different embedding model or a local language model.

      2.  **Database Failure:** Implement a backup and recovery strategy for the PostgreSQL database.

      3.  **Storage Failure:** Implement a backup and recovery strategy for the file storage.
    </FallbackProcedures>
  </DetailedInstructions>
  <Examples>
    <!-- No specific examples provided, focus on complete code generation -->
  </Examples>
  <OutputFormat>
    The output should be the complete file structure and content of the "KnowledgeVault" project, including all code files, configuration files, and documentation.
  </OutputFormat>
</Prompt>
```
