# Lyapunov exponent

# \dot{x(t)} = f(x(t))
# λ = \lim_{n → ∞} \frac{1}{n} \sum_{i=0}^{n-1} \ln | f'(x_i) |

using Plots

function tent_map(x_n, mu=2.0)
  if 0.0 <= x_n <= 0.5
    return mu * x_n
  elseif 0.5 < x_n <= 1.0
    return mu - mu * x_n
  end
end


function tent_collection(x_0, mu, n = 100)
  x = zeros(n)
  x[1] = x_0

  for i = 2 : n
    x[i] = tent_map(x[i-1], mu)
  end

  return x
end

x = range(0.0, 1.0, length=300)
plot(x, tent_map.(x, 2.0))

function branch(x_0, mu, n=100)
  x = zeros(length(mu))
  index = 0

  for m = mu
    index += 1
    collection = tent_collection(x_0, m, n)
    x[index] = collection[n]
  end

  return x
end

mu = range(1.0, 2.0, length=300)
plt = plot()
for x_0 = range(0.4, 0.6, length=300)
  plot!(plt, mu, branch(x_0, mu), st=:scatter, mc=:black, ms=1, ma=0.1, markerstrokewidth=0, legend=false)
end

plot(plt)
