#  ----------------------------------------------------------------------------------------------------------------
#	A Decision Support Tool to Assess Recreational Harvest Slots, Discard Mortality, and Bycatch Accountability	
#	Applied to Gulf of Mexico Red Snapper, SEDAR 52 see http://sedarweb.org/sedar-52
#
#	Erin C. Bohaboy
#	NOAA Fisheries
#	erin.bohaboy@noaa.gov
#	January 2021
#
# 	Code in R (https://www.r-project.org/) to take outputs from SS report and forecast-report files
#	
#  ----------------------------------------------------------------------------------------------------------------
#


# empty workspace if necessary
#	rm(list=ls())
# load R libraries
library(sqldf)
library(plyr)
library(dplyr)

#   ----------------------------------------------------------------------------------
# set working directories that contain input SS files and list of simulation models
setwd("C:/mydirectory")
inpath <- "C:/mydirectory"

# read in mods list
  mods <- read.table(paste(inpath,"/models.csv", sep=""),sep=",",head=TRUE)

#  ---------------- create empty matrices with columns for fleets and put them into a list object to hold results ----------------------------
apical_Fs <- matrix(nrow=nrow(mods),ncol=14)
dead_N <- matrix(nrow=nrow(mods),ncol=14)
dead_B <- matrix(nrow=nrow(mods),ncol=14)
catch_N <- matrix(nrow=nrow(mods),ncol=14)
catch_B <- matrix(nrow=nrow(mods),ncol=14)
ret_N <- matrix(nrow=nrow(mods),ncol=14)
ret_B <- matrix(nrow=nrow(mods),ncol=14)
SPR2032 <- matrix(nrow=nrow(mods),ncol=1)

#	dead at age
DAA_1 <- matrix(nrow=nrow(mods),ncol=21)
DAA_2 <- matrix(nrow=nrow(mods),ncol=21)
DAA_3 <- matrix(nrow=nrow(mods),ncol=21)
DAA_4 <- matrix(nrow=nrow(mods),ncol=21)
DAA_5 <- matrix(nrow=nrow(mods),ncol=21)
DAA_6 <- matrix(nrow=nrow(mods),ncol=21)
DAA_7 <- matrix(nrow=nrow(mods),ncol=21)
DAA_8 <- matrix(nrow=nrow(mods),ncol=21)
DAA_9 <- matrix(nrow=nrow(mods),ncol=21)
DAA_10 <- matrix(nrow=nrow(mods),ncol=21)
DAA_11 <- matrix(nrow=nrow(mods),ncol=21)
DAA_12 <- matrix(nrow=nrow(mods),ncol=21)
DAA_13 <- matrix(nrow=nrow(mods),ncol=21)
DAA_14 <- matrix(nrow=nrow(mods),ncol=21)

N_at_Age_Area1 <- matrix(nrow=nrow(mods),ncol=21)
N_at_Age_Area2 <- matrix(nrow=nrow(mods),ncol=21)

#  selectivity at age by fleet in 2032 will be the same for all simulations, read once.
    reptemp <- readLines(paste(inpath,"/report_", 48, ".sso", sep=""))
	Age_Sel_Fleet <- matrix(nrow=14,ncol=21)
	Age_Sel_Fleet[1,1:21] <- as.numeric(unlist(strsplit(reptemp[16042], split = " ")))[8:28]
	Age_Sel_Fleet[2,1:21] <- as.numeric(unlist(strsplit(reptemp[16049], split = " ")))[8:28]
	Age_Sel_Fleet[3,1:21] <- as.numeric(unlist(strsplit(reptemp[16056], split = " ")))[8:28]
	Age_Sel_Fleet[4,1:21] <- as.numeric(unlist(strsplit(reptemp[16063], split = " ")))[8:28]
	Age_Sel_Fleet[5,1:21] <- as.numeric(unlist(strsplit(reptemp[16072], split = " ")))[8:28]
	Age_Sel_Fleet[6,1:21] <- as.numeric(unlist(strsplit(reptemp[16081], split = " ")))[8:28]
	Age_Sel_Fleet[7,1:21] <- as.numeric(unlist(strsplit(reptemp[16090], split = " ")))[8:28]
	Age_Sel_Fleet[8,1:21] <- as.numeric(unlist(strsplit(reptemp[16099], split = " ")))[8:28]
	Age_Sel_Fleet[9,1:21] <- as.numeric(unlist(strsplit(reptemp[16104], split = " ")))[8:28]
	Age_Sel_Fleet[10,1:21] <- as.numeric(unlist(strsplit(reptemp[16109], split = " ")))[8:28]
	Age_Sel_Fleet[11,1:21] <- as.numeric(unlist(strsplit(reptemp[16118], split = " ")))[8:28]
	Age_Sel_Fleet[12,1:21] <- as.numeric(unlist(strsplit(reptemp[16127], split = " ")))[8:28]
	Age_Sel_Fleet[13,1:21] <- as.numeric(unlist(strsplit(reptemp[16132], split = " ")))[8:28]
	Age_Sel_Fleet[14,1:21] <- as.numeric(unlist(strsplit(reptemp[16137], split = " ")))[8:28]

