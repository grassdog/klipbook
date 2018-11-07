Feature: klipbook outputs clippings from a clippings file into a Markdown file
  As an avid reader and note taker
  I want to see a Markdown summary for each of the books that I've read
  So that I can export them to other tools for my enjoyment

  Scenario: File with clippings for a book
    Given a directory named "output"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "3" books from the file "input.txt" as "markdown" to the output directory "output"
    Then I should find a "markdown" file in the folder "output" named "Lean Software Development An Agile Toolkit.md" that contains "13" clippings
    Then I should find a "markdown" file in the folder "output" named "Instapaper Long Reads.md" that contains "4" clippings
    Then I should find a "markdown" file in the folder "output" named "Clean Code A Handbook of Agile Software Craftsmanship.md" that contains "3" clippings
    And the exit status should be 0

  Scenario: Attempting to write to an existing file
    Given a directory named "output"
    And a file in "output" named "Clean Code A Handbook of Agile Software Craftsmanship.md"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "3" books from the file "input.txt" as "markdown" to the output directory "output"
    Then the output should contain "- Skipping Clean Code A Handbook of Agile Software Craftsmanship.md"
    And the exit status should be 0
