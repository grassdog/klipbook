module Colours
  GREEN = "\033[32m"
  YELLOW = "\033[33m"

  def self.green(message)
    colorize(message, GREEN)
  end

  def self.yellow(message)
    colorize(message, YELLOW)
  end

  def self.colorize(message, color)
    "#{color}#{message}\033[0m"
  end
end
