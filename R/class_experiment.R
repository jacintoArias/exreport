
.experiment <- function(data, method, problem, params, outs, name, historic){
  
  tags <- .metaTags(title = name, context = name)
  
  result <- list( "data" = data,
                  "method" = method,
                  "problem" = problem,
                  "parameters" = params,
                  "outputs" = outs,
                  "configuration" = list(),
                  "tags" = tags,
                  "historic" = historic)
  
  class(result) <- c("experiment", "reportable")
  result
}


is.experiment <- function(x) {
  is(x, "experiment")
}

#' @export
toString.experiment <- function (x, ...) {
  d <- x[["data"]]
  
  result <- paste("experiment ", x$name,"\n\n",sep="")
  
  result <- paste(result,
                  sprintf("#%s: %s\n", 
                          x$method, paste(levels(experiment$data[[experiment$method]]),
                                          collapse = ', ') ) , 
                  sep="")
  result <- paste(result,
                  sprintf("#%s: %s\n",
                          x$problem, paste(levels(experiment$data[[experiment$problem]]),
                                           collapse = ', ') ), "
                  \n",
                  sep="")
  
  if (length(x["parameters"]) != 0)
    result <- paste(result, 
                    sprintf("#parameters: %s", 
                            paste(x[["parameters"]], collapse = ', ') ),
                    sep="")
  
  if (length(x["configuration"]) != 0)
    result <- paste(result, 
                    sprintf("%s", 
                            paste(x[["configuration"]], "(instantiated)", collapse = ', ') ),
                    sep="")
  result <- paste0(result,"\n")
  
  result <- paste(result, 
                  sprintf("#outputs: %s\n", 
                          paste(x[["outputs"]], collapse = ', ') ),
                  sep="")
}

#' @export
print.experiment <- function(x, ...){
  cat( toString(x) )
}

#' @export
summary.experiment <- function (object, ...) {
  h <- object$historic
  
  cat(.nestedList2String(h))
  
  cat("\n")
  print(object)
}

names.experiment <- function(e){
  e$name
}