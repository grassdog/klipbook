class InvalidSourceError < RuntimeError

  DEFAULT_MESSAGE = "Please provide a valid source.\n" +
                    "e.g.\n" +
                    "     file:path/to/my-clippings-file.txt\n" +
                    "     site:my-kindle-user@blah.com:my-kindle-password"

  def initialize(msg = DEFAULT_MESSAGE)
    super
  end
end

