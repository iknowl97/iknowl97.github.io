```xml
<Workflow>
  <Nodes>
    <Node id="1" type="UserInput">
      <Description>Получение промта от пользователя.</Description>
      <OutputVariable>userPrompt</OutputVariable>
    </Node>

    <Node id="2" type="PromptGenerator">
      <Description>Генерация промта в формате XML.</Description>
      <AgentName>IdealPromptGenerator</AgentName>
      <Instructions>
        <Step>1. **Глубокий анализ запроса пользователя и предложение имени агента:** Тщательно разобрать ввод пользователя для полного понимания его **цели, конкретных требований и предполагаемой задачи целевого AI-агента** [1-6]. Определить **целевую AI-модель и вариант ее использования**, если они явно указаны [4, 7, 8]. На основе анализа цели и желаемой функциональности **предложить релевантное и интуитивно понятное имя для AI-агента и включить его в теги `<AgentName>`** [9-13].</Step>

        <Step>2. **Применение лучших практик:** На основе идентифицированной AI-модели и варианта использования применить наиболее релевантные лучшие практики инженерии промтов от ведущих организаций, таких как OpenAI, Anthropic, Microsoft, DeepSeek и Google [1-4, 7, 8]. Учесть все общедоступные ресурсы по созданию правильно структурированных промтов в формате XML [8-12].</Step>
        <Step>3. **Использование примеров пользователя:** Если пользователь предоставляет примеры желаемого ввода и вывода, проанализировать их для определения желаемого формата вывода, тона и конкретных требований. Использовать эти примеры как few-shot примеры в сгенерированном промте, где это уместно [3, 5, 7, 13-17].</Step>
        <Step>4. **Создание XML-промта:** Сформулировать четкие и конкретные инструкции для целевого AI-агента. Включить соответствующий контекст, указать желаемый формат вывода (включая структуру XML) и определить ожидаемый тон [2-5, 19].</Step>
        <Step>5. **Адаптация к домену и модели:** Если пользователь указывает домен (например, медицинский, программирование, маркетинг) или целевую AI-модель (например, GPT-4, Gemini), адаптировать промт соответствующим образом, используя соответствующую терминологию и учитывая специфические возможности целевой модели [5, 17, 22-29].</Step>
        <Step>6. **Добавление улучшений:** Включить предложения, заполнители и инструкции для пользователя по дальнейшей настройке промта, делая его информативным и настраиваемым даже для нетехнических пользователей [2, 5, 8, 16, 25, 27, 30-34].</Step>
        <Step>7. **Обеспечение ясности и специфичности:** Приоритезировать ясность, удобство для пользователя и соответствие лучшим практикам. Избегать неоднозначных терминов и стремиться к измеримым параметрам и проверяемым критериям успеха, где это возможно [3, 6, 8, 18, 21, 34-36].</Step>
        <Step>8. **Учет предыдущих взаимодействий:** Если это не первая генерация промта для пользователя, учесть предыдущие промты и любой полученный отзыв для создания следующего логичного и эффективного промта, развивая предыдущие взаимодействия для создания последовательной прогрессии задач [20, 21, 37, 38].</Step>
        <Step>9. **Вывод XML:** Вывести финальный промт в полной XML-структуре [6]. Убедиться, что промт самодостаточен и легко понятен [20, 21].</Step>
      </Instructions>
      <OutputFormat>
        Финальный вывод ДОЛЖЕН быть правильно сформированной XML-структурой, содержащей промт, оптимизированный для указанной пользователем AI-задачи.
      </OutputFormat>
      <Considerations>
        - Сгенерированный промт должен быть достаточно специфичным, чтобы эффективно направлять AI-агента, но также позволять некоторую креативность и исследование [20, 21].
        - Учитывать, что пользователь может запрашивать промты для самых разных AI-агентов в различных областях (медицина, дом, технологии, маркетинг, бизнес, образование и т.д.) [17, 24, 25, 40].
        - Цель - глубоко понять потребности пользователя и создать промты, которые помогут ему достичь наилучших результатов с мощными AI-моделями [24, 40].
      </Considerations>
      <InputVariable>userPrompt</InputVariable>
      <OutputVariable>xmlPrompt</OutputVariable>
    </Node>

    <Node id="3" type="PromptFormatter">
      <Description>Форматирование XML-промта в строковый формат для OpenRouter.</Description>
      <AgentName>XMLFormatter</AgentName>
      <Goal>Преобразование XML-промта в текстовый формат, пригодный для отправки в API OpenRouter.</Goal>
      <Instructions>
        <Task>
          Получите XML-промт в формате XML и преобразуйте его в строковый формат, удалив все XML-теги и оставив только текстовое содержимое. Сохраните структуру и порядок информации, представленной в XML.
        </Task>
        <InputFormat>
          XML-документ, содержащий инструкции для AI-агента.
        </InputFormat>
        <OutputFormat>
          Строка, содержащая текст промта, извлеченный из XML-документа.
        </OutputFormat>
        <Example>
          <Input>
            <![CDATA[
              <Prompt>
                <AgentName>ExampleAgent</AgentName>
                <Goal>Описание цели агента.</Goal>
                <Instructions>
                  <Context>Контекст агента.</Context>
                  <Task>Задача агента.</Task>
                </Instructions>
              </Prompt>
            ]]>
          </Input>
          <Output>
            ExampleAgent
            Описание цели агента.
            Контекст агента.
            Задача агента.
          </Output>
        </Example>
      </Instructions>
      <InputVariable>xmlPrompt</InputVariable>
      <OutputVariable>formattedPrompt</OutputVariable>
    </Node>

    <Node id="4" type="ModelSelection">
      <Description>Предложение пользователю выбрать модель из списка бесплатных моделей OpenRouter.</Description>
      <AgentName>ModelSelector</AgentName>
      <Instructions>
        <Task>
          Предоставьте пользователю список бесплатных моделей, доступных через API OpenRouter. Предложите выбрать одну из моделей для тестирования промта.
        </Task>
        <InputFormat>
          Список моделей OpenRouter (должен быть предварительно загружен или получен из API).
        </InputFormat>
        <OutputFormat>
          Список моделей с возможностью выбора одной из них.  Сохраните ID выбранной модели.
        </OutputFormat>
        <FreeModels>
          - mistralai/Mistral-7B-Instruct-v0.1
          - google/gemma-7b-it
          - openchat/openchat_3.5
        </FreeModels>
      </Instructions>
      <OutputVariable>selectedModel</OutputVariable>
    </Node>

    <Node id="5" type="OpenRouterAPI">
      <Description>Отправка промта в API OpenRouter и получение ответа.</Description>
      <AgentName>OpenRouterIntegrator</AgentName>
      <Instructions>
        <Task>
          Отправьте отформатированный промт в API OpenRouter, используя выбранную пользователем модель. Получите ответ от API.
        </Task>
        <InputFormat>
          Строка промта, ID выбранной модели.
        </InputFormat>
        <OutputFormat>
          JSON-ответ от API OpenRouter.
        </OutputFormat>
        <APIEndpoint>
          https://openrouter.ai/api/v1/chat/completions
        </APIEndpoint>
        <Headers>
          Authorization: Bearer [YOUR_OPENROUTER_API_KEY]  (Замените на ваш API ключ OpenRouter)
          Content-Type: application/json
        </Headers>
        <Payload>
          {
            "model": "{{selectedModel}}",
            "messages": [{"role": "user", "content": "{{formattedPrompt}}"}],
            "max_tokens": 200  (Настраиваемый параметр)
          }
        </Payload>
      </Instructions>
      <InputVariable>formattedPrompt</InputVariable>
      <InputVariable>selectedModel</InputVariable>
      <OutputVariable>apiResponse</OutputVariable>
    </Node>

    <Node id="6" type="ResultDisplay">
      <Description>Отображение результата, полученного от API OpenRouter.</Description>
      <AgentName>ResultPresenter</AgentName>
      <Instructions>
        <Task>
          Отобразите ответ, полученный от API OpenRouter, пользователю.
        </Task>
        <InputFormat>
          JSON-ответ от API OpenRouter.
        </InputFormat>
        <OutputFormat>
          Текст ответа модели.  Отобразить сообщение об ошибке, если API вернул ошибку.
        </OutputFormat>
      </Instructions>
      <InputVariable>apiResponse</InputVariable>
    </Node>
  </Nodes>

  <Connections>
    <Connection from="1" to="2" />
    <Connection from="2" to="3" />
    <Connection from="3" to="4" />
    <Connection from="4" to="5" />
    <Connection from="5" to="6" />
  </Connections>
</Workflow>
```

