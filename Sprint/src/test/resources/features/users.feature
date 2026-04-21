Feature: GoRest Users API Validation

  Scenario: Verify get all users successfully
    Given User sets users endpoint
    When User sends GET request for all users
    Then Response status code should be 200

  Scenario: Verify get single user successfully
    Given User sets single user endpoint
    When User sends GET request for single user
    Then Response status code should be 200

  Scenario: Verify create new user successfully
    Given User sets create user endpoint
    When User sends POST request with valid user data
    Then Response status code should be 201

  Scenario: Verify update user with PUT successfully
    Given User sets update user endpoint
    When User sends PUT request with updated user data
    Then Response status code should be 200

  Scenario: Verify update user with PATCH successfully
    Given User sets patch user endpoint
    When User sends PATCH request with partial user data
    Then Response status code should be 200

  Scenario: Verify delete user successfully
    Given User sets delete user endpoint
    When User sends DELETE request
    Then Response status code should be 204

  Scenario: Verify user not found with invalid id
    Given User sets invalid user endpoint
    When User sends GET request for invalid user
    Then Response status code should be 404

  Scenario: Verify unauthorized user creation without token
    Given User sets create user endpoint without authorization
    When User sends POST request with valid user data
    Then Response status code should be 401
