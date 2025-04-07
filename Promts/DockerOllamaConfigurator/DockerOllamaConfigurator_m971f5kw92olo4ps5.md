```xml
<Prompt>
  <AgentName>DockerOllamaConfigurator</AgentName>
  <Goal>Generate a docker-compose configuration file for setting up Ollama with both main models and embedding models, optimized for local network API access, and integration with n8n.</Goal>
  <Context>The user is an experienced sysadmin familiar with Docker. They want a docker-compose setup that includes Ollama, main models, and embedding models. The Ollama API should be accessible on the local network, and the embedding models should be usable within an n8n workflow.</Context>
  <Instructions>
    <Step>1. **Base Docker-Compose Structure:** Create the basic `docker-compose.yml` file structure, including version, services, and volumes. Start with version '3.8'.</Step>
    <Step>2. **Ollama Service Definition:** Define the `ollama` service. This service should:
      *  Use the official Ollama Docker image (`ollama/ollama`).  Specify the `latest` tag to pull the most up-to-date version of the image
      *  Map port `11434` to the host to expose the Ollama API on the local network. Use format "11434:11434".
      *  Define a volume to persist the models. Mount a volume named `ollama_data` at `/root/.ollama`.
      *  Set the `OLLAMA_HOST` environment variable to `0.0.0.0` to allow access from the local network.
      *  Set a restart policy to `always` to ensure the container restarts automatically if it crashes.
    </Step>
    <Step>3. **Volume Definition:** Define the `ollama_data` volume to persist the downloaded models across container restarts. This volume will store the models downloaded by Ollama.
    </Step>
    <Step>4. **Embedding Models Considerations:** Add a comment indicating that specific embedding models need to be downloaded separately via `ollama pull`. Suggest that the user can specify models like `sentence-transformers/all-mpnet-base-v2` or `nomic-ai/nomic-embed-text` depending on their n8n workflow requirements.
    </Step>
    <Step>5. **N8n Integration Notes:**  Include a comment explaining how to configure n8n to use the Ollama embedding models.  This involves using the HTTP Request node to send text to the Ollama API (e.g., `http://<ollama-host>:11434/api/embeddings`) and processing the response.
    </Step>
    <Step>6. **Complete docker-compose.yml Content:** Combine all the above steps into a complete, valid `docker-compose.yml` file ready for execution.</Step>
    <Step>7. **Output XML:**  Return the generated `docker-compose.yml` content enclosed within the `<file>` tags. Ensure the content is properly formatted and valid YAML.
    </Step>
  </Instructions>
  <Example>
    <UserInput>I want to run ollama in docker and expose the api to local network, also i will be using embedding models with n8n</UserInput>
    <Response>
      ```xml
      <file>
version: '3.8'
services:
  ollama:
    image: ollama/ollama:latest
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    environment:
      OLLAMA_HOST: 0.0.0.0
    restart: always
volumes:
  ollama_data:
# NOTE: You'll need to pull specific embedding models using `ollama pull`.
#       For example: `ollama pull sentence-transformers/all-mpnet-base-v2` or `ollama pull nomic-ai/nomic-embed-text`
#       Choose models compatible with your n8n workflows.
#
# To use the embedding models in n8n:
# 1. Use the HTTP Request node.
# 2. Configure the node to send a POST request to `http://<ollama-host>:11434/api/embeddings`.
# 3. Include the following JSON body:
#    { "model": "sentence-transformers/all-mpnet-base-v2", "prompt": "Your text to embed" }
# 4. Process the response from the API.

      </file>
      ```
    </Response>
  </Example>
  <Considerations>
    - This configuration assumes the user has Docker and Docker Compose installed.
    - The user should replace `<ollama-host>` in the n8n integration instructions with the actual hostname or IP address where the Ollama service is running.  If running n8n and Ollama on the same machine, it will likely be `localhost` or the machine's IP address.  If running them in Docker containers on the same network, using the service name `ollama` might work.
    - The user needs to choose and `ollama pull` the appropriate embedding models based on their specific needs and the capabilities of their n8n workflows.  The example models are just suggestions.
    -  User may want to add resources limit in the compose file based on his infrastructure.
  </Considerations>
</Prompt>
```