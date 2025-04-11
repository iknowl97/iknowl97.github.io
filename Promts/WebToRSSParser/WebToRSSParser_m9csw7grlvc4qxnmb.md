```xml
<Project>
  <AgentName>WebToRSSParser</AgentName>
  <AgentTitle>Universal Website RSS Feed Generator</AgentTitle>
  <Description>
    This project creates a universal parser that can generate RSS feeds from HTML websites. It uses AI to analyze website content, structure the data, and format it into an RSS feed.
  </Description>
  <Components>
    <Component>
      <Name>HTML Downloader</Name>
      <Description>Downloads HTML content from a given URL.</Description>
      <Technology>Python with requests library</Technology>
      <Code>
        <![CDATA[
        import requests

        def download_html(url):
          try:
            response = requests.get(url)
            response.raise_for_status()  # Raise HTTPError for bad responses (4xx or 5xx)
            return response.text
          except requests.exceptions.RequestException as e:
            print(f"Error downloading {url}: {e}")
            return None
        ]]>
      </Code>
      <Testing>
        Unit tests to ensure successful download and error handling.
      </Testing>
    </Component>
    <Component>
      <Name>HTML Parser</Name>
      <Description>Parses HTML content to extract relevant information.</Description>
      <Technology>Python with BeautifulSoup4</Technology>
      <Code>
        <![CDATA[
        from bs4 import BeautifulSoup

        def parse_html(html_content):
          if not html_content:
            return None
          soup = BeautifulSoup(html_content, 'html.parser')
          return soup
        ]]>
      </Code>
      <Testing>
        Unit tests to verify correct parsing and handling of malformed HTML.
      </Testing>
    </Component>
    <Component>
      <Name>Content Analyzer</Name>
      <Description>
        Analyzes the parsed HTML content using AI to identify key elements like title, content, image, etc.  Utilizes OpenRouter API with specified models.
      </Description>
      <Technology>
        Python with OpenAI/OpenRouter API
      </Technology>
      <Models>
        <Model>deepseek/deepseek-chat-v3-0324:free</Model>
        <Model>deepseek/deepseek-v3-base:free</Model>
        <Model>Google: Gemini 2.5 Pro Experimental (free) - For image analysis</Model>
      </Models>
      <Code>
        <![CDATA[
        import openai

        OPENROUTER_API_KEY = "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"
        openai.api_key = OPENROUTER_API_KEY
        openai.api_base = "https://openrouter.ai/api/v1"

        def analyze_content(soup, url):
          """Analyzes HTML content to extract key elements."""

          # Use a more robust prompt for content extraction
          prompt = f"""
          Analyze the following HTML content from the website {url} and extract the following information:

          - **Title:** The main title of the article or page.
          - **Content:** The main body of the article, including paragraphs, lists, and other text elements.
          - **Image URL:** The URL of the main image associated with the article. If multiple images exist, choose the most relevant one.
          - **Background Image URL:** If there's a distinct background image, extract its URL. Otherwise, return "None".
          - **Price:** If the page lists a price for a product or service, extract it. Otherwise, return "None".
          - **Sale Price:** If there's a sale price listed, extract it. Otherwise, return "None".
          - **Details:** Extract any other relevant details or metadata, such as author, publication date, etc. Return as a JSON object.

          Here is the HTML content:
          {str(soup)}

          Return the extracted information as a JSON object with the following format:
          {{
            "title": "Extracted Title",
            "content": "Extracted Content",
            "image_url": "URL of the image",
            "background_image_url": "URL of the background image or None",
            "price": "Price if available or None",
            "sale_price": "Sale price if available or None",
            "details": {{
              "author": "Author's name",
              "publication_date": "Date of publication",
              "other_details": "Any other relevant details"
            }}
          }}
          """
          try:
            completion = openai.chat.completions.create(
              model="deepseek/deepseek-chat-v3-0324:free",
              messages=[{"role": "user", "content": prompt}],
            )
            return completion.choices[0].message.content
          except Exception as e:
            print(f"Error during content analysis: {e}")
            return None
        ]]>
      </Code>
      <Testing>
        Integration tests to verify correct data extraction using the AI models.  Test with different website structures.
      </Testing>
    </Component>
    <Component>
      <Name>RSS Feed Generator</Name>
      <Description>Generates an RSS feed from the extracted and structured data.</Description>
      <Technology>Python with feedgen library</Technology>
      <Code>
        <![CDATA[
        from feedgen.feed import FeedGenerator
        import json

        def create_rss_feed(data, website_url):
          """Creates an RSS feed from the extracted data."""
          if not data:
            return None

          try:
            data = json.loads(data) # Parse JSON string into a Python dict
          except json.JSONDecodeError as e:
            print(f"Error decoding JSON data: {e}")
            return None

          fg = FeedGenerator()
          fg.id(website_url) # Use website URL as a unique ID
          fg.title(data.get('title', 'Untitled'))  # Use title from extracted data, default to 'Untitled' if missing
          fg.link(href=website_url, rel='alternate') # Link to the original website

          fe = fg.add_entry()
          fe.id(website_url + "#entry1")  # Unique ID for the entry
          fe.title(data.get('title', 'Untitled')) # Title from extracted data, default if missing
          fe.content(data.get('content', 'No content')) # Content from extracted data, default if missing

          # Add image if available
          image_url = data.get('image_url')
          if image_url:
            fe.link(href=image_url, rel='enclosure', type='image/jpeg') # Assuming JPEG, adjust type if needed.

          return fg.rss_str(pretty=True) # Return RSS feed as a string
        ]]>
      </Code>
      <Testing>
        Unit tests to ensure the generated RSS feed is valid and well-formed.  Verify different data scenarios.
      </Testing>
    </Component>
    <Component>
      <Name>Website Crawler (Optional)</Name>
      <Description>
        Crawls the website to discover all pages that need to be parsed.  Can be integrated for a fully automated solution.
      </Description>
      <Technology>Python with Scrapy or similar web crawling library</Technology>
      <Note>This is an optional component for fully automated crawling.  User can also provide a list of URLs.</Note>
    </Component>
  </Components>

  <Workflow>
    <Step>
      1. **Download HTML:**  The `HTML Downloader` component downloads the HTML from the specified URL.
    </Step>
    <Step>
      2. **Parse HTML:** The `HTML Parser` component parses the downloaded HTML content.
    </Step>
    <Step>
      3. **Analyze Content:** The `Content Analyzer` component uses AI to extract key information from the parsed HTML.
    </Step>
    <Step>
      4. **Generate RSS:** The `RSS Feed Generator` component creates an RSS feed using the extracted information.
    </Step>
    <Step>
      5. **(Optional) Crawl Website:** The `Website Crawler` can be used to automatically discover all pages on the website.
    </Step>
  </Workflow>

  <Deployment>
    <Environment>
      Docker containerized application for easy deployment.
    </Environment>
    <Dockerfile>
      <![CDATA[
      FROM python:3.9-slim-buster

      WORKDIR /app

      COPY requirements.txt .
      RUN pip install --no-cache-dir -r requirements.txt

      COPY . .

      CMD [ "python", "main.py" ]
      ]]>
    </Dockerfile>
    <DockerCompose>
      Example `docker-compose.yml` (adapt as needed):
      <![CDATA[
      version: "3.8"
      services:
        web-to-rss:
          build: .
          ports:
            - "8000:8000" #Example port
          environment:
            - OPENROUTER_API_KEY=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
      ]]>
    </DockerCompose>
  </Deployment>

  <CodeStructure>
    <File>
      main.py - Main application entry point.  Orchestrates the workflow.
    </File>
    <File>
      html_downloader.py - Contains the HTML Downloader component.
    </File>
    <File>
      html_parser.py - Contains the HTML Parser component.
    </File>
    <File>
      content_analyzer.py - Contains the Content Analyzer component.
    </File>
    <File>
      rss_generator.py - Contains the RSS Feed Generator component.
    </File>
    <File>
      requirements.txt - Lists all Python dependencies.
    </File>
    <File>
      Dockerfile - Dockerfile for containerization.
    </File>
    <File>
      docker-compose.yml - Docker Compose file for orchestrating the application.
    </File>
  </CodeStructure>

  <ErrorHandling>
    Comprehensive error handling with logging and informative error messages.  Specific error handling in each component.  Retry mechanisms for transient errors.
  </ErrorHandling>

  <Dependencies>
    <Dependency>requests</Dependency>
    <Dependency>BeautifulSoup4</Dependency>
    <Dependency>openai</Dependency>
    <Dependency>feedgen</Dependency>
    <Dependency>Scrapy (Optional)</Dependency>
  </Dependencies>

  <Configuration>
    The OpenRouter API key is configured as an environment variable `OPENROUTER_API_KEY`. Website URL(s) to parse are passed as command-line arguments or configured in a configuration file.
  </Configuration>

  <TestingStrategy>
    Unit tests for individual components. Integration tests for end-to-end workflow.  End-to-end testing with various websites.
  </TestingStrategy>

  <Improvements>
    Implement caching to avoid redundant API calls.  Add support for different RSS feed formats.  Improve the AI analysis prompt for better accuracy.  Implement a more sophisticated crawling strategy.
  </Improvements>
  <Notes>
    Remember to install the dependencies using `pip install -r requirements.txt`.  Replace the placeholder website URL in the `main.py` file with the actual URL you want to parse. Adjust the Dockerfile and docker-compose.yml to match your specific needs.
  </Notes>
</Project>
```
