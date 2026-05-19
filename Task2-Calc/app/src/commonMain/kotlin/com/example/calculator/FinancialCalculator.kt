package com.example.calculator

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import kotlin.math.pow

@Composable
fun FinancialCalculator() {
    var initialAmount by remember { mutableStateOf("10000") }
    var interestRate by remember { mutableStateOf("10") }
    var years by remember { mutableStateOf("5") }
    var capitalizationFreq by remember { mutableStateOf(12) }

    var finalAmount by remember { mutableStateOf(0.0) }
    var profit by remember { mutableStateOf(0.0) }
    var history by remember { mutableStateOf(listOf<Double>()) }

    Column(modifier = Modifier.padding(16.dp).fillMaxSize()) {
        Text("Финансовый калькулятор", style = MaterialTheme.typography.headlineSmall)
        Spacer(modifier = Modifier.height(16.dp))

        PlatformInputField(
            value = initialAmount,
            onValueChange = { initialAmount = it },
            label ="Начальная сумма"
        )

        PlatformInputField(
            value = interestRate,
            onValueChange = { interestRate = it },
            label = "Годовая ставка (%)"
        )

        PlatformInputField(
            value = years,
            onValueChange = { years = it },
            label = "Срок (лет)"
        )

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                val p = initialAmount.toDoubleOrNull() ?: 0.0
                val r = (interestRate.toDoubleOrNull() ?: 0.0) / 100
                val t = years.toIntOrNull() ?: 0
                val n = capitalizationFreq

                val calculatedHistory = mutableListOf<Double>()
                calculatedHistory.add(p)

                for (year in 1..t) {
                    val amount = p * (1 + r / n).pow(n * year)
                    calculatedHistory.add(amount)
                }

                history = calculatedHistory
                finalAmount = calculatedHistory.lastOrNull() ?: 0.0
                profit = finalAmount - p
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Рассчитать")
        }

        Spacer(modifier = Modifier.height(16.dp))

        if (finalAmount > 0) {
            Text("Конечная сумма: ${"%.2f".format(finalAmount)}")
            Text("Общая прибыль: ${"%.2f".format(profit)}")

            Spacer(modifier = Modifier.height(24.dp))
            Text("График роста капитала:", style = MaterialTheme.typography.titleMedium)
            Spacer(modifier = Modifier.height(8.dp))

            Canvas(modifier = Modifier.fillMaxWidth().height(200.dp)) {
                if (history.size > 1) {
                    val maxVal = history.maxOrNull()?.toFloat() ?: 1f
                    val minVal = history.first().toFloat()
                    val rangeY = (maxVal - minVal).coerceAtLeast(1f)

                    val stepX = size.width / (history.size - 1)
                    val scaleY = size.height / rangeY

                    val path = Path()
                    path.moveTo(0f, size.height)

                    for (i in history.indices) {
                        val x = i * stepX
                        val y = size.height - ((history[i].toFloat() - minVal) * scaleY)
                        if (i == 0) path.moveTo(x, y) else path.lineTo(x, y)
                    }

                    drawPath(
                        path = path,
                        color = Color.Blue,
                        style = Stroke(width = 5f)
                    )
                }
            }
        }
    }
}