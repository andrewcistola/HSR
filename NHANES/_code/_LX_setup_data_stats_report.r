# Local Script for Linux

## Local Step 1: Location Variables

### Local path to working directory
path = '/home/drewc/_UFL/' 
project = 'HSA_7708/' # Input local path to directory containing the repo where allocativ folder was placed
subject = 'NHANES/' # Input an informative short directory label for the subject of the analysis

## Local Step 2: Project and Subject Variables

### Define features and labels specfic to this analysis
ST = '' # Define geographic boundary for study Subsample by state abbreviations
pop = '' # Define study Subsample by project specific prefix
outcome = '' # Define outcome of interest by project specific prefix
unit = '' # Define unit of measure for the outcome

### Define Descriptions
desc_target = ''
notes = ''

### Text for Output files
title = 'HSA 7708 Spring 2021' # Input basic title
descriptive = 'Replication Study Assignment' # Input descriptive title
author = 'Andrew S. Cistola MPH' # Input full legal name of author
reference = ''
about = ''
disclaimer = ''

## Local Step 3: User Specific variables

### Define user
user = 'andrewcistola@ufl.edu' # Name of GitHub user or isntitutional email

### Access keys
key_census = 'c82350b0bbe6c8a46ce163365ee3f2abcd16253e' # Personal census key
key_google = 'AIzaSyD4OFeCyUSbG_3zeOwVUBRDxjngluLfJJ8' # Google geocoding key

### Style preferences
low = 'blue3' # Standard map colorscheme
mid = 'lightyellow' # Standard map colorscheme
high = 'red3' # Standard map colorscheme
na = 'grey50' # Standard map colorscheme
line = 'black' # Standard map colorschem
breaks = 9 # Standard map colorscheme
scheme = 'trad' # Standard map colorscheme
font = 'Vollkorn' # Define font for all figs 


# Setup Section: Environment setup

## Setup Step 1: Import Libraries

### Hadley Wickham
library(tidyverse) # All of the libraries above in one line of code
library(skimr) # Simple data view tool from Hadley-Wickham
library(reshape2) # old version of tidyr that contains the melt() function

### Formatting
library(sysfonts) # Dependency for showfonts
library(showtext) # Access google fonts
library(stringi) # Proper title for strings
library(rmarkdown) # Render markdown in R

### Data management
library(httr) # API queries from http
library(jsonlite) # JSON to data frame conversions
library(data.table) # provides a high-performance version of base R's data.frame with syntax and feature enhancements for ease of use, convenience and programming speed.

### NHANES
# devtools::install_github("SilentSpringInstitute/RNHANES")
library(RNHANES) #  Facilitates Analysis of CDC NHANES Data

### Statistics
library(statmod) # Dependency for lme4
library(lme4) # Linear mixed effect modeling in R
library(arm) # Visualizations of linear mixed effect modeling using 'lme4' in R
library(lmtest) # Linear model tests including Breusch Pagan
library(lmerTest) # Linear mixed effect model tests allowing for Saittherwaier DOF and signficiance tests
library(DescTools) # Descriptive statistics including Jarque-Bera, Andrerson-Darling, Durbin-Watson, Cronbach's Alpha
library(ineq) # Gini coefficient and Lorenz curve
library(performance) # Inter class correlation coefficient for HLM
library(survey) #  Analysis of Complex Survey Samples 

### Machine Learning
library(randomForest) # Popular random forest package for R
library(randomForestExplainer) # Complimentary to randfomForest package with tools for analysis

### GIS
library(sp) # S4 classes for spatial data in R
library(ggmap) # General use mapping library with ggplot API
library(GWmodel) # Geographic weighted regression in R
library(maptools) # Dependency for GW model
library(rgdal) # Read shapefiles into R
library(rgeos) # Calculate centroids
library(ggsn) # North function for mapping
library(raster)  # Scalebar function for mapping
library(grid) # Used for scalebar
library(maps) # USed to scalebar
library(ggspatial) # Easy scalebar

