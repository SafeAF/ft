json.extract! company, :id, :name, :contact, :address, :phone, :email, :website, :hours, :about, :category, :created_at, :updated_at
json.url company_url(company, format: :json)
