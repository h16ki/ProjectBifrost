# Visualize the motion and breaking of law of the conservation of energy by Euler, Runge-Kutta and Symplectic method
# Ref: https://docs.juliaplots.org/latest/gallery/gr/generated/gr-ref031/#gr_ref031
# Layout:
#   left: potential and motion
#   right-upper: phase
#   right-bottom: energy conservation
# Test model is harmonic oscillator
using Plots

# layout
LAYOUT = @layout [
  a{0.6w} [grid(2, 1)]
  b{0.1h}
  c{0.1h}
]

q0 = 1.0  # coordinate (initial value)
p0 = 0.0  # momentum (initial value)
INITIAL_VALUES = [p0, q0]

function potential(t, p, q)
  return 0.5 * q^2
end

function Euler(t)
end

function RK4(t,)
end

function ImplicitEuler(t)
end

function main()
  q = range(-3, 3, length=50)
  t = range(0, 100, length=300)
  # potential
  plot(q, potential.(0,0,q), linestyle=:dash, framestyle=:box)
  p1 = plot!(q,q)
  # phase
  one_cycle = range(0, 2*π, length=100)
  p2 = plot(cos.(one_cycle), sin.(one_cycle), linestyle=:dash, framestyle=:box, aspect_ratio=:equal)  # exact
  # energy
  p3 = plot(q, potential.(0,0,q), framestyle=:box)
  # position
  p4 = plot(t, cos.(t), framestyle=:zerolines)
  # velocity
  p5 = plot(t, sin.(t), framestyle=:zerolines)
  plot(
    p1, p2, p3, p4, p5,
    layout=LAYOUT,
    legend=false
  )
end

main()
