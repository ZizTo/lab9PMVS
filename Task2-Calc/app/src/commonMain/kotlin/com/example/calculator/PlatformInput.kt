package com.example.calculator
import androidx.compose.runtime.Composable

@Composable
expect fun PlatformInputField(value: String, onValueChange: (String) -> Unit, label: String)