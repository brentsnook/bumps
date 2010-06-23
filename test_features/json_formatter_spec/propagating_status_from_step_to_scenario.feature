@id:propagating_status_from_step_to_scenario
Feature: Feature

  Scenario: passed
    Given I passed
    
  Scenario: failed
    Given I failed
    And I passed
    
  Scenario: pending
    Given I am pending
  
  Scenario: undefined
    Given I am undefined
    
  Scenario: skipped
    Given I failed
    And I passed
  