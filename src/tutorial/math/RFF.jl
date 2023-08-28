using Random
using LinearAlgebra
using Plots


function dataset(size, span=(0, 1))
  lower, upper = span
  x = (upper - lower) * rand(size) .+ lower
  y = sin.(x) .+ 0.3 * rand(size)
  return x, y
end

scatter(dataset(30, (-pi, pi)))

function RBFKernel(x, y, beta=1.0)
  z = x .- y
  return exp(-beta * dot(z, z))
end

function GramMatrix(x, y)
  n = length(x)
  K = zeros(n, n)
  for i in 1:n
    for j in i:n
      K[i, j] = RBFKernel(x[i], y[j])
      K[j, i] = K[i, j]
    end
  end

  return K
end

function regression(x, data)
  in_train, out_train = data
  n = length(in_train)
  weight = out_train \ GramMatrix(in_train, in_train)
  return length(weight)
  # return dot(weight, RBFKernel.(in_train, x))
end

x = range(-pi, pi, 1000)
ds = dataset(30, [-pi, pi])
regression(x, ds)
