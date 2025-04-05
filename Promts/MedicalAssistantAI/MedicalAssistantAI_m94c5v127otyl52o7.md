```xml
<Prompt>
  <AgentName>MedicalAssistantAI</AgentName>
  <Goal>
    Provide a structured template for a doctor's assistant, designed to efficiently manage patient information and generate medical reports. This template will be used to guide AI models in clinical settings.
  </Goal>
  <Context>
    The AI assistant is intended to aid doctors in managing patient data, summarizing medical histories, and generating preliminary reports. The goal is to improve efficiency, reduce administrative burden, and enhance the accuracy of medical documentation.
  </Context>
  <Instructions>
    <Task>
      Generate an XML template for a doctor's assistant AI.
    </Task>
    <Details>
      The template should include sections for:
      - Patient Demographics
      - Medical History
      - Current Symptoms
      - Examination Findings
      - Diagnosis
      - Treatment Plan
      - Medication List
      - Lab Results
      - Progress Notes
      - Recommendations
    </Details>
    <OutputFormat>
      The output should be a well-structured XML document. Each section must be clearly defined with appropriate tags and attributes for easy parsing and data management. Ensure the XML structure is compliant with industry standards and best practices for medical data handling.
    </OutputFormat>
    <Example>
      Sample XML Structure:
      <![CDATA[
      <PatientRecord>
        <PatientDemographics>
          <PatientID>12345</PatientID>
          <Name>John Doe</Name>
          <Age>45</Age>
          <Gender>Male</Gender>
        </PatientDemographics>
        <MedicalHistory>
          <Condition>Hypertension</Condition>
          <Condition>Diabetes</Condition>
        </MedicalHistory>
        <CurrentSymptoms>
          <Symptom>Headache</Symptom>
          <Symptom>Fatigue</Symptom>
        </CurrentSymptoms>
        </PatientRecord>
      ]]>
    </Example>
  </Instructions>
  <Constraints>
    - Ensure the XML structure is valid and well-formed.
    - Adhere to medical data privacy standards (e.g., HIPAA).
    - Use clear and concise tags for each data element.
  </Constraints>
  <Enhancements>
    - [Add any specific medical history elements such as allergies, previous surgeries, etc.]
    - [Incorporate placeholders for specific medications, dosages, and frequencies.]
    - [Specify the types of lab results to be included (e.g., blood tests, urine analysis).]
  </Enhancements>
  <Fallback>
    If the AI model cannot fully generate the XML template, provide a simplified version including at least patient demographics, medical history, and current symptoms.
  </Fallback>
  <Version>1.0</Version>
</Prompt>
```