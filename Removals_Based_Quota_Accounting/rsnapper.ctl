#V3.30.12.00_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.6
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#_data_and_control_files: rsnapper.dat // rsnapper.ctl
# forecast input file for A Decision Support Tool to Assess Recreational Harvest Slots, Discard Mortality, and Bycatch Accountability
#  modified SEDAR 52 Gulf of Mexico Red Snapper v3.24 SS assessment control file - see http://sedarweb.org/sedar-52
#	converted to v3.30, modified for dome-shaped retention of rec fleets, time blocks added for forecast change in DMrec and landing length regs.
#	Erin C. Bohaboy, erin.bohaboy@noaa.gov, Jan2021
#  ----------------------------------------------------------------------------------------------------------------------------
#    INTRO TO PATTERNS AND BLOCKS / TIME-VARYING PARMS
 0  	# 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
 1 	#_N_Growth_Patterns
 1 	#_N_platoons_Within_GrowthPattern 
#	_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#	_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
 2 	# recr_dist_method for parameters:  2=main effects for GP, Area, Settle timing; 3=each Settle entity
 1 	# not yet implemented; Future usage: Spawner-Recruitment: 1=global; 2=by area
 2 	#  number of recruitment settlement assignments 
 0 	# unused option
# GPattern month  area  age (for each settlement assignment)
 1 1 1 0
 1 1 2 0
 0 	#_N_movement_definitions
#	_Cond 1.0 # first age that moves (real age at begin of season, not integer) if do_migration>0
#	_Cond 1 1 1 2 4 10 # example move definition for seas=1, GP=1, source=1 dest=2, age1=4, age2=10
#  OLD 7 BLOCKS # 7 	#_Nblock_Patterns
# 4 4 1 1 2 1 1 	#_blocks_per_pattern 
#  NEW 8 BLOCKS- 8=2 BUT 2000-2016 split at 2011
 9 	#_Nblock_Patterns
 4 4 1 2 2 1 1 6 1	#_blocks_per_pattern 
# begin and end years of blocks
 1985 1993 1994 1994 1995 2006 2007 2016			# Block 1 commercial size limit, <100% retention during IFQ
 1985 1993 1994 1994 1995 1999 2000 2016			# Block 2 rec size limit
 2007 2016							# Block 3 com selex IFQ
 2008 2015 2016 2016						# Block 4 rec disc mort - allow shift in 2016
 2008 2010 2011 2016						# Block 5 rec selex (circle hooks)
 1871 1871							# Block 6 initial conditions (start_year-1)- must have for R1 offset approach
 1871 1983							# Block 7 is for R0 shift in 1984 replaces the old env_cov band-aid
 1985 1993 1994 1994 1995 1999 2000 2010 2011 2015 2016 2016	# Block 8 MOdified block 2 to include 2011-2015 retention block to match selex for rec fleets (block 5) and a 2016-forecast block
 2008 2016							# block 9 is com disc mort
#
# controls for all timevary parameters 
 1 	#_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#  autogen
 1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
# 
#
#
#  ----------------------------------------------------------------------------------------------------------------------------
#    M, GROWTH, MATURITY, FECUNDITY, RECRUITMENT
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement 
#
 3 	#_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
#_Age_natmort_by sex x growthpattern
 1 1.6 0.695 0.17 0.14 0.122 0.11 0.103 0.097 0.093 0.09 0.087 0.085 0.084 0.083 0.082 0.081 0.08 0.08 0.079 0.079
 1 	# GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr; 5=age_specific_K_each; 6=not implemented
 0.75 	#_Age(post-settlement)_for_L1;linear growth below this
 999 	#_Growth_Age_for_L2 (999 to use as Linf)
 -999 	#_exponential decay for growth above maxage (fixed at 0.2 in 3.24; value should approx initial Z; -999 replicates 3.24)
 0  	#_placeholder for future growth feature
 0 	#_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
 1 	#_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
 4 	#_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
#_Age_Fecundity by growth pattern
 0 0 350000 2.62e+06 9.07e+06 2.03e+07 3.471e+07 4.995e+07 6.427e+07 7.676e+07 8.715e+07 9.553e+07 1.0215e+08 1.073e+08 1.1127e+08 1.143e+08 1.1661e+08 1.1836e+08 1.1968e+08 1.2067e+08 1.23235e+08
 2 	#_First_Mature_Age
 3 	#_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
 0 	#_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
 1 	#_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms- ALL FIXED
#_ LO HI 	INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
 7 21 		9.96 		9.96 1 0 -3 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 70 100 	85.64 		85.64 1 0 -3 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.05 0.8 	0.1919 		0.1919 1 0 -3 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.01 0.5 	0.1735 		0.1735 1 0 -5 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.5 	0.0715 		0.0715 1 0 -5 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
 0 1 		1.673e-05 	1.673e-05 1 0 -3 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
 0 4 		2.953 		2.953 1 0 -3 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
 50 1000 	999 		999 1 0 -3 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1
 -1 1000 	999 		999 1 0 -3 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
 0 1000 	999 		999 1 0 -3 0 0 0 0 0 0 0 # Eggs_scalar_Fem_GP_1
 0 1000 	999 		999 1 0 -3 0 0 0 0 0 0 0 # Eggs_exp_wt_Fem_GP_1
 0 0 		0 		0 0 0 -4 0 0 0 0 0 0 0 # RecrDist_GP_1
#
# Rec_dist- Area1 estimated relative to Area2
#_ 	LO 	HI 	INIT 		PRIOR 	PR_SD 	PR_type PHASE 	env_var&link 	dev_link 	dev_minyr 	dev_maxyr 	dev_PH 	Block 	Block_Fxn
 	-4 	4 	-0.648222 	-0.8 	1 	0 	4 	0 		2 		1972 		2016 		5 	0 	0 		# RecrDist_Area_1  FIXED (Rick estimated)
 	-4 	4 	0 		0 	1 	0 	-4 	0 		0 		0 		0 		0 	0 	0 		# RecrDist_Area_2
#
# remaining fixed growth parms
  0 0 		0 		0 0 0 -4 0 0 0 0 0 0 0 # RecrDist_month_1
  0.1 10 	1 		1 1 6 -1 0 0 0 0 0 0 0 # CohortGrowDev
  1e-06 0.999999 0.5 		0.5 0.5 0 -99 0 0 0 0 0 0 0 # FracFemale_GP_1
#
# timevarying growth / recruitment parms
#_ LO		HI	INIT		PRIOR 		PR_SD 	PR_type  	PHASE
  0.0001 	5       0.480876 	0.480876 	0.5 	6 		5 	# RecrDist_Area_1_dev_se fixed in SS3.24 but better fit if parameterized here
  -0.99 	0.99 	0 		0 		0.5 	6 		-6 	# RecrDist_Area_1_dev_autocorr
#	
# info on dev vectors created for MGparms are reported with other devs after tag parameter section 
#
#_seasonal_effects_on_biology_parms (placeholder)
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
#
#  ----------------------------------------------------------------------------------------------------------------------------
#    LEADING S-R
#
3 	#_Spawner-Recruitment; Options: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm
0  	# 0/1 to use steepness in initial equ recruitment calculation
0  	#  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR           PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn 	#  parm_name
             11            13       12.0019807145    11.8            1             0         1          0          0          0          0          0          7          1 	# SR_LN(R0)
           0.2             1          0.99          0.99             1             0         -4          0          0          0          0          0          0          0 	# SR_BH_steep
             0             2           0.3           0.3             1             0         -4          0          0          0          0          0          0          0 	# SR_sigmaR
            -5             5             0             0             1             0         -4          0          0          0          0          0          0          1 	# SR_regime
             0             0             0             0             0             0        -99          0          0          0          0          0          0          0 	# SR_autocorr
#  Time varying short parm lines
#_ 	LO 	HI 	INIT 		PRIOR 	PR_SD 	PR_type  	PHASE
 	-5 	5 	-0.390016366535	 0 	2.5 	6 		4 		# SR_regime_BLK7add_1871
#
#  ----------------------------------------------------------------------------------------------------------------------------
#    REC DEVS AND BIAS CORRECT
1 	#do_recdev:  0=none; 1=devvector; 2=simple deviations
1899 	# first year of main recr_devs; early devs can preceed this era
2016 	# last year of main recr_devs; forecast devs start in following year
4 	#_recdev phase 
1 	# (0/1) to read 13 advanced options
 0 	#_recdev_early_start (0=none; neg value makes relative to recdev_start)
 -5 	#_recdev_early_phase
 0 	#_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 	#_lambda for Fcast_recr_like occurring before endyr+1
 1971.4 #_last_yr_nobias_adj_in_MPD; begin of ramp
 1971.6 #_first_yr_fullbias_adj_in_MPD; begin of plateau
 2015.9 #_last_yr_fullbias_adj_in_MPD
 2017 	#_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
 0.9229 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
 0 	#_period of cycles in recruitment (N parms read below)
 -5 	#min rec_dev
 5 	#max rec_dev
#  try reading in 3.3 recdevs for each year
 0 	#_number_recdevs_to_read
