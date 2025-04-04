```xml
<Prompt>
  <AgentName>N8nWorkflowSynthesizer</AgentName>
  <Goal>
    Synthesize a complete, fixed, modified, and improved n8n workflow in JSON format based on the entirety of the current conversation history, encompassing the user's requirements for Georgian speech-to-text transcription and subtitle generation, and taking into account the discussion of potential tools and strategies. The workflow should automate the process from audio input to .srt subtitle output.
  </Goal>
  <Instructions>
    <ContextReview>
      <Action>Thoroughly review the entire chat history to identify all relevant user requirements, constraints, and suggestions regarding the desired n8n workflow.</Action>
      <Details>
        *   **Georgian STT:** The workflow must handle Georgian speech-to-text transcription.
        *   **Character Limit:** The generated subtitles must adhere to a strict character limit (9 characters per line).
        *   **.srt Output:** The final output should be a properly formatted .srt subtitle file.
        *   **Model Selection:** The workflow should be adaptable to different STT models (Flash 2.0, Gemini, Whisper).
        *   **n8n Integration:** The workflow should seamlessly integrate with n8n.
        *   **Error Handling:** Robust error handling should be implemented to gracefully manage potential failures (e.g., transcription errors, file access issues).
        *   **Optimization:** The workflow should be optimized for performance.
        *   **Open Source:** Favor open-source solutions where possible.
      </Details>
    </ContextReview>
    <WorkflowDesign>
      <OverallStructure>
        The workflow should follow a clear, modular structure, breaking down the task into distinct stages:
        1.  **Audio Input:** Fetch the Georgian audio file.
        2.  **Transcription:** Transcribe the audio to Georgian text.
        3.  **Subtitle Formatting:** Format the transcribed text into .srt subtitles with the character limit constraint.
        4.  **Output:** Save the .srt file.
      </OverallStructure>
      <NodeDetails>
        <AudioInput>
          *   **Node Type:** Likely a "Get File" or "HTTP Request" node (depending on the source of the audio file – Google Drive, URL, etc.).
          *   **Configuration:** Allow the user to specify the audio file path/URL.
        </AudioInput>
        <Transcription>
          *   **Node Type:**  "Function" or "Execute Command" node (to interact with an external STT service or script). A Function node with a call to a cloud-based STT API would also work.
          *   **Model Selection:** Implement logic to choose between different STT models (Flash 2.0, Gemini, Whisper) based on user preference or availability.  Consider a "Switch" node.
          *   **API Call:** If using an API, construct the API request with the audio file.
          *   **Error Handling:** Implement error handling to retry transcription or log errors.
        </Transcription>
        <SubtitleFormatting>
          *   **Node Type:** "Function" node (to implement the custom formatting logic).
          *   **Character Limit:** Enforce the 9-character limit per line.
          *   **Line Break Logic:** Move entire words to the next line if they exceed the character limit.
          *   **Timing:**  Generate basic timing information (e.g., 2-second intervals).  Ideally, integrate with an audio analysis library (if feasible within n8n) for more accurate timing.
          *   **SRT Formatting:** Generate the .srt output string.
        </SubtitleFormatting>
        <Output>
          *   **Node Type:** "Write to File" node.
          *   **Configuration:** Allow the user to specify the output file path.
        </Output>
      </NodeDetails>
    </WorkflowDesign>
    <CodeGeneration>
      Generate the complete n8n workflow JSON, including:
      *   All necessary nodes with appropriate types and configurations.
      *   Connections between nodes to ensure correct data flow.
      *   JavaScript code for the "Function" nodes (transcription and subtitle formatting).  Favor clear, well-commented code.
      *   Error handling logic.
      *   Example configurations (file paths, API keys – where applicable). **Remember to replace any API keys with placeholders.**
    </CodeGeneration>
    <Optimization>
      *   **Efficiency:** Optimize the workflow for speed and resource usage.
      *   **Modularity:** Keep the workflow modular and easy to understand.
    </Optimization>
    <JSONValidation>
      Ensure that the generated JSON is valid using a JSON validator.
    </JSONValidation>
  </Instructions>
</Prompt>
