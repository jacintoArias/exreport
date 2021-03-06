% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fun_exreport.R
\name{exreportRender}
\alias{exreportRender}
\title{Render an exreport document}
\usage{
exreportRender(rep, destination = NULL, target = "html", safeMode = TRUE,
  visualize = TRUE)
}
\arguments{
\item{rep}{The exreport object to be rendered}

\item{destination}{Path to the rendered file. If NULL, it uses a temporary directory}

\item{target}{The format of the target rendering. HTML and PDF are allowed.}

\item{safeMode}{Denies or allows (TRUE or FALSE) output files overwriting}

\item{visualize}{Visualize the generated output or not}
}
\value{
an experiment object
}
\description{
This function renders an existing exreport object to a given file and format.
}

