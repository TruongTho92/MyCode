# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 99.times do |n|
#   name = Faker::Name.name
#   email = Faker::Internet.email
#   password = "password"
#   User.create!(name: name,
#               email: email,
#               password: password,
#               password_confirmation: password)
# end

# User.create!(name: "Truong Tho",
#             email: "tho.trannhattruong922001@gmail.com",
#             password: "123456",
#             password_confirmation: "123456",
#             admin: true)

users = User.order(:created_at)
30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# users = User.all
# user = User.find(114)
# following = users[2..20]
# followers = users[3..15]
# following.each{|followed| user.follow(followed)}
# followers.each{|follower| follower.follow(user)}