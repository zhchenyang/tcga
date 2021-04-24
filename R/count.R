#' Count mutation
#'
#' @param df from get_result()
#' @param stage filter NA
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' mutation(get_result(cancer, tcga_path, db_path))
#' }
mutation <- function(df, stage = FALSE) {
  contain <- stages <- mutations <- iscontain <- NULL
  if (stage) df <- df[!is.na(stages)]

  mutations <- df[contain == TRUE][
    , .(mutations = paste0(id, collapse = ",")), by = "submitter_id"]
  df <- merge(df, mutations, by = "submitter_id",  all = TRUE)
  ucols <- c("submitter_id", "Tumor_Sample_Barcode", "mutations", "race")
  udf <- unique.data.frame(df[, ..ucols])
  res <-
    df[any(contain == TRUE),
       .(iscontain = any(contain)),
       by = c("submitter_id", "stages")][udf, on = "submitter_id"]
  return(res)
}
