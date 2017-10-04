# encoding:UTF-8
FactoryGirl.define do
  factory :attendee do
    initialize_with { new(name: 'John Doe', email: 'john.doe@email.com') }
  end
end
