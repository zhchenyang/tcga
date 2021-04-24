#' format file
#'
#' @param maf_path maf files
#' @param csv_path csv files
#' @param maf_index columns need to read in maf
#' @param csv_index columns need to read in csv
#' @param dir_name where palace the file
#' @param cancer_cn the Chinese cancer name
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' csv <- c("data/41419_2020_2531_MOESM10_ESM.csv")
#' maf <- c("data/41419_2020_2531_MOESM11_ESM.csv")
#' maf_index <- c(10, 11, 13, 14, 4, 6, 1)
#' csv_index <- c(1, 4, 2, 3, 5)
#' format_df(maf, csv, maf_index, csv_index, "new", "胃癌")
#' }
format_df <- function(maf_path,
                      csv_path,
                      maf_index,
                      csv_index,
                      dir_name,
                      cancer_cn) {
  if (!dir.exists("output"))
    dir.create("output")
  output_path <- glue::glue("output/{dir_name}")
  if (!dir.exists(output_path))
    dir.create(output_path)
  nas <- c("/", "-", "")
  code <- cancer2code(cancer_cn)[1]
  csv <- fread(csv_path, select = csv_index, na.strings = nas)
  maf <- fread(maf_path, select = maf_index, na.strings = nas)

  names(maf) <- names(maf_cols)
  names(csv) <- names(csv_cols)
  csv$tumor_stage <- tolower(csv$tumor_stage)

  bname <- strsplit(basename(maf_path), "\\.")[[1]][1]
  fwrite(maf, glue::glue("{output_path}/{bname}_{code}.maf"))
  bname <- strsplit(basename(csv_path), "\\.")[[1]][1]
  fwrite(csv, glue::glue("{output_path}/{bname}_{code}.csv"))
}

