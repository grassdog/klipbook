Feature: klipbook lists the books in a clipping file
  As an avid reader and note taker
  I want to be shown an indexed list of books
  So that I can see which books are available for collation

  Scenario: Empty file
    Given I have a clippings file "input.txt" that contains no clippings
    When I list "1" books in the file "input.txt"
    Then the output should contain "No books available"

  Scenario: File with one book
    Given a file that contains clippings for 3 books called "input.txt"
    When I list "5" books in the file "input.txt"
    Then the output should contain "[1] Clean Code: A Handbook of Agile Software Craftsmanship by Robert C. Martin"
    Then the output should contain "[2] Lean Software Development: An Agile Toolkit by Mary Poppendieck and Tom Poppendieck"
    Then the output should contain "[3] Instapaper: Long Reads by Instapaper: Long Reads"

  Scenario: Site with one book
    When I list "1" books from the kindle site
    Then the output should match /[1] .+ by .+/

