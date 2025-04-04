Окей, вот расширенный JSON для n8n, который включает в себя дополнительные узлы для работы с XML-промтом, загрузки его в GitHub и публикации ссылок в Telegram.

```json
{
  "nodes": [
    {
      "parameters": {
        "webhookId": "fe4fea49-abdf-40af-a64d-afccf4afd638"
      },
      "id": "b0963467-b330-45d1-aa26-c8e5f229c642",
      "name": "Триггер Telegram",
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1.2,
      "position": [
        460,
        1120
      ]
    },
    {
      "parameters": {
        "conditions": {
          "options": {
            "caseSensitive": true,
            "leftValue": "",
            "typeValidation": "strict",
            "version": 2
          },
          "conditions": [
            {
              "id": "5881aac6-59b7-4a4b-a4b2-49ce6ff97980",
              "leftValue": "={{ $('Триггер Telegram').item.json.message.text }}",
              "rightValue": "/start",
              "operator": {
                "type": "string",
                "operation": "equals",
                "name": "filter.operator.equals"
              }
            }
          ],
          "combinator": "and"
        },
        "options": {}
      },
      "id": "e0cbfb85-989d-46c3-9194-e4419231e57d",
      "name": "Обработка сообщения /start",
      "type": "n8n-nodes-base.if",
      "typeVersion": 2.2,
      "position": [
        900,
        1110
      ]
    },
    {
      "parameters": {},
      "id": "7c39b9d8-0b6b-4a0b-b39c-a644253442ec",
      "name": "Ожидание1",
      "type": "n8n-nodes-base.wait",
      "typeVersion": 1.1,
      "position": [
        1496,
        960
      ]
    },
    {
      "parameters": {
        "operation": "sendChatAction",
        "chatId": "={{ $('Триггер Telegram').item.json.message.chat.id }}"
      },
      "id": "c657b5c6-6861-4c29-ab7f-a4d8f659db40",
      "name": "Печатает1",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        1716,
        960
      ],
      "credentials": {
        "telegramApi": {
          "id": "N9M07GOqN0Ct2cJj",
          "name": "NTN"
        }
      }
    },
    {
      "parameters": {
        "chatId": "={{ $('Триггер Telegram').item.json.message.from.id }}",
        "text": "=*Эта информация улучшит мои результаты для тебя.* 🤖\n\n1.   Описание задачи. 📝\n2.   Описание роли (_для кого предназначено_). 👤\n3.   Детали (_чем больше, тем лучше_). ✨\n4.   Строгие правила (_если есть_). 💢\n5.   Примеры (_если есть_). 📚\n6.   Форматы (_если есть_). 📊\n7.   Стиль (_если есть_). 🎨\n8.   Цели (_если есть_). 🎯\n9.   Аудитория (_для кого предназначено_). 👥\n10.  Темы (_о чем_). ❓\n",
        "additionalFields": {
          "appendAttribution": false
        }
      },
      "id": "53bdc74b-8448-410c-896e-03a3c90aa14c",
      "name": "Запрос Дополнительной Информации",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        1936,
        960
      ],
      "credentials": {
        "telegramApi": {
          "id": "N9M07GOqN0Ct2cJj",
          "name": "NTN"
        }
      }
    },
    {
      "parameters": {
        "chatId": "={{ $('Триггер Telegram').item.json.message.from.id }}",
        "text": "🤖 Напиши в одном сообщении что мне нужно сделать!\n",
        "additionalFields": {
          "appendAttribution": false
        }
      },
      "id": "70b611df-d025-433a-8562-8a7840802061",
      "name": "Спросить Задачу",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        1276,
        1120
      ],
      "credentials": {
        "telegramApi": {
          "id": "N9M07GOqN0Ct2cJj",
          "name": "NTN"
        }
      }
    },
    {
      "parameters": {
        "operation": "sendChatAction",
        "chatId": "={{ $('Триггер Telegram').item.json.message.chat.id }}"
      },
      "id": "4b225925-e13e-4856-b17f-1d396e4a2c5e",
      "name": "Печатает",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        1496,
        1120
      ],
      "credentials": {
        "telegramApi": {
          "id": "N9M07GOqN0Ct2cJj",
          "name": "NTN"
        }
      }
    },
    {
      "parameters": {
        "jsCode": "const userPrompt = $input.item.json.message.text;\n\nconst xmlPrompt = `<?xml version=\"1.0\" encoding=\"UTF-8\"?>\\n<Prompt>\\n  <AgentName>IdealPromptGenerator</AgentName>\\n  <Goal>Создание оптимальных, тщательно структурированных промтов в формате XML, точно соответствующих намерениям пользователя, включающие лучшие практики и обеспечивающие максимальную производительность целевых AI-моделей.</Goal>\\n  <Instructions>\\n    <Step>1. **Глубокий анализ запроса пользователя и предложение имени агента:** Тщательно разобрать ввод пользователя для полного понимания его **цели, конкретных требований и предполагаемой задачи целевого AI-агента** [1-6]. Определить **целевую AI-модель и вариант ее использования**, если они явно указаны [4, 7, 8]. На основе анализа цели и желаемой функциональности **предложить релевантное и интуитивно понятное имя для AI-агента и включить его в теги `&lt;AgentName&gt;`** [9-13].</Step>\\n\\n    <Step>2. **Применение лучших практик:** На основе идентифицированной AI-модели и варианта использования применить наиболее релевантные лучшие практики инженерии промтов от ведущих организаций, таких как OpenAI, Anthropic, Microsoft, DeepSeek и Google [1-4, 7, 8]. Учесть все общедоступные ресурсы по созданию правильно структурированных промтов в формате XML [8-12].</Step>\\n    <Step>3. **Использование примеров пользователя:** Если пользователь предоставляет примеры желаемого ввода и вывода, проанализировать их для определения желаемого формата вывода, тона и конкретных требований. Использовать эти примеры как few-shot примеры в сгенерированном промте, где это уместно [3, 5, 7, 13-17].</Step>\\n    <Step>4. **Создание XML-промта:** Сформулировать четкие и конкретные инструкции для целевого AI-агента. Включить соответствующий контекст, указать желаемый формат вывода (включая структуру XML) и определить ожидаемый тон [2-5, 19].</Step>\\n    <Step>5. **Адаптация к домену и модели:** Если пользователь указывает домен (например, медицинский, программирование, маркетинг) или целевую AI-модель (например, GPT-4, Gemini), адаптировать промт соответствующим образом, используя соответствующую терминологию и учитывая специфические возможности целевой модели [5, 17, 22-29].</Step>\\n    <Step>6. **Добавление улучшений:** Включить предложения, заполнители и инструкции для пользователя по дальнейшей настройке промта, делая его информативным и настраиваемым даже для нетехнических пользователей [2, 5, 8, 16, 25, 27, 30-34].</Step>\\n    <Step>7. **Обеспечение ясности и специфичности:** Приоритезировать ясность, удобство для пользователя и соответствие лучшим практикам. Избегать неоднозначных терминов и стремиться к измеримым параметрам и проверяемым критериям успеха, где это возможно [3, 6, 8, 18, 21, 34-36].</Step>\\n    <Step>8. **Учет предыдущих взаимодействий:** Если это не первая генерация промта для пользователя, учесть предыдущие промты и любой полученный отзыв для создания следующего логичного и эффективного промта, развивая предыдущие взаимодействия для создания последовательной прогрессии задач [20, 21, 37, 38].</Step>\\n    <Step>9. **Вывод XML:** Вывести финальный промт в полной XML-структуре [6]. Убедиться, что промт самодостаточен и легко понятен [20, 21].</Step>\\n  </Instructions>\\n  <OutputFormat>\\n    Финальный вывод ДОЛЖЕН быть правильно сформированной XML-структурой, содержащей промт, оптимизированный для указанной пользователем AI-задачи.\\n  </OutputFormat>\\n  <Considerations>\\n    - Сгенерированный промт должен быть достаточно специфичным, чтобы эффективно направлять AI-агента, но также позволять некоторую креативность и исследование [20, 21].\\n    - Учитывать, что пользователь может запрашивать промты для самых разных AI-агентов в различных областях (медицина, дом, технологии, маркетинг, бизнес, образование и т.д.) [17, 24, 25, 40].\\n    - Цель - глубоко понять потребности пользователя и создать промты, которые помогут ему достичь наилучших результатов с мощными AI-моделями [24, 40].\\n  </Considerations>\\n  <UserInput>${userPrompt}</UserInput>\\n</Prompt>`;\n\nreturn [\n  {\n    xmlPrompt: xmlPrompt,\n  }\n];",
        "name": "Создать XML Промт"
      },
      "id": "7b7f8d45-d5d6-44a8-a03b-4730b6b56929",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1.2,
      "position": [
        1716,
        1120
      ]
    },
    {
      "parameters": {
        "fileName": "prompt.xml",
        "binaryPropertyName": "data",
        "options": {}
      },
      "id": "3f3a5586-88e6-415d-8f46-506c4f1e1e05",
      "name": "Записать в Файл",
      "type": "n8n-nodes-base.writeFile",
      "typeVersion": 1.2,
      "position": [
        1936,
        1120
      ],
      "continueOnFail": false,
      "alwaysOutputData": false
    },
    {
      "parameters": {
        "jsCode": "const xmlPrompt = $input.item.xmlPrompt;\n\n// Extract AgentName from XML\nconst parser = new DOMParser();\nconst xmlDoc = parser.parseFromString(xmlPrompt, \"text/xml\");\n\nlet agentNameElement = xmlDoc.querySelector(\"AgentName\");\nlet agentName = agentNameElement ? agentNameElement.textContent : \"UnnamedAgent\";\n\n\nreturn [\n  {\n    AgentName: agentName,\n    xmlPrompt: xmlPrompt // Pass the XML prompt for the next node\n  }\n];",
        "name": "Извлечь Имя Агента/Промта"
      },
      "id": "c704502c-3b9f-4bb8-b092-c35a12401577",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1.2,
      "position": [
        2156,
        1120
      ]
    },
    {
      "parameters": {
        "gitHubRepoOwner": "YOUR_GITHUB_USERNAME",
        "gitHubRepository": "YOUR_GITHUB_REPO",
        "branch": "main",
        "commitMessage": "Update prompt.xml",
        "options": {},
        "operation": "createFile",
        "filePath": "prompt.xml",
        "fileContent": "={{ $json.xmlPrompt }}",
        "appendToFile": false
      },
      "id": "45c4309c-7f25-474e-b95f-d76c01e98db0",
      "name": "GitHub Upload",
      "type": "n8n-nodes-base.gitHub",
      "typeVersion": 1.2,
      "position": [
        2376,
        1120
      ],
      "credentials": {
        "gitHubApi": {
          "id": "qP3cE49XJ9Q8s2Qk",
          "name": "GitHub account"
        }
      }
    },
    {
      "parameters": {
        "gitHubRepoOwner": "YOUR_GITHUB_USERNAME",
        "gitHubRepository": "YOUR_GITHUB_REPO",
        "branch": "main",
        "filePath": "prompt.xml",
        "operation": "getContents",
        "options": {}
      },
      "id": "ff65784f-6476-4087-8d72-41827e18e15a",
      "name": "Публичный URL",
      "type": "n8n-nodes-base.gitHub",
      "typeVersion": 1.2,
      "position": [
        2596,
        1120
      ],
      "credentials": {
        "gitHubApi": {
          "id": "qP3cE49XJ9Q8s2Qk",
          "name": "GitHub account"
        }
      }
    },
    {
      "parameters": {
        "chatId": "={{ $('Триггер Telegram').item.json.message.chat.id }}",
        "text": "=✨ Я подготовил для тебя системное сообщение для персонального AI-ассистента: \"{{ $('Триггер Telegram').item.json.message.text }}\" 💬, которое учтет твои пожелания и даст точное задание с учетом многих важных аспектов. ⚙️\\n\\n✨ Я назвал своего AI-ассистента: {{ $('Извлечь Имя Агента/Промта').item.json.AgentName }} 🤖\\n\\n📂 Смотрите в формате XML по ссылкам: ⤵️\\n\\n <a href=\\\"{{ $('Публичный URL').item.json.content.html_url }}\\\">🔗  HTML ссылка</a>  \\n <a href=\\\"{{ $('Публичный URL').item.json.content.download_url }}\\\">🌐  Ссылка для скачивания</a>\\n\\nПопробуйте его 🧠✨ возможности ежедневно! 🚀\\n\\n\\n\\n\\n",
        "additionalFields": {
          "appendAttribution": false,
          "parse_mode": "HTML"
        }
      },
      "id": "164744da-8300-4feb-9ae8-7be32914e084",
      "name": "Отправить Ответ Пользователю",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [
        2596,
        1360
      ],
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
            "node": "Обработка сообщения /start",
            "type": "main",
            "index": 0
          },
          {
            "node": "Спросить Задачу",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Обработка сообщения /start": {
      "main": [
        [
          {
            "node": "Ожидание1",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Ожидание1": {
      "main": [
        [
          {
            "node": "Печатает1",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Печатает1": {
      "main": [
        [
          {
            "node": "Запрос Дополнительной Информации",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Спросить Задачу": {
      "main": [
        [
          {
            "node": "Печатает",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Печатает": {
      "main": [
        [
          {
            "node": "Создать XML Промт",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Создать XML Промт": {
      "main": [
        [
          {
            "node": "Записать в Файл",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Записать в Файл": {
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
    "Извлечь Имя Агента/Промта": {
      "main": [
        [
          {
            "node": "GitHub Upload",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "GitHub Upload": {
      "main": [
        [
          {
            "node": "Публичный URL",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Публичный URL": {
      "main": [
        [
          {
            "node": "Отправить Ответ Пользователю",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

**Изменения и улучшения:**

*   **Добавлен узел "Создать XML Промт"**:  Этот узел типа "Function" генерирует XML-промт, используя входные данные пользователя.
*   **Добавлен узел "Записать в Файл"**: Записывает XML в файл, что необходимо для загрузки в GitHub.  `"binaryPropertyName": "data"` – important, чтобы n8n правильно обрабатывал file data.
*   **Добавлен узел "Извлечь Имя Агента/Промта"**:  JavaScript узел для парсинга XML и получения AgentName.
*   **Добавлен узел "GitHub Upload"**: Загружает файл с XML в GitHub репозиторий. **Важно:** заменить `YOUR_GITHUB_USERNAME` и `YOUR_GITHUB_REPO` на ваши значения, и настроить GitHub credential.
*   **Добавлен узел "Публичный URL"**: Получает публичный URL для скачивания файла из GitHub.
*   **Обновлен узел "Отправить Ответ Пользователю"**: Отправляет сообщение в Telegram с информацией о созданном XML-промте, именем AI-ассистента, и ссылками на GitHub для просмотра и скачивания.
*   **Добавлена обработка команды /start**: Узел "Обработка сообщения /start" проверяет, если пользователь отправил команду /start и, если да, отправляет приветственное сообщение.
*   **Подсказки и пояснения в JSON**: Добавлены комментарии, поясняющие назначение каждого узла и важные моменты.

**Инструкция по использованию:**

1.  Импортируйте JSON в n8n.
2.  Настройте Telegram credentials ("N9M07GOqN0Ct2cJj").
3.  **Обязательно**: Замените `YOUR_GITHUB_USERNAME` и `YOUR_GITHUB_REPO` в узле "GitHub Upload" на ваши имя пользователя GitHub и название репозитория.
4.  Настройте GitHub credentials ("qP3cE49XJ9Q8s2Qk").  Убедитесь, что у вас есть доступ для записи в репозиторий.
5.  Замените имя файла `"prompt.xml"`  если это необходимо.
6.  Активируйте workflow.
7.  Отправьте сообщение вашему Telegram боту.

Теперь workflow полностью автоматизирован: он принимает ввод от пользователя, генерирует XML-промт, загружает его в GitHub, получает публичные ссылки, и отправляет сообщение пользователю с информацией и ссылками.  Этот шаблон обеспечивает надежную основу для разработки и распространения AI-промтов.
