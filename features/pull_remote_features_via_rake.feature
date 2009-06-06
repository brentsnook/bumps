Feature: Pull remote features via Rake

  As a developer
  I want to pull remote features using Rake
  So that I can run the features as part of my continuous integration build
    
  Scenario: Pull all features via Rake

    Given that a feature server is running
    When I pull all remote features as a Rake task
    Then all remote features will be written to the feature directory