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
#'
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
  dt <- fread(file = data_path, select = index_type, col.names = col_names)
  if (bind) dt$id <- paste0(dt$gene, "-", dt$mutation)
  return(dt)

}

get_sample_info <- function(data_path, index, bind = FALSE) {
  dt <- get_mua(data_path, index)
  return(dt)
}


format_data <- function(mua, db_path, sample_info) {
  db <- fread(db_path)
  db$contain <- TRUE

}
