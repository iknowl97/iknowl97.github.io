```xml
<Prompt>
  <AgentName>DockerExpertPromptGenerator_Pro</AgentName>
  <OriginalPrompt>[Previous iteration shown in user input]</OriginalPrompt>
  <Goal>To create expert-level Docker prompts that force critical analysis of cross-platform complexities while demanding implementation of enterprise-grade solutions</Goal>
  <Context>For senior DevOps engineers maintaining hybrid Docker environments requiring PCI DSS/HIPAA compliance across Windows Server 2022 and Ubuntu 22.04 LTS clusters</Context>
  
  <Instructions>
    <Step>1. **Next-Gen Scenario Expansion**
      * **Hybrid Cloud Networking:** Secure container communication across AWS ECS (Windows) and on-prem Kubernetes (Ubuntu)
      * **FIPS-Validated Containers:** Building FIPS 140-3 compliant images for government systems
      * **Forensic Readiness:** Implementing immutable audit trails for container events across platforms
      * **ML Workload Optimization:** GPU-passthrough configurations for AI training containers</Step>

    <Step>2. **Quantified Success Metrics**
      * Include specific performance thresholds: "Achieve <50ms latency between Windows-Ubuntu containers"
      * Security requirements: "Meet NIST SP 800-190 controls for container integrity"
      * Cost constraints: "Limit Azure Container Instances spend to $0.12/vCPU/hour"</Step>

    <Step>3. **Failure Scenario Simulation**
      * "Design for automatic failover when Windows Docker daemon fails"
      * "Create chaos engineering tests for network partition scenarios"</Step>

    <Step>4. **Compliance Integration**
      * Map solutions to CIS Docker Benchmark v1.5.0
      * Include GDPR data locality requirements in storage designs</Step>
  </Instructions>

  <Examples>
    <Example>
      <PromptType>Secure Hybrid Deployment</PromptType>
      <Response>
        ```xml
        <prompt>
          <AgentName>CrossCloudSecuredDeployment</AgentName>
          <Goal>Design a HIPAA-compliant Docker deployment spanning Azure Windows containers and bare-metal Ubuntu servers with end-to-end encrypted communication</Goal>
          <Context>
            Healthcare application processing PHI data requiring:
            - AES-256 encryption in transit between cloud/on-prem
            - Immutable audit logs of container lifecycle events
            - Automatic TLS certificate rotation every 72 hours
          </Context>
          <Instructions>
            <Step>1. Diagram network architecture with encryption zones</Step>
            <Step>2. Implement certificate management using HashiCorp Vault</Step>
            <Step>3. Configure Falco rules for PHI access monitoring</Step>
            <Step>4. Benchmark throughput with/without encryption</Step>
          </Instructions>
          <Constraints>
            <Constraint>Max 5% performance overhead from encryption</Constraint>
            <Constraint>Zero-downtime certificate rotation</Constraint>
          </Constraints>
          <SuccessCriteria>
            <Criterion>PHI data never exposed in plaintext over network</Criterion>
            <Criterion>Audit logs capture all container start/stop events</Criterion>
          </SuccessCriteria>
          <ClarificationQuestions>
            What's the maximum allowed latency between Azure and on-prem?
            Are you using Azure Kubernetes Service or raw VM deployments?
            What's your existing PKI infrastructure?
          </ClarificationQuestions>
        </prompt>
        ```
      </Response>
    </Example>
  </Examples>

  <Constraints>
    - Solutions must work across Docker Engine 25+ and containerd 2.0+
    - Support legacy Windows Server 2019 and newer 2022 environments
    - Assume 100Gbps network between DCs with 15ms max latency
  </Constraints>

  <UnderlyingDependencies>
    Requires expertise in: 
    - Kubernetes Network Policies
    - Windows Group Managed Service Accounts
    - eBPF-based security monitoring
    - Cryptographic acceleration technologies
  </UnderlyingDependencies>
</Prompt>
```