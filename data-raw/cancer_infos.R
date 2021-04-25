## code to prepare `cancer_info` dataset goes here
library(data.table)
cancer_info <- fread("data-raw/cancer22_info.csv")
# cancer_info <- cancer_info[,
#                            .(tissue,
#                              zh_name = stringi::stri_escape_unicode(zh_name),
#                              cancer_name = stringi::stri_escape_unicode(cancer_name))] # TODO

usethis::use_data(cancer_info, overwrite = TRUE)

maf_cols <- c(
  "Chromosome" = "character",
  "Start_Position" = "integer",
  "Tumor_Seq_Allele1" = "character",
  "Tumor_Seq_Allele2" = "character",
  "Hugo_Symbol" = "character",
  "HGVSp_Short" = "character",
  "Tumor_Sample_Barcode" = "character"
)
usethis::use_data(maf_cols, overwrite = TRUE)

csv_cols <- c(
  "submitter_id" = "character",
  "tumor_stage" = "character",
  "gender" = "character",
  "race" = "character",
  "year_of_birth" = "character"
)
usethis::use_data(csv_cols, overwrite = TRUE)
