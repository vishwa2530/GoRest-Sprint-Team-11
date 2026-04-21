Feature: User API Testing

Scenario: Verify GET all users
When user sends GET request for all users
Then status code should be 200

Scenario: Verify POST create user
When user sends POST request
Then status code should be 201

Scenario: Verify PUT update user
When user sends PUT request
Then status code should be 200

Scenario: Verify PATCH update user
When user sends PATCH request
Then status code should be 200


Scenario: Verify DELETE user
When user sends DELETE request
Then status code should be 204
