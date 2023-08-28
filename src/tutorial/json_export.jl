using JSON

data = Dict(
  "name" => "Alice",
  "age" => 30,
  "city" => "Wonderland",
)

json_file = open("data.json", "w")
JSON.print(json_file, [data, data, data], 2)
close(json_file)

REL_TOL = 1e-12
ABS_TOL = 1e-12

#振動数に関係した関数
function omega2_k(t, k, beta, ratio)
  return k^2 + scale_factor(t)^2 * ratio^2 * (1 + beta^2 * (inflaton_dynamics_f(t))^2)
end

#upの初期値
real_q0_plus(k, beta, ratio) = (1 + scale_factor(0) * c / sqrt(omega2_k(0, k, beta, ratio)))^0.5
real_q0_minus(k, beta, ratio) = -(k / sqrt(omega2_k(0, k, beta, ratio))) / (1 + ratio * scale_factor(0) / sqrt(omega2_k(0, k, beta, ratio)))^0.5
imag_q0_plus(k, beta, ratio) = 0
imag_q0_minus(k, beta, ratio) = -(beta * ratio * inflaton_dynamics_f(0) * scale_factor(0) / sqrt(omega2_k(0, k, beta, ratio))) / (1 + scale_factor(0) * ratio / sqrt(omega2_k(0, k, beta, ratio)))^0.5

#upの初期速度
real_p0_plus(k, beta, ratio) = scale_factor(0) * ratio * inflaton_dynamics_f(0) * beta * real_q0_minus(k, beta, ratio) + scale_factor(0) * ratio * imag_q0_plus - k * imag_q0_minus
real_p0_minus(k, beta, ratio) = -scale_factor(0) * ratio * inflaton_dynamics_f(0) * beta * real_q0_plus(k, beta, ratio)- k * imag_q0_plus - scale_factor(0) * ratio * imag_q0_minus
imag_p0_plus(k, beta, ratio) = -scale_factor(0) * ratio * real_q0_plus(k, beta, ratio) + k * real_q0_minus + scale_factor(0) * inflaton_dynamics_f(0) * ratio * beta * imag_q0_minus(k, beta, ratio)
imag_p0_minus(k, beta, ratio) = k * real_q0_plus(k, beta, ratio) + scale_factor(0) * ratio * real_q0_minus(k, beta, ratio) - scale_factor(0) * inflaton_dynamics_f(0) * ratio * beta * imag_q0_plus(k, beta, ratio)


#微分方程式
function expanding_universe(xdot, x, p, t)
  momentum, beta, ratio = p
  xdot[1] = x[2]
  xdot[2] = -(omega2_k(t, momentum, beta, ratio)) * x[1] + scale_factor_prime(t) * ratio * x[5] + beta * (scale_factor(t) * inflaton_dynamics_f_prime(t) + scale_factor_prime(t) * inflaton_dynamics_f(t)) * ratio * x[3]
  xdot[3] = x[4]
  xdot[4] = -(omega2_k(t, momentum, beta, ratio)) * x[3] - scale_factor_prime(t) * ratio * x[7] - beta * (scale_factor(t) * inflaton_dynamics_f_prime(t) + scale_factor_prime(t) * inflaton_dynamics_f(t)) * ratio * x[1]
  xdot[5] = x[6]
  xdot[6] = -(omega2_k(t, momentum, beta, ratio)) * x[5] - scale_factor_prime(t) * ratio * x[1] + beta * (scale_factor(t) * inflaton_dynamics_f_prime(t) + scale_factor_prime(t) * inflaton_dynamics_f(t)) * ratio * x[7]
  xdot[7] = x[8]
  xdot[8] = -(omega2_k(t, momentum, beta, ratio)) * x[7] + scale_factor_prime(t) * ratio * x[3] - beta * (scale_factor(t) * inflaton_dynamics_f_prime(t) + scale_factor_prime(t) * inflaton_dynamics_f(t)) * ratio * x[5]
end

function export_ode_solution()
  for setting in settings
    momentum = setting.parameters.momentum
    ratio = setting.parameters.ratio
    beta = setting.parameters.beta

    x0 = [
      real_q0_plus(momentum, beta, ratio), real_p0_plus(momentum, beta, ratio),
      real_q0_minus(momentum, beta, ratio), real_p0_minus(momentum, beta, ratio),
      imag_q0_plus(momentum, beta, ratio), imag_p0_plus(momentum, beta, ratio),
      imag_q0_minus(momentum, beta, ratio), imag_p0_minus(momentum, beta, ratio)
    ]

    reltol = haskey(setting.ode_problem_params, "reltol") ? setting.ode_problem_params.reltol : REL_TOL
    abstol = haskey(setting.ode_problem_params, "abstol") ? setting.ode_problem_params.abstol : ABS_TOL

    expanding_universe_problem = ODEProblem(expanding_universe, x0, tspan, p=(momentum, ratio, beta))
    sol = solve(expanding_universe_problem, Vern9(), reltol=reltol, abstol=abstol, dt=0.01, dense=true)

    const filename = "k=$k,β=$beta,ratio=$ratio"
    save(filename, sol_up)
    setting.filename = filename

  end
end
