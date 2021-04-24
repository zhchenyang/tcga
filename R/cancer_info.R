cancer2code <- function(cancer) {
  codes <- cancer_info[cancer_name == cancer]
  codes
  print(glue::glue("{cancer}:{codes}"))
}
