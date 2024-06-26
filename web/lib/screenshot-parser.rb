require 'net/http'
require 'uri'
require 'json'
require 'rtesseract'
require_relative '../config/environment'
puts "[+] Loaded Rails Environment"

api_key = ENV['OPENAI_API_KEY']

if api_key.nil?
  puts "[-] Error: OPENAI_API_KEY environment variable is not set."
  exit 1
end
puts "[+] OpenAI Key Detected"

if ARGV.empty?
  puts "[-] No image. Usage: ruby screenshot-parser.rb <image_path>"
  exit 1
end

image_path = ARGV[0]

p "[+] Using image #{ARGV[0]}"


ft_bot_user = User.find_by(username: "ft-bot")

# Fall back to the first user if 'ft-bot' is not found
ft_bot_user = User.first unless ft_bot_user

# Check if a user is found
unless ft_bot_user
  puts "No users available."
  exit 1
end

p "[+] Will poast as user #{ft_bot_user.username} "

def query_openai_api(prompt, api_key)
  return if prompt.nil?

  uri = URI.parse("https://api.openai.com/v1/chat/completions")

  header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{api_key}"
  }

  body = {
      model: "gpt-4", # You can change this to "gpt-3.5-turbo" if needed
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


# Function to read text from an image
def read_text_from_image(image_path)
  image = RTesseract.new(image_path)
  image.to_s # Returns the text read from the image
rescue RTesseract::Error => e
  puts "An error occurred: #{e.message}"
end


# Example usage

text = read_text_from_image(image_path)
proompt = "can you take this output from rtesseract and clean it up " +
"and create json objects with title, heading, and content from it please and " +
"can we ignore the part you are interpreting as the title and heading" +
"and craft a new title and heading from the content so it is relevant " +
"and makes more sense? please keep the content the same. And can you return it as valid JSON with no extra words, i need to be able to use the response programmatically: " + text

#p = "Prompt: #{proompt}}"

puts "[+] Image read and proompt crafted, querying Chad.."


raw_response = query_openai_api(proompt, api_key)
#puts "Raw response: #{raw_response}"


puts "[+] Parsing.."

begin
  # Adjusted regular expression to match JSON array structure
  json_match = raw_response.match(/\[\s*\{.*?\}\s*\]/m)
  if json_match
    json_string = json_match[0]
    posts_data = JSON.parse(json_string)
  else
    raise "No JSON found in the response"
  end

  p "[+] Parsing complete, creating poasts.."
  # Create Post objects from the parsed data
  posts_data.each do |post_data|
    post = Poast.new(
      user: ft_bot_user,
      title: post_data["title"],
      subheading: post_data["heading"],
      content: post_data["content"] # Assuming 'action' contains the content
    )

    if post.save
      puts "Post titled '#{post.title}' created successfully."
      puts "Subheading: #{post.subheading}"
      puts "ActionText: #{post.content}"
    else
      puts "Failed to create post titled '#{post.title}'."
    end
  end
rescue JSON::ParserError => e
  puts "Failed to parse JSON: #{e.message}"
  puts "Raw response: #{raw_response}"
  exit 1
rescue => e
  puts "An error occurred: #{e.message}"
  exit 1
end
