Feature: Run features via Rake

  As a developer
  I want to run remote features using Rake
  So that I can run the features as part of my continuous integration build
    
  Scenario: Run all features via Rake

    Given that a feature server is running
    When I run all remote features as a Rake task
    Then a report will be produced containing all remote features