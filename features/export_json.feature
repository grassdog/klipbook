Feature: klipbook outputs clippings from a clippings file into a JSON file
  As an avid reader and note taker
  I want to see a single JSON file collating the clippings of the books that I've read
  So that I can export them to other tools for my enjoyment

  Scenario: File with clippings for a book
    Given a file that contains clippings for 3 books called "input.txt"
    When I tojson clippings for "3" books from the file "input.txt" to the output file "books.json"
    Then I should find a file called "books.json" that contains "Lean Software Development: An Agile Toolkit"
    And the exit status should be 0