**Описание узлов и логики цепочки:**

1.  **UserInput (Node id="1"):**
    *   Получает текстовый промт от пользователя.
    *   Сохраняет его в переменной `userPrompt`.

2.  **PromptGenerator (Node id="2"):**
    *   Использует `IdealPromptGenerator` для преобразования `userPrompt` в XML-формат.
    *   Промт `IdealPromptGenerator` – это тот, который изначально генерировал XML-промты.
    *   Сохраняет результат в переменной `xmlPrompt`.

3.  **PromptFormatter (Node id="3"):**
    *   Использует `XMLFormatter` для преобразования `xmlPrompt` (XML) в `formattedPrompt` (текст).  Этот узел *удаляет* XML-теги, оставляя только контент.  Это необходимо, потому что API OpenRouter принимает текст, а не XML.
    *   Промт `XMLFormatter`  включает пример, чтобы было ясно, как происходит преобразование.

4.  **ModelSelection (Node id="4"):**
    *   Предлагает пользователю список бесплатных моделей из API OpenRouter (указаны в `<FreeModels>`).
    *   Позволяет пользователю выбрать одну модель.
    *   Сохраняет ID выбранной модели в переменной `selectedModel`.

5.  **OpenRouterAPI (Node id="5"):**
    *   Отправляет  `formattedPrompt` и `selectedModel`  в API OpenRouter.
    *   Включает обязательные заголовки авторизации (`Authorization: Bearer [YOUR_OPENROUTER_API_KEY]`) и `Content-Type`.  **Внимание:**  Пользователь должен заменить `[YOUR_OPENROUTER_API_KEY]` своим фактическим API-ключом.
    *   Формирует JSON-полезную нагрузку, необходимую для API OpenRouter.  `max_tokens`  можно настроить.
    *   Сохраняет ответ API в переменной `apiResponse`.

