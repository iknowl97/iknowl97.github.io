Окей, я понял. Ты хочешь интегрировать процесс тестирования промтов с OpenRouter в существующий workflow n8n. Основываясь на предоставленном JSON, я могу предложить следующие дополнительные ноды и изменения:

```json
{
  "nodes": [
    {
      "parameters": {
        "question": "Enter your prompt for the Reels script agent. Include details about target audience, theme, format, duration, and goal.",
        "name": "Prompt ввода пользователя"
      },
      "name": "Триггер Telegram",
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1.2,
      "position": [
        -240,
        400
      ],
      "id": "initialPrompt",
      "webhookId": "fa88c39a-4f5c-4da2-999a-47aeee823e92"
    },
    {
      "parameters": {
        "jsCode": "const userPrompt = $input.item.message.text;\n\nreturn [\n  {\n    userPrompt: userPrompt,\n  },\n];",
        "name": "Преобразование в JSON"
      },
      "name": "Подготовка данных",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1.2,
      "position": [
        0,
        400
      ],
      "id": "convertToJson"
    },
    {
      "parameters": {
        "jsCode": "// Access the prompt from the previous node\nconst userPrompt = $input.item.userPrompt;\n\n// Define the XML structure with the user's prompt\nconst xmlPrompt = `\n<Prompt>\n    <OriginalPrompt>${userPrompt}</OriginalPrompt>\n    <AgentName>ReelsScriptPro</AgentName>\n    <Goal>Creating engaging and viral Reel scripts.</Goal>\n    <Instructions>\n        <Context>You are an expert in short-form video content creation.</Context>\n        <Task>Based on the theme, create a script suitable for a Reel.</Task>\n        <Theme>Please specify the theme of the Reel.</Theme>\n        <Example>Scene 1: Visual - Person dancing. Text - Learn the latest TikTok dance craze! Audio - Trending music.</Example>\n    </Instructions>\n</Prompt>\n`;\n\nreturn [\n  {\n    xmlPrompt: xmlPrompt,\n  },\n];",
        "name": "Генерация XML Prompt"
      },
      "name": "XML-Генератор Промтов",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1.2,
      "position": [
        240,
        400
      ],
      "id": "xmlGenerator"
    },
    {
      "parameters": {
        "jsCode": "// Access the XML prompt from the previous node\nconst xmlPrompt = $input.item.xmlPrompt;\n\n// Remove XML tags and extract the content\nconst textPrompt = xmlPrompt.replace(/<[^>]*>/g, '');\n\nreturn [\n  {\n    textPrompt: textPrompt.trim(), // Trim whitespace\n  },\n];",
        "name": "Удаление XML Тегов"
      },
      "name": "Текст из XML",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1.2,
      "position": [
        480,
        400
      ],
      "id": "extractTextFromXML"
    },
    {
      "parameters": {
        "question": "Choose a model from OpenRouter (mistralai/Mistral-7B-Instruct-v0.1, google/gemma-7b-it, openchat/openchat_3.5):",
        "name": "Model Selection"
      },
      "name": "Выбор Модели OpenRouter",
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1.2,
      "position": [
        -240,
        600
      ],
      "id": "selectModel",
      "webhookId": "fa88c39a-4f5c-4da2-999a-47aeee823e92"
    },
    {
      "parameters": {
        "url": "https://openrouter.ai/api/v1/chat/completions",
        "options": {},
        "authentication": "headerAuth",
        "headerAuthType": "genericAuth",
        "headerAuthentication": {
          "field": "Authorization",
          "type": "Bearer Token",
          "token": "YOUR_OPENROUTER_API_KEY"
        },
        "requestMethod": "POST",
        "sendHeaders": true,
        "sendData": true,
        "dataFormat": "json",
        "bodyParametersUi": {
          "parameter": [
            {
              "name": "model",
              "value": "={{ $('Выбор Модели OpenRouter').item.message.text }}"
            },
            {
              "name": "messages",
              "value": "[{\"role\": \"user\", \"content\": \"{{ $('Текст из XML').item.textPrompt }}\"}]"
            },
            {
              "name": "max_tokens",
              "value": "200"
            }
          ]
        },
        "name": "Вызов API OpenRouter"
      },
      "name": "OpenRouter API",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 2.2,
      "position": [
        720,
        400
      ],
      "id": "openRouterCall",
      "credentials": {}
    },
    {
      "parameters": {
        "jsCode": "const apiResponse = $input.item;\n\nif (apiResponse.error) {\n  return [\n    {\n      response: `Error from OpenRouter: ${apiResponse.error.message}`,\n    },\n  ];\n} else {\n  const content = apiResponse.choices[0].message.content;\n  return [\n    {\n      response: `Model Response: ${content}`,\n    },\n  ];\n}",
        "name": "Обработка Ответа"
      },
      "name": "Обработка ответа API",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1.2,
      "position": [
        960,
        400
      ],
      "id": "processResponse"
    },
    {
      "parameters": {
        "chatId": "={{ $json.message.chat.id }}",
        "text": "={{ $json.response }}",
        "parseMode": "markdown",
        "options": {}
      },
      "name": "Отправка Ответа Telegram",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        1200,
        400
      ],
      "id": "sendTelegramResponse",
      "credentials": {
        "telegramApi": {
          "id": "N9M07GOqN0Ct2cJj",
          "name": "NTN"
        }
      }
    }
  ],
  "connections": {
    "Триггер Telegram": {
      "main": [
        [
          {
            "node": "Подготовка данных",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Подготовка данных": {
      "main": [
        [
          {
            "node": "XML-Генератор Промтов",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "XML-Генератор Промтов": {
      "main": [
        [
          {
            "node": "Текст из XML",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Текст из XML": {
      "main": [
        [
          {
            "node": "OpenRouter API",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Выбор Модели OpenRouter": {
      "main": [
        [
          {
            "node": "OpenRouter API",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "OpenRouter API": {
      "main": [
        [
          {
            "node": "Обработка ответа API",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Обработка ответа API": {
      "main": [
        [
          {
            "node": "Отправка Ответа Telegram",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

**Изменения и Дополнительные Ноды (с объяснениями):**

1.  **Prompt ввода пользователя (Telegram Trigger):**
    *   Идентификатор: `initialPrompt`
    *   Новый Telegram Trigger, принимающий первичный промт от пользователя.
2.  **Подготовка данных (Function):**
    *   Идентификатор: `convertToJson`
    *   Функция для преобразования входящего текста от пользователя в JSON формат, что делает его более удобным для обработки в последующих узлах.
3.  **XML-Генератор Промтов (Function):**
    *   Идентификатор: `xmlGenerator`
    *   Создает XML-структуру промта, как и в предыдущем примере.
4.  **Текст из XML (Function):**
    *   Идентификатор: `extractTextFromXML`
    *   Удаляет XML теги для получения текста, который будет отправлен в API OpenRouter.
5.  **Выбор Модели OpenRouter (Telegram Trigger):**
    *   Идентификатор: `selectModel`
    *   Новый Telegram Trigger, где пользователь выбирает модель. Важно, что это *отдельный* запрос, чтобы пользователь мог сначала ввести промт, а затем выбрать модель, не перегружая одно сообщение.
6.  **OpenRouter API (HTTP Request):**
    *   Идентификатор: `openRouterCall`
    *   Практически без изменений из предыдущего примера, использует `message.text` из `selectModel` для выбора модели.
7.  **Обработка ответа API (Function):**
    *   Идентификатор: `processResponse`
    *   Обрабатывает ответ от OpenRouter API, выводя сообщение об ошибке или контент, в зависимости от результата.
8.  **Отправка Ответа Telegram (Telegram):**
    *   Идентификатор: `sendTelegramResponse`
    *   Отправляет результат пользователю в Telegram.

**Важные Моменты:**

*   **Отдельные Telegram Trigger'ы:** Использование двух Telegram Trigger-ов – для ввода промта и выбора модели –  делает workflow более понятным и простым в использовании.
*   **Локализация:**  Я перевел названия нод на русский язык, как это было в твоем первоначальном JSON.  Ты можешь использовать любой язык.
*   **JSON Преобразование:**  Я добавил узел "Подготовка данных", который явным образом преобразует текст от пользователя в JSON.  Хотя это может показаться излишним, это хорошая практика, чтобы сделать поток данных более предсказуемым.
*   **Идентификаторы:** Я добавил `id` для каждой ноды, чтобы было легче ссылаться на них при отладке или модификации workflow.
*   **Совместимость:** Убедись, что у тебя установлены последние версии `n8n-nodes-base` и `n8n-nodes-telegram`.  Я указал `typeVersion: 1.2` и `typeVersion: 2.2`, но это может отличаться в зависимости от твоей установки.

**Как Использовать этот JSON:**

1.  **Импортируй JSON в n8n:** В n8n, нажми "Import" и выбери этот JSON файл.
2.  **Замени API Ключ:**  Не забудь заменить `"YOUR_OPENROUTER_API_KEY"` на свой реальный API ключ OpenRouter в ноде "OpenRouter API".
3.  **Свяжи Telegram Credentials:** В нодах "Триггер Telegram" и "Отправка Ответа Telegram" выбери или создай свои учетные данные Telegram API.
4.  **Активируй Workflow:** Нажми "Active" в правом верхнем углу.

Теперь, когда ты отправишь сообщение своему боту Telegram, он сначала запросит у тебя промт, потом запросит выбор модели, и затем вернет ответ от OpenRouter.
