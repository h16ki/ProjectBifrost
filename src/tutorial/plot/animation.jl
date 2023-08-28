using Plots
using SpecialFunctions: zeta

theme(:bright)

# z = [0.5 + imag * 1.0im for imag = range(-30, 30, length=1000)]

function split_riemann_zeta(z)
  re = []
  im = []
  for _z in z
    zeta = riemann_zeta(_z)
    push!(re, real(zeta))
    push!(im, imag(zeta))
  end

  return re, im
end

Base.@kwdef mutable struct Point
  x::Float64 = 0
  y::Float64 = 0
end

function step!(p::Point, step)
  z = 0.5 + step * 1im
  f = zeta(z, 1)
  p.x = real(f)
  p.y = imag(f)
end

attractor = Point()
plt = plot(1, marker=2, xlims=(-4, 4), ylims=(-4, 4))
@gif for i ∈ range(0, 50, length=300)
  step!(attractor, i)
  push!(plt, attractor.x, attractor.y)
end

