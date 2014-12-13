#encoding: UTF-8
require 'optparse'
require_relative '../version.rb'

class CertificateOptionParser
  def initialize
    @dry_run = false
    @certificate_path = File.expand_path('../../config/certificate.json', File.dirname(__FILE__))
    @smtp_settings_path = File.expand_path('../../config/smtp.json', File.dirname(__FILE__))
    @cache_folder_path = File.expand_path('../../certificates/', File.dirname(__FILE__))
    @parser = OptionParser.new{ |opts| options_block.call(opts) }
  end

  def parse!(arguments)
    @parser.parse!(arguments)

    {
      dry_run: @dry_run,
      certificate_config_path: @certificate_path,
      smtp_settings_path: @smtp_settings_path,
      cache_folder_path: @cache_folder_path
    }
  end
  def help
    @parser.help
  end
  private
  def options_block
    -> (opts) {
      opts.banner = "Usage: bundle exec ruby #{$0} csv-filename.csv svg-model-filename.svg [options]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on("--[no-]cache [PATH]",
        "Cache generated PDFs in PATH. If PATH is not specified, save them in a folder called certificates in the current directory") do |path|
        if path == false
          @cache_folder_path = nil
        elsif !path.nil?
          @cache_folder_path = path
        end
      end

      opts.on("--dry-run",
        "Generate certificate PDFs but don't send them.") do
        @dry_run = true
      end

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail("-h", "--help", "--usage", "Show this usage message and quit.") do |setting|
        puts opts.help
        exit
      end

      opts.on_tail("-v", "--version", "Show current version") do
        puts Certifier::VERSION::STRING
        exit
      end
    }
  end
end
