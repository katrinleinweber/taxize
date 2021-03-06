% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nbn_synonyms.R
\name{nbn_synonyms}
\alias{nbn_synonyms}
\title{Return all synonyms for a taxon name with a given id from NBN}
\usage{
nbn_synonyms(id, ...)
}
\arguments{
\item{id}{the taxon identifier code}

\item{...}{Further args passed on to \link[crul:verb-GET]{crul::verb-GET}}
}
\value{
A data.frame
}
\description{
Return all synonyms for a taxon name with a given id from NBN
}
\examples{
\dontrun{
nbn_synonyms(id = 'NHMSYS0001501147')
nbn_synonyms(id = 'NHMSYS0000456036')

# none
nbn_synonyms(id = 'NHMSYS0000502940')
}
}
\references{
\url{https://api.nbnatlas.org/}
}
\seealso{
Other nbn: \code{\link{get_nbnid}},
  \code{\link{nbn_classification}},
  \code{\link{nbn_search}}
}
\concept{nbn}
