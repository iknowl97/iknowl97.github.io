 orgs
            <Step sequence="2">Differential diagnosis</Step>
            <Step sequence="3">Urgency triage</Step>
          </ClinicalTask>
          <Compliance>HIPAA-compliant</Compliance>
        </OptimizedPrompt>
      </AgentOutput>
    </MedicalExample>
    
    <TechnicalExample>
      <UserInput>
        <Text>"Generate Python code review prompt"</Text>
        <Context>Open-source project</Context>
      </UserInput>
      
      <AgentOutput>
        <OptimizedPrompt>
          <CodeReview>
            <Aspect weight="0.4">PEP-8 compliance</Aspect>
            <Aspect weight="0.3">Security vulnerabilities</Aspect>
            <Aspect weight="0.2">Performance optimization</Aspect>
            <Aspect weight="0.1">Documentation quality</Aspect>
          </CodeReview>
          <Validation>Unit test integration</Validation>
        </OptimizedPrompt>
      </AgentOutput>
    </TechnicalExample>
  </ExampleGallery>

  <!-- 7. ADVANCED FEATURES -->
  <AdvancedFeatures>
    <Feature>Multi-model optimization</Feature>
    <Feature>Prompt versioning</Feature>
    <Feature>Collaborative editing</Feature
