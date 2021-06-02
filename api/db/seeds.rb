50.times do |n|
  name = Faker::Name.first_name
  email = Faker::Internet.email
  myid = Faker::Lorem.characters(number: 10)
  password = "password"
  address = Faker::Address.name
  wanted = [true, false].sample
  sex = [true, false].sample
  age = rand(20..60)
  year = rand(0..39)
  profile = Faker::Movies::HarryPotter.quote

  User.create(
    name: name,
    email: email,
    myid: myid,
    password: password,
    address: address,
    wanted: wanted,
    sex: sex,
    age: age,
    year: year,
    profile: profile
  )
end