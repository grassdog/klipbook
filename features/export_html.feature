Feature: klipbook outputs the clippings from a clippings file into a set of HTML files
  As an avid reader and note taker
  I want to see a pretty html summary for each of the books that I've read
  So that I can refer to a nice summary of passages I enjoyed in the book

  Scenario: File with clippings for a book
    Given a directory named "output"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "3" books from the file "input.txt" as "html" to the output directory "output"
    Then I should find a "html" file in the folder "output" named "Lean Software Development An Agile Toolkit.html" that contains "13" clippings
    Then I should find a "html" file in the folder "output" named "Instapaper Long Reads.html" that contains "4" clippings
    Then I should find a "html" file in the folder "output" named "Clean Code A Handbook of Agile Software Craftsmanship.html" that contains "3" clippings
    And the exit status should be 0

  Scenario: Attempting to write to an existing file
    Given a directory named "output"
    And a file in "output" named "Clean Code A Handbook of Agile Software Craftsmanship.html"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "3" books from the file "input.txt" as "html" to the output directory "output"
    Then the output should contain "- Skipping Clean Code A Handbook of Agile Software Craftsmanship.html"
    And the exit status should be 0

  Scenario: Force overwrite of an existing file
    Given a directory named "output"
    And a file in "output" named "Clean Code A Handbook of Agile Software Craftsmanship.html"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "3" books from the file "input.txt" as "html" to the output directory "output" forcefully
    Then the output should contain "+ Writing Clean Code A Handbook of Agile Software Craftsmanship.html"
    And the exit status should be 0

  Scenario: Attempt to write with a bad number of books
    Given a directory named "output"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "notanumber" books from the file "input.txt" as "html" to the output directory "output"
    Then the output should contain "invalid argument: -c notanumber"
    And the exit status should be non-zero

  Scenario: Attempt to write to a non-existent directory
    Given there is not a directory named "output"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "3" books from the file "input.txt" as "html" to the output directory "output"
    Then the output should contain "Error: Output directory 'output' does not exist."
    And the exit status should be non-zero
