require "commander"

module Klipbook
  class CLI
    include Commander::Methods

    def initialize(config=Klipbook::Config.new)
      @config = config.read
    end

    def execute!
      program :name, 'Klipbook'
      program :version, Klipbook::VERSION
      program :description, "Klipbook exports the clippings you've saved on your Kindle into JSON, Markdown, or pretty HTML"

      program :help, 'Source', "You must specify either `--from-file` or `--from-site` as an input."
      program :help, 'Config', "Note that command options can be stored in a file called ~/.klipbookrc. This file is YAML formatted and options should be snake case e.g.\n\n" +
        ":from_site: my-kindle-user@blah.com:my-kindle-password\n" +
        ":output_dir: ~/my/default/output/directory\n"

      default_command :help

      command :list do |c|
        c.syntax = "klipbook list"
        c.description = "List the books on the site or in the clippings file"

        c.option '--from-file FILE', String, "Input clippings file"
        c.option '--from-site username:password', String, "Credentials for Kindle highlights site"
        c.option '-c', '--count COUNT', Integer, "Maximum number of books to list (default is #{Config::DEFAULT_MAXBOOKS})"

        c.action do |_args, options|
          merge_config(options, @config)

          Klipbook::Commands::List.new.run!(options)
        end
      end

      command :export do |c|
        c.syntax = 'klipbook export'
        c.description = 'Export book clippings'

        c.option '--from-file FILE', String, "Input clippings file"
        c.option '--from-site username:password', String, "Credentials for Kindle highlights site"
        c.option '-c', '--count COUNT', Integer, "Maximum number of books to list (default is #{Config::DEFAULT_MAXBOOKS})"
        c.option '--format FORMAT', "Format to export in [html, markdown, or json]"
        c.option '--output-dir DIRECTORY', "Directory to export files to (default pwd)"
        c.option '-f', '--force', "Force overwrite of existing files"

        c.action do |_args, options|
          merge_config(options, @config)

          Klipbook::Commands::Export.new.run!(options)
        end
      end

      run!
    end

    private

    def merge_config(options, config)
      if options.from_site || options.from_file
        [:from_site, :from_file].each { |key| config.delete(key) }
      end

      options.default config
    end
  end
end
