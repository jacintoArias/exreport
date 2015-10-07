is.exPlot <- function(x) {
  is(x, "exPlot")
}

#' @export
print.exPlot <- function (x, ...) {
  print(x$plot)
  print(x$tags$title)
}

#' @export
summary.exPlot <- function (object, ...) {
  print(object$tags$title)
  print(object$plot)
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