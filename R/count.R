#' Count mutation
#'
#' @param df from get_result()
#' @param stage filter NA
#'
#' @return data.table
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

#' Count the ratio
#'
#' @param mutations form mutations
#' @param na filter na
#' @param asian filer asian
#'
#' @return data.table
#' @export
#'
#' @examples
#' \dontrun{
#' get_ratio(mutations)
#' }
get_ratio <- function(mutations, na = FALSE, stages = TRUE, asian = FALSE) {

  if (asian) mutations <- mutations[race == "asian"]
  index <- c("gene", "mutation", "id", "contain")
  mutations <- mutations[, .SD, .SDcols = -index]
  mutations <- unique.data.frame(mutations)
  if (stages) {

    mutations$stages <-  stringr::str_extract(mutations$stages, "[ivx]{1,}")
    mutations$stages <- forcats::fct_relevel(mutations$stages, "i", "ii", "iii", "iv", "v")
    if (na) mutations <- mutations[!is.na(stages)]
    out <- mutations[,
                     .(n = sum(iscontain), N = .N),
                     by = "stages"][order(stages)][     # TODO fixed order
                       , ratio := cumsum(n)/cumsum(N)
                     ]
  } else {
    out <- mutations[, .(n = sum(iscontain), N = .N)]
  }
  return(out)
}


