Feature: klipbook lists the books in a clipping file
  As an avid reader and note taker
  I want to be shown an indexed list of books in my clipping file
  So that I can choose which book I want to extract a pretty collated list of notes from

  Scenario: Empty file
    Given I have a file that contains no clippings
    When I list the books in the file with klipbook
    Then I should see the message "Your clippings file contains no books"

  Scenario: File with one book
    Given I have a file that contains clippings for the book titled "The life of dogs"
    When I list the books in the file with klipbook
    Then I should see the message "The list of books in your clippings file:"
    And I should see the message "[1] The life of dogs"

  Scenario: File with two books
    Given I have a file that contains clippings for the book titled "The life of dogs"
    And I have a file that contains clippings for the book titled "A hard day's night"
    When I list the books in the file with klipbook
    Then I should see the message "The list of books in your clippings file:"
    And I should see the message "[1] A hard day's night"
    And I should see the message "[2] The life of dogs"
