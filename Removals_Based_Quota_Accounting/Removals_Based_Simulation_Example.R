#  ----------------------------------------------------------------------------------------------------------------
#	A Decision Support Tool to Assess Recreational Harvest Slots, Discard Mortality, and Bycatch Accountability	
#	Applied to Gulf of Mexico Red Snapper, SEDAR 52 see http://sedarweb.org/sedar-52
#
#	Erin C. Bohaboy
#	NOAA Fisheries
#	erin.bohaboy@noaa.gov
#	January 2021
#
# 	Simulation code in R (https://www.r-project.org/) 
#	Relies on Stock Synthesis V3.30.12.00-safe (https://vlab.ncep.noaa.gov/group/stock-synthesis)
#	
#  ----------------------------------------------------------------------------------------------------------------
#
#
#	TOTAL REMOVALS-based quota accounting example
#
#
#  ----------------------------------------------------------------------------------------------------------------


# empty workspace if necessary
#	rm(list=ls())

# load R libraries
library(sqldf)
library(plyr)
library(dplyr)

#   ----------------------------------------------------------------------------------
# set working directories that contain input files and will receive all output files
setwd("C:/mydirectory")
inpath <- "C:/mydirectory"


#   ---------------------------------------
# read in a table listing the management scenarios to investigate and parameters to modify
#	for Stage 2 (harvest slots x reductions in discard mortality rate)
#	WARNING- never re-sort the rows in this list since they are indexed in order

mods <- read.table("models.csv",sep=",",head=TRUE)

#   ---------------------------------------
#	Put SS and simulation input files in the working directory
#	starter.ss			----->	read from .par, max phase estimate = 0
#							NOTE- will run much faster if detailed output = 0
#								but if we want forecast age comps, we will need a report.sso
#								that can be made later
#	forecast_original.ss 	----->	SPR target set low (=0.1), will be adjusted in loop below
#							fleet allocation basis = 3 (retainbio)
#							set values for allocation groups 0.51 com to 0.49 rec
#							note number of forecast years = 60 to avoid boundary effects on 2032
#	ss_original.par		----->	base model output parameters (i.e., re-estimated parameter values if assessment DMrec assumptions have been modified)
#							including vectors for fcast_recruitments and Fcast_impl_error (all 0s) 
#	rsnapper.dat		----->	unchanged from SEDAR 52 v. 3.30 assessment file
#	rsnapper.ctl		----->	modified from SEDAR 52 v. 3.30 assessment file for 
#								double-logistic retention in the recreational fleets
#	ss.exe			----->	SS version 3.30.12 executable, https://vlab.ncep.noaa.gov/group/stock-synthesis

#   ---------------------------------------
#	set a variable for 2015 baseline discard mortality to match Stage 1
#	for SEDAR52 = 0.118 = "business as usual"

bau_discmort <- 0.118

#   ---------------------------------------
#   ---------------------------------------
#  loop through all management scenarios in Stage 2. 
#	

