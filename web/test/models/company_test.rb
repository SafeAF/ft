require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", password: "password", password_confirmation: "password")
    @company = Company.new(
      name: "Test Company",
      contact: "Test Contact",
      address: "123 Test St",
      phone: "1234567890",
      email: "test@company.com",
      website: "www.test.com",
      hours: "9-5",
      about: "About Test Company",
      category: "Test Category",
      user: @user
    )
  end

  # test "company should be valid" do
  #   assert @company.valid?
  # end

  # test "name should be present" do
  #   @company.name = ""
  #   assert_not @company.valid?
  # end

  # test "contact should be present" do
  #   @company.contact = ""
  #   assert_not @company.valid?
  # end

  # test "address should be present" do
  #   @company.address = ""
  #   assert_not @company.valid?
  # end

  # test "phone should be present" do
  #   @company.phone = ""
  #   assert_not @company.valid?
  # end

  # test "email should be present" do
  #   @company.email = ""
  #   assert_not @company.valid?
  # end

  # test "website should be present" do
  #   @company.website = ""
  #   assert_not @company.valid?
  # end

  # test "hours should be present" do
  #   @company.hours = ""
  #   assert_not @company.valid?
  # end

  # test "about should be present" do
  #   @company.about = ""
  #   assert_not @company.valid?
  # end

  # test "category should be present" do
  #   @company.category = ""
  #   assert_not @company.valid?
  # end

  # test "email should be in valid format" do
  #   valid_emails = ["test@example.com", "test.test@example.com", "test@example.co.in", "test+test@example.com"]
  #   valid_emails.each do |valids|
  #     @company.email = valids
  #     assert @company.valid?, "#{valids.inspect} should be valid"
  #   end

  #   invalid_emails = %w[mashrur@example mashrur.example.com mashrur@example.]
  #   invalid_emails.each do |invalids|
  #     @company.email = invalids
  #     assert_not @company.valid?, "#{invalids.inspect} should be invalid"
  #   end
  # end

  # test "website should be in valid format" do
  #   valid_websites = ["www.test.com", "http://www.test.com", "https://www.test.com"]
  #   valid_websites.each do |valids|
  #     @company.website = valids
  #     assert @company.valid?, "#{valids.inspect} should be valid"
  #   end

  #   invalid_websites = ["test", "test.com", "http://", "https://"]
  #   invalid_websites.each do |invalids|
  #     @company.website = invalids
  #     assert_not @company.valid?, "#{invalids.inspect} should be invalid"
  #   end
  # end
end
