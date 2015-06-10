is.exPlot <- function(x) {
  is(x, "exPlot")
}

#' @export
print.exPlot <- function (x, ...) {
  print(x$plot)
  print(x$tags$title)
}

#' @export
summary.exPlot <- function (x, ...) {
  print(x$tags$title)
  print(x$plot)
}

#Anonymous constructor
.exPlot <- function(ggplot2Obj, title, tags){
  
  newTags <- .metaTags(title = title)
  tags <- .updateTags(tags, newTags)
  
  plo <- list(
    "plot"     = ggplot2Obj,
    "tags"     = tags
  )
  
  class(plo) <- c("exPlot", "reportable")
  
  plo
}