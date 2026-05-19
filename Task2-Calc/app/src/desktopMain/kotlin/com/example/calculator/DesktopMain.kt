package com.example.calculator

import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application

fun main() = application {
    Window(
        onCloseRequest = ::exitApplication,
        title = "Ziz Calcuklator Desktop"
    ) {
        App()
    }
}