get_ids_dbs <- c(
  "itis", "ncbi", "eol", "col", "tropicos", "gbif", "nbn", "pow"
)

#' Retrieve taxonomic identifiers for a given taxon name.
#'
#' This is a convenience function to get identifiers across all data sources.
#' You can use other `get_*` functions to get identifiers from specific
#' sources if you like.
#'
#' @export
#' @param names character; Taxonomic name to query.
#' @param db character; database to query. One or more of `ncbi`, `itis`, `eol`,
#' `col`, `tropicos`, `gbif`, `nbn`, or `pow`. By default db is set to search
#' all data sources. Note that each taxonomic data source has their own
#' identifiers, so that if you give the wrong `db` value for the identifier you
#' could get a result, it will likely be wrong (not what you were expecting).
#' If using ncbi, eol, and/or tropicos we recommend getting API keys;
#' see [taxize-authentication]
#' @param rows numeric; Any number from 1 to infinity. If the default NA, all
#' rows are returned. When used in `get_ids` this function still only
#' gives back a ids class object with one to many identifiers. See
#' `get_ids_` to get back all, or a subset, of the raw data that you
#' are presented during the ask process.
#' @param ... Other arguments passed to [get_tsn()], [get_uid()],
#' [get_eolid()], [get_colid()], [get_tpsid()], [get_gbifid()],
#' [get_nbnid()].
#' @return A vector of taxonomic identifiers, each retaining their respective
#' S3 classes so that each element can be passed on to another function
#' (see e.g.'s).
#' @note There is a timeout of 1/3 seconds between queries to NCBI.
#'
#' @family taxonomic-ids
#' @seealso [classification()]
#'
#' @section Authentication:
#' See [taxize-authentication] for help on authentication
#'
#' @examples \dontrun{
#' # Plug in taxon names directly
#' ## By default you get ids for all data sources
#' get_ids(names="Chironomus riparius")
#'
#' # specify rows to limit choices available
#' get_ids(names="Poa annua", db=c("col", "eol"), rows=1)
#' get_ids(names="Poa annua", db=c("col", "eol"), rows=1:2)
#'
#' ## Or you can specify which source you want via the db parameter
#' get_ids(names="Chironomus riparius", db = 'ncbi')
#' get_ids(names="Salvelinus fontinalis", db = 'nbn')
#'
#' get_ids(names=c("Chironomus riparius", "Pinus contorta"), db = 'ncbi')
#' get_ids(names=c("Chironomus riparius", "Pinus contorta"),
#'   db = c('ncbi','itis'))
#' get_ids(names=c("Chironomus riparius", "Pinus contorta"),
#'   db = c('ncbi','itis','col'))
#' get_ids(names="Pinus contorta",
#'   db = c('ncbi','itis','col','eol','tropicos'))
#' get_ids(names="ava avvva", db = c('ncbi','itis','col','eol','tropicos'))
#'
#' # Pass on to other functions
#' out <- get_ids(names="Pinus contorta",
#'  db = c('ncbi','itis','col','eol','tropicos'))
#' classification(out$itis)
#' synonyms(out$tropicos)
#'
#' # Get all data back
#' get_ids_(c("Chironomus riparius", "Pinus contorta"), db = 'nbn',
#'   rows=1:10)
#' get_ids_(c("Chironomus riparius", "Pinus contorta"), db = c('nbn','gbif'),
#'   rows=1:10)
#'
#' # use curl options
#' get_ids("Agapostemon", db = "ncbi", messages = TRUE)
#' }

get_ids <- function(names,
  db = c("itis", "ncbi", "eol", "col", "tropicos", "gbif", "nbn",
    "pow"), ...) {
  if (is.null(db)) {
    stop("Must specify on or more values for db!")
  }
  db <- match.arg(db, choices = get_ids_dbs, several.ok = TRUE)
  foo <- function(x, names, ...){
    ids <- switch(x,
                  itis = get_tsn(names, ...),
                  ncbi = get_uid(names, ...),
                  eol = get_eolid(names, ...),
                  col = get_colid(names, ...),
                  tropicos = get_tpsid(names, ...),
                  gbif = get_gbifid(names, ...),
                  nbn = get_nbnid(names, ...),
                  pow = get_pow(names, ...))
    names(ids) <- names
    return( ids )
  }

  tmp <- lapply(db, function(x) foo(x, names = names, ...))
  names(tmp) <- db
  class(tmp) <- "ids"
  return( tmp )
}

#' @export
#' @rdname get_ids
get_ids_ <- function(names, db = get_ids_dbs, rows = NA, ...) {
  if (is.null(db)) stop("Must specify on or more values for db!")
  db <- match.arg(db, choices = get_ids_dbs, several.ok = TRUE)
  foo <- function(x, names, rows, ...){
    ids <- switch(x,
                  itis = get_tsn_(names, rows = rows, ...),
                  ncbi = get_uid_(names, rows = rows, ...),
                  eol = get_eolid_(names, rows = rows, ...),
                  col = get_colid_(names, rows = rows, ...),
                  tropicos = get_tpsid_(names, rows = rows, ...),
                  gbif = get_gbifid_(names, rows = rows, ...),
                  nbn = get_nbnid_(names, rows = rows, ...))
    stats::setNames(ids, names)
  }
  structure(stats::setNames(
    lapply(db, function(x) foo(x, names = names, rows = rows, ...)), db),
  class = "ids")
}
