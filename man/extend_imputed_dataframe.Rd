% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataset-load-and-processing.R
\name{extend_imputed_dataframe}
\alias{extend_imputed_dataframe}
\title{Extended dataframe from imputed dataframe}
\usage{
extend_imputed_dataframe(
  idf,
  wanted_days,
  back_years = 1,
  extend_after_end = TRUE
)
}
\arguments{
\item{idf}{Imputed dataframe.}

\item{wanted_days}{Number of complete days of the extended output.}

\item{back_years}{Number of previous years for which the time series is copied.}

\item{extend_after_end}{If \code{TRUE}, the expansion is appended after the end of the time series; if \code{FALSE}, the expansion is prepended before the beginning of the time series.}
}
\value{
Extended dataframe, i.e. an imputed dataframe with a 3rd column indicating if each sample has been extended or not and a 4th column indicating the original date of the replicated sample.
}
\description{
Create an extended dataframe from an imputed dataframe by replicating previous sequences of the time series, of at least one year, as many times as necessary, until completing a certain number of days. It is consistent with the day of the week.
}
