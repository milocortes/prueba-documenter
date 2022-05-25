# [Ordinary Differential Equations](@id cmip_data)

This tutorial will introduce you to the functionality for solving ODEs. Other
introductions can be found by [checking out SciMLTutorials.jl](https://github.com/JuliaDiffEq/SciMLTutorials.jl).
Additionally, a [video tutorial](https://youtu.be/KPEqYtEd-zY) walks through
this material.

## Example 1 : Solving Scalar Equations

In this example we will solve the equation

```math
\frac{du}{dt} = f(u,p,t)
```