import io.ktor.server.testing.*
import kotlinx.cinterop.ExperimentalForeignApi
import kotlin.test.Test

class ApplicationTest {
    @OptIn(ExperimentalForeignApi::class)
    @Test
    fun testRoot() = testApplication {
        main(arrayOf( "pgdb/url","release1" ,"myapp", "us-west-1", "prod"))
    }
}
