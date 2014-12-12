Certificates generation and mailer [![Build Status](https://snap-ci.com/agile-alliance-brazil/certificates/branch/master/build_image)](https://snap-ci.com/agile-alliance-brazil/certificates/branch/master) [![Dependency Status](https://gemnasium.com/agile-alliance-brazil/certificates.svg)](https://gemnasium.com/agile-alliance-brazil/certificates) [![Code Climate](https://codeclimate.com/github/agile-alliance-brazil/certificates/badges/gpa.svg)](https://codeclimate.com/github/agile-alliance-brazil/certificates) [![Test Coverage](https://codeclimate.com/github/agile-alliance-brazil/certificates/badges/coverage.svg)](https://codeclimate.com/github/agile-alliance-brazil/certificates)
==================================

This is a small helper script to generate and send attendees a certificate PDF based on an SVG and a CSV and a couple properties in JSON format.

Prerequisite
============

In order to run this script you need [ruby 2.1.5+](http://www.ruby-lang.org/) installed and [bundler](http://bundler.io/).

How to Use
==========

Ensure you created a .env file at the root of the repo copying .env.example. Add your data in there.

Create a copy of each .example file without the .example extension and fill in your data.

Then run (in the project's root folder):

```
bundle install
```

And:

```
bundle exec ruby ./lib/certificate.rb your-csv-filename.csv your-svg-model-filename.svg --dry-run
```

This should generate the certificates for you and just print what action would be taken (not actually sending the emails). Once you're happy with the results, just run the same thing without the '--dry-run' option.

Development
===========

You can start guard with ``dev.sh`` or just run all tests with ``bundle exec rake``.

