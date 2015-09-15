.loadHTMLTemplate <- function(name, params=list()) {
  sourceFile <- system.file("extdata",sprintf("htmlTemplates/%s.txt", name) , package="exreport")
  template <- readChar(sourceFile, file.info(sourceFile)$size)  
  template <- .replaceVarsForContent(template,params)
  #for ( var in names(params))
  #  template <- gsub( sprintf("$%s", var), params[[var]], template, fixed=TRUE)
  
  template
}

####################################
## print2Report implementation.
#
#

.print2exreport <- function(element, id, file, path, ...) UseMethod(".print2exreport")

.print2exreport.experiment <- function(element, id, file, path) {

  # Format experiment data:
  
  # First, methods and problems
  methods     <- paste(levels(element$data[[element$method]]), collapse = ', ')
  problems    <- paste(levels(element$data[[element$problem]]), collapse = ', ')
  
  parameters <- ""
  
  # Print the parameters list if any
  params <- c()
  if (length(element$parameters) != 0) 
    for (p in element$parameters)
      params <- c(params, paste0(p, ' [', paste0(levels(element$data[[p]]), collapse = ","), ']'))
  
  if (length(element$configuration) != 0) 
    params <- c(params, element$configuration)
  
  parameters <- .nestedList2HTML(params, numbered=F)
  
  # Print the outputs
  outputs     <- paste(element[["outputs"]], collapse = ', ')
  
  history <- .nestedList2HTML(element$h)
  
  
  templateParams <- c(id = id,
                      element$tags,
                      methods = methods, 
                      problems = problems, 
                      parameters = parameters, 
                      outputs = outputs, 
                      history = history)
  html <- .loadHTMLTemplate("experiment", templateParams)
  cat( html, file = file)
}

.print2exreport.testMultiple <- function(element, id, file, path) {
  
  # TODO: ¡Make proper function!
  
  .print2exreport(element$friedman, id, file, path)
}

.print2exreport.testFriedman <- function(element, id, file, path) {
  
  templateParams <- c(id = id,
                      element$tags)
  html <- .loadHTMLTemplate("friedman", templateParams)
  cat( html, file = file)
}

.print2exreport.testWilcoxon <- function(element, id, file, path) {
  
  templateParams <- c(id = id,
                      element$tags,
                      worstMethod = element$worstMethod,
                      bestMethod = element$bestMethod)
  html <- .loadHTMLTemplate("wilcoxon", templateParams)
  cat( html, file = file)
}

.print2exreport.exTabular <- function(element, id, file, path) {
  
  # Configure tabular structures:
  tables <- element$tables
  formats <- element$formats
  
  # Split tables by maximum number of columns
  colHeader <- tables[[1]][, 1, drop=FALSE]
  colFormatHeader <- formats[[1]][, 1, drop=FALSE]
  maxCol <- ncol(tables[[1]])
  colIndex <- 2
  
  if (element$tableSplit <= 1)
    numCols <- maxCol
  else
    numCols <- round( (maxCol - 1) / element$tableSplit)
  
  # The first iteration is out of the loop just for formating reasons
  # The first table has different number of columns (the rest will have the
  # same numbre, so this first one is filled with the rest)
  # floor((maxCol-1)/colIndex) is the number of tables minus the first one
  numColsFirstTable <- maxCol-1 - numCols*(element$tableSplit-1)
  endIndex <- colIndex+numColsFirstTable-1
  auxTables <- lapply(tables, FUN = function(tab){
    cbind(colHeader,tab[,colIndex:endIndex,drop=F])
  })
  auxFormats <- lapply(formats, FUN = function(tab){
    cbind(colFormatHeader,tab[,colIndex:endIndex,drop=F])
  })
  
  htmlTable  <- .formatDataFrame(tables = auxTables, formats = auxFormats, src = "html")
  latexTable <- .formatDataFrame(tables = auxTables, formats = auxFormats, src = "latex")
  colIndex <- colIndex + numColsFirstTable
  
  while (colIndex <= maxCol)
  {
    endIndex <- colIndex+numCols-1
    auxTables <- lapply(tables, FUN = function(tab){
      cbind(colHeader,tab[,colIndex:endIndex,drop=F])
    })
    auxFormats <- lapply(formats, FUN = function(tab){
      cbind(colFormatHeader,tab[,colIndex:endIndex,drop=F])
    })
    
    htmlTable  <- paste0(htmlTable, "\n<br/><br/>\n", .formatDataFrame(tables = auxTables, formats = auxFormats, src = "html"))
    latexTable <- paste0(latexTable, "\n\n", .formatDataFrame(tables = auxTables, formats = auxFormats, src = "latex"))
    
    colIndex <- colIndex + numCols
  }

  templateParams <- c(id = id,
                      element$tags,
                      htmlTable = htmlTable,
                      latexTable = latexTable
                      )
  # Generate final output, it is conditioned on tableType
  if (element$tableType=="plain")
    html <- .loadHTMLTemplate("exTabular_plain", templateParams)
  else if (element$tableType=="phtest")
    html <- .loadHTMLTemplate("exTabular_phtest", templateParams)
  
  cat( html, file = file )
}

.print2exreport.exPlot <- function(element, id, file, path) {
  
  figPath <- paste(path, "/img/", sep="")
  
  # Generate the pictures
  pdf(paste(figPath, id, ".pdf", sep=""), width=11.69, height=8.27)
  print(element$plot)
  a <- dev.off()
  
  png(paste(figPath, id, ".png", sep=""), width=11.69, height=8.27, units = "in", res=72)
  print(element$plot)
  a <- dev.off()
  
  svg(paste(figPath, id, ".svg", sep=""), width=11.69, height=8.27)
  print(element$plot)
  a <- dev.off()
  
  setEPS()
  postscript(paste(figPath, id, ".eps", sep=""), width=11.69, height=8.27)
  print(element$plot)
  a <- dev.off()
  
  templateParams <- c(id = id,
                      element$tags
                     )
  html <- .loadHTMLTemplate("exPlot", templateParams)
  
  cat( html, file = file)
  
}