
println("The '//' operator means the rational.")
println("Try: 0.333... + 0.333... + 0.333... = 1.0 where 1/3 = 0.333... is:")
println(1//3 + 1//3 + 1//3 == 1)

println("While the conventianal way: 1/3 + 1/3 + 1/3 = 1 is:")
println(1/3 + 1/3 + 1/3 == 1)

if (1/3 == 1//3)
  println("1/3 and 1//3 is same.")
else
  println("1/3 and 1//3 is not same.")
  println("The type of 1/3 is: $(typeof(1/3))")
  println("The type of 1//3 is: $(typeof(1//3))")
end

