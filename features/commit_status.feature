Feature: hub commit-status
  Background:
    Given I am in "dotfiles" git repo
    And the "origin" remote has url "git://github.com/evilchelu/dotfiles.git"
    And I am "mislav" on github.com with OAuth token "OTOKEN"

  Scenario: Non-GitHub repo
    Given the "origin" remote has url "mygh:Manganeez/repo.git"
    When I run `hub commit-status --fetch`
    Then the stderr should contain "Aborted: the origin remote doesn't point to a GitHub repository.\n"
    And the exit status should be 1

  Scenario: Get cached commit status of HEAD
    Given the local commit state of "HEAD" is "success"
    When I successfully run `hub commit-status`
    Then the stdout should contain "success"
    And the exit status should be 0

  Scenario: Get cached commit status of a ref
    Given there is a commit named "badf00d"
    Given the local commit state of "badf00d" is "failure"
    When I successfully run `hub commit-status badf00d`
    Then the stdout should contain "failure"
    And the exit status should be 0

  Scenario: Get cached commit status of non-existent hash
    Given there is a commit named "cafebabe"
    Given the local commit state of "cafebabe" is nil
    When I run `hub commit-status cafebabe`
    Then the stdout should contain exactly:
      """
      """
    And the exit status should be 1

  Scenario: Get commit status of HEAD
    Given the local commit state of "HEAD" is nil
    Given the remote commit state of "evilchelu/dotfiles" "HEAD" is "success"
    When I successfully run `hub commit-status --fetch`
    Then the stdout should contain "success"
    And the exit status should be 0
    And the local commit state of "HEAD" should be "success"

  Scenario: Get commit status of hash
    Given there is a commit named "badf00d"
    Given the local commit state of "badf00d" is nil
    Given the remote commit state of "evilchelu/dotfiles" "badf00d" is "failure"
    When I successfully run `hub commit-status --fetch badf00d`
    Then the stdout should contain "failure"
    And the exit status should be 0
    And the local commit state of "badf00d" should be "failure"

