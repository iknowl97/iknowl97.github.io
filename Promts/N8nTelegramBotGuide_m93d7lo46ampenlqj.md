```xml
<Prompt>
  <AgentName>N8nTelegramBotGuide</AgentName>
  <Goal>
    Produce a concise, actionable, end-to-end step-by-step guide in Russian for creating an n8n workflow that powers a Telegram bot answering questions from Georgian PDF documents, leveraging a vector database for context and memory.
  </Goal>
  <Audience>
    N8n user with basic familiarity.
  </Audience>
  <OutputFormat>
    Step-by-step instruction guide.
  </OutputFormat>
  <Components>
    <Introduction>
      Краткое описание цели workflow и используемых технологий (N8n, Telegram Bot API, Vector Database, LLM).
    </Introduction>
    <DatabaseChoice>
      Рекомендация (PostgreSQL/Supabase with pgvector ИЛИ Pinecone). Обоснование выбора.

    </DatabaseChoice>
    <DatabaseSetup>
      Детальные инструкции по настройке базы данных, включая создание таблиц/индексов.
    </DatabaseSetup>
    <PdfIngestionWorkflow>
      <Heading>PDF Data Ingestion Workflow (N8n)</Heading>
      <Step>1. **PDF Read Node:** Настройка для чтения PDF (`PDF Read` node). Specify "File Path" for doc location.</Step>
      <Step>2. **Text Extraction:** Извлечение текста с помощью `Function` node и `pdf-parse`. Encoding: Check the `PDF Read` node outputs correct Georgian text</Step>
      <Step>3. **Chunking:** Разбивка текста на части (`Function` node). Sentence or Paragraph splitter for vector data efficiency</Step>
      <Step>4. **Embedding:** Embeddings using API (`HTTP Request` node). Model recommendations: OpenAI's embedding, Cohere's Multilingual option </Step>
      <Step>5. **DB Insert:** Вставка текста и embeddings в векторную БД (`Postgres` or `Pinecone` node).</Step>
    </PdfIngestionWorkflow>
    <TelegramBotWorkflow>
      <Heading>Telegram Bot Interaction Workflow (N8n)</Heading>
      <Step>1. **Telegram Trigger:** Получение сообщений (`Telegram Trigger` node).</Step>
      <Step>2. **Conversation Context Management:**
        Хранение истории: n8n variables.
        Memory approach:
      * - Current prompt
      * - Past Prompts (all history)
      * - Summarization (best memory)
      </Step>
      <Step>3. **Prompt Engineering:** Формирование prompt для LLM. "Question" + "Context"</Step>
      <Step>4. **Embedding question:** Embeddings using API HTTP Requst. Send current prompt for embed </Step>
      <Step>5. **Similarity Search:** Поиск релевантных фрагментов в векторной БД.(Postgres, Pinecone node, depending what we chose from start)</Step>
      <Step>6.  "Current Vector Store search output and Combine all to the one propmpt
      "</Step>
      <Step>7. **LLM:** Запрос к LLM (`HTTP Request` node). OpenAI Chat GPT, or similar.</Step>
      <Step>8. **Answer Formatting:** Форматирование ответа для Telegram. (`Function` node).
      </Step>
      <Step>9. **Telegram Send Message:** Отправка ответа пользователю (`Telegram Send Message` node).</Step>
      <Step>9. **Telegram Send Message:** Save full answer history as Vector to Vector Store - "Helps follow history."</Step>
    </TelegramBotWorkflow>
    <ErrorHandling>
      <Heading>Error Handling</Heading>
      Использование `Try/Catch` nodes. Logging ошибок.
    </ErrorHandling>
    <CodeExamples>
      Код JavaScript для Function nodes (текст, prompt, DB).
    </CodeExamples>
  </Components>
  <Instructions>
    * Give instruction using number sequence
    * Be concise
    * List N8N Node in EN, and text in RU.
    * Include links on recomendetd Libraries and information.
    * Output for each node must be with expected input format as example:
    * PDF file stream -> Parsed data
    * User telegram Message -> "Bot is thinking."
  </Instructions>
</Prompt>
```