% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format.R
\name{format_df}
\alias{format_df}
\title{format file}
\usage{
format_df(maf_path, csv_path, maf_index, csv_index, dir_name, cancer_cn)
}
\arguments{
\item{maf_path}{maf files}

\item{csv_path}{csv files}

\item{maf_index}{columns need to read in maf}

\item{csv_index}{columns need to read in csv}

\item{dir_name}{where palace the file}

\item{cancer_cn}{the Chinese cancer name}
}
\description{
format file
}
\examples{
\dontrun{
csv <- c("data/41419_2020_2531_MOESM10_ESM.csv")
maf <- c("data/41419_2020_2531_MOESM11_ESM.csv")
maf_index <- c(10, 11, 13, 14, 4, 6, 1)
csv_index <- c(1, 4, 2, 3, 5)
format_df(maf, csv, maf_index, csv_index, "new", "胃癌")
}
}
