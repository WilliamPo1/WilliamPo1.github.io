# Replication data for "Why do Majoritarian Systems Benefit the Right? Income Groups and Vote Choice across different Electoral Systems"

This repository contains files that together constitute the replication data for:

> Robert Liñeira, Pedro Riera. 2024. "Why do Majoritarian Systems Benefit the Right? Income Groups and Vote Choice across different Electoral Systems." *Political Science Research and Methods*: In press.

The article's analyses are divided into a comparative section and a case study leveraging the 1996 electoral reform in New Zealand.


****************

COMPARATIVE ANALYSIS

Data: We use the CSES IMD dataset contained in the file "cses_imd.dta" (version "VER2020-DEC-08") and incorporate info from several aggregate-level datasets relevant to the analyses. The sequential addition of datasets is explained by the requests of the reviewers after the R&R invitation.

These datasets are:

1. The CSES IMD dataset is contained in the file "cses_imd.dta" (version "VER2020-DEC-08").
2. "macro_bis.dta": Gini and SD´s LR (MARPOR). The inequality variable(s) come(s) from the World Bank and the World Inequality Database
3. "lis_bis.dta¨: different measures from the LIS dataset are irrelevant at the end
4. "RILE Right ter.dta": Reduced version of the MARPOR dataset with the rile index for the mainstream right
5. "PS Frag PSRM.dta": several measures of PS fragmentation

Syntax: The file "Comparative PSRM Final REPLICATION.do" contains all the instructions to replicate the analyses of the comparative section in STATA.

****************


****************
NEW ZEALAND ANALYSIS

Data: We use the three-wave panel of the "New Zealand Electoral Study" conducted between 1993 and 1999 contained in the file "NZESPanel93_96_99".

Syntax: The file "New Zealand PSRM Final REPLICATION.do" contains all the instructions to replicate the analyses of the New Zealand section of the article in STATA.

****************

