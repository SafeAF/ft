require 'httparty'
require 'json'
require 'uri'

def fetch_latest_news
  # GDELT API endpoint with a query including "Idaho"
  query = '"Idaho" sourcecountry:US'
  url = "https://api.gdeltproject.org/api/v2/doc/doc?query=#{URI.encode_www_form_component(query)}&mode=artlist&maxrecords=10&format=json"

  # Make the HTTP GET request
  response = HTTParty.get(url)
  
  # Parse the JSON response
  if response.code == 200
    json_response = JSON.parse(response.body)
    articles = json_response["articles"]

    # Print the titles and URLs of the articles
    articles.each do |article|
      puts "Title: #{article['title']}"
      puts "URL: #{article['url']}"
      puts "Source: #{article['source']}"
      puts "Date: #{article['seendate']}"
      puts "-" * 50
    end
  else
    puts "Error fetching news: #{response.code}"
  end
end

fetch_latest_news
