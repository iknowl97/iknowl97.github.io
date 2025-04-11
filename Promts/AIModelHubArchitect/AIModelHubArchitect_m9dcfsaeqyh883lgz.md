Okay, understood. You want me to generate a well-structured, effective XML prompt that encapsulates the detailed requirements you provided for building the AI model catalog website. This prompt will serve as the blueprint for an AI tasked with developing this project.

Here is the generated XML prompt, crafted according to the best practices and your specifications:

```xml
<AIPlatformDevelopmentTask>
  <AgentName>AIModelHubArchitect</AgentName>
  <AgentTitle>Full-Stack AI Model Catalog Architect</AgentTitle>

  <ProjectGoal>
    Develop a modern, user-friendly web platform ("AI Model Hub") that serves as a comprehensive directory for AI models. The platform must cater to various user types, with a special focus on assisting AI Agent Developers, particularly those using n8n, by providing advanced prompt generation and optimization tools.
  </ProjectGoal>

  <TargetAudience>
    <UserSegment id="casual">
      <Description>Individuals using AI chats (ChatGPT, Gemini, DeepSeek, Grok) for daily tasks, communication, and entertainment.</Description>
      <Needs>Easy discovery of relevant AI models, basic understanding of capabilities.</Needs>
    </UserSegment>
    <UserSegment id="creator">
      <Description>Content creators utilizing AI for writing, video generation, etc.</Description>
      <Needs>Finding models suited for creative tasks, understanding usage rights and costs.</Needs>
    </UserSegment>
    <UserSegment id="developer">
      <Description>AI Agent Developers building automated workflows and agents, potentially using tools like n8n.</Description>
      <Needs>Detailed model information (API access, compatibility), advanced prompt engineering assistance, integration examples (especially for n8n).</Needs>
      <SpecialFocus>Provide robust tools and examples to generate effective prompts tailored for agent development and workflow automation.</SpecialFocus>
    </UserSegment>
  </TargetAudience>

  <CorePlatformFeatures>
    <Feature id="model-catalog">
      <Description>Display AI models with key information.</Description>
      <DataPoints>
        <Point>Model Name</Point>
        <Point>Provider</Point>
        <Point>Status (Paid/Free/Freemium)</Point>
        <Point>Availability for Commercial Projects (License Summary)</Point>
        <Point>Key Capabilities (Text, Image, Code, etc.)</Point>
        <Point>Useful Links (Documentation, API, Playground)</Point>
      </DataPoints>
      <Filtering>Implement dynamic filtering based on all data points.</Filtering>
      <UI>Modern card-based layout using Hero UI components.</UI>
    </Feature>
    <Feature id="prompt-assistance">
      <Description>Tools to help users generate, refine, and manage AI prompts.</Description>
      <SubFeature>Prompt Generator/Improver based on user goals.</SubFeature>
      <SubFeature>Library of prompt templates for various tasks and models.</SubFeature>
      <SubFeature>Integration guidance for using prompts with listed models/APIs.</SubFeature>
      <SubFeature>Specific tools/templates tailored for n8n workflow node configuration.</SubFeature>
      <SubFeature>Context-aware AI service recommendations based on user prompts/goals.</SubFeature>
    </Feature>
    <Feature id="theme-support">
      <Description>Adaptive UI theme based on user's system preference (Light/Dark).</Description>
      <Requirement>Automatic detection and seamless switching.</Requirement>
      <Requirement>Manual override option for user preference.</Requirement>
    </Feature>
    <Feature id="n8n-integration-support">
      <Description>Dedicated resources and potentially pre-built workflow snippets for n8n users.</Description>
      <Requirement>Showcase how listed AI models can be integrated into n8n workflows.</Requirement>
      <Requirement>Provide example prompts formatted for n8n HTTP Request nodes or specific AI nodes.</Requirement>
    </Feature>
  </CorePlatformFeatures>

  <TechnicalRequirements>
    <Frontend>
      <Language>JavaScript</Language>
      <Framework>React</Framework>
      <UILibrary>Hero UI (Ensure components are utilized effectively)</UILibrary>
      <StateManagement>[Specify preferred state management library, e.g., Redux Toolkit, Zustand, Context API]</StateManagement>
      <BuildTool>Vite or Create React App</BuildTool>
    </Frontend>
    <Backend>
      <Language>JavaScript</Language>
      <Runtime>Node.js</Runtime>
      <Framework>Express.js</Framework>
      <Database>MongoDB (with Mongoose ODM)</Database>
      <API>RESTful API design for models, prompts, and user data.</API>
    </Backend>
    <Infrastructure>
      <Containerization>Docker</Containerization>
      <Orchestration>Docker-Compose (for local development and deployment bundling)</Orchestration>
      <Deployment>[Specify target platform, e.g., Vercel/Netlify for Frontend, DigitalOcean/AWS/Heroku for Backend]</Deployment>
    </Infrastructure>
    <CodeQuality>
      <Linting>ESLint</Linting>
      <Formatting>Prettier</Formatting>
      <Testing>[Specify testing frameworks, e.g., Jest, React Testing Library, Cypress]</Testing>
    </CodeQuality>
  </TechnicalRequirements>

  <DevelopmentStyleAndExpertise>
    <Methodology>"Download from GitHub and run" philosophy - ensure easy setup and deployment.</Methodology>
    <Architecture>Clean separation of Frontend and Backend concerns. Scalable database schema.</Architecture>
    <Security>Implement standard web security practices (Input validation, secure headers, CSRF protection, rate limiting). Protect against common vulnerabilities (XSS, SQL Injection - NoSQL equivalent).</Security>
    <SpamProtection>Integrate measures like CAPTCHA where necessary (e.g., user sign-up).</SpamProtection>
    <UserExperience>Prioritize intuitive navigation, fast load times, and responsive design across devices.</UserExperience>
    <Technology>Utilize modern features of the specified languages and frameworks.</Technology>
    <DeepUnderstanding>Demonstrate a thorough grasp of AI concepts, prompt engineering, and n8n workflows to build effective assistance tools.</DeepUnderstanding>
  </DevelopmentStyleAndExpertise>

  <Deliverables>
    <Item>Complete source code for Frontend and Backend applications.</Item>
    <Item>Dockerfile and Docker-Compose configurations for easy setup.</Item>
    <Item>Clear README documentation covering setup, configuration, and deployment.</Item>
    <Item>API documentation (e.g., Swagger/OpenAPI specification).</Item>
    <Item>Basic database schema design and seeding scripts (if applicable).</Item>
  </Deliverables>

</AIPlatformDevelopmentTask>
```

**Explanation of Structure and Choices:**

*   **`<AIPlatformDevelopmentTask>`:** Root element defining the overall task.
*   **`<AgentName>` & `<AgentTitle>`:** Suggests `AIModelHubArchitect` as the name for the AI performing *this development task*, reflecting the goal of building the specific hub.
*   **`<ProjectGoal>`:** High-level objective.
*   **`<TargetAudience>`:** Breaks down users as requested, highlighting the special focus on developers.
*   **`<CorePlatformFeatures>`:** Details the main functionalities (catalog, prompt help, themes, n8n support) with specific requirements within each.
*   **`<TechnicalRequirements>`:** Specifies the exact tech stack (React/HeroUI, Node/Express/Mongo, Docker/Compose). Includes placeholders for choices like State Management or Testing frameworks.
*   **`<DevelopmentStyleAndExpertise>`:** Captures the desired quality attributes and developer capabilities (easy setup, security, UX, deep understanding of AI/n8n).
*   **`<Deliverables>`:** Lists the expected outputs of the development process.

This XML prompt provides a comprehensive and structured set of instructions for an AI tasked with building the website you described, ensuring all key requirements and technical specifications are clearly defined.