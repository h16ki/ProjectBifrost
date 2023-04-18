# Tutorials for julia lang

println("Howdy noobs for Julia!\n")
print("""
Well, well, well. If you're looking to join the big leagues in the world of data science, you better get to know Julia - the programming language that's taking the scientific computing world by storm!

Julia is a high-performance, open-source programming language that is designed for scientific and numerical computing. It is fast, efficient, and has a syntax that is both easy to learn and highly expressive. With Julia, you can write code that is as fast as C, as powerful as Python, and as versatile as MATLAB - all in one package!

What makes Julia so special is its ability to do just about anything you throw at it. From machine learning to data visualization, Julia has an extensive library of packages that will make your life easier. Want to build a recommendation engine? Check out the Flux.jl package. Want to visualize your data in 3D? Try out the Makie.jl package. Julia even has built-in support for distributed computing, so you can scale your computations across multiple processors or nodes.

So, if you're looking to become a super-hacker in the world of scientific computing and data science, you better add Julia to your toolbox. With its combination of speed, power, and ease-of-use, Julia is sure to be a game-changer for anyone who wants to tackle the most challenging computing problems of our time.
""")

x::Int = 4
const pi::Float32 = 3.14159
print("x is $x and pi is $pi\n")

u::Array{Float64} = [1.0, 2.0, 3.0]

u[1]::Int = 9

println(u)
