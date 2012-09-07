Feature: klipbook collates the clippings from a clippings file
  As an avid reader and note taker
  I want to see a pretty html collation for books that I've read
  So that I can refer to a nice summary of passages I enjoyed in the book

  Scenario: File with clippings for a book
    Given a directory named "output"
    And a file that contains clippings for 3 books called "input.txt"
    When I collate clippings for "3" books from the file "input.txt" to the output directory "output"
    Then I should find a file in the folder "output" named "Lean Software Development: An Agile Toolkit by Mary Poppendieck and Tom Poppendieck.html" that contains "13" clippings
    Then I should find a file in the folder "output" named "Instapaper: Long Reads by Instapaper: Long Reads.html" that contains "4" clippings
    Then I should find a file in the folder "output" named "Clean Code: A Handbook of Agile Software Craftsmanship by Robert C. Martin.html" that contains "3" clippings

  Scenario: Attempting to write to an existing file
    Given a directory named "output"
    And a file in "output" named "Clean Code: A Handbook of Agile Software Craftsmanship by Robert C. Martin.html"
    And a file that contains clippings for 3 books called "input.txt"
    When I collate clippings for "3" books from the file "input.txt" to the output directory "output"
    Then the output should contain "Skipping Clean Code: A Handbook of Agile Software Craftsmanship by Robert C. Martin.html"

  Scenario: Force overwrite of an existing file
    Given a directory named "output"
    And a file in "output" named "Clean Code: A Handbook of Agile Software Craftsmanship by Robert C. Martin.html"
    And a file that contains clippings for 3 books called "input.txt"
    When I collate clippings for "3" books from the file "input.txt" to the output directory "output" forcefully
    Then the output should contain "Writing Clean Code: A Handbook of Agile Software Craftsmanship by Robert C. Martin.html"

  Scenario: Site with clippings for a book
    Given a directory named "output"
    When I collate clippings for "1" books from the kindle site to the output directory "output"
    Then I should find "1" collated files in the directory "output" that contains clippings
