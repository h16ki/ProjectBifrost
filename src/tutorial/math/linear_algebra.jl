using LinearAlgebra

println("Vector is defined like: v::Array{Real} = [1, 3, 4]")
v::Array{Real} = [1, 3, 4]
u::Array{Real} = [4, 5, 6]

println("v = $v, u = $u")
println("v + u = $(v + u)")

a::Real = 3.0
println("3.0 * v = $(a * v)")

println("dot product: dot(u, v) = $(dot(u, v))")
println("cross product: cross(u, v) = $(cross(u,v))")
println("Note: cross() works only for 3d vector")

println("The operation for each component is using '.' attaching before operator.")
println("For example, the Hadamard product u ∘ v (4, 15, 24) -> u .* v = $(u .* v)")
println("Divide is also done: u ./ v = $(u ./ v)")

println("Matrix is defined like: M::Matrix{Real} = [1 2; 3 4]")
M::Matrix{Real} = [1 2; 3 4]

println("M = $M")
println("trace is 'tr(M)': $(tr(M))")
println("determinant is 'det(M)': $(det(M))")
println("rank is 'rand(M)': $(rank(M))")
println("inverse is 'inv(M)': $(inv(M))")
println("The transpose is 'transpose(M)' or M'. The former is good: $(transpose(M))")

println("The break is available: N::Matrix{Real} [ 1 2 3; 'BREAK' 4 5 6; 'BREAK' 7 8 9 ]")

println("The product operator is '*': M * M^{-1} = $(M * inv(M))")
println("The matrix power like M^2 use the hat '^': M^2 = $(M^2)")

println("Solving the equation Ax = b -> x = A^{-1} b is used '\' instead of inv:")
println("Other useful function: Symmetric, Diagonal, diag, diagm, LowerTriangular, UpperTriangular. Skip here.")
