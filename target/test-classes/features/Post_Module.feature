@PostsAPI
Feature: Posts API - CRUD Operations, Filtering, Pagination, and Authorization

  Background:
    Given the base URL is configured
    And the API is accessible
    And a valid authorization token is set in the request header

  # ===========================================================================
  # TS_Post_01 - Create Post (POST /posts)
  # ===========================================================================

  @smoke @positive @TC-001
  Scenario: TC-001 - Successfully create a post with valid user ID and complete payload
    Given a valid user ID "1" exists in the system
    When the user sends a POST request to "/posts" with the following payload:
      | title     | body        | userId |
      | Test Post | Sample body | 1      |
    Then the response status code should be 201
    And the response body should contain a generated post ID
    And the response body should contain "title" as "Test Post"
    And the response body should contain "body" as "Sample body"
    And the response body should contain "userId" as "1"

  @negative @TC-002
  Scenario: TC-002 - Fail to create a post with a non-existing user ID
    Given a non-existing user ID "99999" is prepared
    When the user sends a POST request to "/posts" with the following payload:
      | title     | body        | userId |
      | Test Post | Sample body | 99999  |
    Then the response status code should be 404 or 400
    And the response body should contain an appropriate error message

  @negative @TC-003
  Scenario Outline: TC-003 - Fail to create a post with incorrect or duplicate payload data
    When the user sends a POST request to "/posts" with the following payload:
      | title   | body   | userId   |
      | <title> | <body> | <userId> |
    Then the response status code should be 400
    And the response body should indicate a duplicate or incorrect data issue

    Examples:
      | title | body | userId |
      |       |      | 1      |
      | Duplicate Title | Duplicate Body | 1 |

  @negative @TC-004
  Scenario: TC-004 - Fail to create a post when mandatory fields are missing
    When the user sends a POST request to "/posts" with the following payload:
      | userId |
      | 1      |
    Then the response status code should be 400
    And the response body should contain a validation error for missing fields "title" and "body"

  # ===========================================================================
  # TS_Post_02 - Get Post (GET /posts and GET /posts/{id})
  # ===========================================================================

  @smoke @positive @TC-005
  Scenario: TC-005 - Successfully retrieve a post with a valid post ID
    Given a post with ID "1" exists in the system
    When the user sends a GET request to "/posts/1"
    Then the response status code should be 200
    And the response body should contain the details of post with ID "1"

  @negative @TC-006
  Scenario: TC-006 - Fail to retrieve a post with a non-existing post ID
    Given a non-existing post ID "99999" is prepared
    When the user sends a GET request to "/posts/99999"
    Then the response status code should be 404
    And the response body should contain an appropriate error message

  @smoke @positive @TC-007
  Scenario: TC-007 - Successfully retrieve all posts
    Given a predefined set of posts exists in the system
    When the user sends a GET request to "/posts"
    Then the response status code should be 200
    And the response body should contain a JSON array of all available posts
    And the response body should not be empty

  # ===========================================================================
  # TS_Post_03 - Full Update Post (PUT /posts/{id})
  # ===========================================================================

  @smoke @positive @TC-008
  Scenario: TC-008 - Successfully fully update a post with a valid post ID and complete payload
    Given a post with ID "1" exists in the system
    When the user sends a PUT request to "/posts/1" with the following payload:
      | id | title         | body         | userId |
      | 1  | Updated Title | Updated body | 1      |
    Then the response status code should be 200
    And the response body should reflect the fully updated post data
    And the response body should contain "title" as "Updated Title"
    And the response body should contain "body" as "Updated body"

  @negative @TC-009
  Scenario: TC-009 - Fail to update a post with a non-existing post ID
    Given a non-existing post ID "99999" is prepared
    When the user sends a PUT request to "/posts/99999" with the following payload:
      | title         | body         | userId |
      | Updated Title | Updated body | 1      |
    Then the response status code should be 404
    And the response body should contain an appropriate error message

  @negative @TC-010
  Scenario: TC-010 - Fail to fully update a post with invalid data types in payload
    Given a post with ID "1" exists in the system
    When the user sends a PUT request to "/posts/1" with the following invalid payload:
      | title | body | userId |
      | 12345 | null | abc    |
    Then the response status code should be 400
    And the response body should indicate the invalid data error

  @negative @TC-011
  Scenario: TC-011 - Fail to fully update a post when required fields are missing
    Given a post with ID "1" exists in the system
    When the user sends a PUT request to "/posts/1" with the following payload:
      | userId |
      | 1      |
    Then the response status code should be 400
    And the response body should contain a validation error for missing fields "title" and "body"

  # ===========================================================================
  # TS_Post_04 - Partial Update Post (PATCH /posts/{id})
  # ===========================================================================

  @smoke @positive @TC-012
  Scenario: TC-012 - Successfully partially update a post with a valid post ID
    Given a post with ID "1" exists in the system
    When the user sends a PATCH request to "/posts/1" with the following payload:
      | title                    |
      | Partially Updated Title  |
    Then the response status code should be 200
    And the response body should contain "title" as "Partially Updated Title"
    And the response body should retain all other existing fields unchanged

  @negative @TC-013
  Scenario: TC-013 - Fail to partially update a post with a non-existing post ID
    Given a non-existing post ID "99999" is prepared
    When the user sends a PATCH request to "/posts/99999" with the following payload:
      | title         |
      | Updated Title |
    Then the response status code should be 404
    And the response body should contain an appropriate error message

  @negative @TC-014
  Scenario: TC-014 - Fail to partially update a post with invalid field values
    Given a post with ID "1" exists in the system
    When the user sends a PATCH request to "/posts/1" with the following invalid payload:
      | title |
      | 99999 |
    Then the response status code should be 400
    And the response body should indicate an invalid field value error

  @negative @TC-015
  Scenario: TC-015 - Fail to partially update a post with an empty payload
    Given a post with ID "1" exists in the system
    When the user sends a PATCH request to "/posts/1" with an empty payload
    Then the response status code should be 400
    And the response body should indicate that the payload cannot be empty

  # ===========================================================================
  # TS_Post_05 - Delete Post (DELETE /posts/{id})
  # ===========================================================================

  @smoke @positive @TC-016
  Scenario: TC-016 - Successfully delete a post with a valid post ID
    Given a post with ID "1" exists in the system
    When the user sends a DELETE request to "/posts/1"
    Then the response status code should be 200 or 204
    And the response body should confirm successful deletion

  @negative @TC-017
  Scenario: TC-017 - Fail to delete a post with a non-existing post ID
    Given a non-existing post ID "99999" is prepared
    When the user sends a DELETE request to "/posts/99999"
    Then the response status code should be 404
    And the response body should contain an appropriate error message

  @positive @TC-018
  Scenario: TC-018 - Verify that a deleted post cannot be retrieved
    Given a post with ID "1" has been successfully deleted
    When the user sends a GET request to "/posts/1"
    Then the response status code should be 404
    And the response body should indicate the post no longer exists

  # ===========================================================================
  # TS_Post_06 - Filter Posts (GET /posts?queryParam=value)
  # ===========================================================================

  @smoke @positive @TC-019
  Scenario: TC-019 - Successfully filter posts using a valid userId query parameter
    Given posts with user ID "1" exist in the system
    When the user sends a GET request to "/posts" with query parameter "userId=1"
    Then the response status code should be 200
    And the response body should contain only posts matching "userId" equal to "1"

  @positive @TC-020
  Scenario Outline: TC-020 - Verify filtered results contain only posts for the specified user
    Given posts with user ID "<userId>" exist in the system
    When the user sends a GET request to "/posts" with query parameter "userId=<userId>"
    Then the response status code should be 200
    And every post in the response body should have "userId" equal to "<userId>"

    Examples:
      | userId |
      | 1      |
      | 2      |
      | 3      |

  @negative @TC-021
  Scenario: TC-021 - Handle invalid query parameters gracefully
    When the user sends a GET request to "/posts" with query parameter "invalidParam=abc"
    Then the response status code should be 400 or 200
    And the system should handle the invalid parameter without crashing
    And the response body should contain an empty array or a default result

  @negative @TC-022
  Scenario: TC-022 - Return error for an invalid filter value in query parameter
    When the user sends a GET request to "/posts" with query parameter "userId=xyz"
    Then the response status code should be 400
    And the response body should contain an error message indicating an invalid filter value

  # ===========================================================================
  # TS_Post_07 - Authorization Checks
  # ===========================================================================

  @security @negative @TC-023
  Scenario: TC-023 - Fail to create a post with an invalid or expired authorization token
    Given an invalid or expired authorization token is set in the request header
    When the user sends a POST request to "/posts" with the following payload:
      | title | body | userId |
      | Test  | Body | 1      |
    Then the response status code should be 401
    And the response body should indicate authentication failure

  @security @negative @TC-024
  Scenario Outline: TC-024 - Fail to update a post with an invalid or expired authorization token
    Given an invalid or expired authorization token is set in the request header
    When the user sends a "<method>" request to "/posts/1" with the following payload:
      | title   |
      | Updated |
    Then the response status code should be 401
    And the response body should indicate authentication failure

    Examples:
      | method |
      | PUT    |
      | PATCH  |

  @security @negative @TC-025
  Scenario: TC-025 - Fail to delete a post with an invalid or expired authorization token
    Given an invalid or expired authorization token is set in the request header
    When the user sends a DELETE request to "/posts/1"
    Then the response status code should be 401
    And the response body should indicate authentication failure

  @security @negative @TC-026
  Scenario: TC-026 - Fail to retrieve all posts with an invalid or expired authorization token
    Given an invalid or expired authorization token is set in the request header
    When the user sends a GET request to "/posts"
    Then the response status code should be 401
    And the response body should indicate authentication failure

  # ===========================================================================
  # TS_Post_08 - Pagination (GET /posts with pagination params)
  # ===========================================================================

  @smoke @positive @TC-027
  Scenario: TC-027 - Successfully retrieve posts using default pagination
    Given multiple posts exist in the system
    When the user sends a GET request to "/posts" without any pagination parameters
    Then the response status code should be 200
    And the response body should contain posts using the default page size

  @positive @TC-028
  Scenario: TC-028 - Successfully navigate through pages using the page parameter
    Given multiple pages of posts exist in the system
    When the user sends a GET request to "/posts" with query parameter "page=2"
    Then the response status code should be 200
    And the response body should contain records corresponding to page "2"

  @positive @TC-029
  Scenario Outline: TC-029 - Verify the system returns the correct number of records per page
    Given multiple posts exist in the system
    When the user sends a GET request to "/posts" with query parameter "limit=<limit>"
    Then the response status code should be 200
    And the response body should contain exactly "<limit>" records

    Examples:
      | limit |
      | 5     |
      | 10    |
      | 20    |

  @positive @edge @TC-030
  Scenario: TC-030 - Verify empty response when page number exceeds available data
    Given the total number of posts in the system is known
    When the user sends a GET request to "/posts" with query parameter "page=9999"
    Then the response status code should be 200
    And the response body should contain an empty array or indicate no records found for the requested page

  # ===========================================================================
  # Edge Cases
  # ===========================================================================

  @edge
  Scenario: Verify API handles extremely large input values in title and body fields
    When the user sends a POST request to "/posts" with the following payload:
      | title                                                      | body                                                        | userId |
      | ThisIsAnExtremelyLongTitleWithMoreThanTwoHundredCharacters  | ThisIsAnExtremelyLongBodyFieldThatExceedsNormalInputLimits  | 1      |
    Then the response status code should be 400 or 201
    And the system should handle the large input without crashing

  @edge
  Scenario: Verify API handles special characters in post title and body
    When the user sends a POST request to "/posts" with the following payload:
      | title                    | body                      | userId |
      | Title with <special> !@# | Body with symbols & chars | 1      |
    Then the response status code should be 400 or 201
    And the system should handle special characters without returning a server error

  @edge
  Scenario: Verify API response structure matches the expected schema for a single post
    Given a post with ID "1" exists in the system
    When the user sends a GET request to "/posts/1"
    Then the response status code should be 200
    And the response body should match the expected JSON schema:
      | field  | type    |
      | id     | integer |
      | title  | string  |
      | body   | string  |
      | userId | integer |

  @edge
  Scenario: Verify API response structure matches the expected schema for a list of posts
    When the user sends a GET request to "/posts"
    Then the response status code should be 200
    And each post in the response body should match the expected JSON schema:
      | field  | type    |
      | id     | integer |
      | title  | string  |
      | body   | string  |
      | userId | integer |