### Devtools
# library(cli)
# library(devtools)
# install.packages('')
# remove.packages('')
# library(installr)
# updateR()

## Setup Step 3: 

### System variables
day = Sys.Date() # Save simple date as string
stamp = date() # Save Date and timestamp
directory = paste(path, project, subject, sep = "") # Set wd to project repository using variables

### Output files
report = '_report.md'

### Run functions
setwd(directory) # Set working directory
register_google(key = key_google)
font_add_google(name = font, family = font)
showtext_auto()
options(width = 250) # Set widescreen option for printing data frames (default = 80)

# Data Section

## Data Step 1: Define Pull Stack Function

pull_stack <- function(Files, Cycles, Descriptions)
    {
        l_NHY <- base::list()
        l_NHV <- base::list()
        for (I in Cycles)
            {
                df_DATA = data.frame(Files, Descriptions)
                df_DATA$Cycle <- I
                l_NH <- base::list()
                for (i in c(as.numeric(rownames(df_DATA))))
                    {
                        df_i = nhanes_load_data(as.character(df_DATA$Files[i]), year = I)
                        df_i$file_name <- NULL
                        df_i$cycle <- NULL
                        df_i$begin_year <- NULL
                        df_i$end_year <- NULL
                        l_NH[[i]] <- df_i
                    }
                df_I = l_NH %>% reduce(full_join, by = 'SEQN')
                df_I$Cycle <- as.character(I) 
                l_NHY[[I]] = df_I
                vars = colnames(df_I)
                df_V = as.data.frame(vars)
                df_V[I] <- as.character(I) 
                l_NHV[[I]] = df_V
            }
        df_NHV = l_NHV %>% reduce(inner_join, by = 'vars')
        l_NH = base::list()
        l_NH = lapply(l_NHY, function(j) 
                                {
                                    j2 = j[c(as.character(df_NHV$vars))]
                                    return(j2)
                                }
                                )
        df_NH = rbindlist(l_NH)
        head(df_NH)
        df_NH = df_NH %>% relocate('Cycle')
        df_NH = df_NH %>% relocate('SEQN')
        df_NH$SEQN_Cycle <- paste(as.character(df_NH$SEQN), '_', as.character(df_NH$Cycle), sep = '')       
        df_NH = as.data.frame(df_NH)
        write.csv(df_NH, paste('_data/NHANES_', format(Sys.time(), "%m-%d_%H%M"), '.csv', sep = ''), row.names = FALSE) # Clean in excel and select variable
        options(width = 250)
        sink(file = paste('_data/NHANES_', format(Sys.time(), "%m-%d_%H%M"), '.txt', sep = ''))
        cat('National Health and Nutrition Examination Survey<br>\n')
        cat('Automated Data pull using `RNHANES` library in R<br>\n')
        cat('https://cran.r-project.org/web/packages/RNHANES/vignettes/introduction.html<br>\n')
        cat('Download:', date(), '<br>\n')
        cat('Filename: _data/NHANES', format(Sys.time(), "%m-%d_%H%M"), '.csv<br>\n')
        cat('Files: ', Files, '<br>\n')
        cat('Cycles: ', Cycles, '<br>\n<br>\n')
        cat(print(skim(df_NH)))
        sink()
        options(width = 80)
        return(df_NH)
    }

## Data Step 2: Pull NHANES Data

## Select files and cycles
Files = c('DEMO', 'BMX', 'DIQ', 'DPQ', 'HIQ', 'HUQ', 'MCQ')
Cycles = "2015-2016"
Descriptions = c('Demographic Variables and Sample Weights', 'Body Measures', 'Diabetes', 'Mental Health - Dperession Screener', 'Health insurance', 'Hospital Utilization & Access to Care', 'Medical Conditions')

