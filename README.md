# Health Services Research
Notes, code, and references for common methods used in Health Services Research.

## About this Repository
This a private repository containing comprehensive resources for conducting health services research. This includes notes on econometric and biostatistical methods, corresponding code scripts for multiple applications, and references to previously published example studies. This repository was created as a study guide for the comprehsnive exams to qualify for PhD cantidacy in the Dept. of Health Servcies Research, Management, and Policy at the Unviersity of Florida.

## Repository Contents:
`_code` Code scripts used across projects including FractureProof v2.1<br>
`_data` Data files used across projects including the 2020 release from the Healthy Neighborhoods Repository<br>
`.vscode` Settings for VS Code IDE for use with allocativ products<br>
`LICENSE` Generic open source MIT license for use with allocativ products<br>
`.gitattributes` File extensions marked for GH large file storage for use with allocativ products<br>
`allocativ_v2-1.yml` Conda environment with dependencies for use with allocativ products

## Organization and Style
This repository uses the following description for file organization and coding style:

### File Organization:
This repository organizes file by project specfic topics and generic folders<br>
Project specfic topic descriptions are included in the README<br>
Generic folders may include the following based on the needs of the repository:<br>
`_archive` Old files from previous projects<br>
`_code` Code scripts used across projects<br>
`_data` Data files used across projects<br>
`_fig` Exported figures used across projects<br>
`_refs` References and documentation used across projects

### File Names:
File names use 2-6 letter label based on the file content followed by standard prefixes and suffixes<br>
Template: `topic_version_suffix.ext`<br>
Greek alphabet is used to represent file versions:<br>
`alpha_`, `beta_`, `gamma_`... `omega_`<br> 
Standard suffixes represent the following types of files:<br>
`_code` Development code script for working in an IDE<br>
`_book` Jupyter notebook <br>
`_stage` Data files that have been modified from raw source<br>
`_2020-01-01` Text scripts with results output with date it was run<br>
`_map` 2D geographic display<br>
`_graph` 2D chart or graph representing numeric data

### Variable Names:
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

### PEP-8 Standards:
Whenever possible code scripts follow PEP-8 standards<br>
Wihtin these standards, scripts use the following elective options:<br>
`=` for variable defintions (no `<-`)<br>
`''` for all character strings or arguments (no `""`) <br>
Arguments in a function are suuplied by name, rather than position (ex. `ggplot(data = df_XY, aes(x = ColX, y = ColY)`)<br>
A single space is provided between each element (ex. `columns = 'ColA'`)<br>

## Disclaimer
While the author (Andrew Cistola) is a Florida DOH employee and a University of Florida PhD student, these are NOT official publications by the Florida DOH, the University of Florida, or any other agency. All information in this repository is available for public review and dissemination but is not to be used for making medical decisions. All code and data inside this repository is available for open source use per the terms of the included license.

### allocativ
This repository is part of the larger allocativ project dedicated to prodiving analytical tools that are 'open source for public health.' Learn more at https://allocativ.com. 