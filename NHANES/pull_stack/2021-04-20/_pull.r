
Files = c('DEMO', 'DIQ', 'BPQ', 'FSQ', 'L13', 'L13AM')
Cycles = c('2001-2002', '2003-2004')
df_NH = pull_NHANES(Files, Cycles)

inputs <- as.data.frame(matrix(c(
  # COLUMN    COMMENT     WEIGHTS
   "URXBPH", "URDBPHLC", "WTSB2YR", # Food secuirty
   "URXTRS", "URDTRSLC", "WTSB2YR", # 
), ncol = 3, byrow = TRUE), stringsAsFactors = FALSE) 
names(inputs) <- c("column", "comments", "weights") # You can compute quantiles for multiple columns at once. The simplest way is to pass vectors for the column, comment, and weight name inputs.
nhanes_quantile(df_NH, inputs, quantiles = c(0.5, 0.95, 0.99)) # You can also pass in a data frame that specifies the columns to compute quantiles for.
nhanes_survey(svymean, df_NH, inputs, na.rm = TRUE) #You can use any function from the survey package to analyze your data through the nhanes_survey function. This provides a generic way to apply a survey function to NHANES data.

