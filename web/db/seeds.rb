# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Clean database (optional)
 Company.destroy_all
 User.destroy_all


foo = User.create!(
    username: "Foo",
    location: "Twin Falls, ID",
    email: "foo@foo.com",
    password: "foobar",
    password_confirmation: "foobar"
)

# Create some Users
user1 = User.create!(
  username: 'JohnDoe',
  location: 'New York, USA',
  email: 'john@example.com',
  password: '12345678',
  password_confirmation: '12345678'
)


user2 = User.create!(
    username: 'JaneDoe',
    location: 'Los Angeles, USA',
    email: 'jane@example.com',
    password: '12345678',
    password_confirmation: '12345678'
  )



  50.times do
    Company.create!(
      name: Faker::Company.name + rand(10).to_s,
      contact: Faker::Name.name,
      address: Faker::Address.full_address,
      phone: Faker::PhoneNumber.phone_number,
      email: Faker::Internet.email + rand(10).to_s,
      website: Faker::Internet.url,
      hours: "9am - 5pm",
      about: Faker::Company.catch_phrase,
      category: Company.categories.keys.sample,
      user: User.all.sample
    )
  end


# Assuming you have some users in your database, 
# the following will fetch the first user to associate with the dummy listings.
user = User.first




(1..50).each do |list|
list = Listing.new
list.title = Faker::Lorem.sentence(word_count: 5)
list.description = Faker::Lorem.sentence(word_count: 15)
list.user = User.first
list.category = Listing.categories.keys.sample
list.location = Faker::Address.city
list.price = rand(1..100.0).round(2)
list.thumbnail.attach(io: File.open('/home/sam/Downloads/old-gold.jpg'), filename: 'old-gold.jpg')
list.save!
end


# seeds.rb

# Assuming User model exists and has at least one record
first_user = User.first

50.times do
  Job.create(
    title: Faker::Job.title,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    job_type: ["Full-Time", "Part-Time", "Contract", "Internship"].sample,
    location: Faker::Address.city,
    company_name: Faker::Company.name,
    company_description: Faker::Company.catch_phrase,
    company_website: Faker::Internet.url(host: 'example.com'),
    company_phone: Faker::PhoneNumber.cell_phone,
    company_contact: Faker::Name.name,
    user: first_user  # Replace this with logic to assign to different users if needed
  )
end
  
  # seeds.rb

# Assuming User model exists and has at least one record
first_user = User.first

50.times do
  Article.create(
    user_id: first_user.id,
    title: Faker::Book.title,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    location: Faker::Address.city,
    views: rand(0..1000),
    category: ["Local News", "Technology", "Sports", "Health", "Entertainment"].sample,
    created_at: Faker::Date.between(from: 2.days.ago, to: Date.today),
    updated_at: Faker::Date.between(from: 1.days.ago, to: Date.today)
  )
end



