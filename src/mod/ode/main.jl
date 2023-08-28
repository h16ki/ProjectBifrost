# ---------------------
# DIY Series
#   : ODE Solver (v0.0.1)
# ---------------------

using Plots
include("./methods/dopri.jl")

function benchmark1(t, x)
  # dxdt = x cos(t), x0 = 1
  return x * cos(t)
end

function exact_benchmark1(t)
  return exp(sin(t))
end

sol = DOPRI(benchmark1, [0.0, 10], 1.0)
plot(sol.time[1:Int(floor(length(sol.time)*0.03)):end], sol.sol[1:Int(floor(length(sol.time)*0.03)):end], st=:scatter)
plot!(sol.time, exact_benchmark1.(sol.time))
