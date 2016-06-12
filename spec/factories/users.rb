FactoryGirl.define do
  factory :user do
    first_name "Foo"
    last_name "Bar"
    email "foobar@example.com"
    password 'password'
    deleted_at nil
  end
end
