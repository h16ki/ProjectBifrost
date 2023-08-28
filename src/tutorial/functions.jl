struct ODEResult{T}
  time::Vector{Float64}
  sol::Vector{T}
end


function euler(fn, tspan, x0)
  t0, t1 = tspan
  println(t0, t1)
  h = 1e-3
  # result = (time=[], sol=[])
  time = []
  sol = []

  x = x0
  for t in range(t0, t1, length=Int(1/h))
    push!(time, t)
    push!(sol, x)

    x = x + h * fn(t, x)
  end

  return ODEResult{Float64}(time, sol)
end

function foo(t, x)
  return sin(t)
end

res = euler(foo, [0, pi], 1)
# println(res)

function target(x, a, b)
  return x^a + b
end

function expand_tuple(fn, x, args...)
  return fn(x, args...)
end

println(expand_tuple(target, 2, 2, 6))

function add_one(x::Int)
  return x + 1
end

function add_one(x::Vector{Int})
  # tmp = zeros(length(x))
  tmp = similar(x, length(x))
  for (index, value) in enumerate(x)
    tmp[index] = value + 1
  end

  return tmp
end

println(add_one(2))
println(add_one([1,2,3]))

struct Point2D{T}
  x::T
  y::T
end

p = Point2D(2, 3)
println(p)

function distance(p::Point2D{T}) where T
  sqrt(p.x^2 + p.y^2)
end

println(distance(Point2D{Int}(5,12)))

function hoge(fn, t, x; args)
  function curried_fn(args)
    return (t, x) -> fn(t, x, args...)
  end
  return curried_fn(args)
end

function target(t, x, a, b, c)
  return c / (a^2 + x^2) + b
end

test = hoge(target, 0, 1, args=(1, 2, 3))
print(test(0, 0))
