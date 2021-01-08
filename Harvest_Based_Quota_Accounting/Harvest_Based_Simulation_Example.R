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
#	HARVEST-based quota accounting example
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


# ----------------------------------------
# ----------------------------------------
#	Make report.sso files
#  Rerun ss.exe -nohess using parameter values from each forecast-report.sso from above

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
