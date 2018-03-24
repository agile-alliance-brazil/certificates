# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'certificator/version'

Gem::Specification.new do |spec|
  spec.name          = 'certificator'
  spec.version       = Certificator.version
  spec.authors       = ['Hugo Corbucci']
  spec.email         = ['sistemas@agilebrazil.com']

  spec.summary       = <<-SUMMARY
  Small helper script to generate and send attendees certificate PDFs.
SUMMARY
  spec.homepage      = 'https://github.com/agile-alliance-brazil/certificates'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
