#encoding: UTF-8
require_relative('./models/attendee.rb')
require_relative('./models/csv_parser.rb')
require_relative('./mailer/certificate_sender.rb')
require_relative('./workers/bulk_sender_worker.rb')
require_relative('./configuration.rb')
require_relative('./delivery.rb')
