using Plots

function RK(fn, tspan, x0, h=0.0001)
  t0, t1 = tspan
  x = x0
  result = (time = [t0], sol = [x0], err = "")

  for t ∈ range(t0, t1, length = Int(1 / h))
    k1 = fn(t, x)
    k2 = fn(t + 0.5 * h, x + 0.5 * h * k1)
    k3 = fn(t + 0.5 * h, x + 0.5 * h * k2)
    k4 = fn(t + h, x + h * k3)
    x = x + 0.1666666 * h * (k1 + 2.0 * k2 + 2.0 * k3 + k4)

    push!(result.time, t)
    push!(result.sol, x)
  end

  return result
end

function decay(t, x)
  return cos(2.0 * pi * t)
end

sol = RK(decay, [0.0, 3], 0.0)

# plot(sol.time, sol.sol)

BUTCHER_TABLE_A = [
  0 0 0 0 0 0
  1/4 0 0 0 0 0
  3/32 9/32 0 0 0 0
  1932/2197 -7200/2197 7296/2197 0 0 0
  439 -8 3680/513 -845/4140 0 0
  -8/27 2 -3544/2565 1859/4104 -11/40 0
]

BUTCHER_TABLE_B = [
  16/135 0 6656/12825 28561/56430 -9/50 2/55 # 5th order
  25/216 0 1408/2565 2197/4104 -1/5 0 # 4th order
]

BUTCHER_TABLE_C = [
  0 1/4 3/8 12/13 1 1/2
]

function RungeKuttaFehlberg(fn, tspan, x0, h=0.0001)
  t0, t1 = tspan
  xq4 = x0
  xq5 = x0
  result = (time = range(t0, t1, length = Int(1 / h)), q5 = [], q4 = [], err = "")

  for (s, x) ∈ enumerate([xq5, xq4])
    x_result = [x]
    for t ∈ range(t0, t1, length = Int(1 / h) - 1)
      k1 = fn(t, x)
      k2 = fn(t + BUTCHER_TABLE_C[2] * h, x + h * (BUTCHER_TABLE_A[2,1] * k1))
      k3 = fn(t + BUTCHER_TABLE_C[3] * h, x + h * (BUTCHER_TABLE_A[3,2] * k2 + BUTCHER_TABLE_A[3,1] * k1))
      k4 = fn(t + BUTCHER_TABLE_C[4] * h, x + h * (BUTCHER_TABLE_A[4,3] * k3 + BUTCHER_TABLE_A[4,2] * k1 + BUTCHER_TABLE_A[4,1] * k1))
      k5 = fn(t + BUTCHER_TABLE_C[5] * h, x + h * (BUTCHER_TABLE_A[5,4] * k4 + BUTCHER_TABLE_A[5,3] * k3 + BUTCHER_TABLE_A[5,2] * k2 + BUTCHER_TABLE_A[5,1] * k1))
      k6 = fn(t + BUTCHER_TABLE_C[6] * h, x + h * (BUTCHER_TABLE_A[6,5] * k5 + BUTCHER_TABLE_A[6,4] * k4 + BUTCHER_TABLE_A[6,3] * k3 + BUTCHER_TABLE_A[6,2] * k2 + BUTCHER_TABLE_A[6,1] * k1))

      x = x + h * (BUTCHER_TABLE_B[s,1] * k1 + BUTCHER_TABLE_B[s,2] * k2 + BUTCHER_TABLE_B[s,3] * k3 + BUTCHER_TABLE_B[s,4] * k4 + BUTCHER_TABLE_B[s,5] * k5 + BUTCHER_TABLE_B[s,6] * k6)

      push!(x_result, x)
    end
    push!(result[s+1], x_result)
  end

  return result
end

function DOPRI(fn, tspan, x0, params, tol = 1e-4)
  """Dormond-Prince method"""
  h, hmax, hmin = 1e-4, 1e-4, 1e-13
  t0, t1 = tspan
  x = x0
  result = (time = [t0], sol = [x0], status = "Ok")

  function curried_fn(params)
    return (t,x) -> fn(t, x, params...)
  end

  t = t0
  # for t ∈ range(t0, t1, length = Int(1 / h))
  while t < t1
    k1 = fn(t, x)
    k2 = fn(t + 0.25 * h, x + h * 0.25 * k1)
    k3 = fn(t + 0.3 * h, x + h * (3/40 * k1 + 9/40 * k2))
    k4 = fn(t + 0.8 * h, x + h * (44/45 * k1 - 56/15 * k2 + 32/9 * k3))
    k5 = fn(t + 8/9 * h, x + h * (19372/6561 * k1 - 25360/2187 * k2 + 64448/6561 * k3 - 212/729 * k4))
    k6 = fn(t + h, x + h * (9017/3168 * k1 - 355/33 * k2 + 46732/5247 * k3 + 49/176 * k4 - 5103/18656 * k5))

    x += h * (35/384 * k1 + 500/1113 * k3 + 125/192 * k4 - 2187/6784 * k5 + 11/84 * k6)

    push!(result.time, t)
    push!(result.sol, x)

    k7 = fn(t + h, x)
    err = abs(71/57600 * k1 - 71/16695 * k3 + 71/1920 * k4 - 17253/339200 * k5 + 22/525 * k6 - 1/40 * k7)
    if (err > tol)
      result.status = "hoeg"
    end

    delta = (0.5 * tol / err) ^ (0.25)

    if delta <= 0.1
      h = min(hmax, 0.1 * h)
    elseif delta >= 4.0
      h = min(hmax, 4.0 * h)
    else
      h = min(hmax, delta * h)
    end

    if (t + h > t1)
      h = t1 - t
    end

    if (h < hmin)
      break
    end

    t += h
  end

  return result
end

sol = DOPRI(decay, [0.0, 3], 0.0)

plot(sol.time, sol.sol)

function base(x, y)
  return x * y
end

function curry(x)
  return y -> base(x, y)
end

add_five = curry("5")
println(add_five("3"))
