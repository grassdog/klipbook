# encoding: utf-8
require 'klipbook/blank'
require 'klipbook/version'

require 'klipbook/sources/kindle_device/file_parser'
require 'klipbook/sources/kindle_device/entry_parser'
require 'klipbook/sources/kindle_device/entry'
require 'klipbook/sources/kindle_device/file'

require 'klipbook/sources/amazon_site/scraper'
require 'klipbook/sources/amazon_site/book_scraper'

require 'klipbook/invalid_source_error'
require 'klipbook/config'
require 'klipbook/book'
require 'klipbook/clipping'

require 'klipbook/fetcher'
require 'klipbook/collator'
require 'klipbook/printer'

require 'klipbook/output/html_summary_writer'
require 'klipbook/output/book_helpers'
