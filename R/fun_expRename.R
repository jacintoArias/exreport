#' Change the name of elements that an experiment contains
#'
#' This function change the name of problems, methods or parameter values that
#' an existing experiment object contains.
#'
#' @export
#' @param e Input experiment
#' @param elements A list of arrays of strings containing the new names. The old
#' name will be specified as the name of the element in such array, and the name
#' for the parameter, method or problem will be given by the name of the 
#' corresponding object in the list.
#' @return A modified exreport experiment object with some changes on the name of
#' the elements.
#'
#' @examples
#' # We load the wekaExperiment problem as an experiment and then change the name
#' of one value for the parameter discretization and for one method.
#' 
#' experiment <- expCreate(wekaExperiment, name="test", parameter="fold")
#' expRename(experiment, list(featureSelection = c("no"="false"),
#'                            method=c("RandomForest"="RndForest")))
#' 
expRename  <- function(e, elements){
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
  oldMethods    <- levels(e$data[[e$method]])
  oldProblems   <- levels(e$data[[e$problem]])
  oldParameters <- list()
  for(param in e$parameters){
    oldParameters[[param]] <- levels(e$data[[param]])
  }
  for(elemName in names(elements)){
    # Check that all new names have a proper name
    if(is.null(names(elements[[elemName]])))
      stop(.callErrorMessage("noValueNamesError"))
    # Check that all old names exist for the variable
    if(elemName==e$method){
      if(!all(names(elements[[elemName]]) %in% oldMethods))
        stop(.callErrorMessage("noValueNamesError"))
    }
    else if(elemName==e$problem){
      if(!all(names(elements[[elemName]]) %in% oldProblems))
        stop(.callErrorMessage("noValueNamesError"))
    }
    else{
      # Check that this paramName exists
      if(!(elemName %in% e$parameters))
        stop(.callErrorMessage("noNamesError"))
      # Also check if the valueNames exist for that parameter
      if(!all(names(elements[[elemName]]) %in% oldParameters[[elemName]]))
        stop(.callErrorMessage("noValueNamesError"))
    }
  }
  
  # Copy the experiment
  result <- e
  
  # Now we apply all the renames
  for(var in names(elements)){
    l <- levels(e$data[[var]])
    for(val in names(elements[[var]])){
      idx <- which(l==val)
      l[idx] <- elements[[var]][val]
    }
    levels(result$data[[var]]) <- l
  }
  
  # Append this operation in the historic
  varNames <- names(elements)
  oldElemNames <- lapply(elements, FUN=names)
  newElemNames <- lapply(elements, FUN=identity)
  renames <- c()
  for(i in varNames){
    renames <- c(renames,paste0(i,": [",paste(oldElemNames[[i]],newElemNames[[i]],sep="->",collapse=", "), "]"))
  }
  result$historic <- c(result$historic, 
                       list(paste0("Discrete values from method, problem or parameters columns have been renamed: ",
                            paste(renames,collapse = "; "))))
  result
}