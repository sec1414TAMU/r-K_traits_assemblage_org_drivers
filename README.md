# assemblage_org_drivers

GENERAL INFORMATION

This README.txt file was updated on 10/25/26

A. Paper associated with this archive: Complex interplay between trait representation and environmental drivers alters prediction of emergent ecosystem properties, 

B. Citation: TBD

C. Brief abstract: Here we generate a self-organizing phytoplankton assemblage with traits spanning an r/K gradient, in which population density shifts with trait fitness under different environmental conditions, and embed it in a coastal ecosystem model. The program files and functions provided complete all necessary tasks to run a model simulation using either the “trait-rich” (v.rich) or “trait-poor” (v.poor) model version. 

D. Originators [REMOVED FOR SUBMISSION]

E. Contact information [REMOVED FOR SUBMISSION]

F. Funding Sources [REMOVED FOR SUBMISSION]


ACCESS INFORMATION

1. Licenses/restrictions placed on the data or code

TBD

2. Data derived from other sources

Daily average discharge for the San Antonio and Guadalupe Rivers was obtained from United States Geologic Service (USGS) gauge stations above their confluence. These gauges included 08188500 (San Antonio River at Goliad, Tx), 08176500 (Guadalupe River at Victoria, Tx), 08177500 (Coleto Creek near Victoria, Tx). Nutrient concentrations (soluble reactive phosphorous, nitrite+nitrate, ammonium) from below the confluence of the San Antonio and Guadalupe Rivers were acquired from Roelke et al. (2017), while Chla associated with discharge was pulled from site 12578 in the Texas Commission for Environmental Quality’s Surface Water Quality Monitoring Information System (TCEQ SWQMIS). Chla and nutrients (soluble reactive phosphorous, nitrite+nitrate, ammonium) data for systems adjacent to the lower region of San Antonio Bay was obtained from multiple sources. For Mesquite Bay, data came from Gable et al. (2010) and for Espiritu Bay data came from Roelke et al. (2017). Water temperature and salinity data for sites throughout the bay were pooled from multiple sources, including Roelke et al. (2017), TCEQ’s SWQMIS (middle region -13399, 14737 ,14738, 14747, 14749, 14751, 14752, 14753, 14754, 14755, 14891, 14950, 14956; lower region- 13397, 13398, 14739, 14740, 14741, 14744, 14882), and the Texas Coastal Ocean Observation Network (TCOON) mooring platforms (GBRA1, MANERR1, MANERR5).

3. Recommended citation for this data/code archive

TBD

DATA & CODE FILE OVERVIEW

This data repository consists of 33 empirical data files (.txt, .xlsx), 8 code scripts (.m), 12 MATLAB data files (.mat) with model results, and this README document.

Code scripts:
1.	TotalMasterProgram_SABS.m
2.	Pstruct_params_func.m
3.	Dstruct_data_func.m
4.	Data_Interp.m
5.	DiffEq_func.m
6.	lightfunc2.m
7.	Figures_Manuscript_Calcs.m
8.	Figures_Manuscript_D4.m

MATLAB data files:
1.	1_A.mat
2.	1_I.mat
3.	1_N.mat
4.	1_prodZ.mat
5.	1_uA.mat
6.	1_Z.mat
7.	10_A.mat
8.	10_I.mat
9.	10_N.mat
10.	10_prodZ.mat
11.	10_uA.mat
12.	10_Z.mat

Workflow:

1.	“TotalMasterProgram_SABS.m” is opened and the user defines the model version that they would like to use for the simulation. Running the program will call code scripts listed above in order from 2-6. The simulation will produce a set of state variable solutions which are then used in subsequent calculations and figures.
2.	To generate figures, run “Figures_Manuscript_D4.m”. Running the program will call code script, “Figures_Manuscript_Calcs.m”, which utilizes the MATLAB data files 1-12 and calls code scripts 2 & 3. 

SOFTWARE VERSIONS

All code and analysis were written or conducted in MATLAB R2024a.

REFERENCES
1.	Roelke, D. L., Li, H. P., Miller, C. J., Gable, G. M., & Davis, S. E. (2017). Regional shifts in phytoplankton succession and primary productivity in the San Antonio Bay System (USA) in response to diminished freshwater inflows. Marine and Freshwater Research, 68, 131-145.
2.	Gable, G. M. (2010). Spatio-temporal patterns of biophysical parameters in a microtidal, bar-built, subtropical estuary of the Gulf of Mexico (Doctoral dissertation, Texas A & M University).
