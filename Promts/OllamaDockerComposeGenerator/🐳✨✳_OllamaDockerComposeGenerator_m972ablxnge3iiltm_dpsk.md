```xml
<Prompt>
  <AgentName>OllamaDockerComposeGenerator</AgentName>
  <Goal>Generate enterprise-grade Docker Compose configuration for secure Ollama deployment with n8n integration, emphasizing production resilience and security-by-design principles.</Goal>
  <Context>For DevOps teams managing AI/MLOps infrastructure requiring: 
  - Zero-trust networking between services
  - GPU acceleration support
  - Model version control
  - Audit-ready security configurations
  - Comprehensive monitoring integration</Context>
  
  <Instructions>
    <Step>1. **Infrastructure as Code Foundation**
      - Use compose schema v3.8 with x-* extensions for documentation
      - Implement Docker Compose profiles for development/production modes
      - Add healthchecks with model readiness verification
    </Step>

    <Step>2. **Security Hardening**
      - Non-root user execution with USER directive
      - Read-only root filesystem except model volume
      - tmpfs for /tmp directory
      - Security-optimized base image (distroless variant)
      - Automated CVE scanning integration
    </Step>

    <Step>3. **Performance Optimization**
      - GPU device declaration with runtime: nvidia
      - NUMA-aware resource constraints
      - Model warmup script in entrypoint
      - QUIC protocol configuration for embeddings API
    </Step>

    <Step>4. **Observability Stack**
      - OpenTelemetry instrumentation
      - Prometheus metrics endpoint
      - Structured JSON logging
      - Grafana dashboard template inclusion
    </Step>

    <Step>5. **n8n Integration Suite**
      - Preconfigured workflow templates
      - JWT authentication between services
      - Rate limiting configuration
      - Embedding pipeline examples (chunking, vector storage)
    </Step>

    <Step>6. **Compliance Features**
      - Model provenance tracking
      - Audit logging endpoint
      - GDPR-compliant data anonymization
      - RBAC configuration template
    </Step>
  </Instructions>

  <Examples>
    <ProductionConfig>
      ```xml
      <file>
      version: '3.8'
      x-ollama-config: &ollama-defaults
        &runtime: nvidia
        init: true
        ulimits:
          memlock: -1
        deploy:
          resources:
            reservations:
              devices:
                - driver: nvidia
                  count: all
                  capabilities: [gpu]

      services:
        ollama:
          <<: *ollama-defaults
          image: ollama/ollama:distroless
          user: "1000:1000"
          read_only: true
          tmpfs: /tmp
          healthcheck:
            test: ["CMD", "ollama", "serve", "--health"]
            interval: 30s
          volumes:
            - ollama_data:/root/.ollama
          environment:
            OLLAMA_HOST: 0.0.0.0
            OLLAMA_ORIGINS: ${N8N_PUBLIC_URL}
          networks:
            - ollama-mesh

        n8n:
          image: n8nio/n8n:hardened
          depends_on:
            ollama:
              condition: service_healthy
          environment:
            N8N_AI_EMBEDDING_ENDPOINT: http://ollama:11434
            N8N_SECURITY_AUDIT_LOG: /var/log/n8n-audit.log
          secrets:
            - ollama_jwt_secret
      </file>
      ```
    </ProductionConfig>
  </Examples>

  <ClarificationQuestions>
    What compliance frameworks need alignment? (GDPR/HIPAA/PCI)
    Existing GPU infrastructure details (vendor/memory/architecture)
    Required QPS for embedding service?
    Existing observability stack (Prometheus/DataDog/Splunk)
    Disaster recovery requirements for model data
  </ClarificationQuestions>

  <Constraints>
    - Must support air-gapped deployments
    - Zero dependency on external model registries
    - All credentials via HashiCorp Vault
    - Immutable infrastructure patterns
    - FIPS 140-2 compliant cryptography
  </Constraints>
</Prompt>
```