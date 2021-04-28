# HSR/NHANES/HSA7708_replication
script = 'HSA 7708 Replication Project https://doi.org/10.3945/jn.109.112573'

## Pull NHANES Data
Files = c('DEMO', 'DIQ', 'BPQ', 'FSQ', 'L13', 'L13AM')
Cycles = c('2003-2004')
Descriptions = c('Demographic Variables and Sample Weights', 'Diabetes', 'Blood Pressure & Cholesterol', 'Food Security', 'Cholesterol - Total & HDL', 'Cholesterol - LDL & Triglycerides')
df_NH = pull_stack(Files, Cycles, Descriptions)

## Modify Variables
df_NH$FSDAD[df_NH$FSDAD > 2] <- 1
df_NH$FSDAD[df_NH$FSDAD != 1] <- 0
df_NH$FSDAD[!is.finite(df_NH$FSDA)] <- 0
df_NH$FSDAD

## Extract Population estimates with survey weights
inputs <- as.data.frame(matrix(c(
  # COLUMN    COMMENT     WEIGHTS
   "RIDAGENDR", "SDDSRVYR", "WTMEC2YR", # Gender
   "RIDAGEYR", "SDDSRVYR", "WTMEC2YR", # Age
   "RIDRETH1", "SDDSRVYR", "WTMEC2YR", # Race
   "DMDEDUC2", "SDDSRVYR", "WTMEC2YR", # Education
   "INDHHINC", "SDDSRVYR", "WTMEC2YR", # Income
   "URXTRS", "SDDSRVYR", "WTMEC2YR", # Hypertension
   "URXTRS", "SDDSRVYR", "WTMEC2YR", # Hyperlipidemia
   "URXTRS", "SDDSRVYR", "WTMEC2YR", # Diabetes
   "FSDAD", "SDDSRVYR", "WTMEC2YR" # Food Security
), ncol = 3, byrow = TRUE), stringsAsFactors = FALSE) 
names(inputs) <- c("column", "comments", "weights") # You can compute quantiles for multiple columns at once. The simplest way is to pass vectors for the column, comment, and weight name inputs.
nhanes_quantile(df_NH, inputs, quantiles = c(0, 0.25, 0.5, 0.75, 1)) #You can use any function from the survey package to analyze your data through the nhanes_survey function. This provides a generic way to apply a survey function to NHANES data.

### Reghression Models
D = df_NH
crude = c('age', 'gender', 'race/ethnicity', 'food security')
adjusted = c('age', 'gender', 'race/ethnicity', 'food security', 'education', 'income')

## Hypertension
Y = 'Hypertension'
X = crude
F = as.formula(paste(Y, ' ~ ', paste(X, collapse = ' + '), sep = ''))
HT_c = glm(F, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)
X = adjusted
F = as.formula(paste(Y, ' ~ ', paste(X, collapse = ' + '), sep = ''))
HT_a = glm(F, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)

## Hyperlipidemia
Y = 'Hyperlipidemia'
F = as.formula(paste(Y, ' ~ ', paste(X, collapse = ' + '), sep = ''))
HL_c = glm(F, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)
X = adjusted
F = as.formula(paste(Y, ' ~ ', paste(X, collapse = ' + '), sep = ''))
HL_a = glm(F, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)

### Diabetes
Y = 'Diabetes'
F = as.formula(paste(Y, ' ~ ', paste(X, collapse = ' + '), sep = ''))
DM_c = glm(F, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)
X = adjusted
F = as.formula(paste(Y, ' ~ ', paste(X, collapse = ' + '), sep = ''))
DM_a = glm(F, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)

### Export to Summary File
sink(file = 'summary.txt', append = TRUE, type = 'output')
cat('HSA 7708 Replication Study\n\n', file = 'summary.txt', append = TRUE)
summary(HT_c)
summary(HT_a)
summary(HL_c)
summary(HL_a)
summary(DM_c)
summary(DM_a)
cat(c('\n\n'), file = 'summary.txt', append = TRUE)
cat(c('####################', '\n\n'), file = 'summary.txt', append = TRUE)
sink()