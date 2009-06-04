Feature: Run remote features

  As a developer
  I want to run Cucumber features from a remote location
  So that the features can be authored using a separate tool
    
  Scenario: Run all remote features

    Given that a feature server is running
    When I run all remote features
    Then a report will be produced containing all remote features

  Scenario: Run a single remote feature

    Given that a feature server is running
    When I run a single remote feature
    Then a report will be produced containing only the nominated feature

  Scenario: Nominated feature does not exist

    Given that a feature server is running
    When I run a single remote feature that does not exist
    Then an error message will be displayed stating that the feature was not found

  Scenario: Feature server not running

    Given that a feature server is not running
    When I run all remote features
    Then an error message will be displayed stating that the feature server could not be reached