for (imod in 1:nrow(mods)) {

	# create .par for management scenario

	partemp <- readLines(paste(inpath,"/ss_original.par",sep=""))
	partemp[2565] <- mods[imod,8]
	partemp[2577] <- mods[imod,9]
	partemp[2589] <- mods[imod,10]
	partemp[2601] <- mods[imod,11]
	partemp[2605] <- mods[imod,12]*bau_discmort
	partemp[2617] <- mods[imod,13]
	partemp[2629] <- mods[imod,14]
	partemp[2641] <- mods[imod,15]
	partemp[2653] <- mods[imod,16]
	partemp[2657] <- mods[imod,17]*bau_discmort
	partemp[2669] <- mods[imod,18]
	partemp[2681] <- mods[imod,19]
	partemp[2693] <- mods[imod,20]
	partemp[2705] <- mods[imod,21]
	partemp[2709] <- mods[imod,22]*bau_discmort
	partemp[2721] <- mods[imod,23]
	partemp[2733] <- mods[imod,24]
	partemp[2745] <- mods[imod,25]
	partemp[2757] <- mods[imod,26]
	partemp[2761] <- mods[imod,27]*bau_discmort
	partemp[2769] <- mods[imod,28]*bau_discmort
	partemp[2773] <- mods[imod,29]*bau_discmort

	writeLines(partemp,paste(inpath,"/ss.par",sep=""))

	# copy over forecast
	  file.copy("forecast_original.ss", paste("forecast.ss", 
            sep = ""),overwrite = TRUE)

#   ---------------------------------------
#  		inner do while to loop to get correct SPR2026
# 	may have to modify condition in the while statement if the loop stops before SPR2032 ~ 0.26

#initialize SPR2032
SPR2032 <- .007

# make a counter
while_i <- 0


while ( abs(0.26-SPR2032)>0.001 )
{

# run SS with what we have- forecast_original starts with SPR target = 0.1

	  shell("ss.exe -nohess")

fortemp <- readLines(paste(inpath,"/forecast.ss",sep=""))

linemod <- as.numeric(unlist(strsplit(fortemp[16], split = "\t")))
old_spr_targ <- linemod[1]

# read in forecast results

	forcresults <- readLines(paste(inpath,"/Forecast-report.sso", sep=""))
	SPR2032 <- as.numeric(unlist(strsplit(forcresults[511], split = " ")))[9]

# update target try again

target_per_act <- old_spr_targ/SPR2032
new_spr_targ <- round((old_spr_targ + (target_per_act*(0.26-SPR2032))),5)

# modify forecast.ss

fortemp[16] <- new_spr_targ

writeLines(fortemp,paste(inpath,"/forecast.ss",sep=""))

while_i <- while_i + 1
print(paste("Input_SPR_Target_____________", old_spr_targ,sep=""))
print(paste("SPR2032_____________", SPR2032,sep=""))
print(paste("try_new_SPR_target_____________", new_spr_targ,sep=""))
print(paste("iteration_____________", while_i,sep=""))
print("__________end of do while loop_______________________________")

#  END INNER DO WHILE LOOP

}


# save copies of outputs once we have forecast run with correct spr2032

	  file.copy("Forecast-report.sso", paste("Forecast-report_", imod, ".sso", 
            sep = ""),overwrite = TRUE)
	  file.copy("ss.par", paste("par_", imod, ".par", 
            sep = ""),overwrite = TRUE)

#  end scenario loop

}


#   ---------------------------------------
#   ---------------------------------------
#  read in outputs from each management scenario, compile into R object

#  forecast with allocations is on lines 515 and 516

# initialize empty matrix to hold results
outputs2 <- matrix(nrow=nrow(mods),ncol=21)

