package com.example.calculator
import androidx.compose.ui.test.*
import kotlin.test.Test

@OptIn(ExperimentalTestApi::class)
class CalculatorUiTest {
    @Test
    fun testInitialUIState() = runComposeUiTest {
        setContent { FinancialCalculator() }
        onNodeWithText("Финансовый калькулятор").assertExists()
        onNodeWithText("Рассчитать").assertExists()
    }

    @Test
    fun testCalculationFlow() = runComposeUiTest {
        setContent { FinancialCalculator() }
        onNodeWithText("Рассчитать").performClick()
        onNodeWithText("График роста капитала:").assertExists()
    }

    @Test
    fun testEmptyInputHandling() = runComposeUiTest {
        setContent { FinancialCalculator() }
        onNodeWithText("10").performTextClearance()
        onNodeWithText("Рассчитать").performClick()
        onNodeWithText("Конечная сумма: 10000,00").assertExists()
    }
}