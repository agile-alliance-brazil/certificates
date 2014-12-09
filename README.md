Certificates generation and mailer
==================================

This is a small helper script to generate and send attendees a certificate PDF based on an SVG and a CSV and a couple properties in JSON format.

Prerequisite
============

In order to run this script you need [ruby 1.8.7](http://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.zip) installed and [bundler](http://bundler.io/).

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

