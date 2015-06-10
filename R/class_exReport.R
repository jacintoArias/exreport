is.exReport <- function(x) {
  is(x, "exReport")
}

#' @export
print.exReport <- function (x, ...) {
  print(paste0("Report (",length(x$content),") elements. Title: ", x$title))
}

#' @export
summary.exReport <- function (x, ...) {
  print(paste0("Report (",length(x$content),") elements. Title: ", x$title))
  print("----------------------------------------")
  print(x$content)
}

#Constructor
.exReport <- function(title) {
  rep <- list(
    "title"   = title,
    "content" = list()
  )
  
  class(rep) <- c("exReport")
  rep
}

####################
# Interface: reportable
########
#
# Purpose: All classes that implements this interface must have the function.
# This functions (the generic definition and the specific class implementations)
# are in the file web_reports.R
#

is.reportable <- function(x) {
  is(x, "reportable")
}