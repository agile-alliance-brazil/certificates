#encoding: UTF-8
ActionMailer::Base.smtp_settings = {
  address: ENV['SMTP_SERVER'],
  port: ENV['SMTP_PORT'] || "587",
  domain: ENV['MAIL_DOMAIN'],
  authentication: :login,
  user_name: "#{ENV['MAIL_USER']}@#{ENV['MAIL_DOMAIN']}",
  password: ENV['SMTP_PASSWORD'],
}
