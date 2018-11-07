Feature: klipbook outputs clippings from a clippings file into a JSON file
  As an avid reader and note taker
  I want to see a JSON summary for each of the books that I've read
  So that I can export them to other tools for my enjoyment

  Scenario: File with clippings for a book
    Given a directory named "output"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "3" books from the file "input.txt" as "json" to the output directory "output"
    Then I should find a "json" file in the folder "output" named "Lean Software Development An Agile Toolkit.json" that contains "13" clippings
    Then I should find a "json" file in the folder "output" named "Instapaper Long Reads.json" that contains "4" clippings
    Then I should find a "json" file in the folder "output" named "Clean Code A Handbook of Agile Software Craftsmanship.json" that contains "3" clippings
    And the exit status should be 0

  Scenario: Attempting to write to an existing file
    Given a directory named "output"
    And a file in "output" named "Clean Code A Handbook of Agile Software Craftsmanship.json"
    And a file that contains clippings for 3 books called "input.txt"
    When I export clippings for "3" books from the file "input.txt" as "json" to the output directory "output"
    Then the output should contain "- Skipping Clean Code A Handbook of Agile Software Craftsmanship.json"
    And the exit status should be 0
