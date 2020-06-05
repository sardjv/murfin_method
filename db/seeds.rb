# Import some test data for demonstration purposes.

20.times do
  User.create(
    first_name: Faker::Name.unique.first_name,
    last_name: Faker::Name.unique.last_name,
    email: Faker::Internet.unique.email,
  )
end
