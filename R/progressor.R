taxize_env <- new.env()
taxize_env$options <- list()

#' taxon state options
#'
#' @export
#' @keywords internal
#' @param taxon_state_messages (logical) allow messages. default: `TRUE`
#' @param quiet (logical) quiet informational output from this function.
#' default: `TRUE`
#' @examples
#' taxize_options()
#' taxize_options(FALSE)
#' taxize_options(TRUE)
taxize_options <- function(taxon_state_messages = NULL, quiet = FALSE) {
  taxize_env$options$taxon_state_messages <- taxon_state_messages
  tseo <- taxize_env$options
  if (!quiet) cat("taxize options", sep = "\n")
  if (length(tseo) == 0) return(cat(""))
  for (i in seq_along(tseo)) {
    if (!quiet) cat(sprintf("  %s: %s", names(tseo)[i], tseo[[i]]),
      sep = "\n")
  }
}

#' methods for preparing/printing info for prompts for `get_*` functions
#'
#' @keywords internal
#' @examples \dontrun{
#' nms <- c("Quercus", "Sasdsfasdf")
#' x <- progressor$new(items = nms)
#' x
#' x$prog_start()
#'
#' x$completed(nms[1], "found")
#' x$prog_found()
#'
#' x$completed(nms[2], "not found")
#' x$prog_not_found()
#'
#' x$prog_summary()
#'
#' # suppress cli::cat_line
#' x <- progressor$new(items = nms, suppress = TRUE)
#' x$prog_summary()
#' }
progressor <- R6::R6Class(
  "progressor",
  public = list(
    total = 0,
    found = list(),
    not_found = list(),
    done = list(),
    suppress = FALSE,

    initialize = function(items, suppress = FALSE) {
      if (!missing(items)) self$total <- length(items)
      if (!is.null(taxize_env$options$taxon_state_messages)) {
        self$suppress <- taxize_env$options$taxon_state_messages
      } else {
        self$suppress <- suppress
      }
    },
    completed = function(name, att) {
      private$update_suppress()
      switch(att,
        "found" = self$completed_found(name),
        "not found" = self$completed_not_found(name))
    },
    completed_found = function(name)
      self$found <- c(self$found, name),
    completed_not_found = function(name)
      self$not_found <- c(self$not_found, name),
    prog_start = function() {
      private$update_suppress()
      private$sm(cli::cat_line(
        cli::rule(
          left = sprintf(" %s queries ", self$total),
          line = 2, line_col = "blue", width = 30)
      ))
      len <- length(self$found) + length(self$not_found)
      if (len > 0) {
        private$sm(cli::cat_line(cli::rule(
          left = sprintf(" %s completed ", len),
          line = 2, line_col = "lightblue", width = 25)
        ))
      }
    },
    prog = function(att) {
      private$update_suppress()
      switch(att,
        "found" = self$prog_found(),
        "not found" = self$prog_not_found())
    },
    prog_found = function() {
      name <- private$last(self$found)
      private$sm(cli::cat_line(
        paste(crayon::style(
          paste(private$sym$tick,  " Found: "), "green"), name)
      ))
    },
    prog_not_found = function() {
      name <- private$last(self$not_found)
      private$sm(cli::cat_line(
        paste(crayon::style(
          paste(private$sym$cross,  " Not Found: "), "red"), name)
      ))
    },
    prog_summary = function() {
      private$update_suppress()
      private$sm(cli::cat_line(
        cli::rule(left = " Results ", line = 2, line_col = "grey", width = 30),
        "\n"
      ))
      private$sm(cli::cat_line(
        paste(private$sym$bullet, "Total:",
          crayon::style(self$total, "green"), "\n"),
        paste(private$sym$bullet, "Found:",
          crayon::style(length(self$found), "green"), "\n"),
        paste(private$sym$bullet, "Not Found:",
          crayon::style(length(self$not_found), "green"))
      ))
    }
  ),

  active = list(
    p = function() (length(self$done) / self$total) * 100,
    d = function() length(c(self$found, self$not_found))
  ),

  private = list(
    sym = list(
      bullet = cli::symbol$bullet,
      tick = cli::symbol$tick,
      cross = cli::symbol$cross
    ),
    last = function(x) x[length(x)],
    sm = function(x) if (!self$suppress) x,
    update_suppress = function() {
      if (!is.null(taxize_env$options$taxon_state_messages)) {
        self$suppress <- taxize_env$options$taxon_state_messages
      }
    }
  )
)
