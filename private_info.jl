# Julia file containing personal information about your retirement

# Handy numbers you can use as a reference
us_early_retirement_age   = 60
us_normal_retirement_age  = 65
us_late_retirement_age    = 70
us_male_life_expectancy   = 77
us_female_life_expectancy = 82
roth_2019_max_contribution      = 6000  # US dollars; for one person
trad_401k_2019_max_contribution = 19000 # US dollars; for one person
sandp_500_average_rate = 0.08  # S&P 500 average yearly rate
risky_retirement_rate  = 0.05  # Mostly stocks; not recommended
medium_retirement_rate = 0.03  # Blended stocks and bonds
safe_retirement_rate   = 0.015 # Mostly bonds; recommended
risky_retirement_withdrawal_rate = 0.04  # 4.0% rule of thumb
safe_retirement_withdrawal_rate  = 0.035 # 3.5% rule of thumb

# TODO: User must input personal values below
# Your current age
current_age    = 50
# Your expected age at which you plan to retire
retirement_age = us_normal_retirement_age
# Your expected age at which you will no longer use retirement money as income
death_age      = us_male_life_expectancy
# Yearly ammount you will contribute to retirement accounts before you retire
# Calculations assume you contribute at the beginning of every year
yearly_retirement_contribution = roth_2019_max_contribution
# Expected long term savings/retirement accounts before you retire; more aggressive
long_term_savings_account_rate    = sandp_500_average_rate
# Expected long term savings/retirement accounts after you retire; more conservative
long_term_retirement_account_rate = safe_retirement_rate
# Rule of thumb rate at which you want to pull money out of retirement account
retirement_withdrawal_rate        = safe_retirement_withdrawal_rate
# All money you currently have in retirement accounts and/or earmarked for retirement.
# Calculations assume this money is already invested today.
current_savings_value = 10000
