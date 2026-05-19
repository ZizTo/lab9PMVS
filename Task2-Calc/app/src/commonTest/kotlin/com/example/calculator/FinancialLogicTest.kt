package com.example.calculator
import kotlin.test.Test
import kotlin.test.assertEquals

class FinancialLogicTest {
    @Test
    fun testNormalCalculation() {
        val result = FinancialLogic.calculateCompoundInterest(1000.0, 0.1, 1, 1)
        assertEquals(1100.0, result.last(), 0.01)
    }

    @Test
    fun testZeroInterest() {
        val result = FinancialLogic.calculateCompoundInterest(5000.0, 0.0, 5, 12)
        assertEquals(5000.0, result.last(), 0.01)
    }

    @Test
    fun testZeroTime() {
        val result = FinancialLogic.calculateCompoundInterest(1000.0, 0.1, 0, 1)
        assertEquals(1000.0, result.last(), 0.01)
        assertEquals(1, result.size)
    }
}