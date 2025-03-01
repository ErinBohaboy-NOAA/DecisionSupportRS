#V3.30.12.00_2018_07_06;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.6
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#C forecast input file for A Decision Support Tool to Assess Recreational Harvest Slots, Discard Mortality, and Bycatch Accountability
#C Erin C. Bohaboy, erin.bohaboy@noaa.gov, Jan2021
#C comment
#C comment
###################################################
#	Erin Bohaboy GOM RS harvest slots November 2018
# Forecast using 2016 for selex, modify for simulations
###################################################
#
# for all year entries except rebuilder; enter either: actual year, -999 for styr, 0 for endyr, neg number for rel. endyr
1 		# Benchmarks: 0=skip; 1=calc F_spr,F_btgt,F_msy; 2=calc F_spr,F0.1,F_msy 
2 		# MSY: 1= set to F(SPR); 2=calc F(MSY); 3=set to F(Btgt) or F0.1; 4=set to F(endyr) 
0.25609
0.26 		# Biomass target (e.g. 0.40)
# Bmark_years
# selex (retention) starts 2016
#_Bmark_years: beg_bio, end_bio, beg_selex, end_selex, beg_relF, end_relF, beg_recr_dist, end_recr_dist, beg_SRparm, end_SRparm (enter actual year, or values of 0 or -integer to be rel. endyr)
 1984 2016 2016 2016 2011 2015 1984 2016 1984 2016
1 		#Bmark_relF_Basis: 1 = use year range; 2 = set relF same as forecast below
# 	SEDAR 52 forecast file uses F_spr
1 		# Forecast: 0=none; 1=F(SPR); 2=F(MSY) 3=F(Btgt) or F0.1; 4=Ave F (uses first-last relF yrs); 5=input annual F scalar
60 		# N forecast years 
0.2 		# F scalar (only used for Do_Forecast==5)
#_Fcast_years:  beg_selex, end_selex, beg_relF, end_relF, beg_mean recruits, end_recruits  (enter actual year, or values of 0 or -integer to be rel. endyr)
# 	again, I am using recent regime only for SR
 2016 2016 2011 2015 1984 2016
0 		# Forecast selectivity (0=fcast selex is mean from year range; 1=fcast selectivity from annual time-vary parms)
2 		# Control rule method (1: ramp does catch=f(SSB), buffer on F; 2: ramp does F=f(SSB), buffer on F; 3: ramp does catch=f(SSB), buffer on catch; 4: ramp does F=f(SSB), buffer on catch) 
0.01 		# Control rule Biomass level for constant F (as frac of Bzero, e.g. 0.40); (Must be > the no F level below) 
0.001 		# Control rule Biomass level for no F (as frac of Bzero, e.g. 0.10) 
1 		# Control rule target as fraction of Flimit (e.g. 0.75) 
3 		#_N forecast loops (1=OFL only; 2=ABC; 3=get F from forecast ABC catch with allocations applied)		NOTE SEDAR 52 REPORT USES 2 HERE
3 		#_First forecast loop with stochastic recruitment
0 		#_Forecast recruitment:  0= spawn_recr; 1=value*spawn_recr_fxn; 2=value*VirginRecr; 3=recent mean from yr range above 		TRY CHANGING LATER
1 		# value is ignored 
0 		#_Forecast loop control #5 (reserved for future bells&whistles) 
2017  		# FirstYear for caps and allocations (should be after years with fixed inputs) 
0 		# stddev of log(realized catch/target catch) in forecast (set value>0.0 to cause active impl_error)
0 		# Do West Coast gfish rebuilder output (0/1) 
2017 		# Rebuilder:  first year catch could have been set to zero (Ydecl)(-1 to set to 1999)
2017 		# Rebuilder:  year for current age structure (Yinit) (-1 to set to endyear+1)
1 		# fleet relative F:  1=use first-last alloc year; 2=read seas, fleet, alloc list below
# Note that fleet allocation is used directly as average F if Do_Forecast=4 
3 		# basis for fcast catch tuning and for fcast catch caps and allocation  (2=deadbio; 3=retainbio; 5=deadnum; 6=retainnum)
# Conditional input if relative F choice = 2
# enter list of:  season,  fleet, relF; if used, terminate with season=-9999
# 1 1 0.0714286
# 1 2 0.0714286
# 1 3 0.0714286
# 1 4 0.0714286
# 1 5 0.0714286
# 1 6 0.0714286
# 1 7 0.0714286
# 1 8 0.0714286
# 1 9 0.0714286
# 1 10 0.0714286
# 1 11 0.0714286
# 1 12 0.0714286
# 1 13 0.0714286
# 1 14 0.0714286
# -9999 0 0  # terminator for list of relF
# enter list of: fleet number, max annual catch for fleets with a max; terminate with fleet=-9999
-9999 -1
# enter list of area ID and max annual catch; terminate with area=-9999
-9999 -1
# enter list of fleet number and allocation group assignment, if any; terminate with fleet=-9999
1 1
2 1
3 1
4 1
5 2
6 2
7 2
8 2
-9999 -1
#_if N allocation groups >0, list year, allocation fraction for each group 
# list sequentially because read values fill to end of N forecast
# terminate with -9999 in year field 
2017  0.51 0.49
 -9999  1  1 
99 # basis for input Fcast catch: -1=read basis with each obs; 2=dead catch; 3=retained catch; 99=input Hrate(F)
#enter list of Fcast catches; terminate with line having year=-9999
#  ------------------------------------------------------------------------------------------------------
#	STOCK ASSESSMENT HAS FIXED F FOR BYCATCH FLEETS- I am going to make everyone own their bycatch
#		so shifts in rec disc mort apply to the closed season, too. this will also assign full F to each area
#		will show effects of slots / reduced discmort better?
-9999 1 1 0 
#
999 # verify end of input 
