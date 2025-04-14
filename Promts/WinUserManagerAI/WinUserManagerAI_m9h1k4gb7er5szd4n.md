Based on your request for an IT Support application to manage Windows Local Users and Groups, here's a well-structured XML prompt with an appropriate agent name and title:

```xml
<aiPrompt>
  <AgentName>WinUserManagerAI</AgentName>
  <AgentTitle>Windows User and RDP Management Expert</AgentTitle>
  
  <Goal>
    Develop a comprehensive Windows desktop application that enables IT support staff to efficiently manage local users and groups including RDP access control, with modern UX/UI design and batch operation capabilities.
  </Goal>
  
  <Context>
    The application will run locally on Windows machines hosting RDP users and servers. It must handle individual and bulk operations, provide email notification capabilities, and maintain strict security standards while being intuitive for IT professionals.
  </Context>
  
  <Requirements>
    <CoreFeatures>
      <Feature>
        <Name>User/Group Management Dashboard</Name>
        <Detail>Modern UI displaying all local users and groups in sortable/filterable tables with quick action buttons</Detail>
      </Feature>
      <Feature>
        <Name>RDP Access Control</Name>
        <Detail>Enable/Disable RDP access with toggle switches; AI-assisted remote execution methods when needed</Detail>
      </Feature>
      <Feature>
        <Name>Batch Operations</Name>
        <Detail>Perform actions on multiple selected users simultaneously (password changes, disables, etc.)</Detail>
      </Feature>
      <Feature>
        <Name>User Lifecycle Management</Name>
        <Detail>Create/Modify/Delete users with full property editing including email/password/group membership</Detail>
      </Feature>
      <Feature>
        <Name>Email Notification System</Name>
        <Detail>Option to send credentials via email on changes, with resend capability</Detail>
      </Feature>
    </CoreFeatures>
    
    <TechnicalSpecs>
      <Spec>Windows desktop application (WPF/WinForms/UWP/WinUI)</Spec>
      <Spec>Secure credential handling and storage</Spec>
      <Spec>Performance optimized for operations on 20+ users simultaneously</Spec>
      <Spec>Small footprint installation</Spec>
    </TechnicalSpecs>
    
    <UIUXRequirements>
      <Requirement>Modern, clean interface following Fluent/WinUI design principles</Requirement>
      <Requirement>Contextual right-click menus on user entries</Requirement>
      <Requirement>Batch operation selection interface with selection counters</Requirement>
      <Requirement>Visual indicators for RDP access status and password age</Requirement>
    </UIUXRequirements>
  </Requirements>
  
  <OutputExpectations>
    <Deliverable>Complete application design specification document</Deliverable>
    <Deliverable>Recommended technology stack with justification</Deliverable>
    <Deliverable>UI mockups/wireframes showing main screens and workflows</Deliverable>
    <Deliverable>Implementation roadmap with phased delivery options</Deliverable>
    <Deliverable>Security considerations documentation</Deliverable>
  </OutputExpectations>
  
  <Constraints>
    <Constraint>Must work on Windows 10/11 Server editions</Constraint>
    <Constraint>No perpetual internet connection requirement</Constraint>
    <Constraint>Support for existing Active Directory structures</Constraint>
  </Constraints>
  
  <Examples>
    <ExampleScenario>
      <Description>IT admin needs to reset passwords for 15 users before rotation deadline</Description>
      <ExpectedFlow>
        1. Select multiple users via checkboxes
        2. Choose "Reset Password" from batch actions menu
        3. Set common parameters (password length/complexity)
        4. Choose notification method (email/nonetcd)
        5. Confirm and execute bulk operation
      </ExpectedFlow>
    </ExampleScenario>
    <ExampleScenario>
      <Description>Disable RDP access for departed employees</Description>
      <ExpectedFlow>
        1. Sort users by last login date
        2. Select inactive users
        3. Toggle RDP access switch off
        4. Save changes with optional disable-date comments
      </ExpectedFlow>
    </ExampleScenario>
  </Examples>
  
  <Notes>
    <Note>Prioritize reliability over advanced features</Note>
    <Note>Include comprehensive logging of administrative actions</Note>
    <Note>Consider CSV import/export for bulk user creation</Note>
    <Note>Provide keyboard shortcuts for power users</Note>
  </Notes>
</aiPrompt>
```

This XML prompt:
1. Names the agent appropriately for the domain (WinUserManagerAI)
2. Provides clear structure and comprehensive requirements
3. Includes specific examples of usage scenarios
4. Details both functional and technical requirements
5. Specifies expected deliverables
6. Maintains focus on the core needs of batch operations and RDP management

Would you like me to adjust any aspects of this prompt or focus more on particular elements of the request?