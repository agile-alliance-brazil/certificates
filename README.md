Certificates generation and mailer [![Build Status](https://circleci.com/gh/agile-alliance-brazil/certificates.svg?style=svg)](https://circleci.com/gh/agile-alliance-brazil/certificates) [![Dependency Status](https://gemnasium.com/agile-alliance-brazil/certificates.svg)](https://gemnasium.com/agile-alliance-brazil/certificates) [![Code Climate](https://codeclimate.com/github/agile-alliance-brazil/certificates/badges/gpa.svg)](https://codeclimate.com/github/agile-alliance-brazil/certificates) [![Test Coverage](https://codeclimate.com/github/agile-alliance-brazil/certificates/badges/coverage.svg)](https://codeclimate.com/github/agile-alliance-brazil/certificates)
==================================

This is a small helper script to generate and send attendees a certificate PDF based on an SVG, a CSV and an email template.

Prerequisite
============

In order to run this script you need [ruby 2.3.1](http://www.ruby-lang.org/).

How to Use
==========

Download the [project's ZIP](https://github.com/agile-alliance-brazil/certificates/archive/master.zip) or clone the project somewhere:

```
git clone https://github.com/agile-alliance-brazil/certificates.git
```

In the root folder, run:

```
./setup.sh
```

This will create a .env file in that same folder. Open it and edit the values to match your needs. Copy the example folder into your own (let's say "example"), change the contents to match your attendees (in a CSV file called data.csv inside that folder), your certificate's svg (called model.svg in that folder) and an email template in markdown (called email.md.erb). Then run:

```
bundle exec ruby ./bin/generate_certificates example --dry-run
```

This should generate the certificates for you and just print what action would be taken (not actually sending the emails). It'll cache the generated certificate PDFs in a folder called certificates in your data directory. Check the `--cache` option for details on that.

Your CSV file needs to have headers and you can use those headers to map values into your SVG and into the certificate PDF filename. Your CSV MUST have a header called 'email'. For the next couple paragraph, consider a CSV like:

```
First name,Last name,email
Attendee,One,attendee.one@yourconf.org
```

You can also provide a `--filename` option with a text pattern for every PDF's file name to be generated. This filename pattern can contain the exact same text of one (or more) of the columns of your CSV file and those will get replaced to generate the PDF file name for each attendant. So for the CSV above, you can specify `--filename "Certificate-First name-Last email"` would generate a PDF certificate named `Certificate-Attendee-One.pdf` for this first attendee. All attendees also have a magical `id` field (unless your own CSV has such field) you can use that represents the row number that they represent. So for the CSV above, `--filename "Certificate-First name-Last email-id"` would generate `Certificate-Attendee-One-1.pdf`.

Now, when it comes to the SVG, you can simply add text elements with `<field name>` where `field name` corresponds to the column in your CSV you want to show. For instance, using the CSV above, if your SVG contains have text elements like `<First name>` and `<Last name>`, those contents will get replaced with the results of each row corresponding to those columns.

Once you're happy with the results, just run the same thing without the `--dry-run` option.

PDF Convertion
==============

If you want to use [Inkscape](http://www.inkscape.org) to generate your PDFs, ensure you have either INKSCAPE_PATH in your .env file or defined as an environment variable. Otherwise, we will use [prawn-svg](https://github.com/mogest/prawn-svg) to convert from SVG to PDF which may have different results than Inkscape (notably, won't convert flowRoot elements, those have to be transformed into text elements and won't have access to unix/X11 fonts).

Another important difference is that Inkscape will use your system fonts to render the PDF. Prawn won't. To compensate for that, you can drop TTF files in the folder that holds your SVG file and prawn will embed the fonts it needs from those. Note that the fonts filenames must match the font family name appended with a dash and the font style name. For example, to load 'font-family:Montserrat;font-weigth:bold;', you need to have a 'Montserrat-bold.ttf' file in the same folder as your SVG.

Development
===========

You can start guard with `./dev.sh` or just run all tests with `./setup.sh && bundle exec rake`.
