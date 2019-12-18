import static net.grinder.script.Grinder.grinder
import static org.junit.Assert.*
import static org.hamcrest.Matchers.*
import net.grinder.plugin.http.HTTPRequest
import net.grinder.plugin.http.HTTPPluginControl
import net.grinder.script.GTest
import net.grinder.script.Grinder
import net.grinder.scriptengine.groovy.junit.GrinderRunner
import net.grinder.scriptengine.groovy.junit.annotation.BeforeProcess
import net.grinder.scriptengine.groovy.junit.annotation.BeforeThread
// import static net.grinder.util.GrinderUtils.* // You can use this if you're using nGrinder after 3.2.3
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import java.util.Date
import java.util.List
import java.util.ArrayList

import HTTPClient.Cookie
import HTTPClient.CookieModule
import HTTPClient.HTTPResponse
import HTTPClient.NVPair

/**
 * 하이클래스 부하테스트
 * @author 이유성
 * 2019-12-18
 */
@RunWith(GrinderRunner)
class TestRunner {

	public static GTest test
	public static HTTPRequest request
	public static NVPair[] headers = []
	public static NVPair[] params = []
	public static Cookie[] cookies = []

	@BeforeProcess
	public static void beforeProcess() {
		HTTPPluginControl.getConnectionDefaults().timeout = 30000
		test = new GTest(1, "sigong-api.hiclass.net")
		request = new HTTPRequest()
		grinder.logger.info("before process.");
	}

	@BeforeThread
	public void beforeThread() {
		test.record(this, "test")
		grinder.statistics.delayReports=true;
		grinder.logger.info("before thread.");
	}

	@Before
	public void before() {
		request.setHeaders(headers)
		cookies.each { CookieModule.addCookie(it, HTTPPluginControl.getThreadHTTPClientContext()) }
		grinder.logger.info("before thread. init headers and cookies");
	}

	@Test
	public void test_posts(){
		HTTPResponse result = request.GET("http://sigong-api.hiclass.net/posts", params)

		if (result.statusCode == 301 || result.statusCode == 302) {
			grinder.logger.warn("Warning. The response may not be correct. The response code was {}.", result.statusCode);
		} else {
			assertThat(result.statusCode, is(200));
		}
	}

	  @Test
	  public void test_parents(){
		HTTPResponse result = request.GET("http://sigong.hiclass.net/login/parents", params)

		if (result.statusCode == 301 || result.statusCode == 302) {
		  grinder.logger.warn("Warning. The response may not be correct. The response code was {}.", result.statusCode);
		} else {
		  assertThat(result.statusCode, is(200));
		}
	  }

	  @Test
	  public void test_student(){
		HTTPResponse result = request.GET("http://sigong.hiclass.net/login/student", params)

		if (result.statusCode == 301 || result.statusCode == 302) {
			  grinder.logger.warn("Warning. The response may not be correct. The response code was {}.", result.statusCode);
		} else {
      assertThat(result.statusCode, is(200));
		}
	  }

	  @Test
	public void test_helpfaqs(){
		HTTPResponse result = request.GET("https://sigong-api.hiclass.net/helpFaqs", params)

		if (result.statusCode == 301 || result.statusCode == 302) {
			grinder.logger.warn("Warning. The response may not be correct. The response code was {}.", result.statusCode);
		} else {
			assertThat(result.statusCode, is(200));
		}
	}
}
