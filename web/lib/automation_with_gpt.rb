require 'net/http'
require 'uri'
require 'json'
require_relative '../config/environment'

api_key = ENV['OPENAI_API_KEY']

if api_key.nil?
  puts "[-] Error: OPENAI_API_KEY environment variable is not set."
  exit 1
end
puts "[+] OpenAI Key Detected #{api_key}"

puts "[+] Loaded Rails Environment"

poast = Poast.last

def query_openai_api(prompt, api_key)
  return if prompt.nil?

  uri = URI.parse("https://api.openai.com/v1/chat/completions")

  header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{api_key}"
  }

  body = {
      model: "gpt-3.5-turbo", # You can change this to "gpt-4-turbo" if needed
      messages: [{ role: "user", content: prompt }],
      temperature: 0.7
  }

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = body.to_json

  response = http.request(request)
  JSON.parse(response.body)["choices"][0]["message"]["content"]
end

puts query_openai_api(poast.content.to_s, api_key)
