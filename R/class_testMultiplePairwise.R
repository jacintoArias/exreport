
is.testMultiplePairwise <- function(x) {
  is(x, "testMultiplePairwise")
}

#' @export
print.testMultiplePairwise <- function (x, ...) {
  print.testMultiple(x)  
}

#' @export
summary.testMultiplePairwise <- function (x, ...) {
  cat("---------------------------------------------------------------------\n")
  summary(x$friedman)
  cat("---------------------------------------------------------------------\n")
  cat(sprintf("Pairwise post hoc test for output %s\n", x$tags$target))
  cat(sprintf("Adjust method: %s\n", x$tags$method))
  cat(sprintf("alpha = %.4f\n", x$alpha))
  cat("\n")
  cat("p-values:\n")
  d <- cbind(x$names, p=x$pvalue)
  means <- rowMeans(x$friedman$ranks)
  means <- means[order(means)]
  t <- reshape2::dcast(d, method1~method2, value.var="p")
  me <- t[,1]
  t <- t[,-1]
  rownames(t) <- me
  print(t[names(means)[-length(means)],names(means)[-1]])  
  cat("---------------------------------------------------------------------\n")
}

#Anonymous constructor
.testMultiplePairwise <- function(names, pvalues, friedman, experiment, alpha, target, scope, method, tags) {

  newTags <- .metaTags(alpha   = alpha,
                       target  = target,
                       scope   = scope,
                       method  = method)
  tags <- .updateTags(tags, newTags)
  
  #Build the superclass object
  ph <- .testMultiple(names      = names, 
                      pvalues    = pvalues, 
                      friedman   = friedman,
                      experiment = experiment, 
                      tags       = tags
                      )
  
  #Specifical field for this class
  class(ph) <- append("testMultiplePairwise",class(ph))
  
  ph
}
