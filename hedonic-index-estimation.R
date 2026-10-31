# Cambridge residential hedonic price index
# Run this file with the project directory as the working directory.
# Input: sales_cambridge.csv (Cambridge Land Registry teaching sample)
# The source data and example slides come from the REM1 Session 3 materials.

sales <- read.csv("sales_cambridge.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(sales) <- c(
  "id", "price", "date", "postcode", "propertytype", "new", "tenure",
  "paon", "saon", "street", "locality", "town", "district", "county",
  "category", "status"
)
sales$date <- as.Date(sales$date, format = "%Y-%m-%d")
sales$year <- format(sales$date, "%Y")

# Basic transparent cleaning used in the teaching example.
sales <- subset(sales, propertytype != "O" & is.finite(price) & price > 0)
sales$propertytype <- factor(sales$propertytype)
sales$new <- factor(sales$new)
sales$tenure <- factor(sales$tenure)
sales$year <- factor(sales$year, levels = sort(unique(sales$year)))

# Descriptive mean and median prices, rebased to the first observed year.
yearly_mean <- aggregate(price ~ year, data = sales, FUN = mean)
yearly_median <- aggregate(price ~ year, data = sales, FUN = median)
yearly <- merge(yearly_mean, yearly_median, by = "year", suffixes = c("_mean", "_median"))
yearly <- data.frame(
  year = as.character(yearly$year),
  mean = yearly$price_mean,
  median = yearly$price_median
)
yearly$mean_index <- 100 * yearly$mean / yearly$mean[1]
yearly$median_index <- 100 * yearly$median / yearly$median[1]

# Hedonic time-dummy model. The first factor level is the reference year.
model_data <- droplevels(sales[complete.cases(sales[c(
  "price", "propertytype", "new", "tenure", "year"
)]), ])
hedonic_model <- lm(
  log(price) ~ propertytype + new + tenure + year,
  data = model_data
)
print(summary(hedonic_model))

periods <- levels(model_data$year)
coef_names <- names(coef(hedonic_model))
time_terms <- grep("^year", coef_names, value = TRUE)
base_period <- periods[1]
gamma <- c(0, unname(coef(hedonic_model)[time_terms]))
stopifnot(length(gamma) == length(periods))

hedonic_index <- data.frame(
  year = periods,
  hedonic = 100 * exp(gamma)
)
index_data <- merge(yearly, hedonic_index, by = "year", sort = TRUE)
print(head(index_data))
cat("Reference period:", base_period, "(index = 100)\n")

# Compare rebased index levels.
plot(
  as.integer(index_data$year), index_data$mean_index,
  type = "l", lwd = 2, col = "#b51676",
  xlab = "Year", ylab = "Index (base period = 100)",
  main = "Cambridge sale-price indices"
)
lines(as.integer(index_data$year), index_data$median_index, lwd = 2, col = "#230356")
lines(as.integer(index_data$year), index_data$hedonic, lwd = 2, col = "#2fd1d1")
legend(
  "topleft", c("Mean", "Median", "Hedonic"),
  col = c("#b51676", "#230356", "#2fd1d1"), lwd = 2, bty = "n"
)

# Annual percentage changes from each index level.
returns <- data.frame(
  year = index_data$year[-1],
  mean = 100 * diff(index_data$mean_index) / head(index_data$mean_index, -1),
  median = 100 * diff(index_data$median_index) / head(index_data$median_index, -1),
  hedonic = 100 * diff(index_data$hedonic) / head(index_data$hedonic, -1)
)
print(head(returns))
