@file:OptIn(ExperimentalForeignApi::class)

import io.ktor.client.*
import kotlinx.cinterop.ExperimentalForeignApi





@OptIn(ExperimentalForeignApi::class)
fun main(args: Array<String>) {
    val key = args[0]
    val components = args.copyOfRange(1, args.size)
    val cc = ConsulClient()
    val r = cc.findKeyValue( key,components )
    println(r)
}




