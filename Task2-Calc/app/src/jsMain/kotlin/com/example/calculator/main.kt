package com.example.calculator

import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.window.CanvasBasedWindow
//import org.jetbrains.skiko.wasm.onWasmReady

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
        App()
    }
}