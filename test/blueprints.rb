require 'machinist/active_record'
require 'sham'
require 'faker'

User.blueprint do
  login { Faker::Internet.user_name }
  password 'testing'
  password_confirmation { password }
  email { Faker::Internet.email }
  activation_code { nil }
  activated_at { 5.days.ago }
  state { 'active' }
end

Ninja.blueprint do
  user
  name  { 'Ninja ' + Faker::Name.first_name }
end

Mission.blueprint do
  ninja
  victim { User.make }
  message { Faker::Lorem.sentences }
end

