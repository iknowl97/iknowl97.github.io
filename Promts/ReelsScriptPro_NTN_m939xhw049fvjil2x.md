```json
{
  "nodes": [
    {
      "parameters": {
        "chatId": "={{ $json.message.chat.id }}",
        "text": "Enter your prompt for the Reels script agent. Include details about target audience, theme, format, duration, and goal.",
        "parseMode": "markdown",
        "options": {}
      },
      "name": "Trigger Telegram",
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1.2,
      "position": [
        200,
        200
      ]
    },
    {
      "parameters": {
        "jsCode": "const prompt = $input.item.message.text;\n\nreturn [\n  {\n    prompt: prompt,\n  },\n];"
      },
      "name": "Подготовить Данные",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [
        400,
        200
      ]
    },
    {
      "parameters": {
        "jsCode": "// Access the prompt from the previous node\nconst userPrompt = $input.item.prompt;\n\n// Define the XML structure with the user's prompt\nconst xmlPrompt = `\n<Prompt>\n    <OriginalPrompt>${userPrompt}</OriginalPrompt>\n    <AgentName>ReelsScriptPro</AgentName>\n    <Goal>Creating engaging and viral Reel scripts.</Goal>\n    <Instructions>\n        <Context>You are an expert in short-form video content creation.</Context>\n        <Task>Based on the theme, create a script suitable for a Reel.</Task>\n        <Theme>Please specify the theme of the Reel.</Theme>\n        <Example>Scene 1: Visual - Person dancing. Text - Learn the latest TikTok dance craze! Audio - Trending music.</Example>\n    </Instructions>\n</Prompt>\n`;\n\nreturn [\n  {\n    xmlPrompt: xmlPrompt,\n  },\n];"
      },
      "name": "Создать XML Промпт",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [
        600,
        200
      ]
    },
    {
      "parameters": {
        "jsCode": "// Access the XML prompt from the previous node\nconst xmlPrompt = $input.item.xmlPrompt;\n\n// Remove XML tags and extract the content\nconst textPrompt = xmlPrompt.replace(/<[^>]*>/g, '');\n\nreturn [\n  {\n    textPrompt: textPrompt.trim(), // Trim whitespace\n  },\n];"
      },
      "name": "Извлечь Текст из XML",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [
        800,
        200
      ]
    },
    {
      "parameters": {
        "chatId": "={{ $json.message.chat.id }}",
        "text": "Выберите модель для тестирования (бесплатные):\n\n🆓 GPT-3.5 Turbo\n🆓 Claude Instant\n🆓 Llama 2 13B",
        "replyMarkup": "replyKeyboard",
        "replyKeyboard": {
          "rows": [
            {
              "row": {
                "buttons": [
                  {
                    "text": "🆓 GPT-3.5 Turbo",
                    "additionalFields": {}
                  },
                  {
                    "text": "🆓 Claude Instant",
                    "additionalFields": {}
                  }
                ]
              }
            },
            {
              "row": {
                "buttons": [
                  {
                    "text": "🆓 Llama 2 13B",
                    "additionalFields": {}
                  }
                ]
              }
            }
          ]
        },
        "additionalFields": {
          "parse_mode": "Markdown"
        }
      },
      "name": "Выбор Модели",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        200,
        800
      ],
      "continueOnFail": false
    },
    {
      "parameters": {
        "chatId": "={{ $json.message.chat.id }}",
        "text": "OK, ждем ответа от {{ $json.selectedModel }}...",
        "parseMode": "markdown",
        "options": {}
      },
      "name": "Отправить Уведомление о Запуске",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        3800,
        200
      ]
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
              "value": "={{ $('Определить Модель').item.json.selectedModel }}"
            },
            {
              "name": "messages",
              "value": "[{\\\"role\\\": \\\"user\\\", \\\"content\\\": \\\"{{ $('Извлечь Текст из XML').item.textPrompt }}\\\"}]"
            },
            {
              "name": "max_tokens",
              "value": "200"
            }
          ]
        },
        "name": "OpenRouter API",
        "type": "n8n-nodes-base.httpRequest",
        "typeVersion": 2,
        "position": [
          4000,
          800
        ],
        "credentials": {}
      },
      "name": "OpenRouter API",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 2,
      "position": [
        4000,
        1060
      ],
      "credentials": {}
    },
    {
      "parameters": {
        "jsCode": "return [{\n    json: {\n        AgentName: \"ReelsScriptPro\",\n        selectedModel: \"{{ $('Установить Модель').item.selectedModel }}\"\n    }\n}]"
      },
      "name": "Извлечь Имя Агента/Промта",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [
        3800,
        400
      ]
    },
    {
      "parameters": {
        "chatId": "={{ $json.message.chat.id }}",
        "text": "=🧪 *Результат тестирования промта {{ $('Извлечь Имя Агента/Промта').item.json.AgentName }}*\n\nМодель: {{ $('Определить Модель').item.json.selectedModel }}\n\nОтвет AI:\n{{ $('OpenRouter API').item.json.choices[0].message.content }}\n\nОцените результат (1-5):",
        "replyMarkup": "replyKeyboard",
        "replyKeyboard": {
          "rows": [
            {
              "row": {
                "buttons": [
                  {
                    "text": "1 ⭐️",
                    "additionalFields": {}
                  },
                  {
                    "text": "2 ⭐️⭐️",
                    "additionalFields": {}
                  },
                  {
                    "text": "3 ⭐️⭐️⭐️",
                    "additionalFields": {}
                  }
                ]
              }
            },
            {
              "row": {
                "buttons": [
                  {
                    "text": "4 ⭐️⭐️⭐️⭐️",
                    "additionalFields": {}
                  },
                  {
                    "text": "5 ⭐️⭐️⭐️⭐️⭐️",
                    "additionalFields": {}
                  }
                ]
              }
            }
          ]
        },
        "additionalFields": {
          "parse_mode": "Markdown"
        }
      },
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        4100,
        1160
      ],
      "name": "Отправить Результат"
    },
    {
      "parameters": {
        "model": "={{ $('Триггер Telegram').item.json.message.text }}",
        "selectedModel": "={{ $('Триггер Telegram').item.json.message.text }}"
      },
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.4,
      "position": [
        3700,
        1060
      ],
      "name": "Установить Модель"
    },
    {
      "parameters": {
        "jsCode": "const modelMap = {\n  \"🆓 GPT-3.5 Turbo\": \"openai/gpt-3.5-turbo\",\n  \"🆓 Claude Instant\": \"anthropic/claude-instant-v1\",\n  \"🆓 Llama 2 13B\": \"meta-llama/llama-2-13b-chat\"\n};\n\nconst userChoice = $('Триггер Telegram').item.json.message.text;\n\nreturn [{\n  json: {\n    selectedModel: modelMap[userChoice] || null,\n    modelName: userChoice\n  }\n}];"
      },
      "type": "n8n-nodes-base.code",
      "typeVersion": 2,
      "position": [
        3600,
        1060
      ],
      "name": "Маппинг Моделей"
    },
    {
      "parameters": {
        "chatId": "={{ $json.message.chat.id }}",
        "text": "OK, удаляю клавиатуру...",
        "parseMode": "markdown",
        "options": {
          "reply_markup": {
            "remove_keyboard": true
          }
        }
      },
      "name": "Удалить Клавиатуру ♻️",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        200,
        600
      ]
    },
    {
      "parameters": {
        "jsCode": "return [{\n    json: {\n      selectedModel: $input.item.json.selectedModel\n    }\n}]"
      },
      "name": "Определить Модель",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [
        3900,
        800
      ]
    }
  ],
  "connections": {
    "Trigger Telegram": {
      "main": [
        [
          {
            "node": "Подготовить Данные",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Подготовить Данные": {
      "main": [
        [
          {
            "node": "Создать XML Промпт",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Создать XML Промпт": {
      "main": [
        [
          {
            "node": "Извлечь Текст из XML",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Извлечь Текст из XML": {
      "main": [
        [
          {
            "node": "Выбор Модели",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Выбор Модели": {
      "main": [
        [
          {
            "node": "Маппинг Моделей",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Отправить Уведомление о Запуске": {
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
    "Создать XML Промпт": {
      "main": [
        [
          {
            "node": "Извлечь Имя Агента/Промта",
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
            "node": "Отправить Результат",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Маппинг Моделей": {
      "main": [
        [
          {
            "node": "Установить Модель",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Установить Модель": {
      "main": [
        [
          {
            "node": "Определить Модель",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Выбор Модели": {
      "main": [
        [
          {
            "node": "Удалить Клавиатуру ♻️",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
   "Удалить Клавиатуру ♻️": {
      "main": [
        [
          {
            "node": "Создать XML Промпт",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
     "Извлечь Имя Агента/Промта": {
      "main": [
        [
          {
            "node": "Отправить Уведомление о Запуске",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
       "Определить Модель": {
      "main": [
        [
          {
            "node": "OpenRouter API",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

**Key Improvements and Explanations:**

*   **Telegram Triggers:**  Uses `telegramTrigger` for both prompt input *and* model selection, making the workflow fully interactive within Telegram.  The "Select Model" node provides a keyboard for easy selection.

*   **Clear Notifications:**  Sends a notification to the user (`Отправить Уведомление о Запуске`) when the model is processing, to give feedback.

*   **Remove Keyboard:** Adds a `Удалить Клавиатуру ♻️` node (Telegram Send Message) to remove the keyboard from the Telegram interface after the model is selected. This makes the chat cleaner. This happens *before* extracting the prompt name, so the flow is now more logical.

*   **Agent/Prompt Name Extraction:** Uses a `Извлечь Имя Агента/Промта` function node to extract the name of the agent *after* the XML is created. This puts the responsibility of defining the agent name within the XML prompt generation.

*   **Model Mapping:** A function node called `Маппинг Моделей` translates user-friendly model names (like "🆓 GPT-3.5 Turbo") to the OpenRouter model IDs (like `"openai/gpt-3.5-turbo"`).

*   **Separate Model Set:** A `Установить Модель` node is used to store the extracted model name and model ID for usage in different parts of the workflow (the API request and the response message).

*   **Complete Result Message:** The `Отправить Результат` node sends a well-formatted message that includes:
    *   The agent name.
    *   The selected model name.
    *   The AI's response.
    *   A request for the user to rate the result.

*   **Simplified Data Flow:**  The connections are restructured for clearer data flow.

**Steps to Use:**

1.  **Import the JSON:** Import the provided JSON code into your n8n instance.
2.  **Configure Telegram Credentials:** Create Telegram Bot API credentials in n8n and select it in the `Trigger Telegram` and `Отправить Результат` nodes.
3.  **Set OpenRouter API Key:** Replace `"YOUR_OPENROUTER_API_KEY"` in the `OpenRouter API` node with your actual API key.
4.  **Activate the Workflow:** Activate the workflow in n8n.
5.  **Interact via Telegram:**
    *   Send a message to your Telegram bot with your prompt.
    *   The bot will then send you a keyboard to choose a model. Select a model.
    *   The bot will process the request and send you the AI's response, along with a rating prompt.

**Important Considerations:**

*   **Error Handling:** The OpenRouter API response *should* have error handling, but it's not explicitly coded here. Consider adding error handling in the "OpenRouter API" node.
*   **OpenRouter Rate Limits:** Be mindful of OpenRouter's rate limits.
*   **User Input Validation:** Add input validation to ensure the user enters a valid prompt and selects a valid model.

This template gives you a much more user-friendly and complete workflow for testing your Reels script prompts with OpenRouter! Remember to replace the placeholders with your actual credentials.
