#' Get Mutation info
#'
#' @param data_path File name in working directory, path to file that contain
#' Gene name, mutation and sample id.
#'
#' @param index A vector of column names to keep. Just look like c(gene =
#' col1_index, mutation = col2_index, sample_id = col3_index). Index can be
#' column name or the number index
#'
#' @param bind TRUE bind gene and mutation
#'
#' @return The dt with id(gene-mutation) and sample id info
#' @export
#' @import data.table
#' @examples
#' \dontrun{
#' index <- c(gene = "Hugo_Symbol", mutation = "HGVSp_Short", sample_id = "Tumor_Sample_Barcode")
#' dt <- get_mutation("data_path", index)
#' }
get_mua <- function(data_path, index, bind = TRUE) {

  stopifnot(length(index) > 1)

  col_names <- names(index)
  cols <- unname(index)
  index_type <- rep("character", length(cols))
  names(index_type) <- cols
  dt <- fread(cmd = glue::glue("grep -v '^#' {data_path}"), select = index_type, col.names = col_names)
  if (bind) dt$id <- paste0(dt$gene, "-", dt$mutation)
  return(dt)

}

#' Get the sample info
#'
#' @param data_path File name in working directory, path to file that contain
#' sample id, stage...
#' @param index A vector of column names to keep. Just look like
#' c(sample_id = col_index, race = col_index2, stages = col_index3). Index can be
#' column name or the number index
#' @param bind FALSE useless
#'
#' @return sample info
#' @export
#'
#' @examples
#' \dontrun{
#' index <- c(sample_id = "submitter_id", race = "race", stages = "tumor_stage")
#' sample_info <- get_sample_info("data_path", index)
#' }
get_sample_info <- function(data_path, index, bind = FALSE) {
  dt <- get_mua(data_path, index)
  dt$id <- NULL
  return(dt)
}


#' Format data for next step
#'
#' @param mua mutation data.frame
#' @param db_path db path
#' @param sample_info sample info data.frame
#'
#' @return data.table
#' @import data.table
#' @export
#'
#' @examples
#' \dontrun{
#' res <- format_data(mua, db_path, sample_info)
#' }
format_data <- function(mua, db_path, sample_info, match = FALSE) {
  if (is.data.frame(db_path)) {
    db <- db_path
    db <- db[, id := paste0(`Gene Name`, "-", `AA Mutation`)]
  } else {
    db <- fread(db_path)
    db <- db[, id := paste0(`Gene Name`, "-", `AA Mutation`)]
  }

  mua <- mua[id %chin% db$id, contain := TRUE]
  mua$contain[is.na(mua$contain)] <- FALSE

  contained_sample <- mua[contain == TRUE, sample_id]
  mua <- mua[sample_id %chin% unique(contained_sample), iscontain := TRUE]
  mua$iscontain[is.na(mua$iscontain)] <- FALSE
  if (match) {
    mua$sample_id_raw <- mua$sample_id
    mua$sample_id <- substr(mua$sample_id, 1, 12)
  }
  mua <- merge(mua, sample_info, by = "sample_id", all = TRUE)

  return(mua)
}
