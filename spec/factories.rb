#encoding: UTF-8
FactoryGirl.define do
  factory :attendee do
    initialize_with { new(name: 'John Doe', email: 'john.doe@email.com') }
  end

  factory :certificate_sender do
    configs({
      'user' => 'no-reply',
      'domain' => 'domain.com',
      'smtp_server' => 'smtp.otherdomain.com',
      'smtp_port' => '865',
      'password' => 'fake'
    })
    subject 'Fake subject'
    content_type 'application/pdf'

    initialize_with { new(configs, subject, content_type) }
  end
end
