% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/genbank2uid.R
\name{genbank2uid}
\alias{genbank2uid}
\title{Get NCBI taxonomy UID from GenBankID}
\usage{
genbank2uid(id, batch_size = 100, key = NULL, ...)
}
\arguments{
\item{id}{A GenBank accession alphanumeric string, or a gi numeric string.}

\item{batch_size}{The number of queries to submit at a time.}

\item{key}{(character) NCBI Entrez API key. optional. See Details.}

\item{...}{Curl args passed on to \link[crul:HttpClient]{crul::HttpClient}}
}
\value{
one or more NCBI taxonomic IDs
}
\description{
Get NCBI taxonomy UID from GenBankID
}
\details{
See \url{http://www.ncbi.nlm.nih.gov/Sitemap/sequenceIDs.html} for
help on why there are two identifiers, and the difference between them.
}
\section{Authentication}{

See \link{taxize-authentication} for help on authentication. We
recommend getting an API key.
}

\examples{
\dontrun{
# with accession numbers
genbank2uid(id = 'AJ748748')
genbank2uid(id = 'Y13155')
genbank2uid(id = 'X78312')
genbank2uid(id = 'KM495596')

# with gi numbers
genbank2uid(id = 62689767)
genbank2uid(id = 22775511)
genbank2uid(id = 156446673)

# pass in many accession or gi numbers
genbank2uid(c(62689767,156446673))
genbank2uid(c('X78312','KM495596'))
genbank2uid(list('X78312',156446673))

# curl options
res <- genbank2uid(id = 156446673, verbose = TRUE)
}
}
