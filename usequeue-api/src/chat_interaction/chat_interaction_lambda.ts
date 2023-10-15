const { OpenAIApi } = require('openai'); // Assuming you have an OpenAI Node.js client library

export const handler = async (event: any) => {
    // Ensure you've set the OPENAI_API_KEY as an environment variable in Lambda or use AWS Secrets Manager
    const apiKey = process.env.OPENAI_API_KEY;
    
    // Initialize the OpenAI client
    const openai = new OpenAIApi({ key: apiKey });
    
    // Extract user message from the incoming event
    let userInput = "";
    if (event && event.body) {
        const body = JSON.parse(event.body);
        userInput = body.message || "";
    }
    
    try {
        // Send the message to OpenAI's ChatGPT
        const response = await openai.complete({
            prompt: userInput,
            max_tokens: 150 // Adjust based on your requirements
        });
        
        // Return the model's response
        return {
            statusCode: 200,
            body: JSON.stringify({ message: response.choices[0].text.trim() })
        };
    } catch (error) {
        console.error("Error calling OpenAI API:", error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: "Failed to communicate with OpenAI." })
        };
    }
};

