% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cancer_info.R
\name{merge_data}
\alias{merge_data}
\title{Get info form maf and csv}
\usage{
merge_data(cancer, tcga_path, maf_index, csv_index, db_path, filter = FALSE)
}
\arguments{
\item{cancer}{The Chinese cancer name.}

\item{tcga_path}{TCGA data path contain maf and csv.}

\item{maf_index}{mutation info}

\item{csv_index}{sample info}

\item{db_path}{db path}

\item{filter}{filter mutation?}
}
\value{
data.table
}
\description{
Get info form maf and csv
}
\examples{
\dontrun{
merge_data("胃癌", "data/path")
}
}
