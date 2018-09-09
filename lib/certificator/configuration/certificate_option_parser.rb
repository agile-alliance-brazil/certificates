# frozen_string_literal: true

require 'optparse'
require 'certificator/version'

module Certificator
  # The parser for certificate options. Describes all options and how
  # to parse them for the application
  class OptionParser
    def initialize(data_folder = '.')
      @dry_run = false
      @cache_folder_path = File.expand_path("#{data_folder}/certificates/")
      @parser = ::OptionParser.new(&options_block)
    end

    def parse!(arguments)
      @parser.parse!(arguments)

      {
        dry_run: @dry_run,
        filename_pattern: @filename_pattern,
        cache_folder_path: @cache_folder_path
      }
    end

    def help
      @parser.help
    end

    private

    def options_block
      lambda do |opts|
        opts.banner = banner_message
        opts.separator ''
        specific_options(opts)
        opts.separator ''
        common_options(opts)
      end
    end

    def specific_options(opts)
      opts.separator 'Specific options:'
      opts.on('--[no-]cache [PATH]', cache_message) do |path|
        @cache_folder_path = cache_folder_for(path)
      end

      opts.on('--filename [name_pattern]', filename_message) do |name_pattern|
        @filename_pattern = name_pattern
      end

      opts.on('--dry-run', dry_run_message) { @dry_run = true }
    end

    def cache_folder_for(path)
      return nil if path == false

      return path unless path.nil?

      @cache_folder_path
    end

    def banner_message
      <<-USAGE
  Usage: bundle exec ruby #{$PROGRAM_NAME} data_folder [options]


  The data folder should contain 3 files:
  \t* data.csv -- A CSV file containing the attendee's list with their names, emails and presence.
  \t* model.svg -- An SVG model file which will be interpreted to generate the PDF for each attendee.
  \t* email.md.erb -- A Markdown file with ERB tags. The tags will be interpreted with an attendee model. The generated markdown will compose the email's body in plain text, it's HTML version interpreted by Markdown and the email subject as the first line of that body.
      USAGE
    end

    def cache_message
      <<-CACHE_MESSAGE
  Cache generated PDFs in PATH. If PATH is not specified, save them in a folder called certificates in the folder specified as data
      CACHE_MESSAGE
    end

    def filename_message
      <<-FILENAME_MESSAGE
  Generates PDF filenames with the given name-pattern. For every chunk of the name pattern (separated by '-'), we will try to replace that chunk with the matching CSV column. For instance, for a CSV with columns 'First name' and 'Last name' and a pattern of 'Certificate-First name-Last name' the PDF filename for a row with value 'Attendee' for column 'First name' and 'One' for column 'Last name', the resulting PDF filename will be 'Certificate-Attendee-One.pdf'. Defaults to simply the row number like '1.pdf'.
      FILENAME_MESSAGE
    end

    def common_options(opts)
      opts.separator 'Common options:'

      opts.on_tail('-h', '--help', '--usage', 'Show this message and quit.') do
        puts opts.help
        exit
      end

      opts.on_tail('-v', '--version', 'Show current version') do
        puts Certifier::VERSION::STRING
        exit
      end
    end

    def dry_run_message
      "Generate certificate PDFs but don't send them."
    end
  end
end