# 118 	#_number_recdevs_to_read
# 1899	-0.00407074
# 1900	-0.0043158
# 1901	-0.00460267
# 1902	-0.00492636
# 1903	-0.00529119
# 1904	-0.00569625
# 1905	-0.00613915
# 1906	-0.00661942
# 1907	-0.00712755
# 1908	-0.00764665
# 1909	-0.00819171
# 1910	-0.0087823
# 1911	-0.00942135
# 1912	-0.010108
# 1913	-0.0108391
# 1914	-0.0116091
# 1915	-0.012405
# 1916	-0.0132167
# 1917	-0.0140565
# 1918	-0.0149399
# 1919	-0.0158767
# 1920	-0.0168837
# 1921	-0.017989
# 1922	-0.0191922
# 1923	-0.0205064
# 1924	-0.0219578
# 1925	-0.0236391
# 1926	-0.0255392
# 1927	-0.02769
# 1928	-0.0299147
# 1929	-0.0321085
# 1930	-0.0344068
# 1931	-0.0367497
# 1932	-0.0390471
# 1933	-0.0414616
# 1934	-0.0441908
# 1935	-0.0471769
# 1936	-0.0505963
# 1937	-0.0547401
# 1938	-0.059251
# 1939	-0.0639281
# 1940	-0.068743
# 1941	-0.0734195
# 1942	-0.0781067
# 1943	-0.0826759
# 1944	-0.087355
# 1945	-0.0922834
# 1946	-0.0973583
# 1947	-0.102943
# 1948	-0.109159
# 1949	-0.114161
# 1950	-0.119591
# 1951	-0.12515
# 1952	-0.129264
# 1953	-0.132981
# 1954	-0.13397
# 1955	-0.135767
# 1956	-0.134255
# 1957	-0.132856
# 1958	-0.128141
# 1959	-0.127047
# 1960	-0.126951
# 1961	-0.129261
# 1962	-0.127244
# 1963	-0.123145
# 1964	-0.120528
# 1965	-0.113764
# 1966	-0.110098
# 1967	-0.105369
# 1968	-0.104791
# 1969	-0.100332
# 1970	-0.102105
# 1971	-0.0752025
# 1972	1.34981
# 1973	0.509404
# 1974	-0.0377264
# 1975	0.12974
# 1976	0.18404
# 1977	0.251057
# 1978	-0.0501185
# 1979	0.171001
# 1980	0.831111
# 1981	1.03461
# 1982	0.459288
# 1983	-0.240334
# 1984	-0.986079
# 1985	-0.596859
# 1986	-0.462479
# 1987	-0.926862
# 1988	-0.484807
# 1989	0.356284
# 1990	0.0417256
# 1991	0.283122
# 1992	-0.105495
# 1993	0.0277454
# 1994	0.0327767
# 1995	0.348368
# 1996	-0.0175158
# 1997	0.0618318
# 1998	-0.362834
# 1999	0.174638
# 2000	0.16672
# 2001	-0.175282
# 2002	0.023871
# 2003	0.118203
# 2004	0.35521
# 2005	0.325604
# 2006	0.415256
# 2007	0.224683
# 2008	-0.187245
# 2009	0.251853
# 2010	0.0187122
# 2011	0.126953
# 2012	0.287279
# 2013	-0.070106
# 2014	0.212304
# 2015	0.458843
# 2016	-0.0914307
#
#  ----------------------------------------------------------------------------------------------------------------------------
#    FISHING MORTALITY SETUP
#
 0.3 	# F ballpark
 -2001 	# F ballpark year (neg value to disable)
 2 	# F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
 2.9 	# max F or harvest rate, depends on F_Method
# 	no additional F input needed for Fmethod 1
# 	if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# 	if Fmethod=3; read N iterations for tuning for Fmethod 3
 0.05 1 0 # overall start F value; overall phase; N detailed inputs to read
#
#
#  ----------------------------------------------------------------------------------------------------------------------------
#    CATCHABILITY FOR CPUE INDICES (FLEETS AND SURVEYS)
#
#_1:  fleet number
#_2:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
#
# -------------- ORIGINAL- Shr is estimated, all others use analytical
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
         1         1         0         0         0         1  #  HL_E
         2         1         0         0         0         1  #  HL_W
        13         1         0         0         0         0  #  Shr_E
        14         1         0         0         0         0  #  Shr_W
        15         1         0         0         0         1  #  Video_E
        16         1         0         0         0         1  #  Video_W
        17         1         0         0         0         1  #  Larv_E
        18         1         0         0         0         1  #  Larv_W
        19         1         0         0         0         1  #  Sum_E
        20         1         0         0         0         1  #  Sum_W
        21         1         0         0         0         1  #  Fall_E
        22         1         0         0         0         1  #  Fall_W
        23         1         0         0         0         1  #  BLL_W
        24         1         0         0         0         1  #  BLL_E
        26         1         0         0         0         1  #  MRIP_Index_E
        27         1         0         0         0         1  #  MRIP_Index_W
        28         1         0         0         0         1  #  HBT_Index_E
        29         1         0         0         0         1  #  HBT_Index_W
-9999 0 0 0 0 0
#
#-------------------MOD- tried to fix 
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
#         1         1         0         0         0         0  #  HL_E
#         2         1         0         0         0         0  #  HL_W
#        13         1         0         0         0         0  #  Shr_E
#        14         1         0         0         0         0  #  Shr_W
#        15         1         0         0         0         0  #  Video_E
#        16         1         0         0         0         0  #  Video_W
#        17         1         0         0         0         0  #  Larv_E
#        18         1         0         0         0         0  #  Larv_W
#        19         1         0         0         0         0  #  Sum_E
#        20         1         0         0         0         0  #  Sum_W
#        21         1         0         0         0         0  #  Fall_E
#        22         1         0         0         0         0  #  Fall_W
#        23         1         0         0         0         0  #  BLL_W
#        24         1         0         0         0         0  #  BLL_E
#        26         1         0         0         0         0  #  MRIP_Index_E
#        27         1         0         0         0         0  #  MRIP_Index_W
#        28         1         0         0         0         0  #  HBT_Index_E
#        29         1         0         0         0         0  #  HBT_Index_W
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -25            25     -7.88237             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_HL_E(1)
           -25            25     -8.58791             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_HL_W(2)
           -10            20      3.71935             1             1             0         1          0          0          0          0          0          0          0  #  LnQ_base_Shr_E(13)
           -10            20      1.49523             1             1             0         1          0          0          0          0          0          0          0  #  LnQ_base_Shr_W(14)
           -25            25      -8.3217             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Video_E(15)
           -25            25     -8.84629             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Video_W(16)
           -25            25     -25.2221             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Larv_E(17)
           -25            25     -25.9933             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Larv_W(18)
           -25            25     -9.62733             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Sum_E(19)
           -25            25     -10.0683             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Sum_W(20)
           -25            25     -10.4058             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Fall_E(21)
           -25            25     -10.9841             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Fall_W(22)
           -25            25     -7.81727             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_BLL_W(23)
           -25            25     -5.85978             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_BLL_E(24)
           -25            25     -8.43604             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_MRIP_Index_E(26)
           -25            25     -8.84731             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_MRIP_Index_W(27)
           -25            25     -8.07425             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_HBT_Index_E(28)
           -25            25      -8.3888             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_HBT_Index_W(29)
#  -----------------------------------------------MOD  -------------------------------
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
#           -25            25    -7.88237              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_HL_E(1)
#           -25            25    -8.58791              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_HL_W(2)
#           -10            20     3.71935              1             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Shr_E(13)
#           -10            20     1.49523              1             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Shr_W(14)
#           -25            25     -8.3217              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Video_E(15)
#           -25            25    -8.84629              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Video_W(16)
#           -25            25    -25.2221              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Larv_E(17)
#           -25            25    -25.9933              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Larv_W(18)
#           -25            25    -9.62733              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Sum_E(19)
#           -25            25    -10.0683              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Sum_W(20)
#           -25            25    -10.4058              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Fall_E(21)
#           -25            25    -10.9841              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Fall_W(22)
#           -25            25    -7.81727              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_BLL_W(23)
#           -25            25    -5.85978              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_BLL_E(24)
#           -25            25    -8.43604              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_MRIP_Index_E(26)
#           -25            25    -8.84731              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_MRIP_Index_W(27)
#           -25            25    -8.07425              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_HBT_Index_E(28)
#           -25            25     -8.3888              0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_HBT_Index_W(29)
#_no timevary Q parameters
#
#
#
#  ----------------------------------------------------------------------------------------------------------------------------
#    SELECTIVITY
#
#_size_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for all sizes
#Pattern:_1; parm=2; logistic; with 95% width specification
#Pattern:_5; parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6; parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8; parm=8; New doublelogistic with smooth transitions and constant above Linf option
#Pattern:_9; parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
#Pattern:_21; parm=2+special; non-parm len selex, read as pairs of size, then selex
#Pattern:_22; parm=4; double_normal as in CASAL
#Pattern:_23; parm=6; double_normal where final value is directly equal to sp(6) so can be >1.0
#Pattern:_24; parm=6; double_normal with sel(minL) and sel(maxL), using joiners
#Pattern:_25; parm=3; exponential-logistic in size
#Pattern:_27; parm=3+special; cubic spline 
#Pattern:_42; parm=2+special+3; // like 27, with 2 additional param for scaling (average over bin range)
#_discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead;_4=define_dome-shaped_retention
#
#  LENGTH-BASED RETENTION WITH DISC MORT 
#_Pattern    Discard   MaleSpec
 0		2 	0 0 	# 1 HL_E
 0 		2 	0 0 	# 2 HL_W
 0 		2 	0 0 	# 3 LL_E
 0 		2 	0 0 	# 4 LL_W
 0 		4 	0 0 	# 5 MRIP_E
 0 		4 	0 0 	# 6 MRIP_W
 0 		4 	0 0 	# 7 HBT_E
 0 		4 	0 0 	# 8 HBT_W
 0 		2 	0 0 	# 9 C_Clsd_E
 0 		2 	0 0 	# 10 C_Clsd_W
 0 		4 	0 0 	# 11 R_Clsd_E
 0 		4 	0 0 	# 12 R_Clsd_W
 0 		3 	0 0 	# 13 Shr_E
 0 		3 	0 0 	# 14 Shr_W
 0 		0 	0 0 	# 15 Video_E
 0 		0 	0 0 	# 16 Video_W
 0 		0 	0 0 	# 17 Larv_E
 0 		0 	0 0 	# 18 Larv_W
 0 		0 	0 0 	# 19 Sum_E
 0 		0 	0 0 	# 20 Sum_W
 0 		0 	0 0 	# 21 Fall_E
 0 		0 	0 0 	# 22 Fall_W
 0 		0 	0 0 	# 23 BLL_W
 0 		0 	0 0 	# 24 BLL_E
 0 		0 	0 0 	# 25 ROV_E
 0 		0 	0 0 	# 26 MRIP_Index_E
 0 		0 	0 0 	# 27 MRIP_Index_W
 0 		0 	0 0 	# 28 HBT_Index_E
 0 		0 	0 0 	# 29 HBT_Index_W
