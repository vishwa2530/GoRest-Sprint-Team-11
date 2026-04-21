package stepdefinition;

import static io.restassured.RestAssured.*;
import static io.restassured.http.ContentType.JSON;

import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.response.Response;

public class UserSteps {

    Response response;
    int userId;

    String token = "f2eab2d47fcbaea74a0748fed9ad92f7603b02a16130f36a2210c09ff5200593";

    // Common method to create user
    public int createUser() {

        String body = "{\n" +
                "\"name\":\"Vishwa\",\n" +
                "\"gender\":\"male\",\n" +
                "\"email\":\"test" + System.currentTimeMillis() + "@gmail.com\",\n" +
                "\"status\":\"active\"\n" +
                "}";

        Response res = given()
                .baseUri("https://gorest.co.in/public/v2")
                .header("Authorization", "Bearer " + token)
                .contentType(JSON)
                .body(body)
                .when()
                .post("/users");

        return res.jsonPath().getInt("id");
    }

    @When("user sends GET request for all users")
    public void getUsers() {

        response = given()
                .baseUri("https://gorest.co.in/public/v2")
                .when()
                .get("/users");
    }

    @When("user sends POST request")
    public void postUser() {

        String body = "{\n" +
                "\"name\":\"Vishwa\",\n" +
                "\"gender\":\"male\",\n" +
                "\"email\":\"test" + System.currentTimeMillis() + "@gmail.com\",\n" +
                "\"status\":\"active\"\n" +
                "}";

        response = given()
                .baseUri("https://gorest.co.in/public/v2")
                .header("Authorization", "Bearer " + token)
                .contentType(JSON)
                .body(body)
                .when()
                .post("/users");

        userId = response.jsonPath().getInt("id");
    }

    @When("user sends PUT request")
    public void putUser() {

        userId = createUser();

        String body = "{ \"name\":\"Updated Name\" }";

        response = given()
                .baseUri("https://gorest.co.in/public/v2")
                .header("Authorization", "Bearer " + token)
                .contentType(JSON)
                .body(body)
                .when()
                .put("/users/" + userId);
    }
    
    @When("user sends PATCH request")
    public void patchUser() {

        userId = createUser();

        String body = "{ \"name\":\"Patched Name\" }";

        response = given()
                .baseUri("https://gorest.co.in/public/v2")
                .header("Authorization", "Bearer " + token)
                .contentType(JSON)
                .body(body)
                .when()
                .patch("/users/" + userId);
    }


    @When("user sends DELETE request")
    public void deleteUser() {

        userId = createUser();

        response = given()
                .baseUri("https://gorest.co.in/public/v2")
                .header("Authorization", "Bearer " + token)
                .when()
                .delete("/users/" + userId);
    }

    @Then("status code should be {int}")
    public void validateStatus(int code) {
        response.then().statusCode(code);
    }
    
}
