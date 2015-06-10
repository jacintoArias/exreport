
.experiment <- function(data, method, problem, params, outs, name, historic){
  
  tags <- .metaTags(title = name, context = name)
  
  result <- list( "data" = data,
                  "method" = method,
                  "problem" = problem,
                  "parameters" = params,
                  "outputs" = outs,
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
                          x$method, paste(unique(x$data[[x$method]]),
                                          collapse = ', ') ) , 
                  sep="")
  result <- paste(result,
                  sprintf("#%s: %s\n",
                          x$problem, paste(unique(x$data[[x$problem]]),
                                           collapse = ', ') ), "
                  \n",
                  sep="")
  
  if (length(x["paramaters"]) != 0)
    result <- paste(result, 
                    sprintf("#parameters: %s\n", 
                            paste(x[["parameters"]], collapse = ', ') ),
                    sep="")
  
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