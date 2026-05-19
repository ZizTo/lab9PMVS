package com.example.weatherapplication

import androidx.compose.ui.window.ComposeUIViewController

fun MainViewController() = ComposeUIViewController {
    App(object : com.example.weatherapplication.Platform { override val isDesktop = false })
}