Feature: Pull remote features

  As a developer
  I want to pull Cucumber features from a remote location
  So that the features can be authored using a separate tool
    
  Scenario: Pull all remote features

    Given that a feature server is running
    When I pull all remote features
    Then the feature directory will contain all remote features

  Scenario: Feature server not running

    Given that a feature server is not running
    When I pull all remote features
    Then an error message will be displayed stating that the feature server could not be reached