results_list <- list(apical_Fs, dead_N, dead_B, catch_N, catch_B, ret_N, ret_B, SPR2032, DAA_1, DAA_2,
				DAA_3, DAA_4, DAA_5, DAA_6, DAA_7, DAA_8, DAA_9, DAA_10, DAA_11, DAA_12,
				DAA_13, DAA_14,
				N_at_Age_Area1, N_at_Age_Area2, Age_Sel_Fleet)
names(results_list) <- c('apical_Fs','dead_N','dead_B', 'catch_N', 'catch_B', 'ret_N', 'ret_B', 'SPR2032',
				'DAA_1', 'DAA_2',
				'DAA_3', 'DAA_4', 'DAA_5', 'DAA_6', 'DAA_7', 'DAA_8', 'DAA_9', 'DAA_10', 'DAA_11', 'DAA_12',
				'DAA_13', 'DAA_14',
				'N_at_Age_Area1', 'N_at_Age_Area2', 'Age_Sel_Fleet')

# str(results_list)
#  -------------------------------- read in results ------------------------------------------------------

for (imod in 1:nrow(mods)) {

  # extract from forecast-report
	forctemp <- readLines(paste(inpath,"/Forecast-report_", imod, ".sso", sep=""))

	results_list$apical_Fs[imod,1] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[18]
	results_list$apical_Fs[imod,2] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[28]
	results_list$apical_Fs[imod,3] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[38]
	results_list$apical_Fs[imod,4] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[48]
	results_list$apical_Fs[imod,5] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[58]
	results_list$apical_Fs[imod,6] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[68]
	results_list$apical_Fs[imod,7] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[78]
	results_list$apical_Fs[imod,8] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[88]
	results_list$apical_Fs[imod,9] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[98]
	results_list$apical_Fs[imod,10] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[108]
	results_list$apical_Fs[imod,11] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[118]
	results_list$apical_Fs[imod,12] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[128]
	results_list$apical_Fs[imod,13] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[138]
	results_list$apical_Fs[imod,14] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[148]
	
	results_list$dead_N[imod,1] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[16]
	results_list$dead_N[imod,2] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[26]
	results_list$dead_N[imod,3] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[36]
	results_list$dead_N[imod,4] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[46]
	results_list$dead_N[imod,5] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[56]
	results_list$dead_N[imod,6] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[66]
	results_list$dead_N[imod,7] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[76]
	results_list$dead_N[imod,8] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[86]
	results_list$dead_N[imod,9] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[96]
	results_list$dead_N[imod,10] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[106]
	results_list$dead_N[imod,11] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[116]
	results_list$dead_N[imod,12] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[126]
	results_list$dead_N[imod,13] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[136]
	results_list$dead_N[imod,14] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[146]

	results_list$dead_B[imod,1] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[13]
	results_list$dead_B[imod,2] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[23]
	results_list$dead_B[imod,3] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[33]
	results_list$dead_B[imod,4] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[43]
	results_list$dead_B[imod,5] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[53]
	results_list$dead_B[imod,6] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[63]
	results_list$dead_B[imod,7] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[73]
	results_list$dead_B[imod,8] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[83]
	results_list$dead_B[imod,9] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[93]
	results_list$dead_B[imod,10] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[103]
	results_list$dead_B[imod,11] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[113]
	results_list$dead_B[imod,12] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[123]
	results_list$dead_B[imod,13] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[133]
	results_list$dead_B[imod,14] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[143]

	results_list$catch_N[imod,1] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[15]
	results_list$catch_N[imod,2] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[25]
	results_list$catch_N[imod,3] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[35]
	results_list$catch_N[imod,4] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[45]
	results_list$catch_N[imod,5] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[55]
	results_list$catch_N[imod,6] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[65]
	results_list$catch_N[imod,7] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[75]
	results_list$catch_N[imod,8] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[85]
	results_list$catch_N[imod,9] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[95]
	results_list$catch_N[imod,10] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[105]
	results_list$catch_N[imod,11] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[115]
	results_list$catch_N[imod,12] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[125]
	results_list$catch_N[imod,13] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[135]
	results_list$catch_N[imod,14] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[145]

	results_list$catch_B[imod,1] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[12]
	results_list$catch_B[imod,2] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[22]
	results_list$catch_B[imod,3] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[32]
	results_list$catch_B[imod,4] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[42]
	results_list$catch_B[imod,5] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[52]
	results_list$catch_B[imod,6] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[62]
	results_list$catch_B[imod,7] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[72]
	results_list$catch_B[imod,8] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[82]
	results_list$catch_B[imod,9] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[92]
	results_list$catch_B[imod,10] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[102]
	results_list$catch_B[imod,11] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[112]
	results_list$catch_B[imod,12] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[122]
	results_list$catch_B[imod,13] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[132]
	results_list$catch_B[imod,14] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[142]

	results_list$ret_N[imod,1] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[17]
	results_list$ret_N[imod,2] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[27]
	results_list$ret_N[imod,3] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[37]
	results_list$ret_N[imod,4] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[47]
	results_list$ret_N[imod,5] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[57]
	results_list$ret_N[imod,6] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[67]
	results_list$ret_N[imod,7] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[77]
	results_list$ret_N[imod,8] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[87] 
	results_list$ret_N[imod,9] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[97]
	results_list$ret_N[imod,10] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[107]
	results_list$ret_N[imod,11] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[117]
	results_list$ret_N[imod,12] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[127]
	results_list$ret_N[imod,13] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[137]
	results_list$ret_N[imod,14] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[147]

	results_list$ret_B[imod,1] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[14]
	results_list$ret_B[imod,2] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[24]
	results_list$ret_B[imod,3] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[34]
	results_list$ret_B[imod,4] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[44]
	results_list$ret_B[imod,5] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[54]
	results_list$ret_B[imod,6] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[64]
	results_list$ret_B[imod,7] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[74]
	results_list$ret_B[imod,8] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[84]
	results_list$ret_B[imod,9] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[94]
	results_list$ret_B[imod,10] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[104]
	results_list$ret_B[imod,11] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[114]
	results_list$ret_B[imod,12] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[124]
	results_list$ret_B[imod,13] <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[134]
	results_list$ret_B[imod,14] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[144]

	results_list$SPR2032[imod,1] <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[9]

  # extract from report

	reptemp <- readLines(paste(inpath,"/report_", imod, ".sso", sep=""))

	results_list$N_at_Age_Area1[imod,] <- as.numeric(unlist(strsplit(reptemp[29005], split = " ")))[14:34]
	results_list$N_at_Age_Area2[imod,] <- as.numeric(unlist(strsplit(reptemp[29419], split = " ")))[14:34]
	
	results_list$DAA_1[imod,] <- as.numeric(unlist(strsplit(reptemp[32150], split = " ")))[13:33]
	results_list$DAA_2[imod,] <- as.numeric(unlist(strsplit(reptemp[32356], split = " ")))[13:33]
	results_list$DAA_3[imod,] <- as.numeric(unlist(strsplit(reptemp[32562], split = " ")))[13:33]
	results_list$DAA_4[imod,] <- as.numeric(unlist(strsplit(reptemp[32768], split = " ")))[13:33]
	results_list$DAA_5[imod,] <- as.numeric(unlist(strsplit(reptemp[32974], split = " ")))[13:33]
	results_list$DAA_6[imod,] <- as.numeric(unlist(strsplit(reptemp[33180], split = " ")))[13:33]
	results_list$DAA_7[imod,] <- as.numeric(unlist(strsplit(reptemp[33386], split = " ")))[13:33]
	results_list$DAA_8[imod,] <- as.numeric(unlist(strsplit(reptemp[33592], split = " ")))[13:33]
	results_list$DAA_9[imod,] <- as.numeric(unlist(strsplit(reptemp[33798], split = " ")))[13:33]
	results_list$DAA_10[imod,] <- as.numeric(unlist(strsplit(reptemp[34004], split = " ")))[13:33]
	results_list$DAA_11[imod,] <- as.numeric(unlist(strsplit(reptemp[34210], split = " ")))[13:33]
	results_list$DAA_12[imod,] <- as.numeric(unlist(strsplit(reptemp[34416], split = " ")))[13:33]
	results_list$DAA_13[imod,] <- as.numeric(unlist(strsplit(reptemp[34622], split = " ")))[13:33]
	results_list$DAA_14[imod,] <- as.numeric(unlist(strsplit(reptemp[34828], split = " ")))[13:33]

  }

