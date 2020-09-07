User.create!(name: "Bùi Hữu Hoàng",
             email: "bhhoang1998@gmail.com",
             password:
                 "1111111111",
             password_confirmation: "1111111111",
             admin: true)
# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "1111111111"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
