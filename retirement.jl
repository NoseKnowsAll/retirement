include("private_info.jl")

using LinearAlgebra, Statistics, Printf

# Decimal value representing inflation rate over past 20 years
# Source: https://www.usinflationcalculator.com/inflation/current-inflation-rates/
function compute_historical_inflation()
    rates = [3.4, 2.8, 1.6, 2.3, 2.7, 3.4, 3.2, 2.8, 3.8, -0.4, 1.6, 3.2, 2.1, 1.5, 1.6, 0.1, 1.3, 2.1, 2.4]
    average_rate = mean(rates)/100
    return average_rate
end

inflation_rate = compute_historical_inflation();

# Returns the value in retirement accounts after years_to_retirement
# years_to_retirement: Default is retirement_age - current_age
# todays_dollars: boolean adjusting for inflation
function compute_savings_at_retirement(todays_dollars=false)
    yearly_contribution = yearly_retirement_contribution
    years_to_retirement = retirement_age - current_age
    savings_value = current_savings_value
    return compound_interest(current_savings_value, long_term_savings_account_rate,
                             years_to_retirement, yearly_contribution,
                             todays_dollars)
end

# Compounds the value you'll have after interest if you invest for total_years
# years at rate with a set yearly_contribution amount at beginning of each year
# todays_dollars: boolean adjusting for inflation
function compound_interest(current_value, rate, total_years,
                           yearly_contribution, todays_dollars=false)
    savings_value = current_value
    for iy = 1:total_years
        savings_value += yearly_contribution
        savings_value *= (1+rate)
        if (todays_dollars)
            savings_value *= (1-inflation_rate)
        end
    end
    return savings_value
end

# Helper function to convert a certain amount of money in the future
# to how much that money would be worth today
function convert_to_todays_dollars(future_value, years_from_today)
    present_value = future_value * (1-inflation_rate)^years_from_today
end

# Helper function to convert a certain amount of money today
# to how much that money would be worth in the future
function convert_to_future_dollars(present_value, years_from_today)
    future_value = present_value / (1-inflation_rate)^years_from_today
end

# Computes two incomes based on your savings at retirement:
function yearly_retirement_income(savings_at_retirement, todays_dollars)
    income1 = solve_for_income(savings_at_retirement)
    income2 = fixed_retirement_income(savings_at_retirement,retirement_withdrawal_rate)
    if (todays_dollars)
        years_to_retirement = retirement_age - current_age
        income1 = convert_to_todays_dollars(income1, years_to_retirement)
        income2 = convert_to_todays_dollars(income2, years_to_retirement)
    end
    return income1, income2
end

# Retirement income if you want to spend it all down
function solve_for_income(savings_at_retirement)
    total_years = death_age - retirement_age
    
    function savings_at_end(income)
        savings = savings_at_retirement
        for iy = 1:total_years
            savings -= income
            savings *= (1+long_term_retirement_account_rate)
        end
        return savings
    end
    
    # Method of bisection to find income s.t. savings_at_end(income) = 0
    close_guess = 0.0
    # First initialize far_guess s.t. answer in [close_guess, far_guess]
    far_guess = 10000.0
    while savings_at_end(far_guess) > 0
        far_guess *= 2
    end
    # Now bisect until within a dollar of exact answer
    maxiter = 100
    while far_guess - close_guess > 1.0 && maxiter > 0
        middle = (close_guess+far_guess)/2
        savings = savings_at_end(middle)
        if (savings > 0)
            close_guess = middle
        else
            far_guess = middle
        end
        maxiter -= 1
    end
    if maxiter == 0
        println("ERROR: INCOME DID NOT CONVERGE!")
        middle = 0.0
    end
    
    return middle
end

# Retirement income if you want to satisfy the withdrawal rate rule of thumb 
function fixed_retirement_income(savings_at_retirement, retirement_withdrawal_rate)
    return retirement_withdrawal_rate*savings_at_retirement
end

# Call this function to actually model retirement with specified parameters
function model_retirement()
    todays_dollars = false
    savings = compute_savings_at_retirement(todays_dollars)
    @printf("At an average rate of %.1f%% growth, and yearly contributions of \$%.2f, your current retirement savings of \$%.2f will become \$%.2f at retirement",
            long_term_savings_account_rate*100, yearly_retirement_contribution,
            current_savings_value, savings)
    if (todays_dollars)
        @printf(" in todays dollars (accounting for inflation).\n\n")
    else
        @printf(".\n\n")
    end
    
    income1, income2 = yearly_retirement_income(savings, false)
    @printf("At an average rate of %.1f%% growth, your yearly income from savings during retirement will be \$%.2f if you plan to fully spend down your money", long_term_retirement_account_rate*100, income1)
    if (todays_dollars)
        @printf(" in todays dollars (accounting for inflation).\n")
    else
        @printf(".\n")
    end
    @printf("If you were to follow the %.1f%% rule of thumb, your yearly income from savings during retirement will be \$%.2f", retirement_withdrawal_rate*100, income2)
    if (todays_dollars)
        @printf(" in todays dollars (accounting for inflation).\n")
    else
        @printf(".\n")
    end
end
