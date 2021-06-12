# HSR/NHANES/HSA7708_replication
script = 'HSA 7708 Replication Project\nhttps://doi.org/10.3945/jn.109.112573'

## Pull NHANES Data
Files = c('DEMO', 'DIQ', 'BPQ', 'BPX', 'FSQ', 'LAB13', 'LAB13AM', 'LAB10AM')
Cycles = c('1999-2000')
Descriptions = c('Demographic Variables and Sample Weights', 'Diabetes', 'Blood Pressure & Cholesterol', 'Blood Pressure', 'Food Security', 'Cholesterol - Total & HDL', 'Cholesterol - LDL & Triglycerides', 'Plasma Fasting Glucose, Serum C-peptide & Insulin')
df_NH1 = pull_stack(Files, Cycles, Descriptions)
df_NH1$FSDAD <- df_NH1$ADFDSEC
head(df_NH1)

## Pull NHANES Data
Files = c('DEMO', 'DIQ', 'BPQ', 'BPX', 'FSQ', 'L13', 'L13AM', 'L10AM')
Cycles = c('2001-2002')
Descriptions = c('Demographic Variables and Sample Weights', 'Diabetes', 'Blood Pressure & Cholesterol', 'Blood Pressure', 'Food Security', 'Cholesterol - Total & HDL', 'Cholesterol - LDL & Triglycerides', 'Plasma Fasting Glucose, Serum C-peptide & Insulin')
df_NH2 = pull_stack(Files, Cycles, Descriptions)
df_NH2$FSDAD <- df_NH2$ADFDSEC
head(df_NH2)

## Pull NHANES Data
Files = c('DEMO', 'DIQ', 'BPQ', 'BPX', 'FSQ', 'L13', 'L13AM', 'L10AM')
Cycles = c('2003-2004')
Descriptions = c('Demographic Variables and Sample Weights', 'Diabetes', 'Blood Pressure & Cholesterol', 'Blood Pressure', 'Food Security', 'Cholesterol - Total & HDL', 'Cholesterol - LDL & Triglycerides', 'Plasma Fasting Glucose, Serum C-peptide & Insulin')
df_NH3 = pull_stack(Files, Cycles, Descriptions)
head(df_NH3)

## Combine cycles
V = colnames(df_NH1)
df_V1 = as.data.frame(V)
df_V1$Cycle <- '1999-2000'
V = colnames(df_NH2)
df_V2 = as.data.frame(V)
df_V2$Cycle <- '2001-2002'
V = colnames(df_NH3)
df_V3 = as.data.frame(V)
df_V3$Cycle <- '2003-2004'
df_V = merge(df_V1, df_V2, by = 'V', how = 'inner')
df_V = merge(df_V, df_V3, by = 'V', how = 'inner')
vars = c(as.character(df_V$V))
df_NH = rbind(df_NH1[vars], df_NH2[vars], df_NH3[vars])
head(df_NH)

## Select variables
NHANES_Variables <- c('RIAGENDR',
                    'RIDAGEYR',
                    'RIDRETH1',
                    'DMDEDUC2',
                    'INDFMPIR',
                    'BPQ020',
                    'BPXSY1',
                    'BPXDI1', 
                    'BPQ080',
                    'LBXTC', 
                    'DIQ010',
                    'LBXGLU',
                    'FSDAD')
NHANES_Description <- c('Gender',
                    'Age at Screening',
                    'Race/Ethnicity',
                    'Education Level - Adults 20+',
                    'Family income to Poverty Ratio',
                    'Doctor told you that you have high blood pressure',
                    'Systolic Blood Pressure',
                    'Diastolic Blood Pressure',
                    'Doctor told you that you have high cholesterol',
                    'Total Cholesterol (mg/dL)',
                    'Doctor told you that you have diabetes',
                    'Glucose, plasma (mg/dL)',
                    'Adult food security category')
df_NHANES = data.frame(NHANES_Variables, NHANES_Description)

Study_Variables <- c('Gender', 
                    'Age', 
                    'Race', 
                    'Education', 
                    'Income', 
                    'Hypertension', 
                    'Hyperlipidemia', 
                    'Diabetes', 
                    'Food')
Study_Description <- c('Female Identifying (RIAGENDR == 2)', 
                    'Age in years (18 to 65) (RIAGENDR = RIAGENDR)', 
                    'Non-white or Hispanic (RIDRETH1 != 3)', 
                    'High School Education or less (DMDEDUC2 < 3)', 
                    'Income Relative to Poverty Line (above 200%)', 
                    'Hypertension Diagnosed (BPQ020 = 1), Clinical (BPXDI1 > 140, BPXSY1 > 90)', 
                    'Hyperlipidemia Diagnosed (BPQ080 = 1), Clinical (LBXTC > 200, LBDLDL > 160)', 
                    'Diabetes Diagnosed (DQI010 = 1), Clinical (LBXGLU > 126)', 
                    'Food Security Low or Very Low, (FSDAD >= 3)')
df_Study = data.frame(Study_Variables, Study_Description)

