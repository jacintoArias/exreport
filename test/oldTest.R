library(ggplot2)
library(reshape2)

dat   <- read.table("./dat/fmc-cfs.txt", header=TRUE, comment.char = "#")
dat <- dat[,c("fold", "classifier", "hamming", "discretization", "fss", "exact", "data")]
e1 <- expCreate(dat, methods="classifier", problems="data", name="fmc-cfs", parameters=c("discretization", "fold", "fss"))
dat   <- read.table("./dat/fmc-no.txt", header=TRUE, comment.char = "#")
dat <- dat[,c("discretization", "method", "hamming", "fold", "fss", "exact", "problem")]
e2 <- expCreate(dat, name="fmc-no", parameters=c("fss", "fold", "discretization"))
exptest <- expConcat(e1,e2)

exptest <- expSubset(exptest, list("fss" = c("CFS")))
exptest <- expSubset(exptest, list("data" = c("CAL500")), invertSelection = T)
exptest <- expReduce(exptest, parameters = "fold", FUN = mean)
exptest <- expInstantiate(exptest, removeUnary=T)

plot1 <- plotExpSummary(exptest, "exact", columns=4, freeScale=F, grayscale=F)
sumTable <- tabularExpSummary(exptest, c("exact", "hamming"), digits=4, format="f", boldfaceColumns="max", tableSplit=1)

phcontrol <- testMultipleControl(exptest, output="exact", rankOrder = "max", alpha=0.05)
summary(phcontrol)
phpairwise <- testMultiplePairwise(exptest, output="exact", rankOrder = "max", alpha=0.05)
summary(phpairwise)

plotf    <- plotCumulativeRank(phpairwise, grayscale=F)
plot2    <- plotRankDistribution(phcontrol)
phtable  <- tabularTestSummary(phcontrol, columns=c("rank", "pvalue", "wtl"))
phtable2 <- tabularTestSummary(phpairwise, columns=c("pvalue", "wtl"))
phtable3 <- tabularTestPairwise(phpairwise)
phtable3 <- tabularTestPairwise(phpairwise, value="wtl")

exptestred <- expExtract(phcontrol)
phcontrol2  <- testMultipleControl(exptestred, output="hamming", rankOrder = "max", alpha=0.05)

exptest2 <- expSubset(exptest, list("classifier" = c("full-A1DE", "full-NB")))
wilcox <- testPaired(exptest2, output="exact", rankOrder = "max", alpha=0.05)
summary(wilcox)
report <- exreport("Testing the report class")
report <- exreportAdd(report, list(exptest, plot1, sumTable))
report <- exreportAdd(report, phcontrol)
report <- exreportAdd(report, plotf)
report <- exreportAdd(report, plot2)
report <- exreportAdd(report, phtable)
report <- exreportAdd(report, phpairwise)
report <- exreportAdd(report, phtable3)
report <- exreportAdd(report, phtable2)
report <- exreportAdd(report, list(exptestred, phcontrol2))
report <- exreportAdd(report, wilcox)

exreportRender(report, target="html")
