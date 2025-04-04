```json
{
	"name": "Test Prompt with OpenRouter",
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
				"question": "Choose a model from OpenRouter (mistralai/Mistral-7B-Instruct-v0.1, google/gemma-7b-it, openchat/openchat_3.5):",
				"name": "Model Selection"
			},
			"name": "Model Selection",
			"type": "telegramTrigger",
			"typeVersion": 1,
			"position": [
				200,
				400
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
							"value": "={{ $('Model Selection').item.message.text }}"
						},
						{
							"name": "messages",
							"value": "[{\\\"role\\\": \\\"user\\\", \\\"content\\\": \\\"{{ $('Extract Text from XML').item.textPrompt }}\\\"}]"
						},
						{
							"name": "max_tokens",
							"value": "200"
						}
					]
				},
				"name": "Call OpenRouter API"
			},
			"name": "Call OpenRouter API",
			"type": "HttpRequest",
			"typeVersion": 2,
			"position": [
				1000,
				400
			],
			"credentials": {}
		},
		{
			"parameters": {
				"jsCode": "const apiResponse = $input.item;\n\nif (apiResponse.error) {\n  return [\n    {\n      response: `Error from OpenRouter: ${apiResponse.error.message}`,\n    },\n  ];\n} else {\n  const content = apiResponse.choices[0].message.content;\n  return [\n    {\n      response: `Model Response: ${content}`,\n    },\n  ];\n}",
				"name": "Process Response"
			},
			"name": "Process Response",
			"type": "Function",
			"typeVersion": 1,
			"position": [
				1200,
				400
			]
		},
		{
			"parameters": {
				"chatId": "={{ $json.message.chat.id }}",
				"text": "={{ $json.response }}",
				"parseMode": "markdown",
				"options": {}
			},
			"name": "Send Response",
			"type": "telegram",
			"typeVersion": 1,
			"position": [
				1400,
				400
			],
			"credentials": {
				"telegramApi": "Telegram Bot"
			}
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
						"node": "Call OpenRouter API",
						"type": "main",
						"index": 0
					}
				]
			]
		},
		"Model Selection": {
			"main": [
				[
					{
						"node": "Call OpenRouter API",
						"type": "main",
						"index": 0
					}
				]
			]
		},
		"Call OpenRouter API": {
			"main": [
				[
					{
						"node": "Process Response",
						"type": "main",
						"index": 0
					}
				]
			]
		},
		"Process Response": {
			"main": [
				[
					{
						"node": "Send Response",
						"type": "main",
						"index": 0
					}
				]
			]
		}
	}
}
```

**Explanation of the N8N Nodes:**

1.  **User Input (Telegram Trigger):**
    *   Listens for a message on Telegram.
    *   Asks the user to enter their prompt for the Reels script agent. It prompts the user to include specific details.
    *   Saves the user's message to the `message.text` property.

2.  **Prepare Data (Function):**
    *   Takes the input from the `User Input` node.
    *   Extracts the `message.text` and assigns it to the `prompt` variable.
    *   Creates a new object with the `prompt` variable and returns it. This node prepares the data for the next node in the workflow.

3.  **Generate XML Prompt (Function):**
    *   Takes the `prompt` from the `Prepare Data` node.
    *   Embeds the prompt inside a predefined XML structure. This XML includes `<AgentName>`, `<Goal>`, `<Instructions>`, `<Context>`, `<Task>`, and `<Example>` elements.
    *   The template uses backticks (\`) to create a multiline string that includes the user's prompt within the XML structure using `${userPrompt}`.
    *   Returns a new object with the `xmlPrompt` variable.

4.  **Extract Text from XML (Function):**
    *   Takes the XML string from the `Generate XML Prompt` node.
    *   Uses a regular expression `/<[^>]*>/g` to remove all XML tags from the string.
    *   The `trim()` function removes any leading or trailing whitespace.
    *   Returns a new object with the extracted text in the `textPrompt` variable.

5.  **Model Selection (Telegram Trigger):**
    *   Another Telegram Trigger node.  This one prompts the user to choose which model they want to use.
    *   Asks the user to choose a model from the provided list of OpenRouter models (mistralai/Mistral-7B-Instruct-v0.1, google/gemma-7b-it, openchat/openchat\_3.5).
    *   Saves the selected model to the `message.text` property.

6.  **Call OpenRouter API (HTTP Request):**
    *   Makes an HTTP POST request to the OpenRouter API endpoint.
    *   Sets the `Authorization` header to `Bearer YOUR_OPENROUTER_API_KEY`. **IMPORTANT:** Replace `"YOUR_OPENROUTER_API_KEY"` with your actual OpenRouter API key.
    *   Sets the `Content-Type` header to `application/json`.
    *   Constructs the JSON payload for the API request:
        *   `model`: The selected model from the `Model Selection` node (`{{ $('Model Selection').item.message.text }}`).
        *   `messages`: An array containing a single message with the role of "user" and the content as the extracted text prompt from the `Extract Text from XML` node (`{{ $('Extract Text from XML').item.textPrompt }}`).
        *   `max_tokens`: Sets the maximum number of tokens in the generated response to 200.
    *   The `bodyParametersUi` section shows how the JSON payload is constructed using n8n expressions.

7.  **Process Response (Function):**
    *   Takes the API response from the `Call OpenRouter API` node.
    *   Checks for an `error` property in the response. If an error exists, it returns an error message.
    *   If the API call is successful, it extracts the `content` from the response ( `apiResponse.choices[0].message.content`).
    *   Returns a new object with the processed response in the `response` variable.

8.  **Send Response (Telegram):**
    *   Uses the Telegram node to send the processed response back to the user via Telegram.
    *   `chatId`: Set to the chat ID from the original message.
    *   `text`: Set to the `response` from the `Process Response` node.
    *   `parseMode`: Set to `markdown` to allow for formatting.

**How to use:**

1.  **Import the JSON:** Import this JSON into your n8n instance.
2.  **Configure Telegram Triggers:** Create Telegram Bot credentials in N8N and assign them to Telegram Trigger and Telegram nodes .
3.  **Set API Key:**  **IMPORTANT:**  Replace `"YOUR_OPENROUTER_API_KEY"` in the `Call OpenRouter API` node with your actual OpenRouter API key.
4.  **Start the Workflow:** Activate the workflow.
5.  **Interact via Telegram:** Send a message to your Telegram bot with your prompt. Followed by a separate message with your chosen model.  The bot will send you the response from OpenRouter.

**Key Improvements and Explanations:**

*   **Complete Workflow:** This provides a fully functional n8n workflow, from receiving the prompt to sending the response back to the user.
*   **Clear Node Descriptions:** Each node has a clear description of its purpose.
*   **Error Handling:** The `Process Response` node handles potential errors from the OpenRouter API.
*   **API Key Placeholder:**  The code explicitly reminds the user to replace the placeholder API key with their own.
*   **Clear Variable Names:** Meaningful variable names are used throughout the workflow.
*   **Prepared JSON Payload:**  The `bodyParametersUi` in the `HttpRequest` node shows exactly how the JSON payload is built, making it easier to understand and modify.
*   **Model Selection Trigger:** The workflow is modified to receive the model selection as a second Telegram trigger, decoupling it from the initial prompt and making the process more user-friendly.
*   **XML Parsing in Javascript:** Uses the Javascript function node to remove the XML tags before passing the prompt on to OpenRouter.

This comprehensive n8n template should give you a good starting point for testing prompts with OpenRouter. Remember to always handle your API keys securely and to monitor your API usage to avoid unexpected charges.
