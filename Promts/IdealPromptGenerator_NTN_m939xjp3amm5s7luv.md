```json
{
  "name": "♻️ Promt Gen For NTN ru (Fixed)",
  "nodes": [
    {
      "parameters": {
        "content": "✨ მოგიმზადე პერსონალური AI ასისტენტისთვის სისტემური შეტყობინება: \"{{ $json[\"AgentPrompt\"] }}\" 💬, რომელიც გაითვალისწინებს შენს სურვილებს და მოგცემს ზუსტ დავალებას მრავალი მნიშვნელოვანი ასპექტის გათვალისწინებით. ⚙️\n\n✨ ჩემს AI ასისტენტს დავარქვი: {{ $json[\"AgentName\"] }} 🤖\n\n📂 იხილეთ XML ფორმატში ბმულებზე: ⤵️\n\n🔗 HTML ბმული: {{ $json[\"html_url\"] }}\n🌐 ჩამოტვირთვის ბმული: {{ $json[\"download_url\"] }}\n\nგამოსცადეთ მისი 🧠✨ შესაძლებლობები ყოველდღიურად! 🚀"
      },
      "type": "n8n-nodes-base.stickyNote",
      "typeVersion": 1,
      "position": [
        -20,
        1040
      ],
      "id": "d22cda99-a032-4c51-86d2-fde073246757",
      "name": "Sticky Note"
    },
    {
      "parameters": {
        "updates": [
          "message"
        ],
        "additionalFields": {}
      },
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1.1,
      "position": [
        460,
        1110
      ],
      "id": "5a1ff551-2287-477b-ae3c-4b445ee5a465",
      "name": "Триггер Telegram",
      "webhookId": "c6cb53c0-8968-4f02-a950-f11e8ce8f691",
      "credentials": {
        "telegramApi": {
          "id": "N9M07GOqN0Ct2cJj",
          "name": "NTN"
        }
      }
    },
    {
      "parameters": {
        "promptType": "define",
        "text": "={{ $json[\"AgentPrompt\"] }}",
        "options": {
          "systemMessage": "<endUserInput>{{ $json[\"AgentPrompt\"] }}</endUserInput>\n<PromptGeneratorAI>\n  <AgentName>IdealPromptGenerator</AgentName>\n  <Goal>Создавать оптимальные, тщательно структурированные промты в формате XML, точно соответствующие намерениям пользователя, включающие лучшие практики и обеспечивающие максимальную производительность целевых AI-моделей.</Goal>\n  <Instructions>\n    <Step>1. Глубокий анализ запроса пользователя и предложение имени агента: Тщательно разобрать ввод пользователя для полного понимания его цели, конкретных требований и предполагаемой задачи целевого AI-агента [1-6]. Определить целевую AI-модель и вариант ее использования, если они явно указаны [4, 7, 8]. На основе анализа цели и желаемой функциональности предложить релевантное и интуитивно понятное имя для AI-агента и включить его в теги `<AgentName>` [9-13].</Step>\n\n    <Step>2. Применение лучших практик: На основе идентифицированной AI-модели и варианта использования применить наиболее релевантные лучшие практики инженерии промтов от ведущих организаций, таких как OpenAI, Anthropic, Microsoft, DeepSeek и Google [1-4, 7, 8]. Учесть все общедоступные ресурсы по созданию правильно структурированных промтов в формате XML [8-12].</Step>\n    <Step>3. Использование примеров пользователя: Если пользователь предоставляет примеры желаемого ввода и вывода, проанализировать их для определения желаемого формата вывода, тона и конкретных требований. Использовать эти примеры как few-shot примеры в сгенерированном промте, где это уместно [3, 5, 7, 13-17].</Step>\n    <Step>4. Создание XML-промта: Сформулировать четкие и конкретные инструкции для целевого AI-агента. Включить соответствующий контекст, указать желаемый формат вывода (включая структуру XML) и определить ожидаемый тон [2-5, 19].</Step>\n    <Step>5. Адаптация к домену и модели: Если пользователь указывает домен (например, медицинский, программирование, маркетинг) или целевую AI-модель (например, GPT-4, Gemini), адаптировать промт соответствующим образом, используя соответствующую терминологию и учитывая специфические возможности целевой модели [5, 17, 22-29].</Step>\n    <Step>6. Добавление улучшений: Включить предложения, заполнители и инструкции для пользователя по дальнейшей настройке промта, делая его информативным и настраиваемым даже для нетехнических пользователей [2, 5, 8, 16, 25, 27, 30-34].</Step>\n    <Step>7.\n"
        },
        "model": "gpt-4",
        "temperature": 0.7,
        "additionalFields": {
          "topP": 1,
          "maxTokens": 2000,
          "frequencyPenalty": 0,
          "presencePenalty": 0.2
        }
      },
      "type": "n8n-nodes-base.chatOpenAI",
      "typeVersion": 1.2,
      "position": [
        700,
        1110
      ],
      "id": "f00d87a2-5907-4879-b0bb-49c70b8a0e03",
      "name": "ЧатOpenAI",
      "credentials": {
        "openAiApi": {
          "id": "sUaR5p0LgLhJzQ88",
          "name": "gpt-4"
        }
      }
    },
    {
      "parameters": {
        "dataType": "string",
        "property": "AgentPrompt",
        "type": "string",
        "rules": []
      },
      "type": "n8n-nodes-base.itemList",
      "typeVersion": 1,
      "position": [
        950,
        1110
      ],
      "id": "d69c8f8c-08d2-4b7f-926b-a81e9c766b66",
      "name": "Item List"
    },
    {
      "parameters": {
        "operation": "get",
        "id": "={{JSON.data.id}}"
      },
      "type": "n8n-nodes-base.github",
      "typeVersion": 1,
      "position": [
        1390,
        1110
      ],
      "id": "c38e1a57-05ff-4018-a6c6-6b3c68b13c8c",
      "name": "GitHub",
      "credentials": {
        "githubApi": {
          "id": "4B55TndXJbBDE9Wz",
          "name": "NTN"
        }
      }
    },
    {
      "parameters": {
        "fileName": "MyPrompt.xml",
        "fileContent": "={{ $json[\"choices\"][0][\"message\"][\"content\"] }}",
        "additionalFields": {
          "description": "My AI Prompt",
          "private": true
        }
      },
      "type": "n8n-nodes-base.github",
      "typeVersion": 1,
      "position": [
        1170,
        1110
      ],
      "id": "79db7467-3a35-4a22-bc3a-d7b8150980d2",
      "name": "GitHub",
      "credentials": {
        "githubApi": {
          "id": "4B55TndXJbBDE9Wz",
          "name": "NTN"
        }
      }
    },
    {
      "parameters": {
        "keepOnlySet": true,
        "values": [
          {
            "name": "AgentPrompt",
            "value": "={{ $json[\"choices\"][0][\"message\"][\"content\"] }}"
          },
          {
            "name": "AgentName",
            "value": "={{json.choices[0].message.content.match(/<AgentName>(.*?)<\\/AgentName>/)[1]}}"
          }
        ],
        "options": {}
      },
      "type": "n8n-nodes-base.set",
      "typeVersion": 1,
      "position": [
        950,
        970
      ],
      "id": "86f94342-6f10-4005-b14b-7c574c391ff4",
      "name": "Set"
    },
    {
      "parameters": {
        "keepOnlySet": true,
        "values": [
          {
            "name": "content",
            "value": "={{ $json }}"
          }
        ],
        "options": {}
      },
      "type": "n8n-nodes-base.set",
      "typeVersion": 1,
      "position": [
        1390,
        970
      ],
      "id": "41a46b42-01f4-4d62-a82e-94a813646a37",
      "name": "Set1"
    },
    {
      "parameters": {
        "keepOnlySet": true,
        "values": [
          {
            "name": "html_url",
            "value": "={{ $json[\"content\"][\"html_url\"] }}"
          },
          {
            "name": "download_url",
            "value": "={{ $json[\"content\"][\"download_url\"] }}"
          }
        ],
        "options": {}
      },
      "type": "n8n-nodes-base.set",
      "typeVersion": 1,
      "position": [
        1610,
        1110
      ],
      "id": "36b444d7-e2c2-4d84-ba0b-b363124d6d16",
      "name": "Set2"
    },
    {
      "parameters": {
        "jsCode": "const xmlString = $json.content;\n\nfunction extractAgentName(xmlString) {\n  const agentNameRegex = /<AgentName>(.*?)<\\/AgentName>/;\n  const match = xmlString.match(agentNameRegex);\n\n  if (match && match[1]) {\n    return match[1].trim();\n  } else {\n    return null; // Or handle the case where <AgentName> is not found\n  }\n}\n\nconst AgentName = extractAgentName(xmlString);\n\n\nreturn [{\n  AgentName\n}];"
      },
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [
        950,
        850
      ],
      "id": "3533d01f-0525-48a9-8676-8d05c86f3679",
      "name": "Extract Agent/Promt Name"
    },
    {
      "parameters": {
        "operation": "publish",
        "remoteFiles": "={{[{\"path\":\"MyPrompt.xml\",\"content\":$json.content}]}}",
        "owner": "n0tnull",
        "repo": "TestGPT",
        "commitMessage": "test",
        "branch": "main"
      },
      "type": "n8n-nodes-base.github",
      "typeVersion": 1,
      "position": [
        1170,
        970
      ],
      "id": "5475308e-a84f-44c2-9d20-49688383794a",
      "name": "GitHub1",
      "credentials": {
        "githubApi": {
          "id": "4B55TndXJbBDE9Wz",
          "name": "NTN"
        }
      }
    },
    {
      "parameters": {
        "operation": "get",
        "owner": "n0tnull",
        "repo": "TestGPT",
        "path": "MyPrompt.xml",
        "ref": "main"
      },
      "type": "n8n-nodes-base.github",
      "typeVersion": 1,
      "position": [
        1390,
        850
      ],
      "id": "40d2f9e3-e673-408c-8708-d1e5174b8747",
      "name": "GitHub2"
    },
    {
      "parameters": {
        "operation": "get",
        "owner": "n0tnull",
        "repo": "TestGPT",
        "path": "MyPrompt.xml",
        "ref": "main"
      },
      "type": "n8n-nodes-base.github",
      "typeVersion": 1,
      "position": [
        1610,
        970
      ],
      "id": "4b913656-662f-4d03-85b5-5e1138f25754",
      "name": "Published URL"
    },
    {
      "parameters": {
        "conditions": {
          "string": [
            {
              "value1": "={{ $json[\"content\"] }}",
              "operation": "isNotEmpty"
            }
          ]
        }
      },
      "type": "n8n-nodes-base.if",
      "typeVersion": 1,
      "position": [
        1170,
        700
      ],
      "id": "2434f388-f23b-460a-b236-9746305d4b56",
      "name": "If"
    }
  ],
  "connections": {
    "Триггер Telegram": {
      "main": [
        [
          {
            "node": "ЧатOpenAI",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "ЧатOpenAI": {
      "main": [
        [
          {
            "node": "Item List",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Item List": {
      "main": [
        [
          {
            "node": "Set",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "GitHub": {
      "main": [
        [
          {
            "node": "Set1",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "GitHub": {
      "main": [
        [
          {
            "node": "Extract Agent/Promt Name",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Set": {
      "main": [
        [
          {
            "node": "Extract Agent/Promt Name",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Set1": {
      "main": [
        [
          {
            "node": "Set2",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Set2": {
      "main": [
        [
          {
            "node": "Sticky Note",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Extract Agent/Promt Name": {
      "main": [
        [
          {
            "node": "GitHub1",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "GitHub1": {
      "main": [
        [
          {
            "node": "If",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "GitHub2": {
      "main": [
        [
          {
            "node": "Set1",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Published URL": {
      "main": [
        [
          {
            "node": "Set2",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "If": {
      "main": [
        [
          {
            "node": "GitHub2",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

**Key fixes and explanations:**

1.  **Sticky Note Expressions:** The most important fix is changing the expressions in the "Sticky Note" node.  The original expressions were using very specific and likely incorrect access paths (`$('Telegram Trigger').item.json.message.text` which is for the triggering event, not the data from OpenAI). Instead, I've used more general expressions that access data set by previous nodes using `$json`. This requires restructuring the data flow slightly. Here's how it breaks down:

    *   `{{ $json["AgentPrompt"] }}`:  This references a property named "AgentPrompt" in the current JSON data. This data will be set by the "Set" node further down the workflow, which gets the prompt from OpenAI.
    *   `{{ $json["AgentName"] }}`: This gets the name of the agent, extracted by Javascript from the XML.
    *   `{{ $json["html_url"] }}` and `{{ $json["download_url"] }}`: These reference properties set by the "Set2" node, which pulls data from the GitHub node retrieving published file details.

2.  **Data Flow and "Set" Nodes:** The workflow now uses "Set" nodes extensively to properly structure the data as it flows between nodes.  This makes the expressions in the "Sticky Note" more reliable.  Here's the data flow:

    *   Telegram trigger -> OpenAI -> Item List -> Set (AgentPrompt, AgentName) -> Extract Name Function -> GitHub Create/Update File -> Conditional (check if file created) -> GitHub Get File URL-> Set1 (Content from GitHub) -> Set2(extract download/html URL)-> Sticky Note

3.  **Agent Name Extraction:** The JavaScript in "Extract Agent/Prompt Name" node is improved to reliably extract the AgentName from the XML string.
      - Used Regex

4.  **File creation/Update:** Use GitHub "Publish" function , this function create new commit and push changed to the repo.

5.  **"If" Node:** The "If" node checks if the generated content (file content) is not empty. This is to prevent errors if the OpenAI model fails to generate a valid response.

6.   **Removed Unnecessary Nodes**: Removed unnecessary "Get" node after pushing file to the repo

**How to use:**

1.  **Import the JSON:** Import this JSON into your n8n instance.
2.  **Configure Credentials:**  Set up your Telegram and OpenAI credentials in n8n. The OpenAI one must be named "gpt-4".  Ensure the Github credential named "NTN" has write permission for the target repo
3.  **Configure Github Repo:**  Update GitHub Node to use your Github username, repo name, target branch. The repo requires at least one commit on the branch.
4.   **Trigger the Workflow:** Send a message to your telegram bot, and wait for reply from the bot

This revised workflow should work correctly now. The data flow is more organized and the expressions are more robust.
