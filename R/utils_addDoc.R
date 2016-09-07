#' Problem: Comparison between several Machine Learning algorithms from the Weka library
#'
#' A problem containing experimental data obtaining by comparing several instances
#' of Machine Algorithms from the Weka library. The variables are as follows:
#'
#' \itemize{
#'   \item method. Classification algorithms used in the experimen (NaiveBayes, J48, IBk)
#'   \item problem. Problems used as benchmark in the comparison, up to 12.
#'   \item featureSelection. Boolean parameter indicating if the data was preprocessed
#'   \item fold. For each configuration a 10-fold cross validation was performed. This variable is a numeric value ranging from 1 to 10.
#'   \item accuracy. This is a measure of the performance of each algorithm. Representing the percentage of correctly classified instances.
#'   \item trainingTime. A second measure of performance. This one indicates the time in seconds that took the algorithm to build the model.
#' }
#' @docType data
#' @keywords problems
#' @name wekaExperiment
#' @usage data(wekaExperiment)
#' @format A data frame with the data detailed in the Description.
#'
"wekaExperiment"

#' Problem: Comparison between two Ionic Liquids packs to capture and reduce the
#' emission of CO2 in industrial fuel combustion processes.
#'
#' A problem containing the percentage of the CO2 reduction in the emission of 20 industrial
#' fuel combustion processes. It has been used two different Ionic Liquids (ILs) packs with
#' different properties. The packs has been reused up to three times, and each experiment
#' has been repeated three times under the same conditions. The variables of the problem are as follows:
#'
#' \itemize{
#'   \item IL The name of the IL packs (IL1 and IL2).
#'   \item Scenario The name of the industrial fuel combustion process (from Scenario 1 to Scenario20).
#'   \item Execution The number of the execution for each experiment under the same conditions.
#'   \item Reused The number of experiments which the IL pack has been used previously (from 0 to 2).
#'   \item CO2 The percentage of CO2 which has been reduced from the emission.
#'}
#' @docType data
#' @keywords problems
#' @name ILsExperiment
#' @usage data(ILsExperiment)
#' @format A data frame with the data detailed in the Description.
#'
"ILsExperiment"
