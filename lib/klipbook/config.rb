module Klipbook
  class Config
    def initialize(config_file_name='.klipbookrc')
      @config_file_name = config_file_name
    end

    def read
      merge_config_from_rc_file({})
    end

    def merge_config_from_rc_file(config)
      config_file = File.join(File.expand_path(ENV['HOME']), @config_file_name)

      if config_file && File.exist?(config_file)
        require 'yaml'
        config.merge!(File.open(config_file) { |file| YAML::load(file) })
      end

      config
    end
  end
end
