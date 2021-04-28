pull_stack <- function(Files, Cycles, Descriptions)
    {
        library(RNHANES)
        library(tidyverse)
        library(skimr)
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
        cat('National Health and Nutrition Examination Survey\n')
        cat('Automated Data pull using `RNHANES` library in R\n')
        cat('https://cran.r-project.org/web/packages/RNHANES/vignettes/introduction.html\n')
        cat('Download:', date(), '\n')
        cat('Filename: _data/NHANES', format(Sys.time(), "%m-%d_%H%M"), '.csv\n')
        cat('Files: ', Files, '\n')
        cat('Cycles: ', Cycles, '\n\n')
        cat(print(skim(df_NH)))
        sink()
        options(width = 80)
        return(df_NH)
    }