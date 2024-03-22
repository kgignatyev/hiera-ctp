import io.ktor.client.*
import io.ktor.client.engine.cio.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

class Result(var res: String, var responseCode: Int) {
    fun hasError(): Boolean {
        return responseCode != 200
    }
}

class ConsulClient {


    fun findKeyValue(key: String, pathComponents: Array<String>): String {
        val client = HttpClient(CIO)
        pathComponents.reverse()
        var result: String? = null
        runBlocking {
            for (lastIndex in (pathComponents.size-1)  downTo 0) {
                val pathBuilder = StringBuilder()
                (0.. lastIndex).forEach { componentIndex ->
                    if (pathBuilder.isNotEmpty()) {
                        pathBuilder.append('/')
                    }
                    pathBuilder.append(pathComponents[componentIndex])
                }
                pathBuilder.append('/').append(key)
                val r = get_key_value(pathBuilder.toString(), client)
                if (!r.hasError()) {
                    result = r.res
                    return@runBlocking
                }
            }
            if( result == null){
                val defaultV = get_key_value("default/$key", client)
                result = defaultV.res
            }
        }
        client.close()
        return result ?: ""
    }

    @OptIn(ExperimentalEncodingApi::class)
    suspend fun get_key_value(path: String, client: HttpClient): Result {

        val urlString = "http://localhost:8500/v1/kv/$path"
        val resp = client.get(Url(urlString))

        return if (resp.status == HttpStatusCode.OK) {
            val responseText = resp.bodyAsText()
            val jsonE = Json.parseToJsonElement( responseText )
            val encodedVal = jsonE.jsonArray[0].jsonObject["Value"]!!.jsonPrimitive.content
            val decodedVal = Base64.decode( encodedVal ).decodeToString()
            Result(decodedVal, 200)
        } else {
            Result("42", -1)
        }
    }
}
