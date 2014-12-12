#encoding: UTF-8
require_relative '../extensions/kernel.rb'
require_all_files_in_relative_folder('initializers')
require_relative './mailer.rb'
require_relative './attendee.rb'
require_relative './csv_parser.rb'
require_relative './bulk_processor.rb'
