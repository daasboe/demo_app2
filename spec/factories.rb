# encoding: UTF-8
FactoryGirl.define do
  factory :user do
    name  "Daniel Aasbø"
    email "daniel.aasbo@gmail.com"
    password "123456"
    password_confirmation "123456"
  end
end