#
# ALL FLEETS SELECTIVITY IS AGE-BASED
#_Pattern Discard Male Special
 20 		0 	0 	0 	# 1 HL_E  	Double normal, p=6, using joiners
 20 		0 	0 	0 	# 2 HL_W
 20 		0 	0 	0 	# 3 LL_E
 20 		0 	0 	0 	# 4 LL_W
 20 		0 	0 	0 	# 5 MRIP_E
 20 		0 	0 	0 	# 6 MRIP_W
 20 		0 	0 	0 	# 7 HBT_E
 20 		0 	0 	0 	# 8 HBT_W
 20 		0 	0 	0 	# 9 C_Clsd_E
 20 		0 	0 	0 	# 10 C_Clsd_W
 15 		0 	0 	5 	# 11 R_Clsd_E	MIRROR open season MRIP
 15 		0 	0 	6 	# 12 R_Clsd_W
 17 		0 	0 	0 	# 13 Shr_E	Random walk, p=3 since only ages 0-2 are caught
 17 		0 	0 	0 	# 14 Shr_W
 20 		0 	0 	0 	# 15 Video_E
 20 		0 	0 	0 	# 16 Video_W
 10 		0 	0 	0 	# 17 Larv_E	selex=1 for 1+
 10 		0 	0 	0 	# 18 Larv_W
 17 		0 	0 	0 	# 19 Sum_E
 17 		0 	0 	0 	# 20 Sum_W
 17 		0 	0 	0 	# 21 Fall_E
 17 		0 	0 	0 	# 22 Fall_W
 12 		0 	0 	0 	# 23 BLL_W	Logistic, p=2, assume all older fish are fully selected by this fishery
 12 		0 	0 	0 	# 24 BLL_E
 20 		0 	0 	0 	# 25 ROV_E
 15 		0 	0 	5 	# 26 MRIP_Index_E	index mirror fishing fleet
 15 		0 	0 	6 	# 27 MRIP_Index_W
 15 		0 	0 	7 	# 28 HBT_Index_E
 15 		0 	0 	8 	# 29 HBT_Index_W
#
#
# LENGTH-RETENTION, DISCARD MORT, AND AGE-SELECTIVITY 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
            10           100         15.24         15.24             1             0         -3          0          0          0          0          0          1          2  #  Retain_L_infl_HL_E(1)
            -1            20             1             1             1             0         -3          0          0          0          0          0          1          2  #  Retain_L_width_HL_E(1)
           -10            1000         999            10             1             0         -2          0          0          0          0          0          1          2  #  Retain_L_asymptote_logit_HL_E(1)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_HL_E(1)
           -10            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_HL_E(1)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_HL_E(1)
            -1             2          0.75          0.75             1             0         -2          0          0          0          0          0          9          2  #  DiscMort_L_level_old_HL_E(1)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_HL_E(1)
            10           100         15.24         15.24             1             0         -3          0          0          0          0          0          1          2  #  Retain_L_infl_HL_W(2)
            -1            20             1             1             1             0         -3          0          0          0          0          0          1          2  #  Retain_L_width_HL_W(2)
           -10          1000           999            10             1             0         -2          0          0          0          0          0          1          2  #  Retain_L_asymptote_logit_HL_W(2)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_HL_W(2)
           -10            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_HL_W(2)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_HL_W(2)
            -1             2          0.78          0.78             1             0         -2          0          0          0          0          0          9          2  #  DiscMort_L_level_old_HL_W(2)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_HL_W(2)
            10           100         15.24         15.24             1             0         -3          0          0          0          0          0          1          2  #  Retain_L_infl_LL_E(3)
            -1            20             1             1             1             0         -3          0          0          0          0          0          1          2  #  Retain_L_width_LL_E(3)
           -10         1000            999            10             1             0         -2          0          0          0          0          0          1          2  #  Retain_L_asymptote_logit_LL_E(3)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_LL_E(3)
           -10            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_LL_E(3)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_LL_E(3)
            -1             2          0.81          0.81             1             0         -2          0          0          0          0          0          9          2  #  DiscMort_L_level_old_LL_E(3)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_LL_E(3)
            10           100         15.24         15.24             1             0         -3          0          0          0          0          0          1          2  #  Retain_L_infl_LL_W(4)
            -1            20             1             1             1             0         -3          0          0          0          0          0          1          2  #  Retain_L_width_LL_W(4)
           -10          1000           999            10             1             0         -2          0          0          0          0          0          1          2  #  Retain_L_asymptote_logit_LL_W(4)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_LL_W(4)
           -10            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_LL_W(4)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_LL_W(4)
            -1             2          0.91          0.91             1             0         -2          0          0          0          0          0          9          2  #  DiscMort_L_level_old_LL_W(4)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_LL_W(4)
#  BASE (1985-1993) PARMS FOR REC FLEETS RETENTION AND DISCARD MORT - MAKE RETENTION DBL_NORM BUT preserve logistic functionality
#   MRIP_E
#  Logistic Retention
#            10           100         15.24         15.24             1             0         -3          0          0          0          0          0          2          2  #  Retain_L_infl_MRIP_E(5)
#            -1            20             1             1             1             0         -3          0          0          0          0          0          2          2  #  Retain_L_width_MRIP_E(5)
#           -10            1000         999            10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_MRIP_E(5)
#            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_MRIP_E(5)
#  Double Norm Retention
             7           100         15.24         15.24             1             0         -3          0          0          0          0          0          8          2  #  Retain_L_asc_infl_MRIP_E(5)
            -1            20             1             1             1             0         -3          0          0          0          0          0          8          2  #  Retain_L_asc_slope_MRIP_E(5)
           -10            1000         999            10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_MRIP_E(5)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_asc_infl_maleoffset_MRIP_E(5)
            -1           500           150             0             1             0         -4          0          0          0          0          0          8          2  #  Retain_L_desc_infl_MRIP_E(5)
            -1             2             1             0             1             0         -4          0          0          0          0          0          8          2  #  Retain_L_desc_slope_MRIP_E(5)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_desc_infl_maleoffset_MRIP_E(5)
#   Discard mortality
            -7            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_MRIP_E(5)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_MRIP_E(5)
            -1             2          0.21          0.21             1             0         -2          0          0          0          0          0          4          2  #  DiscMort_L_level_old_MRIP_E(5)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_MRIP_E(5)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#   MRIP_W
#  Logistic Retention
#            10           100         15.24         15.24             1             0         -3          0          0          0          0          0          2          2  #  Retain_L_infl_MRIP_W(6)
#            -1            20             1             1             1             0         -3          0          0          0          0          0          2          2  #  Retain_L_width_MRIP_W(6)
#           -10            1000         999            10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_MRIP_W(6)
#            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_MRIP_W(6)
#  Double Norm Retention
             7           100         15.24         15.24             1             0         -3          0          0          0          0          0          8          2  #  Retain_L_asc_infl_MRIP_W(6)
            -1            20             1             1             1             0         -3          0          0          0          0          0          8          2  #  Retain_L_asc_slope_MRIP_W(6)
           -10            1000         999            10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_MRIP_W(6)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_asc_infl_maleoffset_MRIP_W(6)
            -1           500           150             0             1             0         -4          0          0          0          0          0          8          2  #  Retain_L_desc_infl_MRIP_W(6)
            -1             2             1             0             1             0         -4          0          0          0          0          0          8          2  #  Retain_L_desc_slope_MRIP_W(6)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_desc_infl_maleoffset_MRIP_W(6)
#   Discard mortality
            -7            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_MRIP_W(6)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_MRIP_W(6)
            -1             2          0.22          0.22             1             0         -2          0          0          0          0          0          4          2  #  DiscMort_L_level_old_MRIP_W(6)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_MRIP_W(6)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#    HBT_E
#  Logistic Retention
#            10           100         15.24         15.24             1             0         -3          0          0          0          0          0          2          2  #  Retain_L_infl_HBT_E(7)
#            -1            20             1             1             1             0         -3          0          0          0          0          0          2          2  #  Retain_L_width_HBT_E(7)
#           -10            1000         999            10             1             0         -2          0          0          0          0          0          2          2  #  Retain_L_asymptote_logit_HBT_E(7)
#            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_HBT_E(7)
#  Double Norm Retention
             7           100         15.24         15.24             1             0         -3          0          0          0          0          0          8          2  #  Retain_L_asc_infl_HBT_E(7)
            -1            20             1             1             1             0         -3          0          0          0          0          0          8          2  #  Retain_L_asc_slope_HBT_E(7)
           -10            1000         999            10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_HBT_E(7)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_asc_infl_maleoffset_HBT_E(7)
            -1           500           150             0             1             0         -4          0          0          0          0          0          8          2  #  Retain_L_desc_infl_HBT_E(7)
            -1             2             1             0             1             0         -4          0          0          0          0          0          8          2  #  Retain_L_desc_slope_HBT_E(7)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_desc_infl_maleoffset_HBT_E(7)
