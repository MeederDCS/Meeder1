# Load necessary libraries
library(PortfolioAnalytics)
library(PerformanceAnalytics)
library(quantmod)
library(DEoptim)

# Define ticker symbols for high-beta and low-beta stocks
high_beta_tickers <- c("JTEK")
low_beta_tickers <- c("VGSH", "QLTA")
benchmark_ticker <- "SPY"

# Fetch historical price data
getSymbols(c(high_beta_tickers, low_beta_tickers, benchmark_ticker), from = "2020-01-01")

# Calculate returns for all assets
prices <- na.omit(merge(Cl(JTEK), Cl(VGSH), Cl(QLTA), Cl(SPY)))
returns <- na.omit(ROC(prices, type = "discrete"))

# Separate benchmark returns
benchmark_returns <- returns[, "SPY.Close"]
asset_returns <- returns[, -ncol(returns)]

# Calculate asset betas
betas <- apply(asset_returns, 2, function(x) {
  lm(x ~ benchmark_returns)$coefficients[2]
})

# Define the portfolio specification
port_spec <- portfolio.spec(assets = colnames(asset_returns))
port_spec <- add.constraint(port_spec, type = "weight_sum", min_sum = 1, max_sum = 1)
port_spec <- add.constraint(port_spec, type = "box", min = 0.1, max = 0.6)
port_spec <- add.objective(port_spec, type = "return", name = "mean")
port_spec <- add.objective(port_spec, type = "risk", name = "StdDev")
port_spec <- add.objective(port_spec, type = "risk_budget", name = "Beta", arguments = list(beta_target = 1.2))

# Optimize the portfolio
opt_portfolio <- optimize.portfolio(R = asset_returns, portfolio = port_spec, optimize_method = "DEoptim")

# Display results
print(opt_portfolio)
chart.RiskReward(opt_portfolio, risk.col = "StdDev", return.col = "mean")