for (imod in 1:nrow(mods)) {

	forctemp <- readLines(paste(inpath,"/Forecast-report_", imod, ".sso", sep=""))

	CatchN_5 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[55]
	RetN_5 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[57]
	CatchB_5 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[52]
	RetB_5 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[54]
	DeadN_5 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[56]
	DeadB_5 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[53]
	F_5 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[58]

	CatchN_6 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[65]
	RetN_6 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[67]
	CatchB_6 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[62]
	RetB_6 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[64]
	DeadN_6 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[66]
	DeadB_6 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[63]
	F_6 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[68]

	CatchN_7 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[75]
	RetN_7 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[77]
	CatchB_7 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[72]
	RetB_7 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[74]
	DeadN_7 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[76]
	DeadB_7 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[73]
	F_7 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[78]

	CatchN_8 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[85]
	RetN_8 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[87]
	CatchB_8 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[82]
	RetB_8 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[84]
	DeadN_8 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[86]
	DeadB_8 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[83]
	F_8 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[88]

	CatchN_11 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[115]
	RetN_11 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[117]
	CatchB_11 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[112]
	RetB_11 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[114]
	DeadN_11 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[116]
	DeadB_11 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[113]
	F_11 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[118]


	CatchN_12 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[125]
	RetN_12 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[127]
	CatchB_12 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[122]
	RetB_12 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[124]
	DeadN_12 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[126]
	DeadB_12 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[123]
	F_12 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[128]

	Pop_bio <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[6] +
			as.numeric(unlist(strsplit(forctemp[515], split = " ")))[6]

	SPR2032 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[9]

	Rec_CatchN <- sum(CatchN_5, CatchN_6, CatchN_7, CatchN_8, CatchN_11, CatchN_12)
	Rec_RetN <- sum(RetN_5, RetN_6, RetN_7, RetN_8, RetN_11, RetN_12)
	Rec_CatchB <- sum(CatchB_5, CatchB_6, CatchB_7, CatchB_8, CatchB_11, CatchB_12)
	Rec_RetB <- sum(RetB_5, RetB_6, RetB_7, RetB_8, RetB_11, RetB_12)
	Rec_DeadN <- sum(DeadN_5, DeadN_6, DeadN_7, DeadN_8, DeadN_11, DeadN_12)
	Rec_DeadB <- sum(DeadB_5, DeadB_6, DeadB_7, DeadB_8, DeadB_11, DeadB_12)
	Rec_F <- sum(F_5, F_6, F_7, F_8, F_11, F_12)
	Rec_Directed_F <- sum(F_5, F_6, F_7, F_8)
	Rec_Bycatch_F <- sum(F_11, F_12)

	RetB_1 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[14]
	RetB_2 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[24]
	RetB_3 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[34]
	RetB_4 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[44]

	Com_DeadB_1 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[13]
	Com_DeadB_2 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[23]
	Com_DeadB_3 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[33]
	Com_DeadB_4 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[43]
	Com_DeadB_9 <- as.numeric(unlist(strsplit(forctemp[515], split = " ")))[93]
	Com_DeadB_10 <- as.numeric(unlist(strsplit(forctemp[516], split = " ")))[103]

	Com_RetB <- sum(RetB_1,RetB_2,RetB_3,RetB_4)
	Com_DeadB <- sum(Com_DeadB_1,Com_DeadB_2,Com_DeadB_3,Com_DeadB_4,Com_DeadB_9,Com_DeadB_10)

	Rec_Directed_CatchN <- sum(CatchN_5,CatchN_6,CatchN_7,CatchN_8)
	Rec_Bycatch_CatchN <- sum(CatchN_11,CatchN_12)

	outputs2[imod,1] <- Rec_CatchN 
	outputs2[imod,2] <- Rec_RetN
	outputs2[imod,3] <- Rec_CatchB
	outputs2[imod,4] <- Rec_RetB
	outputs2[imod,5] <- Rec_DeadN
	outputs2[imod,6] <- Rec_DeadB
	outputs2[imod,7] <- Rec_F
	outputs2[imod,8] <- Pop_bio
	outputs2[imod,9] <- SPR2032
	outputs2[imod,10] <- Com_RetB
	outputs2[imod,11] <- Rec_Directed_F
	outputs2[imod,12] <- Rec_Bycatch_F
	outputs2[imod,13] <- Rec_Directed_CatchN
	outputs2[imod,14] <- Rec_Bycatch_CatchN
	outputs2[imod,15] <- Com_DeadB
	outputs2[imod,16] <- CatchN_5
	outputs2[imod,17] <- CatchN_6
	outputs2[imod,18] <- CatchN_7
	outputs2[imod,19] <- CatchN_8
	outputs2[imod,20] <- CatchN_11
	outputs2[imod,21] <- CatchN_12

	}

	models_vals <- cbind(mods,outputs2)

	colnames(models_vals)[30:50] <- c("Rec_CatchN",
		 "Rec_RetN", "Rec_CatchB", "Rec_RetB", "Rec_DeadN", "Rec_DeadB", "Rec_F", "Pop_bio", 
		"SPR2032", "Com_RetB", "Rec_Directed_F", "Rec_Bycatch_F", "Rec_Directed_CatchN", 
		"Rec_Bycatch_CatchN", "Com_DeadB", "CatchN_5","CatchN_6","CatchN_7","CatchN_8","CatchN_11","CatchN_12" )

	models_vals <- mutate(models_vals, Rec_kg_per_catch = Rec_CatchB/Rec_CatchN)
	models_vals <- mutate(models_vals, Rec_kg_per_harv = Rec_RetB/Rec_RetN)
	models_vals <- mutate(models_vals, Rec_harv_share = Rec_RetB/(Rec_RetB+Com_RetB))
	models_vals <- mutate(models_vals, Rec_dead_share = Rec_DeadB/(Rec_DeadB + Com_DeadB))
	models_vals <- mutate(models_vals, Rec_dead_discB = Rec_DeadB - Rec_RetB)
	models_vals <- mutate(models_vals, Rec_Open_CPUE = Rec_Directed_CatchN/Rec_Directed_F)
	models_vals <- mutate(models_vals, Rec_Overall_CPUE = Rec_CatchN/Rec_F)

