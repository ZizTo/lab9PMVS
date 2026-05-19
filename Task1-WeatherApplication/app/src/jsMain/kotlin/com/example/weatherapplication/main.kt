package com.example.weatherapplication

import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.window.CanvasBasedWindow
import androidx.compose.ui.window.ComposeViewport
import kotlinx.browser.document
import org.w3c.dom.HTMLCanvasElement
//import org.jetbrains.skiko.wasm.onWasmReady
import com.example.weatherapplication.App

@OptIn(ExperimentalComposeUiApi::class)
fun main() {
    //val canvasElement = document.getElementById("ComposeTarget") as HTMLCanvasElement
    /*onWasmReady {
        ComposeViewport(canvasElement) {
            App(object : Platform {
                override val isDesktop = false
            })
        }
    }*/
    CanvasBasedWindow(title = "Weather App", canvasElementId = "ComposeTarget") {
        App(object : Platform {
            override val isDesktop = false
        })
    }
}