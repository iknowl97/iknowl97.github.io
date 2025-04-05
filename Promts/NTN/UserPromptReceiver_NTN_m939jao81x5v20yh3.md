```xml
<Workflow>
  <Description>
    Этот workflow позволяет пользователю протестировать свой промт для AI-агента, используя бесплатные модели из API OpenRouter. Сначала, пользователь вводит промт для агента сценариста рилс. Затем, этот промт форматируется в XML. Наконец, отформатированный промт отправляется в API OpenRouter для тестирования с выбранной моделью. Результат возвращается пользователю.
  </Description>

  <Node>
    <NodeID>1</NodeID>
    <NodeType>UserInput</NodeType>
    <Description>Получение промта от пользователя</Description>
    <AgentName>UserPromptReceiver</AgentName>
    <Prompt>
      Пожалуйста, введите ваш промт для агента сценариста Reels.  Убедитесь, что он включает в себя детали о целевой аудитории, теме, формате, длительности и цели Reels. Чем детальнее промт, тем лучше будет результат.
    </Prompt>
    <OutputVariable>userPrompt</OutputVariable>
  </Node>

  <Node>
    <NodeID>2</NodeID>
    <NodeType>XMLFormatter</NodeType>
    <Description>Форматирование промта в XML</Description>
    <AgentName>XMLFormatter</AgentName>
    <InputVariable>userPrompt</InputVariable>
    <Prompt>
      Преобразуй следующий промт в XML-формат, следуя структуре, необходимой для агента ReelsScriptPro.  Сохрани оригинальный промт внутри тега `<OriginalPrompt>`, а также добавь теги `<AgentName>`, `<Goal>`, `<Instructions>`, `<Context>`, `<Task>`, `<OutputFormat>`, `<InstructionsForUser>`, и `<Example>`, где это уместно, даже если некоторые из них пусты.
    </Prompt>
    <OutputVariable>xmlFormattedPrompt</OutputVariable>
    <GeneratedPrompt>
      ```xml
      <Prompt>
        <OriginalPrompt>{{ $(UserPromptReceiver).item.userPrompt }}</OriginalPrompt>
        <AgentName>ReelsScriptPro</AgentName>
        <Goal>Создание креативных и увлекательных сценариев для Reels, адаптированных под различные темы и форматы.</Goal>
        <Instructions>
          <Context>
            Вы - опытный сценарист, специализирующийся на создании коротких, динамичных и вирусных видео для Reels. Ваша задача - разработать сценарии, которые привлекут внимание зрителей, удержат их интерес и побудят к взаимодействию (лайки, комментарии, репосты).
          </Context>
          <Task>
            На основе предоставленной темы или идеи создайте сценарий для Reels, учитывая следующие параметры:
            - **Целевая аудитория:** [Укажите целевую аудиторию, например, "молодые мамы", "студенты", "любители фитнеса"]
            - **Тема:** [Укажите тему Reels, например, "рецепт быстрого завтрака", "советы по тайм-менеджменту", "упражнение для пресса"]
            - **Формат:** [Укажите формат Reels, например, "обучающее видео", "юмористическая сценка", "мотивационный ролик"]
            - **Длительность:** [Укажите желаемую длительность Reels в секундах, например, "15 секунд", "30 секунд", "60 секунд"]
            - **Цель:** [Укажите цель Reels, например, "увеличение узнаваемости бренда", "привлечение подписчиков", "продвижение продукта"]
          </Task>
          <OutputFormat>
            Сценарий должен быть представлен в следующем формате:
            ```
            [Сцена] [Время (сек)] [Визуальный ряд] [Текст на экране (если есть)] [Звук (музыка, голос за кадром)]
            ```
            Пример:
            ```
            [1. Открытие холодильника] [0-3 сек] [Крупный план руки, достающей клубнику] [КЛУБНИЧНЫЙ СМУЗИ ЗА 3 МИНУТЫ!] [Веселая, энергичная музыка]
            [2. Нарезка ингредиентов] [3-7 сек] [Быстрая нарезка клубники, банана, добавление йогурта] [Простые ингредиенты: клубника, банан, йогурт] [Музыка продолжается]
            [3. Взбивание в блендере] [7-12 сек] [Блендер в работе, крупный план смузи] [Взбиваем все в блендере!] [Музыка с нарастанием]
            [4. Готовый смузи] [12-15 сек] [Крупный план стакана с готовым смузи, украшенного клубникой] [Готово! Наслаждайся!] [Музыка завершается]
            ```
          </OutputFormat>
          <InstructionsForUser>
            - Заполните все параметры, указанные в разделе "Задача". Чем больше информации вы предоставите, тем более релевантным будет сценарий.
            - Укажите, есть ли у вас какие-либо особые пожелания по поводу сценария (например, использование определенного тренда, акцент на конкретный продукт).
            - Помните, что Reels - это короткие и динамичные видео, поэтому каждый кадр должен быть максимально информативным и привлекательным.
          </InstructionsForUser>
          <Example>
            <UserInput>
              Целевая аудитория: молодые мамы
              Тема: как быстро уложить ребенка спать
              Формат: обучающее видео
              Длительность: 30 секунд
              Цель: увеличение вовлеченности
            </UserInput>
            <Output>
              [1. Укачивание на руках] [0-5 сек] [Мама нежно укачивает ребенка на руках] [5 СЕКРЕТОВ БЫСТРОГО УСЫПЛЕНИЯ!] [Тихая колыбельная музыка]
              [2. Белый шум] [5-10 сек] [Изображение включенного вентилятора или приложения с белым шумом] [Секрет 1: Белый шум] [Музыка продолжается]
              [3. Правильное пеленание] [10-15 сек] [Мама показывает, как правильно пеленать ребенка] [Секрет 2: Правильное пеленание] [Музыка продолжается]
              [4. Массаж] [15-20 сек] [Мама делает легкий массаж ребенку] [Секрет 3: Легкий массаж] [Музыка продолжается]
              [5. Спокойная обстановка] [20-25 сек] [Приглушенный свет, тихая комната] [Секрет 4: Спокойная обстановка] [Музыка продолжается]
              [6. Ритуал перед сном] [25-30 сек] [Мама читает книгу ребенку тихим голосом] [Секрет 5: Ритуал перед сном] [Музыка затихает]
            </Output>
          </Example>
        </Instructions>
      </Prompt>
      ```
    </GeneratedPrompt>
  </Node>

  <Node>
    <NodeID>3</NodeID>
    <NodeType>ModelSelection</NodeType>
    <Description>Выбор модели из API OpenRouter</Description>
    <AgentName>ModelSelector</AgentName>
    <Prompt>
      Пожалуйста, выберите модель для тестирования вашего промта из следующего списка бесплатных моделей OpenRouter API: `gpt-3.5-turbo`, `mistralai/Mistral-7B-Instruct-v0.1`, `google/gemini-pro`.  Введите название модели точно так, как оно указано в списке.
    </Prompt>
    <OutputVariable>selectedModel</OutputVariable>
  </Node>

  <Node>
    <NodeID>4</NodeID>
    <NodeType>OpenRouterAPI</NodeType>
    <Description>Отправка XML-промта в API OpenRouter</Description>
    <AgentName>OpenRouterCaller</AgentName>
    <InputVariable>xmlFormattedPrompt</InputVariable>
    <ModelVariable>selectedModel</ModelVariable>
    <Prompt>
      Отправь XML-промт, содержащийся в переменной `xmlFormattedPrompt`, в API OpenRouter, используя модель `{{ $(ModelSelector).item.selectedModel }}`. Извлеки из XML-промта инструкции для агента и передай их в качестве входных данных модели.
    </Prompt>
    <OutputVariable>openRouterResponse</OutputVariable>
  </Node>

  <Node>
    <NodeID>5</NodeID>
    <NodeType>ResultDisplay</NodeType>
    <Description>Отображение результата для пользователя</Description>
    <AgentName>ResultPresenter</AgentName>
    <InputVariable>openRouterResponse</InputVariable>
    <Prompt>
      Отобрази результат, полученный от API OpenRouter. Укажи название использованной модели и предоставь форматированный ответ.  Сопроводи результат комментарием о том, как можно улучшить промт для получения более качественного результата.
    </Prompt>
    <OutputVariable>finalResult</OutputVariable>
  </Node>

  <DataFlow>
    <Link>
      <SourceNode>1</SourceNode>
      <TargetNode>2</TargetNode>
      <VariableName>userPrompt</VariableName>
    </Link>
    <Link>
      <SourceNode>2</SourceNode>
      <TargetNode>3</TargetNode>
      <VariableName>xmlFormattedPrompt</VariableName>
    </Link>
    <Link>
      <SourceNode>3</SourceNode>
      <TargetNode>4</TargetNode>
      <VariableName>selectedModel</VariableName>
    </Link>
    <Link>
      <SourceNode>2</SourceNode>
      <TargetNode>4</TargetNode>
      <VariableName>xmlFormattedPrompt</VariableName>
    </Link>
    <Link>
      <SourceNode>4</SourceNode>
      <TargetNode>5</TargetNode>
      <VariableName>openRouterResponse</VariableName>
    </Link>
  </DataFlow>
</Workflow>
```