Feature: Serve feature results

  As a remote feature authoring tool
  I want to be informed of the results of a feature run
  So that I can format my local feature data accordingly
    
  Scenario: Push all feature results after a run

    Given that a feature run has already been performed
    And that the result server is running
    When a client requests all feature results
    Then the results of the feature run will be sent