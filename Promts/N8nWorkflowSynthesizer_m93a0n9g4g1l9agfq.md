```xml
<Prompt>
  <AgentName>N8nWorkflowSynthesizer</AgentName>
  <Goal>
    Synthesize a complete, fixed, modified, and improved n8n workflow in JSON format, drawing exclusively from examples, instructions, and context established within the complete chat history of this conversation. The workflow should combine the best aspects of the previously discussed functionalities: Georgian speech-to-text transcription, subtitle generation, and incorporate translation to Russian if beneficial.
  </Goal>
  <Instructions>
    <ContextualUnderstanding>
      <Step1_ReviewChatHistory>
        <Action>Thoroughly review the entire chat history to identify all relevant information, including:</Action>
        <Details>
          *   The user's primary goals: Georgian speech-to-text transcription with high accuracy, automatic subtitle generation with character limits, and potential translation to Russian.
          *   Specific requirements: Character limit for subtitles (9 characters), n8n workflow automation, potential use of Flash 2.0, Gemini, or OpenAI models for transcription.
          *   Discussions on data acquisition, preparation, model selection, fine-tuning, optimization, and deployment for a custom Georgian STT solution.
          *   Best practices and optimization techniques discussed in relation to n8n workflows, error handling, and JSON structure.
        </Details>
      </Step1_ReviewChatHistory>
      <Step2_IdentifyKeyElements>
        <Action>Extract the key elements and functionalities that should be included in the synthesized workflow.</Action>
        <Details>
          *   Downloading audio from a source (e.g., Google Drive - needs generic OAuth setup to be functional in the template).
          *   Transcribing Georgian speech to text using the identified (or a combination) of suitable models.
          *   Formatting the transcription into .srt subtitle format with the specified character limit and timing.
          *   (Optional) Translating the subtitles into Russian.
        </Details>
      </Step2_IdentifyKeyElements>
    </ContextualUnderstanding>

    <WorkflowConstruction>
      <Step1_WorkflowSkeleton>
        <Action>Create a basic n8n workflow skeleton with the following nodes:</Action>
        <Details>
          *   **Start:** The initial trigger node (e.g., Webhook, Google Drive trigger, manual execution).
          *   **Download Audio:** Node to download audio from a source (e.g., Google Drive). Requires user-configured credentials. Placeholder for user-defined credentials.
          *   **Transcription:** Node(s) for Georgian speech-to-text transcription (using a suitable model API or a custom script).
          *   **Subtitle Formatting:** Node to format the transcription into .srt subtitle format with character limits and timing.
          *   **(Optional) Translation:** Node to translate subtitles into Russian (if desired and feasible).
          *   **Output:** Node to save or display the generated .srt file.
        </Details>
      </Step1_WorkflowSkeleton>
      <Step2_TranscriptionNode>
        <Action>Implement the transcription node using the most promising approach discussed in the chat history.</Action>
        <Details>
          *   Consider using an HTTP Request node to call an external API (e.g., Flash 2.0, a custom-deployed model, or an alternative transcription service).
          *   If using a custom script, use a Function node and incorporate appropriate libraries (e.g., `transformers`, `torchaudio` in a Python environment).
          *   Implement error handling to gracefully handle transcription failures.
        </Details>
      </Step2_TranscriptionNode>
      <Step3_SubtitleFormattingNode>
        <Action>Create a Function node to format the transcription into .srt subtitle format, enforcing the character limit.</Action>
        <Details>
          *   Implement logic to split long lines into multiple lines, ensuring that words are not broken mid-character.
          *   Incorporate timing information based on estimated speaking speed or, ideally, using a more precise alignment method if available.
          *   Generate the .srt file content according to the standard format.
        </Details>
      </Step3_SubtitleFormattingNode>
      <Step4_TranslationNode>
        <Action>(Optional) If desired and feasible, add a translation node to translate the subtitles into Russian.</Action>
        <Details>
          *   Use an HTTP Request node to call a translation API (e.g., Google Translate, DeepL, or a similar service).
          *   Handle potential rate limits and API errors gracefully.
        </Details>
      </Step4_TranslationNode>
      <Step5_ErrorHandling>
        <Action>Implement robust error handling throughout the workflow.</Action>
        <Details>
          *   Use Try/Catch nodes to catch errors in each major step.
          *   Log errors to a file or send them to a notification service (e.g., email, Slack).
          *   Implement retry logic for transient errors (e.g., API rate limits).
        </Details>
      </Step5_ErrorHandling>
      <Step6_CommentsAndDocumentation>
        <Action>Add clear and concise comments to each node to explain its purpose and functionality.</Action>
        <Details>
          *   Use descriptive labels for each node.
          *   Provide detailed explanations of any complex logic or expressions.
          *   Document any assumptions or dependencies.
        </Details>
      </Step6_CommentsAndDocumentation>
    </WorkflowConstruction>

    <JSONOutput>
      <Action>Generate the complete n8n workflow in JSON format.</Action>
      <Verification>
        *   Ensure that the JSON is valid and well-formatted.
        *   Double-check that all nodes are properly connected and configured.
        *   Verify that the workflow functions correctly and produces the expected results.
      </Verification>
    </JSONOutput>
  </Instructions>
</Prompt>
```
