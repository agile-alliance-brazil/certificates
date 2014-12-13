#encoding: UTF-8
class CertificateOptionParser
  def initialize
    @dry_run = false
    @certificate_path = File.expand_path('../../config/certificate.json', File.dirname(__FILE__))
    @smtp_settings_path = File.expand_path('../../config/smtp.json', File.dirname(__FILE__))
    @certificates_folder_path = File.expand_path('../../certificates/', File.dirname(__FILE__))
    @parser = OptionParser.new{ |opts| options_block.call(opts) }
  end

  def parse!(arguments)
    @parser.parse!(arguments)

    {
      dry_run: @dry_run,
      certificate_config_path: @certificate_path,
      smtp_settings_path: @smtp_settings_path,
      certificates_folder_path: @certificates_folder_path
    }
  end
  def help
    @parser.help
  end
  private
  def options_block
    -> (opts) {
      opts.banner = "Usage: bundle exec ruby #{$0} csv-filename.csv svg-model-filename.svg [--dry-run] [-h]"

      opts.on("--dry-run",
        "Generate certificate PDFs but don't send them via email.") do
        @dry_run = true
      end

      opts.on_tail("-h", "--help", "--usage", "Show this usage message and quit.") do |setting|
        puts opts.help
        exit
      end
    }
  end
end