#  DISCARD
            -7            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_HBT_E(7)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_HBT_E(7)
            -1             2          0.21          0.21             1             0         -2          0          0          0          0          0          4          2  #  DiscMort_L_level_old_HBT_E(7)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_HBT_E(7)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#   HBT_W
#  Logistic Retention
#            10           100         15.24         15.24             1             0         -3          0          0          0          0          0          2          2  #  Retain_L_infl_HBT_W(8)
#            -1            20             1             1             1             0         -3          0          0          0          0          0          2          2  #  Retain_L_width_HBT_W(8)
#           -10            1000         999            10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_HBT_W(8)
#            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_HBT_W(8)
#  Double Norm Retention
             7           100         15.24         15.24             1             0         -3          0          0          0          0          0          8          2  #  Retain_L_asc_infl_HBT_W(8)
            -1            20             1             1             1             0         -3          0          0          0          0          0          8          2  #  Retain_L_asc_slope_HBT_W(8)
           -10            1000         999            10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_HBT_W(8)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_asc_infl_maleoffset_HBT_W(8)
            -1           500           150             0             1             0         -4          0          0          0          0          0          8          2  #  Retain_L_desc_infl_HBT_W(8)
            -1             2             1             0             1             0         -4          0          0          0          0          0          8          2  #  Retain_L_desc_slope_HBT_W(8)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_desc_infl_maleoffset_HBT_W(8)
# DISCARD
            -7            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_HBT_W(8)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_HBT_W(8)
            -1             2          0.22          0.22             1             0         -2          0          0          0          0          0          4          2  #  DiscMort_L_level_old_HBT_W(8)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_HBT_W(8)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  
            10           100            10            10             1             0         -3          0          0          0          0          0          0          0  #  Retain_L_infl_C_Clsd_E(9)
            -1            20             1             1             1             0         -3          0          0          0          0          0          0          0  #  Retain_L_width_C_Clsd_E(9)
           -1000            10        -999           -10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_C_Clsd_E(9)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_C_Clsd_E(9)
           -10            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_C_Clsd_E(9)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_C_Clsd_E(9)
            -1             2          0.74          0.74             1             0         -2          0          0          0          0          0          9          2  #  DiscMort_L_level_old_C_Clsd_E(9)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_C_Clsd_E(9)
            10           100            10            10             1             0         -3          0          0          0          0          0          0          0  #  Retain_L_infl_C_Clsd_W(10)
            -1            20             1             1             1             0         -3          0          0          0          0          0          0          0  #  Retain_L_width_C_Clsd_W(10)
        -1000            10           -999           -10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_C_Clsd_W(10)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_C_Clsd_W(10)
           -10            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_C_Clsd_W(10)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_C_Clsd_W(10)
            -1             2          0.87          0.87             1             0         -2          0          0          0          0          0          9          2  #  DiscMort_L_level_old_C_Clsd_W(10)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_C_Clsd_W(10)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#		MUST INCLUDE PLACEHOLDER PARMS FOR REC_CLSD TO MATCH MRIP AND HBT FLEETS SINCE DISC MORT IS MIRRORED
#  REC_CLSD_E
#  Logistic
#            10           100            10            10             1             0         -3          0          0          0          0          0          0          0  #  Retain_L_infl_R_Clsd_E(11)
#            -1            20             1             1             1             0         -3          0          0          0          0          0          0          0  #  Retain_L_width_R_Clsd_E(11)
#           -1000            10        -999           -10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_R_Clsd_E(11)
#            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_R_Clsd_E(11)
# Double Normal
          0.01           100             1             1             1             0         -3          0          0          0          0          0          0	   0  #  Retain_L_asc_infl_R_Clsd_E(11)
            -1            20             1             1             1             0         -3          0          0          0          0          0          0	   0  #  Retain_L_asc_slope_R_Clsd_E(11)
           -10      1000         0.000000000001     0.000000000001   1             0         -2          0          0          0          0          0          0	   0  #  Retain_L_asymptote_R_Clsd_E(11)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_asc_infl_maleoffset_R_Clsd_E(11)
            -1000         500          -999          -999             1             0         -4          0          0          0          0          0          0	   0  #  Retain_L_desc_infl_R_Clsd_E(11)
            -1             2             1             0             1             0         -4          0          0          0          0          0          0	   0  #  Retain_L_desc_slope_R_Clsd_E(11)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_desc_infl_maleoffset_R_Clsd_E(11)
#
           -10            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_R_Clsd_E(11)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_R_Clsd_E(11)
            -1             2          0.21          0.21             1             0         -2          0          0          0          0          0          4          2  #  DiscMort_L_level_old_R_Clsd_E(11)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_R_Clsd_E(11)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  REC_CLSD_W
#  Logistic
#            10           100            10            10             1             0         -3          0          0          0          0          0          0          0  #  Retain_L_infl_R_Clsd_W(12)
#            -1            20             1             1             1             0         -3          0          0          0          0          0          0          0  #  Retain_L_width_R_Clsd_W(12)
#           -1000          10          -999           -10             1             0         -2          0          0          0          0          0          0          0  #  Retain_L_asymptote_logit_R_Clsd_W(12)
#            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_maleoffset_R_Clsd_W(12)
# Double Normal
            0.01         100             1             1             1             0         -3          0          0          0          0          0          0	   0  #  Retain_L_asc_infl_R_Clsd_W(10)
            -1            20             1             1             1             0         -3          0          0          0          0          0          0	   0  #  Retain_L_asc_slope_R_Clsd_W(10)
           -10      1000         0.000000000001     0.000000000001          1             0         -2          0          0          0          0          0          0	   0  #  Retain_L_asymptote_R_Clsd_W(10)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_asc_infl_maleoffset_R_Clsd_W(10)
            -1000         500          -999          -999            1             0         -4          0          0          0          0          0          0	   0  #  Retain_L_desc_infl_R_Clsd_W(10)
            -1             2             1             0             1             0         -4          0          0          0          0          0          0	   0  #  Retain_L_desc_slope_R_Clsd_W(10)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  Retain_L_desc_infl_maleoffset_R_Clsd_W(10)
# disc mort
           -10            10            -5            -5             1             0         -2          0          0          0          0          0          0          0  #  DiscMort_L_infl_R_Clsd_W(12)
            -1             2             1             1             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_width_R_Clsd_W(12)
            -1             2          0.22          0.22             1             0         -2          0          0          0          0          0          4          2  #  DiscMort_L_level_old_R_Clsd_W(12)
            -1             2             0             0             1             0         -4          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_R_Clsd_W(12)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1   HL_E AgeSelex
             0          19.8       2.70162            5.4          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_peak_HL_E(30)
            -5             3      -1.44357           -2.3          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_top_logit_HL_E(30)
            -4            12     -0.575954            1.6          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_ascend_se_HL_E(30)
            -2             6        3.0464            1.7          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_descend_se_HL_E(30)
           -15             5      -11.5466           -8.3          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_start_logit_HL_E(30)
            -5             5      -1.88022           -1.8          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_end_logit_HL_E(30)
# 2   HL_W AgeSelex
             0          19.8        3.20983           5.4          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_peak_HL_W(31)
            -8             3       -7.12125          -2.3          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_top_logit_HL_W(31)
            -4            12       0.496506           1.6          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_ascend_se_HL_W(31)
            -2             6        2.37828           1.7          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_descend_se_HL_W(31)
           -15             5       -10.4362          -8.3          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_start_logit_HL_W(31)
            -5             5       -3.69326          -1.8          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_end_logit_HL_W(31)
# 3   LL_E AgeSelex
             0          19.8        6.33425           7.5          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_peak_LL_E(32)
            -5             3       -1.95993             3          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_top_logit_LL_E(32)
            -4            12        1.53991           2.2          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_ascend_se_LL_E(32)
            -2             6       -1.20304           2.1          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_descend_se_LL_E(32)
           -15             5       -5.16325         -14.1          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_start_logit_LL_E(32)
            -5             8      -0.171062             5          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_end_logit_LL_E(32)
# 4   LL_W AgeSelex
             0          19.8       7.84824           7.5          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_peak_LL_W(33)
            -5             3      -4.24592             3          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_top_logit_LL_W(33)
            -4            12       2.05731           2.2          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_ascend_se_LL_W(33)
            -2             6       3.24051           2.1          0.05             1          3          0          0          0          0        0.5          3          2  #  Age_DblN_descend_se_LL_W(33)
           -15             5      -5.80854         -14.1          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_start_logit_LL_W(33)
            -5             5     -0.395711             5          0.05             1          2          0          0          0          0        0.5          3          2  #  Age_DblN_end_logit_LL_W(33)
# 5   MRIP_E AgeSelex
             0          19.8       2.23823           5.4          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_peak_MRIP_E(34)
            -6             3       -1.9436          -2.3          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_top_logit_MRIP_E(34)
            -4            12      -2.03605           1.6          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_ascend_se_MRIP_E(34)
            -2             6       2.10525           1.7          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_descend_se_MRIP_E(34)
           -15             5      -6.39471          -8.3          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_start_logit_MRIP_E(34)
            -8             5      -4.90902          -1.8          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_end_logit_MRIP_E(34)
# 6   MRIP_W AgeSelex
             0          19.8       1.29686           5.4          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_peak_MRIP_W(35)
            -8             3      -7.25228          -2.3          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_top_logit_MRIP_W(35)
            -8            12      -4.75481           1.6          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_ascend_se_MRIP_W(35)
            -2             6       2.20189           1.7          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_descend_se_MRIP_W(35)
           -16             5      -13.6583          -8.3          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_start_logit_MRIP_W(35)
            -5             5       -3.6066          -1.8          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_end_logit_MRIP_W(35)
