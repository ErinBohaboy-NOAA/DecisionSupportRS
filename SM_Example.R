
#  ----------------------------------------------------------------------------------------------------------------
#	A Decision Support Tool to Assess Recreational Harvest Slots, Discard Mortality, and Bycatch Accountability	
#	Applied to Gulf of Mexico Red Snapper, SEDAR 52 see http://sedarweb.org/sedar-52
#
#	Erin C. Bohaboy
#	NOAA Fisheries
#	erin.bohaboy@noaa.gov
#	January 2021
#
#	Example summary metrics (SM) calculation
# 	Code in R (https://www.r-project.org/)
#	
#  ----------------------------------------------------------------------------------------------------------------
#

# load R libraries
library(sqldf)
library(plyr)
library(dplyr)


# standardize each input PM to have variance = 1

use_data <- BaseDM_SEDAR52_Harv_Results
harv_alloc_SEDAR52_rel_PM  <- data.frame(Rel_Rec_seas = use_data$Rel_Rec_Seas,
			Rel_Overall_CPUE = use_data$Rel_Rec_CPUE,
			Rel_Com_RetB = use_data$Rel_Com_retB,
			Rel_dead_disc_red= -1*use_data$Rel_Rec_deaddisc_B,
			Rel_prop20p = use_data$Rel_prop20p,
			Rel_rec_dead_share = (-1*abs(use_data$Rel_rec_dead_share)))
rm(use_data)

use_data <- harv_alloc_SEDAR52_rel_PM
std_harv_alloc_SEDAR52_rel_PM <- mutate(use_data, std_rec_seas = Rel_Rec_seas/sd(use_data[,1]),
							std_overall_CPUE = Rel_Overall_CPUE/sd(use_data[,2]),
							std_com_retb = Rel_Com_RetB/sd(use_data[,3]),
							std_dead_disc_red = Rel_dead_disc_red/sd(use_data[,4]),
							std_prop20p = Rel_prop20p/sd(use_data[,5]),
							std_rec_dead_share = Rel_rec_dead_share/sd(use_data[,6]))
							


# read in coefficients (ws) for each summary metric
w_prod <- c(1,1,6,1,1,2)
w_cons <- c(1,1,2,3,3,2)
w_rec <- c(3,3,2,1,1,2)
w_recprod <- c(2,2,4,1,1,2)
w_bal <- c(1.5,1.5,3,1.5,1.5,3)


#  make each SM matrix to graph from
rm(mat_std)
mat_std <- as.matrix(std_harv_alloc_SEDAR52_rel_PM[,7:12])
# production SM
prod_harv_SEDAR52 <- apply(mat_std,1,function(x) crossprod(x,w_prod))
# conservation SM
cons_harv_SEDAR52 <- apply(mat_std,1,function(x) crossprod(x,w_cons))
# rec SM
rec_harv_SEDAR52 <- apply(mat_std,1,function(x) crossprod(x,w_rec))
# rec + prod SM
recprod_harv_SEDAR52 <- apply(mat_std,1,function(x) crossprod(x,w_recprod))
# balanced SM
bal_harv_SEDAR52 <- apply(mat_std,1,function(x) crossprod(x,w_bal))


