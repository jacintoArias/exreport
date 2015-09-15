#' Change the order of elements that an experiment contains
#'
#' This function change the order of problems, methods or parameter values that
#' an existing experiment object contains. The order affects the look of the
#' data representation (as tables and plots).
#'
#' @export
#' @param e Input experiment
#' @param elements A list of arrays of strings containing the ordered names.
#' The name for the parameter, method or problem will be given by the name of the 
#' corresponding object in the list.
#' The names which have not been specified will be placed at the begining or at
#' the end (depending on the parameter placeRestAtEnd).
#' If a name is not present in the set of parameter values, it will be ignored.
#' @param placeRestAtEnd Logical value which indicates if the non specified
#' value names have to be placed after the specified ones (TRUE) or before (FALSE).
#' @return A modified exreport experiment object with some changes on the name of
#' the elements.
#'
#' @examples
#' # We load the wekaExperiment problem as an experiment and then change the order
#' of the values for the parameter featureSelection and for one valoue for the method.
#' 
#' experiment <- expCreate(wekaExperiment, name="test", parameter="fold")
#' expReorder(experiment, list(featureSelection = c("yes","no"),
#'                            method=c("OneR")))
#'                            

expReorder  <- function(e, elements, placeRestAtEnd = T){
  # PARAMETER VALIDATION:
  # Check if parameters are correct
  if (!is.experiment(e))
    stop(.callErrorMessage("wrongParameterError", "e", "experiment"))
  if (!is.list(elements))
    stop(.callErrorMessage("wrongParameterError", "elements", "non-empty list"))
  if (length(elements)==0)
    stop(.callErrorMessage("wrongParameterError", "elements", "non-empty list"))
  # Check that all elements have a proper name
  if (is.null(names(elements)))
    stop(.callErrorMessage("noNamesError"))
  
  # Copy the experiment
  result <- e
  
  # Now we apply all the reordering
  for (elem in names(elements)){
    levels = levels(e$data[[elem]])
    specifiedValues <- sapply(elements[[elem]],FUN=function(x){which(x==levels)})
    nonSpecifiedValues <- seq(1,length(levels))[-1*specifiedValues]
    if (placeRestAtEnd)
      newLevels <- levels[as.integer(c(specifiedValues,nonSpecifiedValues))]
    else
      newLevels <- levels[as.integer(c(nonSpecifiedValues,specifiedValues))]
    levels(result$data[[elem]]) <- newLevels
  }
  
  # Append this operation in the historic
  
  reorders <- c()
  for(i in names(elements)){
    reorders <- c(reorders,paste0(i,": [",toString(newLevels), "]"))
  }
  result$historic <- c(result$historic, 
                       list(paste0("Discrete values from method, problem or parameters columns have been reordered: ",
                                   paste(reorders,collapse = "; "))))
  result
  
}