# 7   HBT_E AgeSelex
             0          19.8        3.18915          5.4          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_peak_HBT_E(36)
            -5             3      -0.838444         -2.3          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_top_logit_HBT_E(36)
            -4            12     -0.0754085          1.6          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_ascend_se_HBT_E(36)
            -2             6      -0.217729          1.7          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_descend_se_HBT_E(36)
           -15             5       -12.4389         -8.3          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_start_logit_HBT_E(36)
            -8             5       -4.48999         -1.8          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_end_logit_HBT_E(36)
# 8   HBT_W AgeSelex
             0          19.8        2.77183          5.4          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_peak_HBT_W(37)
            -8             3       -6.07667         -2.3          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_top_logit_HBT_W(37)
            -6            12      -0.790138          1.6          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_ascend_se_HBT_W(37)
            -2             6         2.1931          1.7          0.05             1          3          0          0          0          0        0.5          5          2  #  Age_DblN_descend_se_HBT_W(37)
           -15             5       -11.5731         -8.3          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_start_logit_HBT_W(37)
            -5             5       -3.02223         -1.8          0.05             1          2          0          0          0          0        0.5          5          2  #  Age_DblN_end_logit_HBT_W(37)
# 9   C_Clsd_E AgeSelex
             0          19.8        3.31728          5.4          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_peak_C_Clsd_E(38)
            -5             3       -3.18198         -2.3          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_top_logit_C_Clsd_E(38)
            -4            12       0.163012          1.6          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_ascend_se_C_Clsd_E(38)
            -2             6        3.05419          1.7          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_descend_se_C_Clsd_E(38)
           -15             5       -10.7403         -8.3          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_start_logit_C_Clsd_E(38)
            -5             5       -2.55286         -1.8          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_end_logit_C_Clsd_E(38)
# 10   C_Clsd_W AgeSelex
             0          19.8        3.51887          5.4          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_peak_C_Clsd_W(39)
            -6             3       -4.90164         -2.3          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_top_logit_C_Clsd_W(39)
            -4            12      0.0324134          1.6          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_ascend_se_C_Clsd_W(39)
            -2             6        1.88384          1.7          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_descend_se_C_Clsd_W(39)
           -15             5       -11.2661         -8.3          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_start_logit_C_Clsd_W(39)
            -5             5       -2.01386         -1.8          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_end_logit_C_Clsd_W(39)
# 13   Shr_E AgeSelex
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P1_Shr_E(13)
           -20            20      -3.33861          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P2_Shr_E(13)
           -20            20      -1.15347          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P3_Shr_E(13)
           -50             0           -20           -20             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P4_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P5_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P6_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P7_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P8_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P9_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P10_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P11_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P12_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P13_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P14_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P15_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P16_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P17_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P18_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P19_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P20_Shr_E(13)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P21_Shr_E(13)
# 14   Shr_W AgeSelex
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P1_Shr_W(14)
           -20            20      -2.78911          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P2_Shr_W(14)
           -20            20      -1.44106          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P3_Shr_W(14)
           -50             0           -20           -20             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P4_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P5_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P6_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P7_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P8_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P9_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P10_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P11_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P12_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P13_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P14_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P15_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P16_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P17_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P18_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P19_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P20_Shr_W(14)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P21_Shr_W(14)
# 15   Video_E AgeSelex
             0          19.8       3.80079           5.4          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_peak_Video_E(44)
            -5             3      -1.23215          -2.3          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_top_logit_Video_E(44)
            -4            12      0.707133           1.6          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_ascend_se_Video_E(44)
            -2             6       1.33721           1.7          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_descend_se_Video_E(44)
           -15             5      -9.76378          -8.3          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_start_logit_Video_E(44)
            -5             5      -1.13423          -1.8          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_end_logit_Video_E(44)
# 16   Video_W AgeSelex
             0          19.8       2.73427           5.4          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_peak_Video_W(45)
            -5             3      -3.48734          -2.3          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_top_logit_Video_W(45)
            -4            12     -0.511086           1.6          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_ascend_se_Video_W(45)
            -2             6       2.26326           1.7          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_descend_se_Video_W(45)
           -15             5      -9.80216          -8.3          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_start_logit_Video_W(45)
            -5             5      -1.66585          -1.8          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_end_logit_Video_W(45)
# 19   Sum_E AgeSelex
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P1_Sum_E(19)
           -20            20       2.39693          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P2_Sum_E(19)
           -20            20    -0.0246087          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P3_Sum_E(19)
           -50             0      -10.0206           -10             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P4_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P5_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P6_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P7_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P8_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P9_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P10_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P11_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P12_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P13_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P14_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P15_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P16_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P17_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P18_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P19_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P20_Sum_E(19)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P21_Sum_E(19)
# 20   Sum_W AgeSelex
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P1_Sum_W(20)
           -20            20       1.72829          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P2_Sum_W(20)
           -20            20     -0.907832          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P3_Sum_W(20)
           -50             0      -10.0107           -10             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P4_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P5_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P6_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P7_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P8_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P9_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P10_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P11_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P12_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P13_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P14_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P15_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P16_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P17_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P18_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P19_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P20_Sum_W(20)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P21_Sum_W(20)
# 21   Fall_E AgeSelex
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P1_Fall_E(21)
           -20            20       -3.9274          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P2_Fall_E(21)
           -20            20     0.0519894          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P3_Fall_E(21)
           -50             0           -20           -20             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P4_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P5_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P6_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P7_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P8_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P9_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P10_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P11_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P12_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P13_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P14_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P15_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P16_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P17_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P18_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P19_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P20_Fall_E(21)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P21_Fall_E(21)
# 22   Fall_W AgeSelex
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P1_Fall_W(22)
           -20            20      -3.44966          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P2_Fall_W(22)
           -20            20     -0.591773          -0.1             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P3_Fall_W(22)
           -50             0           -20           -20             1             6          2          0          0          0          0          0          0          0  #  AgeSel_P4_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P5_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P6_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P7_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P8_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P9_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P10_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P11_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P12_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P13_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P14_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P15_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P16_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P17_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P18_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P19_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P20_Fall_W(22)
           -20            20             0             0             1             6         -1          0          0          0          0          0          0          0  #  AgeSel_P21_Fall_W(22)
# 23   BLL_W AgeSelex
             4            18        6.32016           12             1             0          2          0          0          0          0          0          0          0  #  Age_inflection_BLL_W(23)
            -5             5        1.95327            2             1             6          2          0          0          0          0          0          0          0  #  Age_95%width_BLL_W(23)
# 24   BLL_E AgeSele
             4            18        8.68413           12             1             0          2          0          0          0          0          0          0          0  #  Age_inflection_BLL_E(24)
            -5             5        2.45512            2             1             6          2          0          0          0          0          0          0          0  #  Age_95%width_BLL_E(24)
# 25   ROV_E AgeSelex
             0          19.8        2.19417          5.4          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_peak_ROV_E(54)
            -5             3       -2.65548         -2.3          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_top_logit_ROV_E(54)
            -4            12       -2.00878          1.6          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_ascend_se_ROV_E(54)
            -2             6      -0.645971          1.7          0.05             1          3          0          0          0          0        0.5          0          0  #  Age_DblN_descend_se_ROV_E(54)
           -15             5       -10.7135         -8.3          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_start_logit_ROV_E(54)
            -5             5       0.385026         -1.8          0.05             1          2          0          0          0          0        0.5          0          0  #  Age_DblN_end_logit_ROV_E(54)