## Select variables
NHANES_Variables <- c('SEQN',
                    'RIAGENDR',
                    'RIDAGEYR',
                    'RIDRETH1',
                    'INDFMPIR',
                    'DMDMARTL',
                    'RIDEXPRG',
                    'DMDHHSZA',
                    'DMDHHSZB',
                    'BMXBMI',
                    'DIQ010',
                    'DPQ010',
                    'DPQ020',
                    'DPQ030',
                    'DPQ040',
                    'DPQ050',
                    'DPQ060',
                    'DPQ070',
                    'DPQ080',
                    'DPQ090',
                    'HIQ011',
                    'HUQ010',
                    'HUQ051',
                    'MCQ010',
                    'MCQ080',
                    'MCQ160A',
                    'MCQ160B',
                    'MCQ160C',
                    'MCQ160D',
                    'MCQ160E',
                    'MCQ160F',
                    'MCQ160G',
                    'MCQ160M',
                    'MCQ160K',
                    'MCQ160L',
                    'MCQ160O',
                    'MCQ220')
NHANES_Description <- c('Respondent Number',
                    'Gender',
                    'Age at Screening',
                    'Race/Ethnicity',
                    'Family income to Poverty Ratio',
                    'Marital staus',
                    'Pregancy status at exam',
                    '# of children 5 years or younger in HH',
                    '# of children 6-17 years old in HH',
                    'Doctor told you that you have diabetes',
                    'Body Mass Index (kg/m**2)',
                    'Have little interest in doing things',
                    'Feeling down, depressed, or hopeless',
                    'Trouble sleeping or sleeping too much',
                    'Feeling tired or having little energy',
                    'Poor appetite or overeating',
                    'Feeling bad about yourself',
                    'Trouble concentrating on things',
                    'Moving or speaking slowly or too fast',
                    'Thought you would be better off dead',
                    'Covered by health insurance',
                    'General health condition',
                    '# of times receive healthcare over past year',
                    'Ever been told you have asthma',
                    'Doctor ever said you were overweight',
                    'Doctor ever said you had arthritis',
                    'Ever told had congestive heart failure', 
                    'Ever told you had coronary heart disease',
                    'Ever told you had angina/angina pectoris',
                    'Ever told you had heart attack',
                    'Ever told you had a stroke',
                    'Ever told you had emphysema',
                    'Ever told you had thyroid problem',
                    'Ever told you had chronic bronchitis',
                    'Ever told you had any liver condition',
                    'Ever told you had COPD?',
                    'Ever told you had cancer or malignancy')
df_NHANES = data.frame(NHANES_Variables, NHANES_Description)

### Define Study variables
Study_Variables <- c('Subsample', 
                    'Income',
                    'Married',
                    'Children', 
                    'BMI',
                    'Insurance',
                    'Health',
                    'Utilization',
                    'Depression',
                    'Comorbidity')
Study_Description <- c('White Male (RIAGENDR == 1 & RIDRETH1 == 1) as 1, White Female (RIAGENDR == 2 & RIDRETH1 == 1) as 2, Minority Male (RIAGENDR == 1 & RIDRETH1 > 1) as 3, White Male (RIAGENDR == 2 & RIDRETH1 > 1) as 4', 
                    'Income Relative to Poverty Line (above 200%)', 
                    'Married (DMDMARTL == 1)',
                    'Number of children (DMDHHSZA + DMDHHSZB)',
                    'BMI',
                    'Has health insurance (HIQ010 == 1) as 1 or No health insurance (HUQ010 == 2) as 0',
                    'Excellent (HUQ010 == 1) as 1 ... Poor (HUQ010 == 5) as 5',
                    'None (HUQ051 == 0) as 0 ... 16 or more (HUQ051 == 8) as 8',
                    'Depression level (DPQ010 + DPQ020 + DPQ030 + DPQ040 + DPQ050 + DPQ060 + DPQ070 + DPQ080 + DPQ090)',
                    'Number of comorbidites (MCQ010 == 1 + MCQ080 == 1 + MCQ160a == 1 + MCQ160b == 1 + MCQ160c == 1 + MCQ160d == 1 + MCQ160e == 1 + MCQ160f == 1 + MCQ160g == 1 + MCQ160m == 1 + MCQ160k == 1 + MCQ160l == 1 + MCQ160o == 1 + MCQ220 == 1')