# ----------------------------------------
# ----------------------------------------
#   !!!! make sure that the SPR2032 values for each scenario are = 0.26  +/- 0.001.

# min size = 16

string1 <-  "SELECT max_cm,discM,SPR2032
			FROM models_vals
			WHERE min_in = 16"

SPR2032_16 <- sqldf(string1, stringsAsFactors = FALSE)

try1 <- reshape(SPR2032_16, idvar = "max_cm", timevar = "discM",direction = "wide")
try2 <- try1[nrow(try1):1,]
try2


# min size = 18

string1 <-  "SELECT max_cm,discM,SPR2032
			FROM models_vals
			WHERE min_in = 18"

SPR2032_18 <- sqldf(string1, stringsAsFactors = FALSE)

try1 <- reshape(SPR2032_18, idvar = "max_cm", timevar = "discM",direction = "wide")
try2 <- try1[nrow(try1):1,]
try2

# ----------------------------------------
# ----------------------------------------
#  the 'models_vals' R object contains all primary simulation outputs and management objectives
#    however, additional information of interest, such as the length or age compositions of catch by fleet,
#    is only detailed in the report.sso, which we did not generate in the simulation in order to speed run time
#
#  Rerun ss.exe using parameter values from each forecast-report.sso from above


#  Modify starter.ss so that detailed output = 1


#  loop through all scenarios:
#		pull correct "spr target" out of the forecast-report.sso to make a new forecast.ss with the correct value
#		run -nohess to make the report, save

for (imod in 1:nrow(mods)) {

  	file.copy(paste("par_", imod, ".par", sep=""), "ss.par",overwrite = TRUE)

	forereptemp <- readLines(paste(inpath,"/Forecast-report_", imod, ".sso", sep=""))
	input_SPRtarg <- as.numeric(unlist(strsplit(forereptemp [171], split = " ")))[2] 

	forcasttemp <- readLines(paste(inpath,"/forecast_original.ss", sep=""))
	forcasttemp[16] <- input_SPRtarg
	writeLines(forcasttemp,paste(inpath,"/forecast.ss",sep=""))
	
 shell("ss.exe -nohess")

	file.copy("report.sso", paste("report_", imod, ".sso", sep=""),overwrite = TRUE)

	}


# ----------------------------------------
#  Example code to extract out population and catch length and age comps from report files
#

# make matrices to hold results
N_at_Length_Area1 <- matrix(nrow=nrow(mods),ncol=52)
N_at_Length_Area2 <- matrix(nrow=nrow(mods),ncol=52)
N_at_Age_Area1 <- matrix(nrow=nrow(mods),ncol=21)
N_at_Age_Area2 <- matrix(nrow=nrow(mods),ncol=21)

# extract from report.sso files
for (imod in 1:nrow(mods)) {

	reptemp <- readLines(paste(inpath,"/report_", imod, ".sso", sep=""))

	N_length1 <- as.numeric(unlist(strsplit(reptemp[30663], split = " ")))[15:66]
	N_at_Length_Area1[imod,] <- N_length1

	N_length2 <- as.numeric(unlist(strsplit(reptemp[31073], split = " ")))[15:66]
	N_at_Length_Area2[imod,] <- N_length2

	N_Age1 <- as.numeric(unlist(strsplit(reptemp[29005], split = " ")))[14:34]
	N_at_Age_Area1[imod,] <- N_Age1

	N_Age2 <- as.numeric(unlist(strsplit(reptemp[29419], split = " ")))[14:34]
	N_at_Age_Area2[imod,] <- N_Age2

	}