# timevary RETENTION parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            10           100         33.02         33.02             1             0      -4  # Retain_L_infl_HL_E(1)_BLK1repl_1985
            10           100         35.56         35.56             1             0      -4  # Retain_L_infl_HL_E(1)_BLK1repl_1994
            10           100          38.1          38.1             1             0      -4  # Retain_L_infl_HL_E(1)_BLK1repl_1995
            10           100         33.02         33.02             1             0      -6  # Retain_L_infl_HL_E(1)_BLK1repl_2007
            -1            20             1             1             1             0      -4  # Retain_L_width_HL_E(1)_BLK1repl_1985
            -1            20             1             1             1             0      -4  # Retain_L_width_HL_E(1)_BLK1repl_1994
            -1            20             1             1             1             0      -4  # Retain_L_width_HL_E(1)_BLK1repl_1995
            -1            20             1             1             1             0      -4  # Retain_L_width_HL_E(1)_BLK1repl_2007
           -10          1000           999            10             1             0      -4  # Retain_L_asymptote_logit_HL_E(1)_BLK1repl_1985
           -10          1000           999            10             1             0      -4  # Retain_L_asymptote_logit_HL_E(1)_BLK1repl_1994
           -10          1000           999            10             1             0      -4  # Retain_L_asymptote_logit_HL_E(1)_BLK1repl_1995
           -10            10          2.39377             0             1             0      6  # Retain_L_asymptote_logit_HL_E(1)_BLK1repl_2007
            -1             2          0.56          0.56             1             0      -4  # DiscMort_L_level_old_HL_E(1)_BLK9repl_2008
            10           100         33.02         33.02             1             0      -4  # Retain_L_infl_HL_W(2)_BLK1repl_1985
            10           100         35.56         35.56             1             0      -4  # Retain_L_infl_HL_W(2)_BLK1repl_1994
            10           100          38.1          38.1             1             0      -4  # Retain_L_infl_HL_W(2)_BLK1repl_1995
            10           100         33.02         33.02             1             0      -6  # Retain_L_infl_HL_W(2)_BLK1repl_2007
            -1            20             1             1             1             0      -4  # Retain_L_width_HL_W(2)_BLK1repl_1985
            -1            20             1             1             1             0      -4  # Retain_L_width_HL_W(2)_BLK1repl_1994
            -1            20             1             1             1             0      -4  # Retain_L_width_HL_W(2)_BLK1repl_1995
            -1            20             1             1             1             0      -4  # Retain_L_width_HL_W(2)_BLK1repl_2007
           -10         1000            999            10             1             0      -4  # Retain_L_asymptote_logit_HL_W(2)_BLK1repl_1985
           -10         1000            999            10             1             0      -4  # Retain_L_asymptote_logit_HL_W(2)_BLK1repl_1994
           -10         1000            999            10             1             0      -4  # Retain_L_asymptote_logit_HL_W(2)_BLK1repl_1995
           -10            10         3.36624             0              1              0     6  # Retain_L_asymptote_logit_HL_W(2)_BLK1repl_2007
            -1             2           0.6           0.6             1             0      -4  # DiscMort_L_level_old_HL_W(2)_BLK9repl_2008
             6           100         33.02         33.02             1             0      -4  # Retain_L_infl_LL_E(3)_BLK1repl_1985
             6           100         35.56         35.56             1             0      -4  # Retain_L_infl_LL_E(3)_BLK1repl_1994
             6           100          38.1          38.1             1             0      -4  # Retain_L_infl_LL_E(3)_BLK1repl_1995
             6           100         33.02         33.02             1             0      -6  # Retain_L_infl_LL_E(3)_BLK1repl_2007
            -1            20             1             1             1             0      -4  # Retain_L_width_LL_E(3)_BLK1repl_1985
            -1            20             1             1             1             0      -4  # Retain_L_width_LL_E(3)_BLK1repl_1994
            -1            20             1             1             1             0      -4  # Retain_L_width_LL_E(3)_BLK1repl_1995
            -1            20             1             1             1             0      -4  # Retain_L_width_LL_E(3)_BLK1repl_2007
           -10          1000            999            10            1             0      -4  # Retain_L_asymptote_logit_LL_E(3)_BLK1repl_1985
           -10          1000            999            10            1             0      -4  # Retain_L_asymptote_logit_LL_E(3)_BLK1repl_1994
           -10          1000            999            10            1             0      -4  # Retain_L_asymptote_logit_LL_E(3)_BLK1repl_1995
           -10            10        0.246055             0              1             0      6  # Retain_L_asymptote_logit_LL_E(3)_BLK1repl_2007
            -1             2          0.64          0.64             1             0      -4  # DiscMort_L_level_old_LL_E(3)_BLK9repl_2008
            10           100         33.02         33.02             1             0      -4  # Retain_L_infl_LL_W(4)_BLK1repl_1985
            10           100         35.56         35.56             1             0      -4  # Retain_L_infl_LL_W(4)_BLK1repl_1994
            10           100          38.1          38.1             1             0      -4  # Retain_L_infl_LL_W(4)_BLK1repl_1995
            10           100         33.02         33.02             1             0      -6  # Retain_L_infl_LL_W(4)_BLK1repl_2007
            -1            20             1             1             1             0      -4  # Retain_L_width_LL_W(4)_BLK1repl_1985
            -1            20             1             1             1             0      -4  # Retain_L_width_LL_W(4)_BLK1repl_1994
            -1            20             1             1             1             0      -4  # Retain_L_width_LL_W(4)_BLK1repl_1995
            -1            20             1             1             1             0      -4  # Retain_L_width_LL_W(4)_BLK1repl_2007
           -10          1000            999           10             1             0      -4  # Retain_L_asymptote_logit_LL_W(4)_BLK1repl_1985
           -10          1000            999           10             1             0      -4  # Retain_L_asymptote_logit_LL_W(4)_BLK1repl_1994
           -10          1000            999           10             1             0      -4  # Retain_L_asymptote_logit_LL_W(4)_BLK1repl_1995
           -10            10         2.93657             0             1              0      6  # Retain_L_asymptote_logit_LL_W(4)_BLK1repl_2007
            -1             2          0.81          0.81             1             0      -4  # DiscMort_L_level_old_LL_W(4)_BLK9repl_2008
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  TIME VARYING RECREATIONAL RETENTION PARMS- FIXED PRE-2000, ESTIMATE 2000-2016          
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
#  MRIP_E            
#  logistic asc infl x 4 blocks - all fixed
#            10           100         33.02         33.02             1             0      -4  # Retain_L_infl_MRIP_E(5)_BLK2repl_1985
#            10           100         35.56         35.56             1             0      -4  # Retain_L_infl_MRIP_E(5)_BLK2repl_1994
#            10           100          38.1          38.1             1             0      -4  # Retain_L_infl_MRIP_E(5)_BLK2repl_1995
#            10           100         40.64         40.64             1             0      -4  # Retain_L_infl_MRIP_E(5)_BLK2repl_2000
#
# double norm asc infl x 6 blocks
            10           100         33.02         33.02             1             0      -4  # Retain_L_asc_infl_MRIP_E(5)_BLK8repl_1985
            10           100         35.56         35.56             1             0      -4  # Retain_L_asc_infl_MRIP_E(5)_BLK8repl_1994
            10           100          38.1          38.1             1             0      -4  # Retain_L_asc_infl_MRIP_E(5)_BLK8repl_1995
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_MRIP_E(5)_BLK8repl_2000       
	    10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_MRIP_E(5)_BLK8repl_2011
	    10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_MRIP_E(5)_BLK8repl_2016
#  logistic asc slope / width x 4 blocks - all fixed
#            -1            20             1             1             1             0      -4  # Retain_L_width_MRIP_E(5)_BLK2repl_1985
#            -1            20             1             1             1             0      -4  # Retain_L_width_MRIP_E(5)_BLK2repl_1994
#            -1            20             1             1             1             0      -4  # Retain_L_width_MRIP_E(5)_BLK2repl_1995
#            -1            20             1             1             1             0      -4  # Retain_L_width_MRIP_E(5)_BLK2repl_2000
#
#  double norm asc slope / width x 6 blocks   
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_MRIP_E(5)_BLK8repl_1985
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_MRIP_E(5)_BLK8repl_1994
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_MRIP_E(5)_BLK8repl_1995
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_MRIP_E(5)_BLK8repl_2000
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_MRIP_E(5)_BLK8repl_2011
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_MRIP_E(5)_BLK8repl_2016
#  double norm desc infl x 6 blocks
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_MRIP_E(5)_BLK8rep1_1985
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_MRIP_E(5)_BLK8rep1_1994            
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_MRIP_E(5)_BLK8rep1_1995            
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_MRIP_E(5)_BLK8rep1_2000            
            -1           500           150           150 	     1             0      -4  #  Retain_L_desc_infl_MRIP_E(5)_BLK8rep1_2011
            -1           500           150           150 	     1             0      -4  #  Retain_L_desc_infl_MRIP_E(5)_BLK8rep1_2016
#  double norm desc slope x 6 blocks          
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_E(5)_BLK8rep1_1985
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_E(5)_BLK8rep1_1994            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_E(5)_BLK8rep1_1995            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_E(5)_BLK8rep1_2000            
            -1             5             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_E(5)_BLK8rep1_2011
            -1             5             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_E(5)_BLK8rep1_2016
# discM unchanged for now            
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_MRIP_E(5)_BLK4repl_2008
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_MRIP_E(5)_BLK4repl_2016
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  MRIP_W
#  logistic asc infl x 4 blocks - all fixed
#           10           100         33.02         33.02             1             0      -4  # Retain_L_infl_MRIP_W(6)_BLK2repl_1985
#            10           100         35.56         35.56             1             0      -4  # Retain_L_infl_MRIP_W(6)_BLK2repl_1994
#            10           100          38.1          38.1             1             0      -4  # Retain_L_infl_MRIP_W(6)_BLK2repl_1995
#            10           100         40.64         40.64             1             0      -4  # Retain_L_infl_MRIP_W(6)_BLK2repl_2000
#
# double norm asc infl x 6 blocks
            10           100         33.02         33.02             1             0      -4  # Retain_L_asc_infl_MRIP_W(6)_BLK8repl_1985
            10           100         35.56         35.56             1             0      -4  # Retain_L_asc_infl_MRIP_W(6)_BLK8repl_1994
            10           100          38.1          38.1             1             0      -4  # Retain_L_asc_infl_MRIP_W(6)_BLK8repl_1995
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_MRIP_W(6)_BLK8repl_2000 
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_MRIP_W(6)_BLK8repl_2011
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_MRIP_W(6)_BLK8repl_2016
#  logistic asc slope / width x 4 blocks - all fixed
#            -1            20             1             1             1             0      -4  # Retain_L_width_MRIP_W(6)_BLK2repl_1985
#            -1            20             1             1             1             0      -4  # Retain_L_width_MRIP_W(6)_BLK2repl_1994
#            -1            20             1             1             1             0      -4  # Retain_L_width_MRIP_W(6)_BLK2repl_1995
#            -1            20             1             1             1             0      -4  # Retain_L_width_MRIP_W(6)_BLK2repl_2000
#            
# double norm asc slope / width x 6 blocks
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_MRIP_W(6)_BLK8repl_1985
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_MRIP_W(6)_BLK8repl_1994
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_MRIP_W(6)_BLK8repl_1995
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_MRIP_W(6)_BLK8repl_2000
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_MRIP_W(6)_BLK8repl_2011
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_MRIP_W(6)_BLK8repl_2016
#
#  double norm desc infl x 6 blocks
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_MRIP_W(6)_BLK8rep1_1985
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_MRIP_W(6)_BLK8rep1_1994            
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_MRIP_W(6)_BLK8rep1_1995            
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_MRIP_W(6)_BLK8rep1_2000            
            -1           500           150           150 	     1             0      -4  #  Retain_L_desc_infl_MRIP_W(6)_BLK8rep1_2011
            -1           500           150           150 	     1             0      -4  #  Retain_L_desc_infl_MRIP_W(6)_BLK8rep1_2016