### Modify Variables
New = 'Gender'
Old = 'RIAGENDR'
Level = 2
df_NH[New] <- 0
df_NH[New][df_NH[Old] == Level] <- 1
summary(df_NH[New])
New = 'Age'
Old = 'RIDAGEYR'
df_NH[New] <- df_NH[Old]
summary(df_NH[New])
New = 'Race'
Old = 'RIDRETH1'
Level = 1
df_NH[New] <- 3
df_NH[New][df_NH[Old] != Level] <- 1
summary(df_NH[New])
New = 'Education'
Old = 'DMDEDUC2'
Level = 3
df_NH[New] <- 0
df_NH[New][df_NH[Old] < Level] <- 1
summary(df_NH[New]) 
New = 'Income'
Old = 'INDHHINC'
df_NH[New] <- df_NH[Old]
df_NH[New][df_NH[New] > 5] <- 5
summary(df_NH[New]) 
New = 'Hypertension'
Old = 'BPQ020'
Old2 = 'BPXDI1'
Old3 = 'BPXSY1'
Level = 1
Level2 = 140
Level3 = 90
df_NH[New] <- 0
df_NH[New][df_NH[Old] == Level] <- 1
df_NH[New][df_NH[Old2] > Level2] <- 1
df_NH[New][df_NH[Old3] > Level3] <- 1
summary(df_NH[New])
New = 'Hyperlipidemia'
Old = 'BPQ080'
Old2 = 'LBXTC'
Old3 = 'LBDLDL'
Level = 1
Level2 = 200
Level3 = 160
df_NH[New] <- 0
df_NH[New][df_NH[Old] == Level] <- 1
df_NH[New][df_NH[Old2] > Level2] <- 1
df_NH[New][df_NH[Old3] > Level3] <- 1
summary(df_NH[New])
New = 'Diabetes'
Old = 'DIQ010'
Old2 = 'LBXGLU'
Level = 1
Level2 = 126
df_NH[New] <- 0
df_NH[New][df_NH[Old] == Level] <- 1
df_NH[New][df_NH[Old2] > Level2] <- 1
summary(df_NH[New])
New = 'Food'
Old = 'FSDAD'
Level = 3
df_NH[New] <- 0
df_NH[New][df_NH[Old] >= Level] <- 1
summary(df_NH[New])  

### Export to Summary File
options(width = 250)
sink(file = 'summary.txt', append = TRUE, type = 'output')
cat(script, '\n\n', file = 'summary.txt', append = TRUE)
cat('NHANES Cycles: ', Cycles, '\n')
cat('NHANES Files: ', Files, '\n')
cat('NHANES Variables:', '\n', file = 'summary.txt', append = TRUE)
summary(df_NH[NHANES_Variables])
cat('\n', file = 'summary.txt', append = TRUE)
cat('NHANES Descriptions:', '\n', file = 'summary.txt', append = TRUE)
df_NHANES
cat('\n', file = 'summary.txt', append = TRUE)
cat('Study Variables:', '\n', file = 'summary.txt', append = TRUE)
summary(df_NH[Study_Variables])
cat('\n', file = 'summary.txt', append = TRUE)
cat('Study Descriptions:', '\n', file = 'summary.txt', append = TRUE)
df_Study
cat('\n', file = 'summary.txt', append = TRUE)
cat(c('####################', '\n\n'), file = 'summary.txt', append = TRUE)
sink()

### Survey Weighted Generalizaed Reghression Models
D = df_NH[which(df_NH$INDFMPIR < 2 & df_NH$RIDAGEYR > 18 & df_NH$RIDAGEYR < 65), ]
S = nhanes_survey_design(D, weights_column = 'WTINT2YR')
X = 'Food'
A = c('Gender', 'Age', 'Race', 'Education', 'Income')
Y1 = 'Hypertension'
F1 = as.formula(paste(Y1, ' ~ ', paste(X, '+', paste(A, collapse = ' + ')), sep = ''))
M1 = svyglm(F1, design = S, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)
Y2 = 'Hyperlipidemia'
F2 = as.formula(paste(Y2, ' ~ ', paste(X, '+', paste(A, collapse = ' + ')), sep = ''))
M2 = svyglm(F2, design = S, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)
Y3 = 'Diabetes'
F3 = as.formula(paste(Y3, ' ~ ', paste(X, '+', paste(A, collapse = ' + ')), sep = ''))
M3 = svyglm(F3, design = S, data = D, family = poisson()) # Log link [Y = ln(DV)] (aka: Log-Linear) with poisson error (aka: Poisson regression)

### Export to Summary File
sink(file = 'summary.txt', append = TRUE, type = 'output')
cat('Generalized Regression Models using Survey Weights', '\n\n', file = 'summary.txt', append = TRUE)
cat('Title:\n', Y1, 'and', X, 'adjusted by', A, '\n', file = 'summary.txt', append = TRUE)
summary(M1)
cat('Odds Ratios: ', '\n', 'Intercept', X, A, '\n', exp(coef(M1)), '\n', file = 'summary.txt', append = TRUE)
cat('\n', file = 'summary.txt', append = TRUE)
cat('Title:\n', Y2, 'and', X, 'adjusted by', A, '\n', file = 'summary.txt', append = TRUE)
summary(M2)
cat('Odds Ratios: ', '\n', 'Intercept', X, A, '\n', exp(coef(M2)), '\n', file = 'summary.txt', append = TRUE)
cat('\n', file = 'summary.txt', append = TRUE)
cat('Title:\n', Y3, 'and', X, 'adjusted by', A, '\n', file = 'summary.txt', append = TRUE)
summary(M3)
cat('Odds Ratios: ', '\n', 'Intercept', X, A, '\n', exp(coef(M3)), '\n', file = 'summary.txt', append = TRUE)
cat('\n', file = 'summary.txt', append = TRUE)
cat(c('####################', '\n\n'), file = 'summary.txt', append = TRUE)
sink()