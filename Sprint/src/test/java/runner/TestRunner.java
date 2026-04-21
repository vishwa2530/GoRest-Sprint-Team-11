package runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
features="./src/test/resources/features/users.feature",
glue={"stepdefinition"},
plugin={"pretty","html:target/report.html"}
)

public class TestRunner extends AbstractTestNGCucumberTests {
}
