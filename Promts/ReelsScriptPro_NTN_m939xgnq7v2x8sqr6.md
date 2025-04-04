Окей, я вижу, что ты предоставил часть n8n workflow в формате JSON.  На основе этой информации я создам дополнительные ноды и логику, чтобы пользователь мог протестировать свой промт, используя OpenRouter API. Я буду исходить из предположения, что workflow уже генерирует промт, предоставляет возможность выбора модели и отправляет промт в OpenRouter.  Мне нужно добавить логику обработки результата и отправки его обратно пользователю.

Вот JSON для новых нодов, которые нужно добавить (плюс модификации существующих нодов для большей функциональности):

```json
{
  "nodes": [
    {
      "parameters": {
        "question": "Enter your prompt for the Reels script agent.  Include details about target audience, theme, format, duration, and goal.",
        "name": "User Input"
      },
      "name": "User Input",
      "type": "telegramTrigger",
      "typeVersion": 1,
      "position": [
        200,
        200
      ]
    },
    {
      "parameters": {
        "jsCode": "const prompt = $input.item.message.text;\n\nreturn [\n  {\n    prompt: prompt,\n  },\n];",
        "name": "Prepare Data"
      },
      "name": "Prepare Data",
      "type": "Function",
      "typeVersion": 1,
      "position": [
        400,
        200
      ]
    },
    {
      "parameters": {
        "jsCode": "// Access the prompt from the previous node\nconst userPrompt = $input.item.prompt;\n\n// Define the XML structure with the user's prompt\nconst xmlPrompt = `\n<Prompt>\n    <OriginalPrompt>${userPrompt}</OriginalPrompt>\n    <AgentName>ReelsScriptPro</AgentName>\n    <Goal>Creating engaging and viral Reel scripts.</Goal>\n    <Instructions>\n        <Context>You are an expert in short-form video content creation.</Context>\n        <Task>Based on the theme, create a script suitable for a Reel.</Task>\n        <Theme>Please specify the theme of the Reel.</Theme>\n        <Example>Scene 1: Visual - Person dancing. Text - Learn the latest TikTok dance craze! Audio - Trending music.</Example>\n    </Instructions>\n</Prompt>\n`;\n\nreturn [\n  {\n    xmlPrompt: xmlPrompt,\n  },\n];",
        "name": "Generate XML Prompt"
      },
      "name": "Generate XML Prompt",
      "type": "Function",
      "typeVersion": 1,
      "position": [
        600,
        200
      ]
    },
    {
      "parameters": {
        "jsCode": "// Access the XML prompt from the previous node\nconst xmlPrompt = $input.item.xmlPrompt;\n\n// Remove XML tags and extract the content\nconst textPrompt = xmlPrompt.replace(/<[^>]*>/g, '');\n\nreturn [\n  {\n    textPrompt: textPrompt.trim(), // Trim whitespace\n  },\n];",
        "name": "Extract Text from XML"
      },
      "name": "Extract Text from XML",
      "type": "Function",
      "typeVersion": 1,
      "position": [
        800,
        200
      ]
    },
    {
      "parameters": {
        "chatId": "={{ $('Триггер Telegram').item.json.message.chat.id }}",
        "text": "=🤖 *Выберите модель для тестирования вашего промта:*\n\nВаш промт «{{ $('Extract Text from XML').item.textPrompt }}» готов к тестированию! Выберите одну из доступных моделей:",
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
                  },
                  {
                    "text": "🆓 Llama 2 13B",
                    "additionalFields": {}
                  }
                ]
              }
            },
            {
              "row": {
                "buttons": [
                  {
                    "text": "❌ Отменить тестирование",
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
        3200,
        1160
      ],
      "name": "Выбор Модели",
      "webhookId": "fa88c39a-4f5c-4da2-999a-47aeee823e92"
    },
    {
      "parameters": {
        "conditions": {
          "conditions": [
            {
              "id": "8975ffaa-c94d-4320-ab1f-cfc875f0384e",
              "leftValue": "={{ $('Триггер Telegram').item.json.message.text }}",
              "rightValue": "🆓 GPT-3.5 Turbo",
              "operator": {
                "type": "string",
                "operation": "equals"
              }
            },
            {
              "id": "8975ffaa-c94d-4320-ab1f-cfc875f0384e",
              "leftValue": "={{ $('Триггер Telegram').item.json.message.text }}",
              "rightValue": "🆓 Claude Instant",
              "operator": {
                "type": "string",
                "operation": "equals"
              }
            },
            {
              "id": "8975ffaa-c94d-4320-ab1f-cfc875f0384e",
              "leftValue": "={{ $('Триггер Telegram').item.json.message.text }}",
              "rightValue": "🆓 Llama 2 13B",
              "operator": {
                "type": "string",
                "operation": "equals"
              }
            },
            {
              "id": "8975ffaa-c94d-4320-ab1f-cfc875f0384e",
              "leftValue": "={{ $('Триггер Telegram').item.json.message.text }}",
              "rightValue": "❌ Отменить тестирование",
              "operator": {
                "type": "string",
                "operation": "equals"
              }
            }
          ],
          "combinator": "or"
        },
        "option": "value"
      },
      "type": "n8n-nodes-base.if",
      "typeVersion": 2.2,
      "position": [
        3500,
        1160
      ],
      "name": "Определить Модель"
    },
    {
      "parameters": {
        "url": "=https://openrouter.ai/api/v1/chat/completions",
        "options": {
          "headers": {
            "Authorization": "Bearer {{$credentials.openRouterApi}}",
            "HTTP-Referer": "https://your-site.com",
            "X-Title": "n8n AI Testing"
          },
          "body": {
            "model": "={{ $json.selectedModel }}",
            "messages": [
              {
                "role": "system",
                "content": "={{ $('Generate XML Prompt').item.xmlPrompt }}"
              },
              {
                "role": "user",
                "content": "Проверочный запрос: объясни своими словами, как ты будешь работать с этим промтом?  Предоставь короткий пример, как ты бы сгенерировал сценарий для Reels, используя тему 'Как сделать идеальный кофе дома'."
              }
            ]
          }
        },
        "response": {
          "responseFormat": "string"
        }
      },
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 1.1,
      "position": [
        3800,
        1160
      ],
      "name": "OpenRouter API",
      "credentials": {
        "openRouterApi": {
          "id": "YOUR_OPENROUTER_API_ID",
          "name": "OpenRouter API Key"
        }
      }
    },
    {
      "parameters": {
        "chatId": "={{ $('Триггер Telegram').item.json.message.chat.id }}",
        "text": "=*Тест завершен!*\n\n*Модель:* {{ $json.model }}\n\n*Ответ OpenRouter:*\n\n{{ $json.choices[0].message.content }}",
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
      "name": "Отправить Ответ",
      "webhookId": "fa88c39a-4f5c-4da2-999a-47aeee823e92"
    },
    {
      "parameters": {
        "chatId": "={{ $('Триггер Telegram').item.json.message.chat.id }}",
        "text": "*Тестирование отменено*",
        "additionalFields": {
          "parse_mode": "Markdown"
        }
      },
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        4100,
        1300
      ],
      "name": "Отменить",
      "webhookId": "fa88c39a-4f5c-4da2-999a-47aeee823e92"
    },
    {
      "parameters": {
        "jsCode": "//Code here will be executed.\n\nconst model = $input.item.message.text;\n\nlet selectedModel;\n\nif (model === '🆓 GPT-3.5 Turbo') {\n  selectedModel = 'openai/gpt-3.5-turbo';\n} else if (model === '🆓 Claude Instant') {\n  selectedModel = 'anthropic/claude-instant-v1';\n} else if (model === '🆓 Llama 2 13B') {\n    selectedModel = 'meta-llama/Llama-2-13b-chat-hf'\n}\n\n\nreturn [\n  {\n    selectedModel: selectedModel,\n  },\n];",
        "name": "Выбрать Модель"
      },
      "type": "n8n-nodes-base.function",
      "typeVersion": 1.3,
      "position": [
        3640,
        1160
      ],
      "name": "Выбрать Модель"
    }
  ],
  "connections": {
    "User Input": {
      "main": [
        [
          {
            "node": "Prepare Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Prepare Data": {
      "main": [
        [
          {
            "node": "Generate XML Prompt",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Generate XML Prompt": {
      "main": [
        [
          {
            "node": "Extract Text from XML",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Extract Text from XML": {
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
            "node": "Определить Модель",
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
            "node": "Выбрать Модель",
            "type": "true",
            "index": 0
          }
        ],
        [
          {
            "node": "Отменить",
            "type": "false",
            "index": 0
          }
        ]
      ]
    },
    "OpenRouter API": {
      "main": [
        [
          {
            "node": "Отправить Ответ",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Выбрать Модель": {
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

**Основные изменения и улучшения:**

*   **"Выбрать Модель" (Function Node):** Этот новый Function node берет текст, введенный пользователем (например, "🆓 GPT-3.5 Turbo"), и сопоставляет его с фактическим идентификатором модели OpenRouter (например, "openai/gpt-3.5-turbo").  Это необходимо, потому что пользователю удобнее видеть имена моделей, а API требует идентификаторы.
*   **"Определить Модель" (IF Node):**  Добавлены дополнительные условия для сопоставления текста, вводимого пользователем, с различными моделями, и добавлено условие для отмены тестирования.
*    **Улучшенный Prompt в OpenRouter API:** Добавил в поле  `messages`  роль `system`  с контентом промта, и роль `user` c проверочным запросом
*   **"OpenRouter API" (HttpRequest Node):**
    *   Улучшено добавление `user` с вопросом.
    *   Улучшен синтаксис `{{ $json.choices[0].message.content }}` из ответа, чтобы выдать только ответ.
    *  Запрос теперь отправляет XML Prompt (содержимое)
*   **"Отправить Ответ" (Telegram Node):**  Отображает результаты для пользователя, используя Markdown для форматирования (жирный шрифт для заголовков).  Включает имя модели и ответ от OpenRouter.
*   **"Отменить" (Telegram Node):** Отправляет сообщение об отмене.

**Важные шаги после импорта в n8n:**

1.  **Установите OpenRouter API Key:** Замените `"YOUR_OPENROUTER_API_ID"`  на ID ваших учетных данных OpenRouter API в n8n.  Убедитесь, что у вас есть учетные данные OpenRouter API, настроенные в n8n.  Перейдите в `Credentials` и настройте там OpenRouter.
2.  **Проверьте Webhook ID:** Убедитесь, что `webhookId` в нодах Telegram соответствует вашему текущему webhook ID.
3.  **Активируйте Workflow:** После настройки активируйте workflow.

Теперь, когда пользователь отправит промт через Telegram, workflow обработает его, предложит выбрать модель, отправит промт в OpenRouter и вернет пользователю результат. Если пользователь выберет "Отменить тестирование", workflow отправит сообщение об отмене.
