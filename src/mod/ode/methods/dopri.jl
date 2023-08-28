# ----------------------
# Runge-Kutta-Dormand-Prince method
# ----------------------

function DOPRI(fn, tspan, x0, tol = 1e-4)
  h, hmax, hmin = 1e-4, 1e-4, 1e-13
  t0, t1 = tspan
  x = x0
  result = (time = [t0], sol = [x0], status = "Ok")

  t = t0
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
