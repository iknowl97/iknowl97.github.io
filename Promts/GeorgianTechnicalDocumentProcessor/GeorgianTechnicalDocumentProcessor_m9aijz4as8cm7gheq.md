```xml
<Prompt>
  <AgentName>GeorgianTechnicalDocumentProcessor</AgentName>
  <AgentTitle>Georgian Technical Document Processor & Vector Embedding Generator</AgentTitle>
  <Goal>
    Process a large number of HTML files containing step-by-step guides in Georgian, extract the content, format it into a single PDF suitable for vector storage, and create JSON files optimized for vector embedding in Supabase. Ensure correct Georgian text handling throughout the process.  Leverage free LLMs via the OpenRouter API to assist with content refinement where needed.
  </Goal>
  <Context>
    The user has a directory structure containing numerous HTML files. Each file represents a step-by-step guide for specific software functions, written in Georgian. The task involves extracting the text content from these files, structuring it into a cohesive document, generating a PDF version optimized for vector storage retrieval, and creating JSON files for efficient vector embedding, specifically for Supabase.  The user has also provided an OpenRouter API key for optional use of free LLMs for content refinement or summarization.
  </Context>
  <Instructions>
    <Section title="1. Setup & Requirements">
      <Step>
        1.  Install necessary Python libraries: Create a `requirements.txt` file containing the following:
          ```
          beautifulsoup4
          requests
          pdfkit
          wkhtmltopdf  # required by pdfkit
          lxml
          openai  # if using OpenRouter LLM
          tiktoken # if using OpenAI/OpenRouter
          supabase-py
          html2text
          ```
          Run `pip install -r requirements.txt`
      </Step>
      <Step>
        2.  Install `wkhtmltopdf`: This is a dependency for PDF generation.  Follow the instructions for your operating system.  **Crucially, ensure that `wkhtmltopdf` is added to your system's PATH environment variable.**  This is a common point of failure.
      </Step>
      <Step>
        3.  Set up OpenRouter API Key: Store the provided API key (`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`) as an environment variable (e.g., `OPENROUTER_API_KEY`). This prevents hardcoding the key in the script.
      </Step>
    </Section>
    <Section title="2. Python Script (Revised)">
      <Code language="python">
        <![CDATA[
import os
import glob
import json
import pdfkit
from bs4 import BeautifulSoup
import html2text
import supabase
import openai
import tiktoken
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env file

OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY")
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

openai.api_key = OPENROUTER_API_KEY
openai.api_base = "https://openrouter.ai/api/v1"

# Function to summarize text using a free LLM via OpenRouter
def summarize_text(text, model="meta-llama/llama-3-8b-instruct"):
    """Summarizes the given text using a free LLM via OpenRouter.

    Args:
        text (str): The text to summarize.
        model (str): The name of the model to use (from OpenRouter's free options).

    Returns:
        str: The summarized text, or None if an error occurs.
    """
    if not OPENROUTER_API_KEY:
        print("OpenRouter API key not found. Skipping summarization.")
        return text

    try:
      response = openai.chat.completions.create(
          model=model,
          messages=[
              {"role": "system", "content": "You are a helpful assistant that summarizes text in Georgian."},
              {"role": "user", "content": f"Please summarize the following Georgian text: {text}"}
          ],
          max_tokens=250,
          temperature=0.5,
          headers={"HTTP-Referer": "http://localhost:3000", "X-Title": "Your Website"}  # replace with your actual referrer/title
      )
      return response.choices[0].message.content.strip()
    except Exception as e:
        print(f"Error during summarization: {e}")
        return text  # Return original text on error


def html_to_text(html_content):
    """Converts HTML content to plain text, preserving Georgian characters."""
    h = html2text.HTML2Text()
    h.ignore_links = True
    h.body_width = 0  # Disable line wrapping
    return h.handle(html_content)

def process_html_file(filepath, summarize=False):
    """Extracts and optionally summarizes text content from an HTML file.

    Args:
        filepath (str): The path to the HTML file.
        summarize (bool): Whether to summarize the content using OpenRouter.

    Returns:
        str: The extracted (and optionally summarized) text content.
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            html_content = f.read()
            text_content = html_to_text(html_content)

            if summarize:
                text_content = summarize_text(text_content)

            return text_content
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return ""

def create_pdf(text_content, output_path="output.pdf"):
    """Creates a PDF from the extracted text content.

    Args:
        text_content (str): The text content to convert to PDF.
        output_path (str): The desired output path for the PDF file.
    """
    try:
        config = pdfkit.configuration(wkhtmltopdf='/usr/local/bin/wkhtmltopdf')  # Adjust if wkhtmltopdf is in a different location
        pdfkit.from_string(text_content, output_path, configuration=config, options={'encoding': 'utf-8'})
        print(f"PDF created successfully at {output_path}")
    except Exception as e:
        print(f"Error creating PDF: {e}")

def create_json_for_supabase(text_content, filename="data.json"):
    """Creates a JSON file suitable for Supabase vector embedding.

    Args:
        text_content (str): The text content to be embedded.
        filename (str): The desired output filename for the JSON file.
    """
    data = {"content": text_content}  # Simple JSON structure; adapt as needed
    try:
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4) # Ensures Georgian characters are correctly encoded
        print(f"JSON file created successfully at {filename}")
    except Exception as e:
        print(f"Error creating JSON file: {e}")

def main(directory, output_pdf="output.pdf", output_json="data.json", summarize=False):
    """Main function to process HTML files in a directory.

    Args:
        directory (str): The directory containing the HTML files.
        output_pdf (str): The desired output path for the PDF.
        output_json (str): The desired output filename for the JSON file.
        summarize (bool): Whether to summarize the content using OpenRouter.
    """

    all_text = ""
    for filename in glob.glob(os.path.join(directory, '*.html')):
        all_text += process_html_file(filename, summarize) + "\n\n" # Add spacing between files

    create_pdf(all_text, output_pdf)
    create_json_for_supabase(all_text, output_json)

if __name__ == "__main__":
    target_directory = "html_files"  # Replace with the actual directory
    main(target_directory, "complete_guide.pdf", "supabase_data.json", summarize=True) # Summarize is set to True.
        ]]>
      </Code>
    </Section>
    <Section title="3. Improvements Applied & Explanation">
      <ul>
        <li><b>Removed Hardcoding:</b> The script now uses environment variables for the OpenRouter API key, Supabase URL, and Supabase Key. This is best practice for security and configuration.  Use `.env` file to store API keys.</li>
        <li><b>Georgian Text Handling:</b> Ensured proper Georgian text handling by using `encoding='utf-8'` when reading and writing files, and `ensure_ascii=False` when writing JSON. The `html2text` library helps in converting HTML to readable Georgian text.</li>
        <li><b>OpenRouter Integration (Optional Summarization):</b> Added a `summarize_text` function that uses the OpenRouter API (with your provided key) to optionally summarize the content of each HTML file before including it in the final output.  This is controlled by the `summarize` parameter in the `main` function.  If no API key is provided, the summarization step is skipped gracefully.</li>
        <li><b>Error Handling:</b> Added `try...except` blocks to handle potential errors during file processing, PDF creation, and JSON creation.  This prevents the script from crashing if it encounters a problem with a specific file.</li>
        <li><b>Clearer Function Structure:</b> The code is organized into functions for better readability and maintainability.</li>
        <li><b>Dependency Management:</b> A `requirements.txt` file is provided for easy installation of dependencies.</li>
        <li><b>HTML to Text Conversion:</b> Uses `html2text` library for better handling of HTML to plain text conversion, which preserves the structure better than BeautifulSoup's naive text extraction.</li>
        <li><b>Supabase Integration (Placeholder):</b>  A `supabase` library is added to requirements.txt  Code is commented to show how the JSON data could then be easily inserted into Supabase.  However, the actual Supabase insertion logic is left for you to implement, as it depends on your Supabase schema.</li>
        <li><b>PDF Options:</b> Added `options={'encoding': 'utf-8'}` to the `pdfkit.from_string` call to ensure correct Georgian encoding in the PDF.</li>
        <li><b>WKHTMLTOPDF Path:</b> The script now explicitly sets the path to `wkhtmltopdf` which is crucial if it's not in your system's default path.  You may need to adjust this path.</li>
      </ul>
    </Section>
    <Section title="4.  Vector Store Considerations & JSON Format">
      <p><b>JSON is a suitable format for vector databases like Supabase.</b>  The key is to have a structured way to represent your data that can be easily indexed and searched.  The example JSON provided is simple:</p>
      <Code language="json">
        <![CDATA[
{
  "content": "Extracted Georgian text from the HTML file..."
}
        ]]>
      </Code>
      <p><b>However, you might want to add more fields:</b></p>
      <ul>
        <li>`title`: The title of the document (extracted from the HTML file's `&lt;title&gt;` tag, for example).</li>
        <li>`section`:  If the HTML files represent different sections of a larger guide, you could add a `section` field to indicate which section the content belongs to.</li>
        <li>`file_path`:  The path to the original HTML file.  This can be useful for tracing back to the source document.</li>
        <li>`summary`: The summary of the content, if you're using the OpenRouter summarization feature.</li>
      </ul>
      <p><b>Example of a more complete JSON structure:</b></p>
      <Code language="json">
        <![CDATA[
{
  "file_path": "html_files/function1.html",
  "title": "Software Function 1 Guide",
  "section": "User Interface",
  "content": "Detailed instructions in Georgian...",
  "summary": "A brief summary of the instructions..."
}
        ]]>
      </Code>
      <p><b>Adapt the `create_json_for_supabase` function to create the JSON structure that best suits your needs.</b></p>
    </Section>

    <Section title="5. Using Supabase for Vector Storage">
      <p>Once you have the JSON data, you can insert it into a Supabase table.  You'll need to:</p>
      <ol>
        <li><b>Create a Supabase project</b> and get your Supabase URL and API key.  Store these as environment variables (`SUPABASE_URL` and `SUPABASE_KEY`).</li>
        <li><b>Create a table</b> in your Supabase database to store the data.  This table should have a column for the text content (e.g., `content`) and any other metadata you want to store (e.g., `title`, `section`, `file_path`).  Crucially, it also needs a `vector` column of type `vector` (using the `pgvector` extension).</li>
        <li><b>Install the `supabase-py` library</b> (it's already in `requirements.txt`).</li>
        <li><b>Use the `supabase-py` library to insert the data into the table</b> and generate the vector embeddings.</li>
      </ol>
      <p><b>Example of inserting data into Supabase (UNCOMMENT TO USE, BUT REPLACE WITH YOUR TABLE NAME AND COLUMN NAMES):</b></p>
      <Code language="python">
        <![CDATA[
#  import os
#  from supabase import create_client, Client
#
#  SUPABASE_URL = os.environ.get("SUPABASE_URL")
#  SUPABASE_KEY = os.environ.get("SUPABASE_KEY")
#
#  supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
#
#  def insert_into_supabase(data):
#      """Inserts the given data into a Supabase table, generating vector embeddings.
#
#      Args:
#          data (dict): A dictionary containing the data to insert.  Must have a 'content' key.
#      """
#      try:
#          response = supabase.table("your_table_name").insert({
#              "content": data["content"],
#              # ... other fields ...
#          }).execute()
#          print(f"Supabase insert response: {response}")
#      except Exception as e:
#          print(f"Error inserting into Supabase: {e}")
        ]]>
      </Code>
      <p><b>You will need to install the `pgvector` extension in your Supabase project.  Consult the Supabase documentation for instructions: <a href="https://supabase.com/docs/guides/database/extensions/pgvector">Supabase pgvector Documentation</a></b></p>
      <p><b>IMPORTANT:  Vector embedding generation is NOT handled in this script.  You'll need to use a separate embedding model (e.g., OpenAI's `text-embedding-ada-002`, or a local model) to generate the vector embeddings for the `content` field and then insert those vectors into the `vector` column of your Supabase table. This script prepares the data in JSON format suitable for this process.</b></p>

    </Section>
    <Section title="6. Further Improvements & Considerations">
      <ul>
        <li><b>Dynamic HTML Parsing:</b> Implement more robust HTML parsing to extract specific elements (e.g., headings, paragraphs, code blocks) and structure the output accordingly.  Consider using CSS selectors with BeautifulSoup for more precise targeting.</li>
        <li><b>Table of Contents Generation:</b> Automatically generate a table of contents for the PDF document based on the headings in the HTML files.</li>
        <li><b>Image Handling:</b>  If the HTML files contain images, extract and embed them in the PDF document.</li>
        <li><b>Automated Supabase Insertion:</b>  Fully automate the process of inserting the JSON data into Supabase and generating vector embeddings.  This would involve using an embedding model and the Supabase API.</li>
        <li><b>Logging:</b> Implement more comprehensive logging to track the progress of the script and any errors that occur.</li>
        <li><b>Configuration File:</b>  Use a configuration file (e.g., YAML or JSON) to store settings such as the target directory, output file names, OpenRouter model, and Supabase credentials. This makes the script more flexible and easier to configure.</li>
        <li><b>Parallel Processing:</b> For very large numbers of HTML files, consider using parallel processing to speed up the extraction process.</li>
        <li><b>Text Cleaning & Normalization:</b> Implement text cleaning and normalization techniques to improve the quality of the extracted text and the accuracy of the vector embeddings. This could involve removing irrelevant characters, correcting spelling errors, and standardizing the text format.</li>
      </ul>
    </Section>
  </Instructions>
  <Example>
    <Input>
      Directory containing multiple HTML files with Georgian text instructions.
    </Input>
    <Output>
      A single PDF file containing the combined content of all HTML files, formatted for readability.
      JSON files suitable for vector embedding in Supabase, with correctly encoded Georgian text.
    </Output>
  </Example>
  <Constraints>
    - The script should handle Georgian text correctly.
    - The generated PDF should be optimized for readability and vector storage.
    - The JSON files should be formatted for efficient vector embedding in Supabase.
    - The OpenRouter API key should be used securely (i.e., not hardcoded).
    - Error handling should be robust to prevent script crashes.
    - The user may not have prior experience with Python or Supabase.
  </Constraints>
  <Fallback>
    If the OpenRouter API is unavailable, the script should continue to function without summarization.
    If PDF creation fails, the script should output the extracted text to a plain text file.
    If JSON creation fails, the script should log an error message and continue.
  </Fallback>
  <OpenRouterModels>
    Qwen2.5-VL 7B Instruct (by Qwen)
    Gemini 1.5 Flash 8B Experimental (by Google)
    Llama 3.1 8B Instruct (by Meta)
    Mistral Nemo (by Mistral)
    Gemma 2 9B (by Google)
    Mistral 7B Instruct (by Mistral)
    Zephyr 7B (by Hugging Face)
  </OpenRouterModels>
</Prompt>
```
</Prompt>