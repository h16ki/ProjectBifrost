using Plots: plot, plot!

N = 1 : 10
plt = plot()
sine(x, n) = sin(2 * n *  π * x)
x = 1:100
for n ∈ N
  plot!(sine.(x, n))
end


plt.show()
