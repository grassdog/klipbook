require 'yaml'

module Klipbook
  class Config
    DEFAULT_MAXBOOKS=5

    def read
      merge_config_from_rc_file({
        count: DEFAULT_MAXBOOKS,
        output_dir: Dir.pwd,
        force: false
      })
    end

    private

    def merge_config_from_rc_file(config)
      config.merge(file_config)
    end

    def file_config
      config_file = File.expand_path("~/.klipbookrc")
      if File.exist?(config_file)
        YAML.load(File.read(config_file))
      else
        {}
      end
    end
  end
end
