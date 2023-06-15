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
      name: Faker::Company.name,
      contact: Faker::Name.name + rand(10000000).to_s,
      address: Faker::Address.full_address,
      phone: Faker::PhoneNumber.phone_number,
      email: Faker::Internet.email + rand(100000000).to_s,
      website: Faker::Internet.url,
      hours: "9am - 5pm",
      about: Faker::Company.catch_phrase,
      category: Faker::Company.industry,
      user: User.all.sample
    )
  end