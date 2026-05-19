package com.example.calculator
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.width
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
actual fun PlatformInputField(value: String, onValueChange: (String) -> Unit, label: String) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Text("$label: ", modifier = Modifier.width(150.dp))
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            singleLine = true,
            modifier = Modifier.width(200.dp)
        )
    }
}