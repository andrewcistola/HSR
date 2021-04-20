![](labeled.jpg)

## About this Repository
This a private repository containing helpful resources for conducting health services research. This includes notes on econometric and biostatistical methods, corresponding code scripts for various statistical software packages, and references to previously published example studies. This repository was created as a study guide for the comprehsnive exams to qualify for PhD cantidacy in the Dept. of Health Servcies Research, Management, and Policy at the Unviersity of Florida.

## Repository Contents:
`CODE` Code scripts and decriptive notes for each regression model or statistical test fro use in multiple programs<br>
`NOTES` Descriptive notes on OLS assumptions and approaches to addressing violations<br>
`MEPS` AHRQ Medical Expenditure Panel Survey<br>
`NHANES` CDC's National Health and Nuitritioinal Examination Survey from 1999<br>
`.vscode` Settings for VS Code IDE for use with allocativ products<br>
`LICENSE` Generic open source MIT license for use with allocativ products<br>
`.gitattributes` File extensions marked for GH large file storage for use with allocativ products<br>
`allocativ_v2-1.yml` Conda environment with dependencies for use with allocativ products

### PEP-8:
Whenever possible code scripts follow PEP-8 standards<br>
Wihtin these standards, scripts use the following elective options:<br>
`=` for variable defintions (no `<-` unless required)<br>
`''` for all character strings or arguments (no `""`) <br>
Arguments in a function are suuplied by name, rather than position (ex. `ggplot(data = df_XY, aes(x = ColX, y = ColY)`)<br>
A single space is provided between each element (ex. `columns = 'ColA'`)<br>
Python and R code scripts use the following variable naming conventions:<br>
`xx` 2-6 letter abbrevation based on content within data object<br>
`df_xx` Pandas and R dataframes<br>
`l_xx` Pandas and R lists<br>
`v_xx` R vectors<br>
`a_xx` Numpy arrays<br>
`m_xx` Numpy or R matrices<br>
`p_xx` Matplotlib, ggplot, or R plots<br>
Modles created with various methods are assigned informaitve short names:<br>
`lin_xx`, `log_xx`, `forest_xx`, `rfe_xx`, `pca_xx`<br>
Tables with features and targets used for modeling utilize standard names:<br>
`df_X`, `df_Y`, `df_XY`<br>
When using numbers, two digits are used by default (ex. `df_01`)

## Disclaimer
While the author (Andrew Cistola) is a Florida DOH employee and a University of Florida PhD student, these are NOT official publications by the Florida DOH, the University of Florida, or any other agency. All information in this repository is available for public review and dissemination but is not to be used for making medical decisions. All code and data inside this repository is available for open source use per the terms of the included license.

### allocativ
This repository is part of the larger allocativ project dedicated to prodiving analytical tools that are 'open source for public health.' Learn more at https://allocativ.com. 

(C) Andrew S. Cistola, MPH