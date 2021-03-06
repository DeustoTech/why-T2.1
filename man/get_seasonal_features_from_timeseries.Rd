% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extra-features.R
\name{get_seasonal_features_from_timeseries}
\alias{get_seasonal_features_from_timeseries}
\title{Seasonal features from time series}
\usage{
get_seasonal_features_from_timeseries(tseries, maxmin = FALSE)
}
\arguments{
\item{tseries}{Time series of class \code{msts}.}

\item{maxmin}{Compute, in addition to mean and sd, max and min.}
}
\value{
List of lists with the mean values and standard deviations.
}
\description{
Get the mean values and standard deviations for all hours in a day, weekdays in a week and months in a year across a time series of class \code{msts}.
}
