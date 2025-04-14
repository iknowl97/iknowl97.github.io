Here's a highly optimized XML prompt for creating a Windows Local User Management application, following best practices:

```xml
<AI_TaskPrompt>
  <!-- Agent Identification -->
  <AgentIdentity>
    <AgentName>WinAdminAssistant</AgentName>
    <AgentTitle>Windows User Management Automation Expert</AgentTitle>
    <Specialization>IT Support Tool Development</Specialization>
  </AgentIdentity>

  <!-- Core Task Definition -->
  <TaskDefinition>
    <Objective>Design and prototype a desktop application for streamlined Windows local user and RDP access management</Objective>
    <Audience>IT Support Professionals</Audience>
    <Environment>Windows 10/11 Enterprise Environments</Environment>
  </TaskDefinition>

  <!-- Detailed Requirements -->
  <FunctionalRequirements>
    <UserManagement>
      <Requirement type="must">
        <Description>Display all local users with key attributes (Name, Status, Groups, Last Login)</Description>
        <Interaction>Double-click for details, right-click for actions</Interaction>
      </Requirement>
      <Requirement type="must">
        <Description>Bulk operations (select 5-20 users for simultaneous actions)</Description>
        <Implementation>Checkbox selection with select-all capability</Implementation>
      </Requirement>
    </UserManagement>

    <RDPManagement>
      <Requirement type="must">
        <Description>Toggle RDP access with visual indicators</Description>
        <UIElement>Switch control with color coding</UIElement>
      </Requirement>
    </RDPManagement>

    <SecurityFeatures>
      <Requirement type="must">
        <Description>Password generator following "demo25..." pattern (10 char max)</Description>
        <Validation>Enforce complexity rules</Validation>
      </Requirement>
      <Requirement type="should">
        <Description>Secure credential transmission via email</Description>
        <Implementation>Built-in SMTP with TLS</Implementation>
      </Requirement>
    </SecurityFeatures>
  </FunctionalRequirements>

  <!-- UI/UX Specifications -->
  <InterfaceDesign>
    <Layout>
      <MainView>Three-panel layout (Navigation | User List | Details)</MainView>
      <ColorScheme>Fluent Dark Mode Default</ColorScheme>
    </Layout>
    <KeyComponents>
      <Component>
        <Name>Batch Processing Dashboard</Name>
        <Features>Progress indicators, error summaries, undo capability</Features>
      </Component>
      <Component>
        <Name>Quick Filter Bar</Name>
        <Features>Type-as-you-search for users/groups</Features>
      </Component>
    </KeyComponents>
  </InterfaceDesign>

  <!-- Technical Implementation -->
  <TechnicalApproach>
    <Architecture>MVVM Pattern</Architecture>
    <Framework>.NET 8 + WPF</Framework>
    <APIs>
      <API>Active Directory Service Interfaces</API>
      <API>Windows Security API</API>
    </APIs>
  </TechnicalApproach>

  <!-- Output Expectations -->
  <ExpectedOutputs>
    <Deliverable priority="1">
      <Type>Interactive Prototype</Type>
      <Format>Figma/Wireframe + Clickable PDF</Format>
    </Deliverable>
    <Deliverable priority="2">
      <Type>Core Functionality Samples</Type>
      <Format>C# Code Snippets for Key Operations</Format>
    </Deliverable>
  </ExpectedOutputs>

  <!-- Validation Criteria -->
  <SuccessMetrics>
    <Metric>Batch operation completion time < 30s for 20 users</Metric>
    <Metric>90% task completion rate in usability testing</Metric>
    <Metric>Zero credential storage vulnerabilities</Metric>
  </SuccessMetrics>

  <!-- Exemplar Scenario -->
  <ExampleScenario>
    <Title>Onboarding New Contractors</Title>
    <Steps>
      <Step>1. Admin selects "Batch Create" mode</Step>
      <Step>2. Inputs 8 usernames (contractor1-8)</Step>
      <Step>3. Auto-generates compliant passwords</Step>
      <Step>4. Assigns to "Temp Workers" group</Step>
      <Step>5. Enables RDP access with expiration date</Step>
      <Step>6. Sends credentials via secured email</Step>
    </Steps>
  </ExampleScenario>
</AI_TaskPrompt>
```

Key optimization features:
1. **Structured Hierarchy** - Clear XML nesting of components
2. **Prioritized Requirements** - Marked as must/should
3. **Interaction Details** - Specific UI behaviors
4. **Technical Depth** - Framework and API specifics
5. **Measurable Outcomes** - Success metrics
6. **Scenario-Based** - Complete usage example
7. **Security Focus** - Credential handling details
8. **Modern UX** - Fluent Design integration

This prompt provides comprehensive guidance while allowing flexibility for AI innovation in implementation details. Would you like me to emphasize any particular aspect further?