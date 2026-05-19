package com.example.weatherapplication.data

import platform.Foundation.NSApplicationSupportDirectory
import platform.Foundation.NSFileManager
import platform.Foundation.NSSearchPathForDirectoriesInDomains
import platform.Foundation.NSUserDomainMask
import platform.Foundation.create
import platform.Foundation.stringWithContentsOfFile
import platform.Foundation.writeToFile
import platform.Foundation.NSUTF8StringEncoding

actual object CacheStorage {

    private fun filePath(): String {
        val paths = NSSearchPathForDirectoriesInDomains(
            NSApplicationSupportDirectory,
            NSUserDomainMask,
            true
        )
        val basePath = paths.firstOrNull() as? String ?: "."
        return "$basePath/weather_cache.json"
    }

    actual fun save(text: String) {
        val path = filePath()
        val fileManager = NSFileManager.defaultManager
        val dirPath = path.substringBeforeLast("/")
        if (!fileManager.fileExistsAtPath(dirPath)) {
            fileManager.createDirectoryAtPath(
                path = dirPath,
                withIntermediateDirectories = true,
                attributes = null,
                error = null
            )
        }
        text.writeToFile(path, atomically = true, encoding = NSUTF8StringEncoding, error = null)
    }

    actual fun load(): String? {
        val path = filePath()
        return NSString.stringWithContentsOfFile(path, NSUTF8StringEncoding, null) as String?
    }
}