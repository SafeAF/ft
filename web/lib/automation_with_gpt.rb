

require "openai"
require 'json'


api_key = ENV['OPENAI_API_KEY']

if api_key.nil?
  puts "[-] Error: OPENAI_API_KEY environment variable is not set."
  exit 1
end

p "[+] OpenAI Key Detected"


require_relative '../config/environment'
p "[+] Loaded Rails Environment"

def query_openai_api(proompt)
client = OpenAI::Client.new(access_token: api_key)

#OpenAI.rough_token_count("Your text")

#p client.models.list

response = client.chat(
    parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: proompt}], # Required.
        temperature: 0.7,
    })
puts response.dig("choices", 0, "message", "content")
# => "Hello! How may I assist you today?"
end