#  -------------------------------- manipulate matrices to get derived quantities ----------------------------------

#	Vulnerable number at age

	VAA_1 <- sweep(results_list$N_at_Age_Area1, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[1,1:21]), '*')
	VAA_2 <- sweep(results_list$N_at_Age_Area2, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[2,1:21]), '*')
	VAA_3 <- sweep(results_list$N_at_Age_Area1, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[3,1:21]), '*')
	VAA_4 <- sweep(results_list$N_at_Age_Area2, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[4,1:21]), '*')
	VAA_5 <- sweep(results_list$N_at_Age_Area1, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[5,1:21]), '*')
	VAA_6 <- sweep(results_list$N_at_Age_Area2, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[6,1:21]), '*')
	VAA_7 <- sweep(results_list$N_at_Age_Area1, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[7,1:21]), '*')
	VAA_8 <- sweep(results_list$N_at_Age_Area2, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[8,1:21]), '*')
	VAA_9 <- sweep(results_list$N_at_Age_Area1, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[9,1:21]), '*')
	VAA_10 <- sweep(results_list$N_at_Age_Area2, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[10,1:21]), '*')
	VAA_11 <- sweep(results_list$N_at_Age_Area1, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[11,1:21]), '*')
	VAA_12 <- sweep(results_list$N_at_Age_Area2, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[12,1:21]), '*')
	VAA_13 <- sweep(results_list$N_at_Age_Area1, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[13,1:21]), '*')
	VAA_14 <- sweep(results_list$N_at_Age_Area2, MARGIN=2, as.vector(results_list$Age_Sel_Fleet[14,1:21]), '*')

	tot_vulnerable_flt <- matrix(nrow=nrow(mods),ncol=14)
	tot_vulnerable_flt[1:96,1] <- rowSums(VAA_1)
	tot_vulnerable_flt[1:96,2] <- rowSums(VAA_2)
	tot_vulnerable_flt[1:96,3] <- rowSums(VAA_3)
	tot_vulnerable_flt[1:96,4] <- rowSums(VAA_4)
	tot_vulnerable_flt[1:96,5] <- rowSums(VAA_5)
	tot_vulnerable_flt[1:96,6] <- rowSums(VAA_6)
	tot_vulnerable_flt[1:96,7] <- rowSums(VAA_7)
	tot_vulnerable_flt[1:96,8] <- rowSums(VAA_8)
	tot_vulnerable_flt[1:96,9] <- rowSums(VAA_9)
	tot_vulnerable_flt[1:96,10] <- rowSums(VAA_10)
	tot_vulnerable_flt[1:96,11] <- rowSums(VAA_11)
	tot_vulnerable_flt[1:96,12] <- rowSums(VAA_12)
	tot_vulnerable_flt[1:96,13] <- rowSums(VAA_13)
	tot_vulnerable_flt[1:96,14] <- rowSums(VAA_14)


	Com_tot_v <- tot_vulnerable_flt[,1] + tot_vulnerable_flt[,2] + tot_vulnerable_flt[,3] + tot_vulnerable_flt[,4] +
 				tot_vulnerable_flt[,9] + tot_vulnerable_flt[,10]
	Rec_tot_v <- tot_vulnerable_flt[,5] + tot_vulnerable_flt[,6] + tot_vulnerable_flt[,7] + tot_vulnerable_flt[,8] +
 				tot_vulnerable_flt[,11] + tot_vulnerable_flt[,12]

	Rec_deadN <- results_list$dead_N[,5] + results_list$dead_N[,6] + results_list$dead_N[,7] + results_list$dead_N[,8] +
		results_list$dead_N[,11] + results_list$dead_N[,12]
	Rec_deadB <- results_list$dead_B[,5] + results_list$dead_B[,6] + results_list$dead_B[,7] + results_list$dead_B[,8] +
		results_list$dead_B[,11] + results_list$dead_B[,12]
	RecOpen_deadN <- results_list$dead_N[,5] + results_list$dead_N[,6] + results_list$dead_N[,7] + results_list$dead_N[,8]
	Pop_N <- rowSums(results_list$N_at_Age_Area1) + rowSums(results_list$N_at_Age_Area2)
	Rec_H <- Rec_deadN / Pop_N
	RecOpen_H <- RecOpen_deadN / Pop_N
	Rec_CatchN <- results_list$catch_N[,5] + results_list$catch_N[,6] + results_list$catch_N[,7] + results_list$catch_N[,8] +
		results_list$catch_N[,11] + results_list$catch_N[,12]

	Com_deadN <- results_list$dead_N[,1] + results_list$dead_N[,2] + results_list$dead_N[,3] + results_list$dead_N[,4] +
		results_list$dead_N[,9] + results_list$dead_N[,10]
	Com_deadB <- results_list$dead_B[,1] + results_list$dead_B[,2] + results_list$dead_B[,3] + results_list$dead_B[,4] +
		results_list$dead_B[,9] + results_list$dead_B[,10]
	Com_H <- Com_deadN / Pop_N
	Com_retN <- results_list$ret_N[,1] + results_list$ret_N[,2] + results_list$ret_N[,3] + results_list$ret_N[,4]
	Com_retB <- results_list$ret_B[,1] + results_list$ret_B[,2] + results_list$ret_B[,3] + results_list$ret_B[,4]
	Rec_retN <- results_list$ret_N[,5] + results_list$ret_N[,6] + results_list$ret_N[,7] + results_list$ret_N[,8]
	Rec_retB <- results_list$ret_B[,5] + results_list$ret_B[,6] + results_list$ret_B[,7] + results_list$ret_B[,8]
	Rec_deaddisc_B <- Rec_deadB - Rec_retB
	Rec_DeadShare_B <- Rec_deadB / (Com_deadB + Rec_deadB)
	Rec_LandingsShare_B <- Rec_retB / (Com_retB + Rec_retB)

	DAA_Rec <- results_list$DAA_5 + results_list$DAA_6 + results_list$DAA_7 + 
			results_list$DAA_8 + results_list$DAA_11 + results_list$DAA_12
	DAA_Com <- results_list$DAA_1 + results_list$DAA_2 + results_list$DAA_3 + 
			results_list$DAA_4 + results_list$DAA_9 + results_list$DAA_10

	# compute average age of dead fish
	age_matrix <- matrix(data=seq(0,20,1),nrow=1,ncol=21)

		# ------------------
  		CrunchMe <- DAA_Rec

		  CrunchMe2 <- matrix(nrow=nrow(mods),ncol=2)
		  for (imod in 1:nrow(mods)) {
			CrunchMe2[imod,1] <- sum(CrunchMe[imod,]*age_matrix)
			CrunchMe2[imod,2] <- sum(CrunchMe[imod,])
			}

		  CrunchMe2 <- as.data.frame(CrunchMe2)
			colnames(CrunchMe2)[] <- c('CrossProdDAA_Age','Tot_Dead')
		  CrunchMe3 <- mutate(CrunchMe2, 'Avg_Age_Dead' = CrossProdDAA_Age / Tot_Dead)

	  AvgAge_Rec <- CrunchMe3

		# ------------------
  		CrunchMe <- DAA_Com

		  CrunchMe2 <- matrix(nrow=nrow(mods),ncol=2)
		  for (imod in 1:nrow(mods)) {
			CrunchMe2[imod,1] <- sum(CrunchMe[imod,]*age_matrix)
			CrunchMe2[imod,2] <- sum(CrunchMe[imod,])
			}

		  CrunchMe2 <- as.data.frame(CrunchMe2)
			colnames(CrunchMe2)[] <- c('CrossProdDAA_Age','Tot_Dead')
		  CrunchMe3 <- mutate(CrunchMe2, 'Avg_Age_Dead' = CrossProdDAA_Age / Tot_Dead)

	  AvgAge_Com <- CrunchMe3

	# pop greater than 20
	N_at_age <- results_list$N_at_Age_Area1 + results_list$N_at_Age_Area2
	prop20p <- N_at_age[,21]/rowSums(N_at_age)

	# results communicated relative to model 48 (bau or current management) 
	Rel_Rec_Seas <- ((RecOpen_H - RecOpen_H[48]) / RecOpen_H[48])*100
	Rel_Com_retB <- ((Com_retB - Com_retB[48]) / Com_retB[48])*100
	Rel_Rec_deaddisc_B <- ((Rec_deaddisc_B - Rec_deaddisc_B[48]) / Rec_deaddisc_B[48])*100
	Rel_prop20p <- ((prop20p - prop20p[48]) / prop20p[48])*100
	Rec_CPUE <- Rec_CatchN / Rec_H
	Rel_Rec_CPUE <- ((Rec_CPUE - Rec_CPUE[48]) / Rec_CPUE[48])*100
	Rel_Rec_CatchN <- ((Rec_CatchN - Rec_CatchN[48]) / Rec_CatchN[48])*100
	Rel_Rec_tot_v <- ((Rec_tot_v - Rec_tot_v[48]) / Rec_tot_v[48])*100
	Rel_Com_tot_v <- ((Com_tot_v - Com_tot_v[48]) / Com_tot_v[48])*100


