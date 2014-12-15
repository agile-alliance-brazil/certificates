#encoding: UTF-8
require 'optparse'
require_relative '../version.rb'

class CertificateOptionParser
  def initialize
    @dry_run = false
    @cache_folder_path = File.expand_path('./certificates/')
    @parser = OptionParser.new{ |opts| options_block.call(opts) }
  end

  def parse!(arguments)
    @parser.parse!(arguments)

    {
      dry_run: @dry_run,
      filename_prefix: @filename_prefix,
      cache_folder_path: @cache_folder_path
    }
  end
  def help
    @parser.help
  end
  private
  def options_block
    -> (opts) {
      opts.banner = "Usage: bundle exec ruby #{$0} data_folder [options]\n\n" +
        "The data folder should contain 3 files:\n" +
        "* data.csv -- A CSV file containing the attendee's list with their names, emails and presence.\n" +
        "* model.svg -- An SVG model file which will be interpreted to generate the PDF for each attendee.\n" +
        "* email.md.erb -- A Markdown file with ERB tags. The tags will be interpreted with an attendee model. The generated markdown will compose the email's body in plain text, it's HTML version interpreted by Markdown and the email subject as the first line of that body.\n"

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

      opts.on("--prefix [PREFIX]",
        "Generates PDF filenames with the given prefix. If prefix is 'Certificado-AB2014-', the PDF filename will be 'Certificado-AB2014-AttendeeName.pdf' for an attendee named 'Attendee Name'. Defaults to empty therefore generating 'AttendeeName.pdf'.") do |prefix|
        @filename_prefix = prefix
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