df_Study = data.frame(Study_Variables, Study_Description)

### Subset by selected variables
df_Raw = pull_stack(Files, Cycles, Descriptions)
df_NH = df_Raw[(NHANES_Variables)] # Subset by selected variables
head(df_NH)

### Subset by Subsample demographics
df_NH = df_NH[which(df_NH$RIDAGEYR >= 18 & df_NH$RIDAGEYR < 65), ] # Subsample 18 to 65
df_NH = df_NH[which(df_NH$RIDEXPRG != 1 | !is.finite(df_NH$RIDEXPRG)), ] # Not listed as pregnant
df_NH = df_NH[which(df_NH$DIQ010 == 1), ] # Diagnosed diabetes
head(df_NH)

## Data Step 4: Define composite variables

### Children
df_NH$Children = df_NH$DMDHHSZA + df_NH$DMDHHSZB
summary(df_NH$Children)

### Depression composite variable
df_NH$DPQ010[df_NH$DPQ010 > 3 & df_NH$DPQ010 < 1] <- 0
df_NH$DPQ020[df_NH$DPQ020 > 3 & df_NH$DPQ020 < 1] <- 0
df_NH$DPQ030[df_NH$DPQ030 > 3 & df_NH$DPQ030 < 1] <- 0
df_NH$DPQ040[df_NH$DPQ040 > 3 & df_NH$DPQ040 < 1] <- 0
df_NH$DPQ050[df_NH$DPQ050 > 3 & df_NH$DPQ050 < 1] <- 0
df_NH$DPQ060[df_NH$DPQ060 > 3 & df_NH$DPQ060 < 1] <- 0
df_NH$DPQ070[df_NH$DPQ070 > 3 & df_NH$DPQ070 < 1] <- 0
df_NH$DPQ080[df_NH$DPQ080 > 3 & df_NH$DPQ080 < 1] <- 0
df_NH$DPQ090[df_NH$DPQ090 > 3 & df_NH$DPQ090 < 1] <- 0
df_NH$Depression = df_NH$DPQ010 + df_NH$DPQ020 + df_NH$DPQ030 + df_NH$DPQ040 + df_NH$DPQ050 + df_NH$DPQ060 + df_NH$DPQ070 + df_NH$DPQ080 + df_NH$DPQ090
df_NH$Depression[!is.finite(df_NH$Depression)] <- 0
summary(df_NH$Depression)

