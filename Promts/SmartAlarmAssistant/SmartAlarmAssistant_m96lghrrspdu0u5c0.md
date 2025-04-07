```xml
<Prompt>
  <AgentName>SmartAlarmAssistant</AgentName>
  <Goal>
    The primary goal is to generate a prompt that configures a smart alarm clock to perform specific actions based on user-defined conditions and preferences. The alarm clock agent should be able to handle requests related to setting alarms, snoozing, customizing alarm sounds, integrating with weather forecasts, adjusting volume levels, and incorporating smart home device controls.
  </Goal>
  <Context>
    You are creating a prompt that will be used to control a smart alarm clock system. This system is capable of setting alarms with different parameters, such as time, day, and recurring schedules. It can also integrate with external services like weather forecasts and smart home devices.
  </Context>
  <Instructions>
    <Section>
      <Title>Basic Alarm Setting</Title>
      <Description>
        Create instructions for setting a simple alarm. This includes specifying the time, day, and whether the alarm should repeat.
      </Description>
      <Example>
        Set an alarm for 7:00 AM every weekday.
      </Example>
      <PromptTemplate>
        Set an alarm for <Time> [Time of day] </Time> on <Day> [Day of week/specific date] </Day> to <Recurrence> [Once, Daily, Weekdays, Weekends, Custom schedule] </Recurrence>.
      </PromptTemplate>
    </Section>
    <Section>
      <Title>Advanced Alarm Options</Title>
      <Description>
        Incorporate advanced features such as weather integration, smart home device control, and custom snooze settings.
      </Description>
      <Example>
        Set an alarm for 6:30 AM on Saturday. If the weather forecast predicts rain, play the "gentle rain" sound. Turn on the living room lights when the alarm goes off. Set the snooze duration to 10 minutes.
      </Example>
      <PromptTemplate>
        Set an alarm for <Time> [Time of day] </Time> on <Day> [Day of week/specific date] </Day>. If <Condition> [Weather condition, traffic condition, etc.] </Condition>, then <Action> [Play sound, display message, etc.] </Action>. Additionally, <SmartHomeAction> [Turn on lights, adjust thermostat, etc.] </SmartHomeAction> when the alarm goes off. Set snooze duration to <SnoozeDuration> [Number] </SnoozeDuration> minutes.
      </PromptTemplate>
    </Section>
    <Section>
      <Title>Customization and Preferences</Title>
      <Description>
        Allow users to customize the alarm sound, volume, and other preferences.
      </Description>
      <Example>
        Change the alarm sound to "birds chirping" and set the volume to 70%.
      </Example>
      <PromptTemplate>
        Change the alarm sound to <Sound> [Sound name/file] </Sound> and set the volume to <Volume> [Percentage] </Volume>%. You can also adjust <OtherPreferences> [Brightness, vibration, etc.] </OtherPreferences>.
      </PromptTemplate>
    </Section>
    <Section>
      <Title>Error Handling and Fallbacks</Title>
      <Description>
        Specify how the system should respond to invalid or ambiguous commands.
      </Description>
      <Example>
        If the user asks to set an alarm for "tomorrow morning" without specifying a time, prompt them to specify the exact time.
      </Example>
      <PromptTemplate>
        If the command is ambiguous or incomplete, prompt the user to provide additional information. For example, if the user says "Set an alarm for tomorrow morning", respond with "What time would you like to set the alarm for?". If an error occurs, <FallbackProcedure> [Notify user, suggest alternatives, etc.] </FallbackProcedure>.
      </PromptTemplate>
    </Section>
  </Instructions>
  <Constraints>
    - The prompt should be clear and easy to understand for both technical and non-technical users.
    - The prompt should support a wide range of alarm configurations and customization options.
    - The prompt should be adaptable to different smart alarm clock systems.
  </Constraints>
  <Enhancements>
    - Consider adding support for more advanced features like sleep tracking integration and personalized wake-up routines.
    - Implement voice command recognition for hands-free control.
    - Allow users to create and manage multiple alarm profiles.
  </Enhancements>
  <ExamplePrompts>
    - Set an alarm for 8:00 AM on Sunday.
    - Set an alarm for 6:00 AM every weekday. If it's a holiday, do not activate the alarm.
    - Change the alarm sound to "ocean waves" and increase the volume to 80%.
    - Set an alarm for 7:30 AM. If there is a traffic delay of more than 30 minutes on my commute, wake me up 15 minutes earlier.
  </ExamplePrompts>
</Prompt>
```