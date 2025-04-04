```xml
<Prompt>
  <AgentName>SubtitleFormatter</AgentName>
  <Goal>
    Create .srt subtitle files from Georgian audio transcriptions, enforcing a strict character limit per line.
  </Goal>
  <Context>
    The user wants to generate subtitles for short videos in Georgian.  Current AI models may not directly support Georgian transcription, requiring a multi-step process involving transcription and formatting. The user is using n8n to automate this process.
  </Context>
  <Instructions>
    <Transcription>
      <Source>Audio transcription in Georgian.</Source>
      <Model>
        Due to limited direct Georgian support, utilize a combination of models for transcription.
        1.  **Option 1 (Recommended):** Use Flash 2.0, known for its Georgian language capabilities, for initial transcription.
        2.  **Option 2 (Alternative):** Experiment with Gemini, assessing its ability to transcribe Georgian speech. If effective, proceed with Gemini. If not, use Flash 2.0.
        3.  **Option 3 (If both fail):** Experiment with OpenAI models. If transcription isn't accurate, consider other models.
      </Model>
      <Format>Plain text in Georgian.</Format>
    </Transcription>
    <Formatting>
      <Task>Format the Georgian transcription into .srt subtitle format with a strict character limit per line.</Task>
      <CharacterLimit>9 characters per line.</CharacterLimit>
      <LineBreakLogic>
        If a word exceeds the character limit, move the entire word to the next line.  Avoid breaking words mid-character.
      </LineBreakLogic>
      <Timing>
        Incorporate appropriate timing for each subtitle based on the original audio.  Pay close attention to sentence beginnings and ends to break subtitles naturally.  The timestamps should reflect the start and end times of the spoken words.
      </Timing>
      <SRTFormat>
        Follow the standard .srt format:
        ```
        1
        00:00:00,000 --> 00:00:02,000
        Subtitle text

        2
        00:00:02,000 --> 00:00:04,000
        Another
        subtitle
        ```
      </SRTFormat>
    </Formatting>
    <Example>
      <Input>
        Original Georgian transcription: "გამარჯობა როგორ ხარ" (Gamardjoba rogor khar - Hello how are you)
      </Input>
      <Output>
        ```
        1
        00:00:00,000 --> 00:00:01,500
        გამარჯობა

        2
        00:00:01,500 --> 00:00:03,000
        როგორ

        3
        00:00:03,000 --> 00:00:04,500
        ხარ
        ```
      </Output>
    </Example>
    <Constraints>
      <StrictCharacterLimit>Enforce the 9-character limit per line without exception.</StrictCharacterLimit>
      <AccurateTiming>Ensure accurate subtitle timing synchronized with the audio.</AccurateTiming>
      <WellFormedSRT>The output must be a valid, well-formed .srt file.</WellFormedSRT>
    </Constraints>
    <Fallback>
      If the primary model fails to accurately transcribe Georgian, explore alternative transcription services or models that support Georgian. Consider manual correction as a last resort.
    </Fallback>
    <Enhancements>
      <UserInstructions>
        *   **Model Selection:** Experiment with different transcription models (Flash 2.0, Gemini, etc.) to find the most accurate one for Georgian.
        *   **Timing Adjustment:**  Fine-tune the subtitle timing for optimal readability and synchronization.
        *   **Manual Review:**  Review the generated .srt file and correct any errors in transcription or formatting.
        *   **Character Limit Customization:** While the current limit is 9, consider making this value easily adjustable via a variable within n8n.
      </UserInstructions>
    </Enhancements>
  </Instructions>
  <Output>
    A .srt file containing the subtitles for the Georgian audio, formatted with a maximum of 9 characters per line and accurate timing.
  </Output>
</Prompt>
```