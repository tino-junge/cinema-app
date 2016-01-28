Feature: Validate configuration file and give helpful error messages
  As a movie producer who wants to change the structure of the interactive movie
  I want to see friendly error messages if my configuration file is invalid
  So I know immediately what I've done wrong and I can fix it


  @aruba
  Scenario: Empty config file is invalid
    Given I have an empty config.yml
    When I try to start the server
    Then I should see an error message on the command line like this:
    """
    Configuration file is invalid: Please add a key 'video'.
    """

  @aruba
  Scenario: Every node must have a video file
    Given I have this config.yml
    """
    video:
      v1:
        question: 'Some irrelevant question'
    """
    When I try to start the server
    Then I should see an error message on the command line like this:
    """
    Node v1: No video file!
    """

  @aruba
  Scenario: Corresponding files must exist
    Given I have this config.yml
    """
    video:
      v1:
        file: 'somevideo.mp4'
    """
    And there is no file in 'app/public/videos/somevideo.mp4'
    When I try to start the server
    Then I should see an error message on the command line like this:
    """
    Node v1: No corresponding file
    """
    And the error messages tells the path of the missing file:
    """
    public/videos/somevideo.mp4
    """

  @aruba
  Scenario: Loops are not allowed
    Given I have this config.yml
    """
    video:
      v1:
        file: 'somevideo1.mp4'
        question: 'Do you want to see Video 2?'
        answers:
          a: 'Yes'
          b: 'Yes'
        sequels:
          a: 'v2'
          b: 'v2'
      v2:
        file: 'somevideo2.mp4'
        question: 'Do you want to see Video 1?'
        answers:
          a: 'Yes'
          b: 'Yes'
        sequels:
          a: 'v1'
          b: 'v1'
    """
    And there is a file in 'app/public/videos/somevideo1.mp4'
    And there is a file in 'app/public/videos/somevideo2.mp4'
    When I try to start the server
    Then I should see an error message on the command line like this:
    """
    Node v1: Detected a loop v1->v2->v1
    """

  @aruba
  Scenario: Backtracking the graph should also remove items from the loop buffer
    Given I have this config.yml
    """
    video:
      v1:
        file: 'somevideo1.mp4'
        question: 'Do you want to see Video 2?'
        answers:
          a: 'Sure'
          b: 'Nah'
        sequels:
          a: 'v2'
          b: 'v3'
      v2:
        file: 'somevideo2.mp4'
        question: 'Do you want to see Video 3?'
        answers:
          a: 'Well then...'
        sequels:
          b: 'v3'
      v3:
        file: 'somevideo3.mp4'
        question: 'The end!'
        answers:
          a: 'OK'
          b: 'Cool'
    """
    And there is a file in 'app/public/videos/somevideo1.mp4'
    And there is a file in 'app/public/videos/somevideo2.mp4'
    And there is a file in 'app/public/videos/somevideo3.mp4'
    When I try to start the server
    Then I there are no error messages and the server is going to start
