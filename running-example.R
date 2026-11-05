# Running example for index.html: an illustrative office building in Hull.
# All inputs are teaching assumptions, not sourced market evidence.
# Change the inputs below and re-run (Rscript running-example.R) to regenerate
# every figure quoted on the slides.

inputs <- list(
  price        = 3000000,  # purchase price, GBP
  passing_rent = 350000,   # Year 1 potential gross income, GBP a year
  market_rent  = 375000,   # rent from Year 2 after review, GBP a year
  vacancy      = 0.05,     # vacancy and collection loss, share of rent
  opex         = 0.20,     # operating expenditure, share of effective income
  capex        = 40000,    # capital expenditure, GBP a year
  growth       = 0.015,    # annual NOI growth after the review
  purchase_costs = 0.068,  # used for UK yields only, excluded from cash flows
  ltv          = 0.50,     # interest-only loan
  interest     = 0.065,
  exit_yield   = 0.095,    # applied to Year 6 NOI at sale after Year 5
  selling_costs = 0.02,
  hold         = 5,
  target       = 0.12,     # investor's equity target rate
  value_end_y1 = 3030000,  # assumed value after Year 1
  inflation    = 0.02
)

npv <- function(cf, r) sum(cf / (1 + r)^(seq_along(cf) - 1))
irr <- function(cf) uniroot(function(r) npv(cf, r), c(-0.9, 1), tol = 1e-12)$root

run <- function(x) {
  with(x, {
    noi <- function(rent) rent * (1 - vacancy) * (1 - opex)
    noi1 <- noi(passing_rent); noi_m <- noi(market_rent)
    nois <- c(noi1, noi_m * (1 + growth)^(0:(hold - 2)))
    noi_next <- noi_m * (1 + growth)^(hold - 1)
    sale <- noi_next / exit_yield
    net_sale <- sale * (1 - selling_costs)
    debt <- ltv * price; equity <- price - debt; int <- debt * interest
    unlev <- c(-price, nois - capex); unlev[hold + 1] <- unlev[hold + 1] + net_sale
    eq <- c(-equity, nois - capex - int); eq[hold + 1] <- eq[hold + 1] + net_sale - debt
    gross <- price * (1 + purchase_costs)
    ey <- uniroot(function(e) noi1 / (1 + e) + (noi_m / e) / (1 + e) - gross, c(0.001, 0.5))$root
    r <- (noi_m - capex) / price + growth  # cash yield (after capex) + growth
    tr <- (noi1 - capex) / price + (value_end_y1 - price) / price
    list(
      EGI = passing_rent * (1 - vacancy), opex_amount = passing_rent * (1 - vacancy) * opex,
      NOI_y1 = noi1, NOI_market = noi_m, cash_flow_y1 = noi1 - capex,
      income_return = (noi1 - capex) / price, capital_growth = (value_end_y1 - price) / price,
      total_return = tr, real_total_return = (1 + tr) / (1 + inflation) - 1,
      cap_rate_passing = noi1 / price, cap_rate_market = noi_m / price,
      gross_cost = gross, NIY = noi1 / gross, reversionary_yield = noi_m / gross,
      equivalent_yield = ey,
      value_at_9.0 = noi_m / 0.09, value_at_9.5 = noi_m / 0.095, value_at_10.0 = noi_m / 0.10,
      required_return = r, debt = debt, equity = equity, interest = int,
      debt_yield = noi1 / debt, DSCR = noi1 / int,
      equity_cf_y1 = noi1 - capex - int, cash_on_cash = (noi1 - capex - int) / equity,
      NOI_y2_to_y5 = nois[-1], NOI_y6 = noi_next, sale_value = sale,
      selling_cost = sale * selling_costs, sale_to_equity = net_sale - debt,
      unlevered_cash_flows = unlev, equity_cash_flows = eq, unlevered_irr = irr(unlev), equity_irr = irr(eq),
      npv_at_target = npv(eq, target), equity_multiple = sum(eq[-1]) / equity,
      required_equity_return = interest + (r - interest) / (1 - ltv),
      # Decision: unleveraged cash flows discounted at the market required return r
      npv_unlev_at_r = npv(unlev, r),
      unlevered_irr_with_purchase_costs = {
        u <- unlev; u[1] <- -price * (1 + purchase_costs); irr(u) },
      break_even_price = uniroot(function(p0) npv(c(-p0, unlev[-1]), r), c(1e5, 1e8))$root,
      break_even_price_before_costs = uniroot(
        function(p0) npv(c(-p0 * (1 + purchase_costs), unlev[-1]), r), c(1e5, 1e8))$root
    )
  })
}

base <- run(inputs)
str(base, digits.d = 7)

cat("\nExit-yield sensitivity\n")
for (ey in c(0.09, 0.095, 0.11)) {
  x <- inputs; x$exit_yield <- ey; o <- run(x)
  cat(sprintf("%5.1f%%  sale %9.0f  unlevered IRR %6.2f%%  equity IRR %6.2f%%\n",
              100 * ey, o$sale_value, 100 * o$unlevered_irr, 100 * o$equity_irr))
}
