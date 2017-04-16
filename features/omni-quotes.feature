Feature: Display Random quote
  In order to be inspired
  As a iddle emacs user
  I want to do have quotes display

  Scenario: Turn on quotes mode
     When I call "omni-quotes-mode"
     Then I should see message "Omni-Quotes mode enabled"

  Scenario: Turn off quotes mode
     When I call "omni-quotes-mode"
     And  I call "omni-quotes-mode"
     Then I should see message "Omni-Quotes mode disabled"

  Scenario: Ask for quotes
    When I call "omni-quotes-display-random-quote"
    Then I should see a quote
