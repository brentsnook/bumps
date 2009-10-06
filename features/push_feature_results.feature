Feature: Serve feature results

  As a remote feature authoring tool
  I want to be informed of the results of a feature run
  So that I can format my local feature data accordingly
    
  Scenario: Push all feature results after a run
    Given that a feature server is running
    When a cucumber run is performed
    Then the results of the feature run will be sent to the feature server

  Scenario: Feature server not reachable
    Given that a feature server is not running
    When a cucumber run is performed
    Then the command output should show that features could not be pushed