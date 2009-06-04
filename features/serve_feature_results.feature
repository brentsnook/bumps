Feature: Serve feature results

  As a remote feature authoring tool
  I want to read the results of a feature run
  So that I can format my local feature data accordingly
    
  Scenario: Serve all feature results after a run

    Given that a feature run has already been performed
    And that the result server is running
    When a client requests all feature results
    Then the results of the feature run will be sent

  Scenario: Serve a single feature's results after a run

    Given that a feature run has already been performed
    And that the result server is running
    When a client requests the results for a single feature
    Then only the results of the nominated feature will be sent

  Scenario: Serve empty results if there has not been a run

    Given that no feature run has been performed
    And that the result server is running
    When a client requests all feature results
    Then empty results will be sent