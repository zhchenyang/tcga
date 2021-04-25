#' Get TCGA code by cancer name
#'
#' @param cancer the Chinese cancer name
#'
#' @return TCGA codes
#' @export
#' @import data.table
#'
#' @examples
#' \dontrun{
#' cancer2code("胃癌")
#' }
cancer2code <- function(cancer) {
  cancer_name <- tissue <- NULL
  codes <- cancer_info[cancer_name == cancer, tissue]

  message(glue::glue("{cancer}->{paste(codes, collapse = ',')}"))
  return(codes)
}

#' Get info form maf and csv
#'
#' @param cancer The Chinese cancer name.
#' @param tcga_path TCGA data path contain maf and csv.
#' @param filter filter mutation?
#'
#' @return data.table
#' @export
#'
#' @examples
#' \dontrun{
#' merge_data("胃癌", "data/path")
#' }
merge_data <- function(cancer, tcga_path, filter = FALSE) {
  # NULL for check
  HGVSp_Short <- submitter_id <- stages <- Tumor_Sample_Barcode <- NULL
  tumor_stage <- id <- Hugo_Symbol <- NULL

  codes <- cancer2code(cancer)
  pattern <- paste0(codes, collapse = "|")
  files <- list.files(path = tcga_path, pattern = "maf|csv", full.names = TRUE)
  out <- list()
  for (i in seq_along(codes)) {

    code <- codes[i]

    maf <- grep(glue::glue("{code}.+maf"), files, value = TRUE)
    csv <- grep(glue::glue("{code}.+csv"), files, value = TRUE)
    if (length(maf) == 0) {
      next
    }
    maf <- fread(file = maf, select = maf_cols)
    if (filter) {
      maf <- maf[substr(HGVSp_Short, 3, 3) !=
                   substr(HGVSp_Short, nchar(HGVSp_Short), nchar(HGVSp_Short)),]
    }
    csv <- fread(file = csv, select = csv_cols)

    maf <- maf[, submitter_id := substr(Tumor_Sample_Barcode, 1, 12)][
        csv, on = "submitter_id"][
        , stages := stringr::str_extract(tumor_stage, "[ivx/0]{1,}")
      ]
    out[[i]] <- maf
  }
  res <- purrr::reduce(out, rbind)
  res <- res[, id := paste0(Hugo_Symbol, "-", HGVSp_Short)]
  setcolorder(res, "id")
  setcolorder(res, names(res)[2:5])  ## mark

  # setcolorder(res, c(names(res[1:4]), "id",))
  message(glue::glue("{dim(res)}"))

  return(res)
}

#' Mutation
#'
#' @param cancer The Chinese cancer name
#' @param tcga_path The path to TCGA DB
#' @param db_path THE path to DB
#'
#' @return data.table
#' @export
#'
#' @examples
#' \dontrun{
#' get_result(cancer, tcga_path,  db_path)
#' }
get_result <- function(cancer, tcga_path, db_path) {
  tcga <- merge_data(cancer, tcga_path)
  db <- fread(db_path)
  db <- db[, `id` := paste0(`Gene Name`, "-", `AA Mutation`)]
  index <- (tcga$id %chin% db$id)
  tcga$contain <- FALSE
  tcga$contain[index] <- TRUE
  message(glue::glue("contain:{sum(index)}"))
  return(tcga)
}
