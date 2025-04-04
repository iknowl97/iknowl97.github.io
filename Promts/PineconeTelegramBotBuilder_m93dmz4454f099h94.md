```xml
<Prompt>
  <AgentName>PineconeTelegramBotBuilder</AgentName>
  <Goal>
    Create a refined, actionable, end-to-end step-by-step guide in Russian for building an n8n workflow that powers a Telegram bot answering questions from a multi-format (PDF, Word, TXT, XML, Excel, HTML) Georgian document repository using Pinecone for contextual memory.
  </Goal>
  <Context>
    Building upon a previous request, this iteration focuses on Pinecone as the vector database and expands data source to include various file formats from a monitored Google Drive folder.
  </Context>
  <TimeEstimate>
     Provide an estimated time needed (without breaks) from setup to working prototype.
  </TimeEstimate>
  <Audience>
    N8n user with basic familiarity.
  </Audience>
  <OutputFormat>
    Step-by-step instruction guide in Russian.
  </OutputFormat>
  <Components>
    <Introduction>
      Краткое описание workflow: Pinecone, Telegram Bot, LLM, multi-format data.
    </Introduction>
    <DatabaseChoice>
      Выбрано: Pinecone. Обоснование.
    </DatabaseChoice>
    <DatabaseSetup>
      Детальные инструкции по настройке Pinecone: создание индекса, API keys.
    </DatabaseSetup>
    <GoogleDriveMonitoring>
      <Heading>Google Drive Monitoring & Data Ingestion (N8n)</Heading>
      <Goal>Automatically detect and process new/updated files in a Google Drive folder.</Goal>
      <Step>1. **Google Drive Trigger:** Использовать `Google Drive Trigger` node (On New File or Modified File). Настроить папку для мониторинга ("Folder ID").</Step>
      <Step>2. **File Type Detection (Function):** Определить формат файла (`Function` node). </Step>
      <Step>3. **Conditional Routing (Switch):** Маршрутизация в зависимости от формата (`Switch` node). (PDF, Word, TXT, XML, Excel, HTML).</Step>
      <SubComponent_PDF>
        <Step>4a. **PDF Processing (PDF Branch):** Если PDF:</Step>
        <Step> -  **PDF Read:** `PDF Read` node.</Step>
        <Step> -  **Тext Extraction:** `Function` node + `pdf-parse`, handling Georgian encoding.</Step>
      </SubComponent_PDF>
      <SubComponent_Word>
        <Step>4b. **Word Processing (Word Branch):** Если Word:</Step>
        <Step> - **docx-parser:** `Function Node` +  'docx-parser' npm package  Example  ```const docxParser = require('docx-parser');  const data = await docxParser.parseDocx(Buffer.from(items[0].data["yourBinaryDataPropertyName"].data), 'buffer'); return data;```</Step>

      </SubComponent_Word>
       <SubComponent_Txt>
        <Step>4c. **TXT Processing (TXT Branch):** Если TXT:</Step>
        <Step> - **Read Binary Data:** Assuming you read binary data to `YourBinaryData` then  ```return Buffer.from(items[0].data["YourBinaryData"].data).toString();```</Step>
      </SubComponent_Txt>
       <SubComponent_XML>
        <Step>4d. **XML Processing (XML Branch):** Если XML:</Step>
        <Step> -  "Using Xml2Js npm package ``` const { XMLParser } = require('xml2js'); const parser = new XMLParser(); const xmlData = items[0].json.xml; // Assuming your XML data is in the "xml" property const result = await parser.parseStringPromise(xmlData); return result;```"</Step>
      </SubComponent_XML>
       <SubComponent_Excel>
        <Step>4e. **Excel Processing (Excel Branch):** Если Excel:</Step>
        <Step> -  "Using xlsx npm package ```const XLSX = require('xlsx');  // Assuming your Excel data is in the "excelData" property let workbook = XLSX.read(Buffer.from(items[0].data.file.data), { type: 'buffer' }); let sheetName = workbook.SheetNames[0]; let worksheet = workbook.Sheets[sheetName];  let excelData = XLSX.utils.sheet_to_json(worksheet, { raw: true });  return {excelData};```"</Step>
      </SubComponent_Excel>
       <SubComponent_Html>
        <Step>4f. **HTML Processing (HTML Branch):** Если HTML:</Step>
        <Step> -  "Using jsdom + node-html-parser npm packages, example: ```const { JSDOM } = require('jsdom');  const { parse } = require('node-html-parser');  // Assuming your HTML data is in the "htmlData" property  const dom = new JSDOM(items[0].json.htmlData); const document = dom.window.document;  // Extract text content from the document const textContent = document.body.textContent || ''; return {textContent};```"</Step>
      </SubComponent_Html>
      <Step>5. **Тext Cleaning:** Все ветки (4a, 4b, 4c, 4d) -> Normalize white-spaces and extra special characters </Step>
      <Step>6. **Chunking (Function):** Деление текста на части. ( предлогать разбиение по абзацам )</Step>
      <Step>7. **Embedding:** Embeddings с помощью API (HTTP Request). ( OpenAI Embeddings ) .</Step>
      <Step>8. **Pinecone Insert:** Вставка текста и embeddings в Pinecone (`Pinecone` node).</Step>
    </GoogleDriveMonitoring>
    <TelegramBotWorkflow>
      <Heading>Telegram Bot Interaction Workflow (N8n)</Heading>
      <Step>1. **Telegram Trigger:** Получение сообщений (`Telegram Trigger` node).</Step>
      <Step>2. **Conversation Context Management:**( Same )</Step>
       <Step> a) Store user message to n8n variables </Step>
        <Step> b) create runtime vector data from current message to vectorstore</Step>
      <Step>3. **Similarity Vectorstore Pinecone":** Search vector memory from last messages </Step>
      <Step>4. **Form Vector context":** Merge vector results with current promtp  </Step>
      <Step>5. **LLM:** Запрос к LLM (`HTTP Request` node) combine everthing and send as instruction.</Step>
      <Step>6. **Answer Formatting:**( Same )</Step>
      <Step>7. **Telegram Send Message:** Отправка ответа (`Telegram Send Message` node).</Step>
    </TelegramBotWorkflow>
    <ErrorHandling>
      Использование `Try/Catch` nodes. Logging ошибок.
    </ErrorHandling>
    <CodeExamples>
      Примеры JavaScript для `Function` nodes (извлечение текста, форматирование prompt, DB).
    </CodeExamples>
  </Components>
  <Instructions>
    *   Be concise.
    *   Node names in EN, text in RU.
    *   Links to libraries/info.
  </Instructions>
</Prompt>
```