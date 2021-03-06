% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_data.R
\name{get_mua}
\alias{get_mua}
\title{Get Mutation info}
\usage{
get_mua(data_path, index, bind = TRUE)
}
\arguments{
\item{data_path}{File name in working directory, path to file that contain
Gene name, mutation and sample id.}

\item{index}{A vector of column names to keep. Just look like c(gene =
col1_index, mutation = col2_index, sample_id = col3_index). Index can be
column name or the number index}

\item{bind}{TRUE bind gene and mutation}
}
\value{
The dt with id(gene-mutation) and sample id info
}
\description{
Get Mutation info
}
\examples{
\dontrun{
index <- c(gene = "Hugo_Symbol", mutation = "HGVSp_Short", sample_id = "Tumor_Sample_Barcode")
dt <- get_mutation("data_path", index)
}
}
