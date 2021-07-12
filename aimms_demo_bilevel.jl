using Gurobi
using JuMP
using LinearAlgebra
using Random
using Printf

model = Model(Gurobi.Optimizer) #Gurobi.Optimizer)
set_optimizer_attribute(model, "OutputFlag", true)
set_optimizer_attribute(model, "MIPGap", 0)
using Random
Random.seed!(1234)

n_stores = 1
n_samples = 100
T = 10
demand_forecast = zeros(Float64, (n_stores, T))

for i_store = 1:n_stores
    start = rand(10:0.1:10, 1)

    for t = 1:T
        demand_forecast[i_store, t] = start[1] * sqrt(Float64(t))
    end
end

initial_inventory = demand_forecast[:, 1] ./ 2
min_capacity_store = 0.5
sales_price = 10
inv_cost = 0.5
fixed_cost = 20
@variable(model, x[1:n_stores, 1:T] ≥ 0)
@variable(model, x_fixed[1:n_stores, 1:T], Bin)
@variable(model, sales[1:n_stores, 1:T] ≥ 0)
@variable(model, inv_left[1:n_stores, 1:T])

for i_store = 1:n_stores
    for t = 1:T
        @constraint(model, x[i_store, t] <= x_fixed[i_store, t] * 100)
        @constraint(model, sales[i_store, t] <= demand_forecast[i_store, t])
        @constraint(model, sales[i_store, t] <= initial_inventory[i_store] + sum(x[i_store, 1:t]) - sum(demand_forecast[i_store, 1:t-1]))
        #@constraint(model, initial_inventory[i_store] + sum(x[i_store, 1:t]) - sum(demand_forecast[i_store, 1:t]) >= min_capacity_store)
    end
end

@objective(model, Max, sales_price * sum(sales[i_store, t] for i_store = 1:n_stores for t = 1:T) - inv_cost * sum(initial_inventory[i_store] + sum(x[i_store, 1:t]) - sum(demand_forecast[i_store, 1:t]) for i_store = 1:n_stores for t = 1:T) - sum(fixed_cost * x_fixed[i_store, t] for i_store = 1:n_stores for t = 1:T))
optimize!(model)
x_done = value.(x)
sales_done = value.(sales)
print(x_done[1,:])
print(sales[1,:])

# now the need to check robustness, assume uncertainty of up to 5%
missing_sales = zeros(Float64, (n_stores, T))
uncertainty_level = 0.1

for i_store = 1:n_stores
    for t = 1:T
        # sales related constraints
        inner_model = Model(Gurobi.Optimizer)
        set_optimizer_attribute(inner_model, "OutputFlag", false)

        @variable(inner_model, inner_sales[1:t-1] ≥ 0)
        @variable(inner_model, perturbed_demand[1:t-1])
        @constraint(inner_model, perturbed_demand .<= (1 + uncertainty_level) .* demand_forecast[i_store, 1:t-1])
        @constraint(inner_model, perturbed_demand .>= (1 - uncertainty_level) .* demand_forecast[i_store, 1:t-1])

        for s = 1:t-1
            @constraint(inner_model, inner_sales[s] <= perturbed_demand[s])
            @constraint(inner_model, inner_sales[s] <= initial_inventory[i_store] + sum(x_done[i_store, 1:s]) - sum(inner_sales[1:s-1]))
        end

        @objective(inner_model, Max, -100 * (sum(x_done[i_store, 1:t]) - sum(inner_sales[1:t-1])) + sales_price * sum(inner_sales[1:t-1]) - inv_cost * sum((sum(x_done[i_store, 1:j]) - sum(inner_sales[1:j])) for i_store = 1:n_stores for j = 1:t-1))
        optimize!(inner_model)
        #print(value.(inner_sales))
        vv = initial_inventory[i_store] + sum(x_done[i_store, 1:t]) - sum(value.(inner_sales)[1:t-1])
        print(vv)
        missing_sales[i_store, t] = max(sales_done[i_store, t] - vv, 0)
    end
end

print("Missing sale percentage")
@show(missing_sales)

# now the need to check robustness with sampled uncertainty
missing_sales_randomized = zeros(Float64, (n_stores, T))

for i_store = 1:n_stores
    for t = 1:T
        for i_sample = 1:n_samples
            # sales related constraints
            inner_model = Model(Gurobi.Optimizer)
            set_optimizer_attribute(inner_model, "OutputFlag", false)
            @variable(inner_model, inner_sales[1:t-1] ≥ 0)
            @variable(inner_model, perturbed_demand[1:t-1])
            perturbed_demand = demand_forecast[i_store, 1:t-1] .+ uncertainty_level .* rand(-1:0.01:1, (1, t-1)) .* demand_forecast[i_store, 1:t-1]

            for s = 1:t-1
                @constraint(inner_model, inner_sales[s] <= perturbed_demand[s])
                @constraint(inner_model, inner_sales[s] <= initial_inventory[i_store] + sum(x_done[i_store, 1:s]) - sum(inner_sales[1:s-1]))
            end

            @objective(inner_model, Max, sales_price * sum(inner_sales[1:t-1]) - inv_cost * sum((sum(x_done[i_store, 1:j]) - sum(inner_sales[1:j])) for j = 1:t-1))
            optimize!(inner_model)
            
            vv = initial_inventory[i_store] + sum(x_done[i_store, 1:t]) - sum(value.(inner_sales)[1:t-1])
            missing_sales_randomized[i_store, t] = max(missing_sales_randomized[i_store, t], max(sales_done[i_store, t] - vv, 0))
        end
    end
end

@show(missing_sales_randomized)