module Klipbook
  class Logger
    def initialize(stdout=$stdout, stderr=$stderr)
      @stdout, @stderr = stdout, stderr
    end

    def info(msg)
      @stdout.puts msg
    end

    def error(msg)
      @stderr.puts msg
    end
  end
end
