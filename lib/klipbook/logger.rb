module Klipbook
  class Logger
    def initialize(stdout=$stdout, stderr=$stderr)
      @stdout, @stderr = stdout, stderr
    end
    
    def info
    end

    def error
    end
  end
end
