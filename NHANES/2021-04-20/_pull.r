# http://wwww.silentspring.org/RNHANES/

## Install library
install.packages('RNHANES')
library(RNHANES)

## Download data
year = '1999-2000'
df_NH = nhanes_load_data('DEMO', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_DIQ = nhanes_load_data('DIQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_DIQ, by = 'SEQN')
df_BPQ = nhanes_load_data('BPQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_BPQ, by = 'SEQN')
df_FSQ = nhanes_load_data('FSQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_FSQ, by = 'SEQN')
df_LAB13 = nhanes_load_data('LAB13', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_LAB13, by = 'SEQN')
df_LAB13AM = nhanes_load_data('LAB13AM', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_LAB13AM, by = 'SEQN')
df_NH$file_name <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH99 <- df_NH
head(df_NH99)

## Download data
year = '2001-2002'
df_NH = nhanes_load_data('DEMO', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_DIQ = nhanes_load_data('DIQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_DIQ, by = 'SEQN')
df_BPQ = nhanes_load_data('BPQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_BPQ, by = 'SEQN')
df_FSQ = nhanes_load_data('FSQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_FSQ, by = 'SEQN')
df_LAB13 = nhanes_load_data('L13', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_LAB13, by = 'SEQN')
df_LAB13AM = nhanes_load_data('L13AM', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_LAB13AM, by = 'SEQN')
df_NH$file_name <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH01 <- df_NH
head(df_NH01)

### Download data
year = '2003-2004'
df_NH = nhanes_load_data('DEMO', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_DIQ = nhanes_load_data('DIQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_DIQ, by = 'SEQN')
df_BPQ = nhanes_load_data('BPQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_BPQ, by = 'SEQN')
df_FSQ = nhanes_load_data('FSQ', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_FSQ, by = 'SEQN')
df_LAB13 = nhanes_load_data('L13', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_LAB13, by = 'SEQN')
df_LAB13AM = nhanes_load_data('L13AM', year = year)
df_NH$file_name <- df_NH$cycle <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH = merge(df_NH, df_LAB13AM, by = 'SEQN')
df_NH$file_name <- df_NH$begin_year <- df_NH$end_year <- NULL
df_NH03 <- df_NH
head(df_NH03)

### Get Variable list
V = colnames(df_NH99)
df_NHV = as.data.frame(V)
df_NHV$NH99 <- TRUE
V = colnames(df_NH01)
df_NHV01 = as.data.frame(V)
df_NHV01$NH01 <- TRUE
df_NHV = merge(df_NHV, df_NHV01, by = 'V')
V = colnames(df_NH03)
df_NHV03 = as.data.frame(V)
df_NHV03$NH03 <- TRUE
df_NHV = merge(df_NHV, df_NHV03, by = 'V')
head(df_NHV)
df_NHV = column_to_rownames(df_NHV, 'V')
vars = rownames(df_NHV)
df_NH99 = df_NH99[c(vars)]
df_NH01 = df_NH01[c(vars)]
df_NH03 = df_NH03[c(vars)]
df_NHF = rbind(df_NH99, df_NH01, df_NH03)
df_NHF = df_NHF %>% relocate('cycle')
df_NHF = df_NHF %>% relocate('SEQN')
head(df_NHF)
write.csv(df_NHF, '_data/NHANES_99_01_03_DIQ_FSQ_LAB.csv', row.names = FALSE) # Clean in excel and select variable

# Build a survey design object for use with survey package
survey <- nhanes_survey_design(df_NHF, weights_column = 'WTSA2YR')