#
#  double norm desc slope x 6 blocks
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_W(6)_BLK8rep1_1985
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_W(6)_BLK8rep1_1994            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_W(6)_BLK8rep1_1995            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_W(6)_BLK8rep1_2000            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_W(6)_BLK8rep1_2011
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_MRIP_W(6)_BLK8rep1_2016
# discM unchanged for now            
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_MRIP_W(6)_BLK4repl_2008
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_MRIP_W(6)_BLK4repl_2016
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  HBT_E
#  logistic asc infl x 4 blocks - all fixed
#            10           100         33.02         33.02             1             0      -8  # Retain_L_infl_HBT_E(7)_BLK2repl_1985
#            10           100         35.56         35.56             1             0      -8  # Retain_L_infl_HBT_E(7)_BLK2repl_1994
#            10           100          38.1          38.1             1             0      -8  # Retain_L_infl_HBT_E(7)_BLK2repl_1995
#            10           100         40.64         40.64             1             0      -8  # Retain_L_infl_HBT_E(7)_BLK2repl_2000
#
#  double norm asc infl x 6 blocks
            10           100         33.02         33.02             1             0      -4  # Retain_L_asc_infl_HBT_E(7)_BLK8repl_1985
            10           100         35.56         35.56             1             0      -4  # Retain_L_asc_infl_HBT_E(7)_BLK8repl_1994
            10           100          38.1          38.1             1             0      -4  # Retain_L_asc_infl_HBT_E(7)_BLK8repl_1995
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_HBT_E(7)_BLK8repl_2000     
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_HBT_E(7)_BLK8repl_2011 
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_HBT_E(7)_BLK8repl_2016

#
#  logistic asc slope / width x 4 blocks - all fixed
#            -1            20             1             1             1             0      -4  # Retain_L_width_HBT_E(7)_BLK2repl_1985
#            -1            20             1             1             1             0      -4  # Retain_L_width_HBT_E(7)_BLK2repl_1994
#            -1            20             1             1             1             0      -4  # Retain_L_width_HBT_E(7)_BLK2repl_1995
#            -1            20             1             1             1             0      -4  # Retain_L_width_HBT_E(7)_BLK2repl_2000
#
# double norm asc slope / width x 6 blocks
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_HBT_E(7)_BLK8repl_1985
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_HBT_E(7)_BLK8repl_1994
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_HBT_E(7)_BLK8repl_1995
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_HBT_E(7)_BLK8repl_2000
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_HBT_E(7)_BLK8repl_2011
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_HBT_E(7)_BLK8repl_2016
#
#  double norm desc infl x 6 blocks
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_E(7)_BLK8rep1_1985
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_E(7)_BLK8rep1_1994            
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_E(7)_BLK8rep1_1995            
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_E(7)_BLK8rep1_2000
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_E(7)_BLK8rep1_2011  
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_E(7)_BLK8rep1_2016
# 
#  double norm desc slope x 6 blocks
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_E(7)_BLK8rep1_1985
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_E(7)_BLK8rep1_1994            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_E(7)_BLK8rep1_1995            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_E(7)_BLK8rep1_2000 
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_E(7)_BLK8rep1_2011
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_E(7)_BLK8rep1_2016
#  logistic asymptote
#           -10            1000            999            10             1             0      -4  # Retain_L_asymptote_logit_HBT_E(7)_BLK2repl_1985
#           -10            1000            999            10             1             0      -4  # Retain_L_asymptote_logit_HBT_E(7)_BLK2repl_1994
#           -10            1000            999            10             1             0      -4  # Retain_L_asymptote_logit_HBT_E(7)_BLK2repl_1995
#           -10            1000            999            10             1             0      -6  # Retain_L_asymptote_logit_HBT_E(7)_BLK2repl_2000
# discM unchanged for now
            -1             2         0.118         0.118             1             0      -8  # DiscMort_L_level_HBT_E(7)_BLK4repl_2008
            -1             2         0.118         0.118             1             0      -8  # DiscMort_L_level_HBT_E(7)_BLK4repl_2016
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  HBT_W 
#  logistic asc infl x 4 blocks - all fixed
#            10           100         33.02         33.02             1             0      -4  # Retain_L_infl_HBT_W(8)_BLK2repl_1985
#            10           100         35.56         35.56             1             0      -4  # Retain_L_infl_HBT_W(8)_BLK2repl_1994
#            10           100          38.1          38.1             1             0      -4  # Retain_L_infl_HBT_W(8)_BLK2repl_1995
#            10           100         40.64         40.64             1             0      -4  # Retain_L_infl_HBT_W(8)_BLK2repl_2000
#
# double norm asc infl x 6 blocks
            10           100         33.02         33.02             1             0      -4  # Retain_L_asc_infl_HBT_W(8)_BLK8repl_1985
            10           100         35.56         35.56             1             0      -4  # Retain_L_asc_infl_HBT_W(8)_BLK8repl_1994
            10           100          38.1          38.1             1             0      -4  # Retain_L_asc_infl_HBT_W(8)_BLK8repl_1995
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_HBT_W(8)_BLK8repl_2000
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_HBT_W(8)_BLK8repl_2011
            10           100         40.64         40.64             1             0      -3  # Retain_L_asc_infl_HBT_W(8)_BLK8repl_2016
#
#  logistic asc slope / width x 4 blocks - all fixed
#            -1            20             1             1             1             0      -4  # Retain_L_width_HBT_W(8)_BLK2repl_1985
#            -1            20             1             1             1             0      -4  # Retain_L_width_HBT_W(8)_BLK2repl_1994
#            -1            20             1             1             1             0      -4  # Retain_L_width_HBT_W(8)_BLK2repl_1995
#            -1            20             1             1             1             0      -4  # Retain_L_width_HBT_W(8)_BLK2repl_2000
# double norm asc slope / width x 6 blocks            
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_HBT_W(8)_BLK8repl_1985
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_HBT_W(8)_BLK8repl_1994
            -1            20             1             1             1             0      -4  # Retain_L_asc_slope_HBT_W(8)_BLK8repl_1995
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_HBT_W(8)_BLK8repl_2000
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_HBT_W(8)_BLK8repl_2011
            -1            20             1             1             1             0      -3  # Retain_L_asc_slope_HBT_W(8)_BLK8repl_2016
#
#  double norm desc infl x 6 blocks
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_W(8)_BLK8rep1_1985
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_W(8)_BLK8rep1_1994            
            -1           500           150           150	     1             0      -4  #  Retain_L_desc_infl_HBT_W(8)_BLK8rep1_1995            
            -1           500           150	     150 	     1             0      -4  #  Retain_L_desc_infl_HBT_W(8)_BLK8rep1_2000
            -1           500           150	     150 	     1             0      -4  #  Retain_L_desc_infl_HBT_W(8)_BLK8rep1_2011
            -1           500           150	     150 	     1             0      -4  #  Retain_L_desc_infl_HBT_W(8)_BLK8rep1_2016
#
#  double norm desc slope x 6 blocks
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_W(8)_BLK8rep1_1985
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_W(8)_BLK8rep1_1994            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_W(8)_BLK8rep1_1995            
            -1             2             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_W(8)_BLK8rep1_2000  
            -1             5             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_W(8)_BLK8rep1_2011
            -1             5             1             1             1             0      -4  #  Retain_L_desc_slope_HBT_W(8)_BLK8rep1_2016