### Comorbidity composite variable
df_NH$MCQ010[df_NH$MCQ010 != 1 | !is.finite(df_NH$MCQ010)] <- 0
df_NH$MCQ080[df_NH$MCQ080 != 1 | !is.finite(df_NH$MCQ080)] <- 0
df_NH$MCQ160A[df_NH$MCQ160A != 1 | !is.finite(df_NH$MCQ160A)] <- 0
df_NH$MCQ160B[df_NH$MCQ160B != 1 | !is.finite(df_NH$MCQ160B)] <- 0
df_NH$MCQ160C[df_NH$MCQ160C != 1 | !is.finite(df_NH$MCQ160C)] <- 0
df_NH$MCQ160D[df_NH$MCQ160D != 1 | !is.finite(df_NH$MCQ160D)] <- 0
df_NH$MCQ160E[df_NH$MCQ160E != 1 | !is.finite(df_NH$MCQ160E)] <- 0
df_NH$MCQ160F[df_NH$MCQ160F != 1 | !is.finite(df_NH$MCQ160F)] <- 0
df_NH$MCQ160G[df_NH$MCQ160G != 1 | !is.finite(df_NH$MCQ160G)] <- 0
df_NH$MCQ160M[df_NH$MCQ160M != 1 | !is.finite(df_NH$MCQ160M)] <- 0
df_NH$MCQ160K[df_NH$MCQ160K != 1 | !is.finite(df_NH$MCQ160K)] <- 0
df_NH$MCQ160L[df_NH$MCQ160L != 1 | !is.finite(df_NH$MCQ160L)] <- 0
df_NH$MCQ160O[df_NH$MCQ160O != 1 | !is.finite(df_NH$MCQ160O)] <- 0
df_NH$MCQ220[df_NH$MCQ220 != 1 | !is.finite(df_NH$MCQ220)] <- 0
df_NH$Comorbidity = df_NH$MCQ010 + df_NH$MCQ080 + df_NH$MCQ160A  + df_NH$MCQ160B  + df_NH$MCQ160C  + df_NH$MCQ160D  + df_NH$MCQ160E  + df_NH$MCQ160F  + df_NH$MCQ160G  + df_NH$MCQ160M  + df_NH$MCQ160K  + df_NH$MCQ160L  + df_NH$MCQ160O  + df_NH$MCQ220
df_NH$Comorbidity[!is.finite(df_NH$Comorbidity)] <- 0
summary(df_NH$Comorbidity)

### Rename and clean categorical variables
df_NH$Married <- 0
df_NH$Insurance <- 0
df_NH$Married[df_NH$DMDMARTL == 1] <- 1
df_NH$Insurance[df_NH$HIQ011 == 1] <- 1
summary(df_NH$Married)
summary(df_NH$Insurance)

### Rename and clean quantitative variables
df_NH$Health <- df_NH$HUQ010
df_NH$Utilization <- df_NH$HUQ051
df_NH$BMI <- df_NH$BMXBMI
df_NH$Income <- df_NH$INDFMPIR
df_NH$Health[!is.finite(df_NH$HUQ010) | df_NH$HUQ010 == 0] <- median(is.finite(df_NH$HUQ010))
df_NH$Utilization[!is.finite(df_NH$HUQ051) | df_NH$HUQ051 == 0] <- median(is.finite(df_NH$HUQ051))
df_NH$BMI[!is.finite(df_NH$BMXBMI) | df_NH$BMXBMI == 0] <- median(is.finite(df_NH$BMXBMI))
df_NH$Income[!is.finite(df_NH$INDFMPIR) | df_NH$INDFMPIR == 0] <- median(is.finite(df_NH$INDFMPIR))
summary(df_NH$Health)
summary(df_NH$Utilization)
summary(df_NH$BMI)
summary(df_NH$Income)

### Create Subsamples for analysis
df_NH$Subsample <- 0
df_NH$Subsample[df_NH$RIDRETH == 1 & df_NH$RIAGENDR == 1] <- 1 # White Male
df_NH$Subsample[df_NH$RIDRETH == 1 & df_NH$RIAGENDR == 2] <- 2 # White Female
df_NH$Subsample[df_NH$RIDRETH > 1 & df_NH$RIAGENDR == 1] <- 3 # Minority Male
df_NH$Subsample[df_NH$RIDRETH > 1 & df_NH$RIAGENDR == 2] <- 4 # Minority Female
summary(df_NH$Subsample)

### Subset by selected variables
df_NH = df_NH[Study_Variables]
skim(df_NH)

# Stats Section

## Stats step 1: Table 1

