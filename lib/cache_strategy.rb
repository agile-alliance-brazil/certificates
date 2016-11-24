# encoding:UTF-8
require 'fileutils'

# Decides which cache to use based on a given path
module CacheStrategy
  def self.build_from(path = nil)
    if path
      PDFCache.new(path)
    else
      NoCache.new
    end
  end

  # Caches PDFs into a cache folder
  class PDFCache
    def initialize(cache_path)
      @path = cache_path
    end

    def cache(certificate)
      FileUtils.mkdir_p @path unless Dir.exist?(@path)

      certificate_path = File.expand_path(certificate.filename, @path)
      File.open(certificate_path, 'w') { |f| f.write certificate.pdf }
    end
  end

  # Does not cache certificates at all
  class NoCache
    def cache(certificate)
    end
  end
end