#  discM
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_HBT_W(8)_BLK4repl_2008
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_HBT_W(8)_BLK4repl_2016
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#                        
            -1             2          0.55          0.55             1             0      -4  # DiscMort_L_level_old_C_Clsd_E(9)_BLK9repl_2008
            -1             2          0.74          0.74             1             0      -4  # DiscMort_L_level_old_C_Clsd_W(10)_BL94repl_2008
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_R_Clsd_E(11)_BLK4repl_2008
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_R_Clsd_E(11)_BLK4repl_2016
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_R_Clsd_W(12)_BLK4repl_2008
            -1             2         0.118         0.118             1             0      -4  # DiscMort_L_level_R_Clsd_W(12)_BLK4repl_2016
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#   TIME-VARYING AGE SELEX PARMS
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
             0          19.8       3.48239            5.4          0.05             1      2  # Age_DblN_peak_HL_E(30)_BLK3repl_2007
            -5             3      -4.74897           -2.3          0.05             1      3  # Age_DblN_top_logit_HL_E(30)_BLK3repl_2007
            -4            12       0.40217            1.6          0.05             1      3  # Age_DblN_ascend_se_HL_E(30)_BLK3repl_2007
            -2             6       2.88378            1.7          0.05             1      3  # Age_DblN_descend_se_HL_E(30)_BLK3repl_2007
           -15             5      -12.2311           -8.3          0.05             1      2  # Age_DblN_start_logit_HL_E(30)_BLK3repl_2007
            -5             5       -2.4885           -1.8          0.05             1      2  # Age_DblN_end_logit_HL_E(30)_BLK3repl_2007
             0          19.8       3.64532            5.4          0.05             1      2  # Age_DblN_peak_HL_W(31)_BLK3repl_2007
            -5             3      -4.87264           -2.3          0.05             1      3  # Age_DblN_top_logit_HL_W(31)_BLK3repl_2007
            -4            12     0.0594856            1.6          0.05             1      3  # Age_DblN_ascend_se_HL_W(31)_BLK3repl_2007
            -2             6       2.19014            1.7          0.05             1      3  # Age_DblN_descend_se_HL_W(31)_BLK3repl_2007
           -15             5      -12.9436           -8.3          0.05             1      2  # Age_DblN_start_logit_HL_W(31)_BLK3repl_2007
            -5             5       -2.8229           -1.8          0.05             1      2  # Age_DblN_end_logit_HL_W(31)_BLK3repl_2007
             0          19.8       5.09044            7.5          0.05             1      2  # Age_DblN_peak_LL_E(32)_BLK3repl_2007
            -5             3      -1.73689              3          0.05             1      3  # Age_DblN_top_logit_LL_E(32)_BLK3repl_2007
            -4            12      0.884079            2.2          0.05             1      3  # Age_DblN_ascend_se_LL_E(32)_BLK3repl_2007
            -2             6       1.35677            2.1          0.05             1      3  # Age_DblN_descend_se_LL_E(32)_BLK3repl_2007
           -15             5      -12.4531          -14.1          0.05             1      2  # Age_DblN_start_logit_LL_E(32)_BLK3repl_2007
            -5             5      -1.07455              5          0.05             1      2  # Age_DblN_end_logit_LL_E(32)_BLK3repl_2007
             0          19.8       9.00784            7.5          0.05             1      2  # Age_DblN_peak_LL_W(33)_BLK3repl_2007
            -5             3     -0.311892              3          0.05             1      3  # Age_DblN_top_logit_LL_W(33)_BLK3repl_2007
            -4            12       2.38672            2.2          0.05             1      3  # Age_DblN_ascend_se_LL_W(33)_BLK3repl_2007
            -2             6       4.49459            2.1          0.05             1      3  # Age_DblN_descend_se_LL_W(33)_BLK3repl_2007
           -15             5      -13.1688          -14.1          0.05             1      2  # Age_DblN_start_logit_LL_W(33)_BLK3repl_2007
            -5             5     -0.415488              5          0.05             1      2  # Age_DblN_end_logit_LL_W(33)_BLK3repl_2007
#  time-varying MRIP and HBT selex
             0          19.8       2.00526           5.4          0.05             1     2  # Age_DblN_peak_MRIP_E(34)_BLK5repl_2008
             0          19.8       2.38078           5.4          0.05             1     2  # Age_DblN_peak_MRIP_E(34)_BLK5repl_2011
#
            -5             3      -3.34255          -2.3          0.05             1     3  # Age_DblN_top_logit_MRIP_E(34)_BLK5repl_2008
            -5             3     -0.939269          -2.3          0.05             1     3  # Age_DblN_top_logit_MRIP_E(34)_BLK5repl_2011
#
            -4            12      -1.80048           1.6          0.05             1     3  # Age_DblN_ascend_se_MRIP_E(34)_BLK5repl_2008
            -20           12      -1.64089           1.6          0.05             1     3  # Age_DblN_ascend_se_MRIP_E(34)_BLK5repl_2011
#
            -2             6       2.44897           1.7          0.05             1     3  # Age_DblN_descend_se_MRIP_E(34)_BLK5repl_2008
            -2             6       1.86584           1.7          0.05             1     3  # Age_DblN_descend_se_MRIP_E(34)_BLK5repl_2011
#
           -15             5      -8.43765          -8.3          0.05             1     2  # Age_DblN_start_logit_MRIP_E(34)_BLK5repl_2008
           -15             5      -10.2866          -8.3          0.05             1     2  # Age_DblN_start_logit_MRIP_E(34)_BLK5repl_2011
#
            -5             5      -4.39693          -1.8          0.05             1     2  # Age_DblN_end_logit_MRIP_E(34)_BLK5repl_2008
            -5             5      -3.53396          -1.8          0.05             1     2  # Age_DblN_end_logit_MRIP_E(34)_BLK5repl_2011
#
             0          19.8       2.14957           5.4          0.05             1     2  # Age_DblN_peak_MRIP_W(35)_BLK5repl_2008
             0          19.8       2.36354           5.4          0.05             1     2  # Age_DblN_peak_MRIP_W(35)_BLK5repl_2011
#
            -5             3      -1.60638          -2.3          0.05             1     3  # Age_DblN_top_logit_MRIP_W(35)_BLK5repl_2008
            -5             3      -2.09102          -2.3          0.05             1     3  # Age_DblN_top_logit_MRIP_W(35)_BLK5repl_2011
#
            -4            12      -1.86849           1.6          0.05             1     3  # Age_DblN_ascend_se_MRIP_W(35)_BLK5repl_2008
            -20           12      -1.47993           1.6          0.05             1     3  # Age_DblN_ascend_se_MRIP_W(35)_BLK5repl_2011
#
            -2             6      0.097542           1.7          0.05             1     3  # Age_DblN_descend_se_MRIP_W(35)_BLK5repl_2008
            -2             6       2.91692           1.7          0.05             1     3  # Age_DblN_descend_se_MRIP_W(35)_BLK5repl_2011
#
           -15             5      -3.24759          -8.3          0.05             1     2  # Age_DblN_start_logit_MRIP_W(35)_BLK5repl_2008
           -15             5      -10.2975          -8.3          0.05             1     2  # Age_DblN_start_logit_MRIP_W(35)_BLK5repl_2011
#
            -5             5      -3.56341          -1.8          0.05             1     2  # Age_DblN_end_logit_MRIP_W(35)_BLK5repl_2008
            -5             5      -2.86488          -1.8          0.05             1     2  # Age_DblN_end_logit_MRIP_W(35)_BLK5repl_2011
#
             0          19.8        3.3199           5.4          0.05             1     2  # Age_DblN_peak_HBT_E(36)_BLK5repl_2008
             0          19.8       3.73623           5.4          0.05             1     2  # Age_DblN_peak_HBT_E(36)_BLK5repl_2011
#
            -5             3      -4.68761          -2.3          0.05             1     3  # Age_DblN_top_logit_HBT_E(36)_BLK5repl_2008
            -5             3      -4.64581          -2.3          0.05             1     3  # Age_DblN_top_logit_HBT_E(36)_BLK5repl_2011
#
            -4            12   -0.00211838           1.6          0.05             1     3  # Age_DblN_ascend_se_HBT_E(36)_BLK5repl_2008
            -4            12      0.323002           1.6          0.05             1     3  # Age_DblN_ascend_se_HBT_E(36)_BLK5repl_2011
#
            -2             6        1.9075           1.7          0.05             1     3  # Age_DblN_descend_se_HBT_E(36)_BLK5repl_2008
            -2             6       2.96565           1.7          0.05             1     3  # Age_DblN_descend_se_HBT_E(36)_BLK5repl_2011
#
           -15             5      -9.62846          -8.3          0.05             1     2  # Age_DblN_start_logit_HBT_E(36)_BLK5repl_2008
           -15             5      -8.80231          -8.3          0.05             1     2  # Age_DblN_start_logit_HBT_E(36)_BLK5repl_2011
#
            -5             5      -3.94988          -1.8          0.05             1     2  # Age_DblN_end_logit_HBT_E(36)_BLK5repl_2008
            -5             5      -2.94116          -1.8          0.05             1     2  # Age_DblN_end_logit_HBT_E(36)_BLK5repl_2011
#
             0          19.8       3.56748           5.4          0.05             1     2  # Age_DblN_peak_HBT_W(37)_BLK5repl_2008
             0          19.8       4.57795           5.4          0.05             1     2  # Age_DblN_peak_HBT_W(37)_BLK5repl_2011
#
            -5             3      -3.02087          -2.3          0.05             1     3  # Age_DblN_top_logit_HBT_W(37)_BLK5repl_2008
            -5             3      -4.86697          -2.3          0.05             1     3  # Age_DblN_top_logit_HBT_W(37)_BLK5repl_2011
#
            -4            12      -1.29888           1.6          0.05             1     3  # Age_DblN_ascend_se_HBT_W(37)_BLK5repl_2008
            -4            12      0.363947           1.6          0.05             1     3  # Age_DblN_ascend_se_HBT_W(37)_BLK5repl_2011
#
            -2             6      0.616668           1.7          0.05             1     3  # Age_DblN_descend_se_HBT_W(37)_BLK5repl_2008
            -2             6       1.55852           1.7          0.05             1     3  # Age_DblN_descend_se_HBT_W(37)_BLK5repl_2011
#
           -15             5      -10.6625          -8.3          0.05             1     2  # Age_DblN_start_logit_HBT_W(37)_BLK5repl_2008
           -15             5      -11.3677          -8.3          0.05             1     2  # Age_DblN_start_logit_HBT_W(37)_BLK5repl_2011
#
            -5             5      -2.42126          -1.8          0.05             1     2  # Age_DblN_end_logit_HBT_W(37)_BLK5repl_2008
            -5             5       -3.5701          -1.8          0.05             1     2  # Age_DblN_end_logit_HBT_W(37)_BLK5repl_2011
#
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# deviation vectors for timevary parameters
#	not used here
#
#  ----------------------------------------------------------------------------------------------------------------------------
#    VARIANCE ADJUSTMENT
#	all data weighting is done in the .dat nsamps and index SEs, not here
#
#_Factor  Fleet  Value
 -9999   1    0  # terminator
#
7 	#_maxlambdaphase
1 	#_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark
#like_comp 	fleet  phase  value  sizefreq_method
18  		1 	1  	0  	1
-9999  1  1  1  1  #  terminator
0 # (0/1) read specs for more stddev reporting 
 # 0 0 0 0 0 0 0 0 0 # placeholder for # selex_fleet, 1=len/2=age/3=both, year, N selex bins, 0 or Growth pattern, N growth ages, 0 or NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999