### Mean values
mean_WM = unname(round(apply(df_NH[which(df_NH$Subsample == 1), which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = mean), 4))
mean_WF = unname(round(apply(df_NH[which(df_NH$Subsample == 2), which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = mean), 4))
mean_MM = unname(round(apply(df_NH[which(df_NH$Subsample == 3), which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = mean), 4))
mean_MF = unname(round(apply(df_NH[which(df_NH$Subsample == 4), which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = mean), 4))
mean_full = unname(round(apply(df_NH[ , which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = mean), 4))

### Standard deviations
sd_WM = unname(round(apply(df_NH[which(df_NH$Subsample == 1), which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = sd), 4))
sd_WF = unname(round(apply(df_NH[which(df_NH$Subsample == 2), which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = sd), 4))
sd_MM = unname(round(apply(df_NH[which(df_NH$Subsample == 3), which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = sd), 4))
sd_MF = unname(round(apply(df_NH[which(df_NH$Subsample == 4), which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = sd), 4))
sd_full = unname(round(apply(df_NH[ , which(colnames(df_NH) != 'Subsample')], MARGIN = 2, FUN = sd), 4))

### N 
N_WM = nrow(df_NH[which(df_NH$Subsample == 1), ])
N_WF = nrow(df_NH[which(df_NH$Subsample == 2), ])
N_MM = nrow(df_NH[which(df_NH$Subsample == 3), ])
N_MF = nrow(df_NH[which(df_NH$Subsample == 4), ])
N_full = nrow(df_NH)

## Stats Step 2: Regression Model

### Poisson Regression variables
Y = 'Utilization'
X = c('Income', 'Married', 'Children', 'BMI', 'Insurance', 'Health', 'Utilization', 'Depression', 'Comorbidity')
R = as.formula(paste(Y, ' ~ ', paste(X, collapse = ' + '), sep = ''))
D = df_NH[which(df_NH$Subsample == 1), ]
G = 'poisson'

### Model for Subsample 1
D = df_NH[which(df_NH$Subsample == 1), ]
GLM = glm(R, family = G, data = D) # Identitiy link [Y = DV*1] (aka: Linear) with gaussian error (aka: Linear regression)
coef_WM = round(coef(GLM), 4)
se_WM = round(se.coef(GLM), 4)
p_WM = round(coef(summary(GLM))[,'Pr(>|z|)'], 4)

### Model for Subsample 2
D = df_NH[which(df_NH$Subsample == 2), ]
GLM = glm(R, family = G, data = D) # Identitiy link [Y = DV*1] (aka: Linear) with gaussian error (aka: Linear regression)
coef_WF = round(coef(GLM), 4)
se_WF = round(se.coef(GLM), 4)
p_WF = round(coef(summary(GLM))[,'Pr(>|z|)'], 4)

### Model for Subsample 3
D = df_NH[which(df_NH$Subsample == 3), ]
GLM = glm(R, family = G, data = D) # Identitiy link [Y = DV*1] (aka: Linear) with gaussian error (aka: Linear regression)
coef_MM = round(coef(GLM), 4)
se_MM = round(se.coef(GLM), 4)
p_MM = round(coef(summary(GLM))[,'Pr(>|z|)'], 4)

### Model for Subsample 4
D = df_NH[which(df_NH$Subsample == 4), ]
GLM = glm(R, family = G, data = D) # Identitiy link [Y = DV*1] (aka: Linear) with gaussian error (aka: Linear regression)
coef_MF = round(coef(GLM), 4)
se_MF = round(se.coef(GLM), 4)
p_MF = round(coef(summary(GLM))[,'Pr(>|z|)'], 4)

### Model for full sample
D = df_NH
GLM = glm(R, family = G, data = D) # Identitiy link [Y = DV*1] (aka: Linear) with gaussian error (aka: Linear regression)
coef_full = round(coef(GLM), 4)
se_full = round(se.coef(GLM), 4)
p_full = round(coef(summary(GLM))[,'Pr(>|z|)'], 4)

# Report Section

## Report Step 1: Header

### Open File with Title
cat("##", title, ': ', descriptive, '\n', file = report, append = F)
cat('#####', author, '\n', file = report, append = T)
cat('\n\n', file = report, append = T)

## Report Step 2: Text

### Introduction, Section 1-3
intro = 'In 2019, *Diabetes Research and Clinical Practice* published the article titled “Correlates of health care use among White and minority men and women with diabetes: An NHANES study” by Jessie J Wong et al. The purpose of this study was to find patient level factors that are associated with health care utilization among individuals with diabetes among groups delineated by race/ethnicity and gender.'
title_1 = 'Replication Results'
text_1 = 'This study was replicated using the following data, definitons, and methods. The study was cross-sectional and used data available from the 2015-2016 National Health and Nutrition Examination Survey cohort. The population included 447 non-pregnant adults aged 18-64 with diagnosed diabetes. The independent variables were patient level factors including self-reported health status, depression, comorbidities, income, body mass index, marital status, number of children, insurance coverage, and age. The dependent variable was overall health care use. Poisson regression models were created for white men, minority men, white women, and minority women. Subjective factors were significant for white men, financial factors were significant for minority men, and family structure or mental health was significant for both white and minority women. The replication study (Table 1 and Table 2) provided similar results, with minor deviations likely due to small differences in computational methods (original study used Math+, replication study used R version 3.6)'
title_2 = 'Strengths and Weaknesses'
text_2 = 'The methodology used by the original study was appropriate for a number of reasons. The study utilized regression modeling among subgroups to identify population specific estimates rather than adjusting for these demographics. This allowed for a more precise understanding of the possible effects. Due to the skewed distribution of utilization data, Poisson regression as appropriate. However, specific tests of regression assumptions were not reported and the use of Poisson regression was only mentioned in the abstract. Similarly, the primary weakness of the study was the lack of investigation into the possible combined effects of the various independent variables. Seeing that there are variables that are very similar (marital status and children, or income and insurance) it is very possible that these variables may be confounding a more accurate effect. This could be evaluated with a collinearity matrix or other method for displaying collinearity, but the authors did not provide that information.'
title_3 = 'Alternative Methods'
text_3 = 'In order to answer the same research question, the following approach would also be appropriate. Before creating the final Poisson regression models, the collinearity of the independent variables would be evaluated. Those that are clearly colinear would require alternative methods for inclusion or be a candidate for a possible interaction term. Assuming collinearity is identified, a possible approach would be to redefine the variables of interest by:<br>1) creating a composite index of the objective health status variables (similar to the neighborhood deprivation index)<br>2) recoding the marital and family status variables as one multi-level category defined as 0 = married, no children; 1 = married with children; 2 = unmarried<br>3) Including an interaction term for income and insurance<br>4) Age, BMI, and self-rated health would remain the same<br>These recodings would be validated based on previous studies and evidence of the direction of effect from bivariate statistics. However, these new variables would allow for a more precise understanding of the general effects pertinent to the research question using the same Poisson regression model for each subgroup. Alongside the Poisson regression models for each subgroup, a hierarchical linear model for all groups could be utilized to identify the comparative effect of subgroup identification on utilization. By categorizing the four subgroups as random effects, an intra-class coefficient could be calculated to identify how much of the variation in the data is accounted by these population differences. This information would help compliment the findings from the individual models and show how strong the differences among groups may be when compared to patient level factors.' 

### Create Sections
cat(intro, '\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('### ', title_1, '\n', file = report, append = T)
cat('\n', file = report, append = T)
cat(text_1, '\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('### ', title_2, '\n', file = report, append = T)
cat('\n', file = report, append = T)
cat(text_2, '\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('### ', title_3, '\n', file = report, append = T)
cat('\n', file = report, append = T)
cat(text_3, '\n', file = report, append = T)
cat('\n', file = report, append = T)

## Report Step 3: Tables

### Table Header
cat('### Tables\n', file = report, append = T)
cat('\n', file = report, append = T)

### Table 1
cat('#### Table 1. Descriptive statistics of study variables within full and subsamples.\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('Subsample       |', 'N', '\n', file = report, append = T)
cat('----------------|---------------------------------------------------------------', '\n', file = report, append = T)
cat(c('*Total*          | ', N_full, '\n'), file = report, append = T) 
cat(c('*White men*      | ', N_WM, '\n'), file = report, append = T) 
cat(c('*White women*    | ', N_WF, '\n'), file = report, append = T) 
cat(c('*Minority men*   | ', N_MM, '\n'), file = report, append = T) 
cat(c('*Minority women* | ', N_MF, '\n'), file = report, append = T) 
cat('\n', file = report, append = T)
cat('##### Mean\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('Subsample        |', paste(X, collapse = ' | '), '\n', file = report, append = T)
cat('-----------------|------|------|------|------|------|------|------|------|------', '\n', file = report, append = T)
cat(c('*Total*          | ', paste(format(mean_full, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White men*      | ', paste(format(mean_WM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White women*    | ', paste(format(mean_WF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority men*   | ', paste(format(mean_MM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority women* | ', paste(format(mean_MF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat('\n', file = report, append = T)
cat('##### Standard Deviations\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('Subsample        |', paste(X, collapse = ' | '), '\n', file = report, append = T)
cat('-----------------|------|------|------|------|------|------|------|------|------', '\n', file = report, append = T)
cat(c('*Total*          | ', paste(format(sd_full, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White men*      | ', paste(format(sd_WM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White women*    | ', paste(format(sd_WF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority men*   | ', paste(format(sd_MM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority women* | ', paste(format(sd_MF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat('\n\n', file = report, append = T)

### Table 2
cat('#### Table 2. Standardized regression coefficients and p-values for health care use among White and minority men and women with diabetes.\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('##### Coefficients\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('Subsample        |', paste(X, collapse = ' | '), '\n', file = report, append = T)
cat('-----------------|------|------|------|------|------|------|------|------|------', '\n', file = report, append = T)
cat(c('*Total*          | ', paste(format(coef_full, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White men*      | ', paste(format(coef_WM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White women*    | ', paste(format(coef_WF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority men*   | ', paste(format(coef_MM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority women* | ', paste(format(coef_MF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat('\n', file = report, append = T)
cat('##### Standard Errors\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('Subsample        |', paste(X, collapse = ' | '), '\n', file = report, append = T)
cat('-----------------|------|------|------|------|------|------|------|------|------', '\n', file = report, append = T)
cat(c('*Total*          | ', paste(format(se_full, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White men*      | ', paste(format(se_WM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White women*    | ', paste(format(se_WF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority men*   | ', paste(format(se_MM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority women* | ', paste(format(se_MF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat('\n', file = report, append = T)
cat('##### *p-*values\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('Subsample        |', paste(X, collapse = ' | '), '\n', file = report, append = T)
cat('-----------------|------|------|------|------|------|------|------|------|------', '\n', file = report, append = T)
cat(c('*Total*          | ', paste(format(p_full, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White men*      | ', paste(format(p_WM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*White women*    | ', paste(format(p_WF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority men*   | ', paste(format(p_MM, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat(c('*Minority women* | ', paste(format(p_MF, nsmall = 4), collapse = ' | '), '\n'), file = report, append = T) 
cat('\n\n', file = report, append = T)

## Report Step 4: References

### Styled references
ref_1 = 'Wong JJ, Hood KK, Breland JY. Correlates of health care use among White and minority men and women with diabetes: An NHANES study. Diabetes Res Clin Pract. 2019;150:122-128. doi:10.1016/j.diabres.2019.03.001'

### Create Sections
cat('### References\n', file = report, append = T)
cat('\n', file = report, append = T)
cat('1. ', ref_1, '\n', file = report, append = T)
cat('\n', file = report, append = T)

## Report Step 5: Publish

### Tables
render(report, 'html_document')
render(report, 'word_document')