#  -------------------------------- build results into a dataframe with model info ----------------------------------

	models_vals <- data.frame('min_in' = mods$min_in, 'max_cm' = mods$max_cm, 'discM' = mods$discM,
			 'AvgAge_Rec' = AvgAge_Rec[,3], 'AvgAge_Com' = AvgAge_Com[,3], 'Rel_Rec_Seas' = Rel_Rec_Seas,
			'Com_H' = Com_H, 'Rec_H' = Rec_H, 'Rel_Com_tot_v' = Rel_Com_tot_v, 'Rel_Rec_tot_v' = Rel_Rec_tot_v,
			'Rel_Com_retB' = Rel_Com_retB, 'Rel_Rec_deaddisc_B' = Rel_Rec_deaddisc_B, 'Rel_prop20p' = Rel_prop20p,
			'Rel_Rec_CPUE' = Rel_Rec_CPUE, 'Rec_DeadShare_B' = Rec_DeadShare_B, 'Rel_Rec_CatchN' = Rel_Rec_CatchN)


#  ----------------------------------------------------------------------------------------------------------------
#	create contour matrices for graphing
#  ----------------------------------------------------------------------------------------------------------------

# ----------------------------------------
#  Example Output: Relative recreational season length

dataset <- models_vals
string1 <-  "SELECT max_cm,discM,Rel_Rec_Seas
			FROM dataset
			WHERE min_in = 16"
mydata <- sqldf(string1, stringsAsFactors = FALSE)

# reshape
try1 <- reshape(mydata , idvar = "max_cm", timevar = "discM",direction = "wide")
try2 <- try1[nrow(try1):1,]
try3 <- as.matrix(try2[,-1])
rotate <- function(x) t(apply(x, 2, rev))
mydata_rotate_try3 <- rotate(try3)
Rel_Rec_Seas_z_matrix <- mydata_rotate_try3[-5,]
