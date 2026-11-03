# Artificial Bee Colony Optimization

This project implements the **Artificial Bee Colony (ABC) algorithm** in MATLAB to optimize production line speed and maximize a simulated profit function.

The algorithm is inspired by the foraging behavior of honey bees and uses population-based optimization to search for the best solution.

## Features

- Artificial Bee Colony optimization algorithm
- Employed, onlooker, and scout bee phases
- Production line speed optimization
- Profit maximization using a mathematical objective function
- Tracking of the best solution across iterations
- Visualization of optimization performance

## Optimization Problem

The objective is to maximize the following profit function:

**f(v) = -100v² + 600v + 100**

Where `v` represents production line speed in meters per second.

The search interval is **1 ≤ v ≤ 5 m/s**.

The analytical optimum is:

- **Optimal speed:** 3 m/s
- **Maximum profit:** 1000 units

## Algorithm Parameters

| Parameter | Value |
|---|---|
| Colony size | 20 |
| Food sources | 10 |
| Maximum iterations | 50 |
| Abandonment limit | 5 |
| Lower bound | 1 m/s |
| Upper bound | 5 m/s |

## Visualizations

The project generates five graphs:

1. Objective function and optimal solution
2. Best profit convergence across iterations
3. Maximum, average, and minimum profit
4. Initial and final population distributions
5. Best production line speed across iterations

## Technologies Used

- MATLAB
- Artificial Bee Colony (ABC)
- Metaheuristic Optimization
- Mathematical Modeling
- Data Visualization

## How to Run

1. Open the MATLAB source file (`.m`) in MATLAB or MATLAB Online.
2. Run the script.
3. Review the optimized production line speed and profit values in the Command Window.
4. Examine the generated graphs to evaluate the optimization process.

## About the Project

This project was developed as an educational implementation of a nature-inspired optimization algorithm.

It demonstrates how the Artificial Bee Colony method can be applied to a simplified production line profit maximization problem.

The profit function is a mathematical example and does not represent real industrial production data.
