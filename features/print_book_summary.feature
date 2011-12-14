Feature: klipbook outputs a pretty summary of the clippings for a book
  As an avid reader and note taker
  I want to see a pretty summary file of the clippings for a book
  So that I can read a nice summary of my clippings for a book I've read

  Scenario: File with clippings for a book
    Given I have a file that contains multiple clippings for the book titled "The life of dogs"
    When I print the summary for book number "1" with klipbook
    Then I should see a pretty summary for the book "The life of dogs"