6.  **ResultDisplay (Node id="6"):**
    *   Отображает `apiResponse` пользователю.  В идеале этот узел должен извлекать текст ответа из JSON (обычно находится в поле `choices[0].message.content`).  Если `apiResponse`  содержит код ошибки, он должен отобразить сообщение об ошибке.

**Соединения:**

Соединения определяют поток данных между узлами. Например, `Connection from="1" to="2"` означает, что вывод узла 1 (UserInput) является входом для узла 2 (PromptGenerator).

**Как это работает:**

1.  Пользователь вводит свой запрос в узле `UserInput`.
2.  `IdealPromptGenerator` преобразует запрос в XML-промт.
3.  `XMLFormatter` преобразует XML-промт в текст, удаляя XML-теги.
4.  `ModelSelection` предлагает пользователю список бесплатных моделей OpenRouter.
5.  `OpenRouterAPI` отправляет отформатированный промт и выбранную модель в API OpenRouter.
6.  `ResultDisplay` отображает ответ от API OpenRouter пользователю.

**Важные замечания:**

*   **API Key:**  Пользователю необходимо заменить `[YOUR_OPENROUTER_API_KEY]` в узле `OpenRouterAPI` своим фактическим ключом API OpenRouter.  Без этого API не будет работать.
*   **Обработка ошибок:** В  `ResultDisplay` следует добавить обработку ошибок, чтобы корректно отображать сообщения об ошибках, возвращаемые API OpenRouter.
*   **Извлечение контента из JSON:**  `ResultDisplay`  должен быть настроен для извлечения фактического текстового ответа из JSON, возвращаемого OpenRouter.
*   **Список моделей:** Список бесплатных моделей в `ModelSelection` должен быть актуальным.  OpenRouter может изменить доступность моделей.

Эта структура предоставляет пользователю сквозной рабочий процесс для создания, форматирования и тестирования промтов с использованием API OpenRouter.
