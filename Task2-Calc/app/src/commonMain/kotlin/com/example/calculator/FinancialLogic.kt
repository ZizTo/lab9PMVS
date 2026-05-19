package com.example.calculator
import kotlin.math.pow

object FinancialLogic {
    fun calculateCompoundInterest(p: Double, r: Double, t: Int, n: Int): List<Double> {
        val history = mutableListOf<Double>()
        history.add(p) // Год 0
        for (year in 1..t) {
            val amount = p * (1 + r / n).pow(n * year)
            history.add(amount)
        }
        return history
    }
}