# pull a vector of relative selex for each fleet
#	note all runs were the same so it doesn't matter which simulation output is used for the selex parms
#	here I use simulation #19

  imod=19
  reptemp <- readLines(paste(inpath,"/report_", imod, ".sso", sep=""))
  mid_year_length_age <- matrix(nrow=1,ncol=21)
  Age_Sel_5_11 <- matrix(nrow=1,ncol=21)	# age selex for fleets 5 and 11
  Age_Sel_6_12 <- matrix(nrow=1,ncol=21)  # age selex for fleet 6 and 12
  Age_Sel_7 <- matrix(nrow=1,ncol=21)	# etc.
  Age_Sel_8 <- matrix(nrow=1,ncol=21)

	Len_age <- as.numeric(unlist(strsplit(reptemp[47048], split = " ")))[6:26]
	mid_year_length_age[1,] <- Len_age
	
	age_sel_5 <- as.numeric(unlist(strsplit(reptemp[16072], split = " ")))[8:28]
	Age_Sel_5_11[1,] <- age_sel_5

	age_sel_6 <- as.numeric(unlist(strsplit(reptemp[16081], split = " ")))[8:28]
	Age_Sel_6_12[1,] <- age_sel_6

	age_sel_7 <- as.numeric(unlist(strsplit(reptemp[16090], split = " ")))[8:28]
	Age_Sel_7[1,] <- age_sel_7

	age_sel_8 <- as.numeric(unlist(strsplit(reptemp[16099], split = " ")))[8:28]
	Age_Sel_8[1,] <- age_sel_8


# for each fleet (5,6,7,8), loop through all ages, pull out vulnerable N at age

  VC_5 <- matrix(nrow=nrow(mods),ncol=21)
  for (i in 1:nrow(N_at_Age_Area1)) {
	VC_5[i,1:21] <- N_at_Age_Area1[i,]*Age_Sel_5_11
	}

  VC_6 <- matrix(nrow=nrow(mods),ncol=21)
  for (i in 1:nrow(N_at_Age_Area2)) {
	VC_6[i,1:21] <- N_at_Age_Area2[i,]*Age_Sel_6_12
	}

  VC_7 <- matrix(nrow=nrow(mods),ncol=21)
  for (i in 1:nrow(N_at_Age_Area1)) {
	VC_7[i,1:21] <- N_at_Age_Area1[i,]*Age_Sel_7
	}

  VC_8 <- matrix(nrow=nrow(mods),ncol=21)
  for (i in 1:nrow(N_at_Age_Area2)) {
	VC_8[i,1:21] <- N_at_Age_Area2[i,]*Age_Sel_8
	}


#  convert to relative prop at age in the vulnerable to catch

  rel_VC_5 <- matrix(nrow=nrow(mods),ncol=21)
  for (i in 1:nrow(VC_5)) {
	sum_VC <- sum(VC_5[i,1:21])
	rel_VC_5[i,1:21] <- VC_5[i,1:21]/sum_VC
	}

  rel_VC_6 <- matrix(nrow=nrow(mods),ncol=21)
  for (i in 1:nrow(VC_6)) {
	sum_VC <- sum(VC_6[i,1:21])
	rel_VC_6[i,1:21] <- VC_6[i,1:21]/sum_VC
	}

  rel_VC_7 <- matrix(nrow=nrow(mods),ncol=21)
  for (i in 1:nrow(VC_7)) {
	sum_VC <- sum(VC_7[i,1:21])
	rel_VC_7[i,1:21] <- VC_7[i,1:21]/sum_VC
	}

  rel_VC_8 <- matrix(nrow=nrow(mods),ncol=21)
  for (i in 1:nrow(VC_8)) {
	sum_VC <- sum(VC_8[i,1:21])
	rel_VC_8[i,1:21] <- VC_8[i,1:21]/sum_VC
	}




















