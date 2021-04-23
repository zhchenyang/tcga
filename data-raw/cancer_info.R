## code to prepare `cancer_info` dataset goes here
library(data.table)
cancer_info <- fread("data-raw/cancer22_info.txt")
usethis::use_data(cancer_info, overwrite = TRUE)
