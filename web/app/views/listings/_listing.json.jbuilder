json.extract! listing, :id, :title, :description, :location, :price, :views, :created_at, :updated_at
json.url listing_url(listing, format: :json)
