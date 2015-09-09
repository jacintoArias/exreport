
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
  
  result <- paste0("experiment ", x$name,"\n\n")
  
  result <- paste0(result,
                  sprintf("#%s: %s\n", 
                          x$method, paste(levels(experiment$data[[experiment$method]]),
                                          collapse = ', ') ))
  result <- paste0(result,
                  sprintf("#%s: %s\n",
                          x$problem, paste(levels(experiment$data[[experiment$problem]]),
                                     collapse = ', ') ), 
                  "\n")
  
  result <- paste0(result,"#parameters: ")
  if (length(x$parameters) != 0) {
    result <- paste(result, paste0(x[["parameters"]], collapse = ', '))
    if (length(x$configuration) != 0) 
      result <- paste0(result, ", ")
  }
    
  if (length(x$configuration) != 0)
    result <- paste0(result, paste(x[["configuration"]], "(instantiated)", collapse = ', '))
  result <- paste0(result,"\n")
  
  result <- paste0(result, sprintf("#outputs: %s\n", paste(x[["outputs"]], collapse = ', ') ))
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