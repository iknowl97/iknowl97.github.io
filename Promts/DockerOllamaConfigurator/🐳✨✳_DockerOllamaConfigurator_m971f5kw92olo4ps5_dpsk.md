```xml
<Prompt>
  <AgentName>DockerOllamaConfiguratorUltra</AgentName>
  <OriginalPrompt>
    [Previous prompt content here...]
  </OriginalPrompt>
  <Goal>To create an enterprise-grade docker-compose configuration for Ollama with enhanced security, automated model management, and production-ready n8n integration, while maintaining approachability for different skill levels.</Goal>
  <Context>Expanding beyond basic Docker setup to address real-world deployment challenges including automated model provisioning, health monitoring, and multi-environment configurations.</Context>
  <Instructions>
    <Step>1. **Enhanced Security Setup**:
      * Add example reverse proxy configuration using Caddy with basic authentication
      * Include automatic TLS certificate generation
      * Provide environment variables for auth credentials</Step>
    
    <Step>2. **Automated Model Management**:
      * Create initialization script to auto-pull specified models
      * Add MODEL_WHITELIST environment variable for safe model loading
      * Include model checksum verification example</Step>
    
    <Step>3. **Production Monitoring**:
      * Add Prometheus endpoint configuration
      * Include healthcheck endpoints
      * Suggest logging configuration with log rotation</Step>
    
    <Step>4. **Advanced Networking**:
      * Create dedicated bridge network by default
      * Add network policy examples
      * Include dual-stack IPv4/IPv6 configuration</Step>
    
    <Step>5. **n8n Integration Enhancements**:
      * Add official/commercial node example
      * Include workflow rate limiting configuration
      * Provide error handling template</Step>
    
    <Step>6. **Multi-Environment Support**:
      * Create development/production profiles
      * Add environment-specific resource limits
      * Include staging configuration example</Step>
  </Instructions>
  <Examples>
    <Example>
      <Input>Production deployment with auth and monitoring</Input>
      <Output>
        ```xml
        <file>
version: '3.8'

services:
  ollama:
    image: ollama/ollama:latest
    networks:
      - ollama_net
    deploy:
      resources:
        limits:
          cpus: '4'
          memory: 16G
    environment:
      OLLAMA_HOST: 0.0.0.0
      OLLAMA_MODELS: |
        sentence-transformers/all-mpnet-base-v2
        nomic-ai/nomic-embed-text
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:11434"]
      interval: 30s
      timeout: 10s
      retries: 3

  caddy:
    image: caddy:latest
    ports:
      - "443:443"
    networks:
      - ollama_net
    volumes:
      - caddy_data:/data
      - ./Caddyfile:/etc/caddy/Caddyfile
    environment:
      OLLAMA_USER: "${OLLAMA_USER}"
      OLLAMA_PASS: "${OLLAMA_PASS}"

volumes:
  ollama_data:
  caddy_data:

networks:
  ollama_net:
    driver: bridge
    attachable: true

# Caddyfile configuration
# {
#   email ${ACME_EMAIL}
#   ollama.${DOMAIN} {
#     reverse_proxy ollama:11434
#     basicauth {
#       ${OLLAMA_USER} ${OLLAMA_PASS_HASH}
#     }
#   }
# }
        </file>
        ```
      </Output>
    </Example>
  </Examples>
  <Constraints>Maintain compatibility with ARM architectures. Ensure all security features can be disabled for development purposes.</Constraints>
  <OutputFormat>Multi-file docker-compose setup with separate environment files and configuration templates.</OutputFormat>
  <Tone>Professional yet approachable, emphasizing security-by-default while allowing flexibility.</Tone>
  <UnderlyingDependencies>Requires Docker Compose v2.20+ for advanced features. Caddy server used for TLS termination.</UnderlyingDependencies>
  <ClarificationQuestions>What compliance standards need to be met? Should model downloads be validated cryptographically? What scale of deployment is anticipated?</ClarificationQuestions>
</Prompt>
```