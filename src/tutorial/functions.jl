# an example of dot product
function dot_product(v::Vector{T}, u::Vector{T}) where T<:Real
  if length(v) != length(u)
    throw(ArgumentError("Vectors must have same length"))
  end

  dotprod = zero(T)
  for i = 1:length(v)
    dotprod += v[i] * u[i]
  end

  return dotprod
end

const v::Array{Real} = [1.0, 2.0, 3.0]
const u::Array{Real} = [4.0, 5.0, 6.0]

dp = dot_product(v, u)
println(dp)

# numpy-like vectorization
x = range(-2*π, 2*π, length=300)
y = sin.(x)
println(length(y))
