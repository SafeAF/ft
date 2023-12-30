require 'httparty'
require 'json'
require 'uri'

require_relative '../config/environment'
puts "[+] Loaded Rails Environment"

def fetch_latest_news
  query = '"Idaho" sourcecountry:US'
  url = "https://api.gdeltproject.org/api/v2/doc/doc?query=#{URI.encode_www_form_component(query)}&mode=artlist&maxrecords=10&format=json"

  response = HTTParty.get(url)
  
  if response.code == 200
    json_response = JSON.parse(response.body)
    articles = json_response["articles"]

    articles.each do |article_data|
      next if Article.exists?(description: article_data['url']) # Skip if the article already exists

      article = Article.new(
        title: article_data['title'],
        description: article_data['url'], # Using URL as description
        location: "Idaho",
        user: User.first
        # Other fields are not populated as per your instruction
      )

      if article.save
        puts "Article '#{article.title}' saved successfully."
      else
        puts "Failed to save article: #{article.errors.full_messages.join(", ")}"
      end
    end
  else
    puts "Error fetching news: #{response.code}"
  end
end

fetch_latest_news

