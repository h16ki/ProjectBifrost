using Plots

function fake_potential(x)
  return tanh(x) ^ 2
end

x = range(-3, 3, length=100)


function fake_force(x)
  return 2.0 * tanh(x) / cosh(x) ^2
end


function RK(fn, span, x0, h=1e-6)
  t0, t1 = span
  return t0, t1
end

@show RK("a", [1, 2], 0)
