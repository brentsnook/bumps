Feature: Run remote features

  As a developer
  I want to run Cucumber features from a remote location
  So that the features can be authored using a separate tool
    
  Scenario: Run all remote features

    Given that a feature server is running
    When I run all remote features
    Then a report will be produced containing all remote features