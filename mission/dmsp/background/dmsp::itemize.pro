PRO dmsp::itemize
COMPILE_OPT IDL2, STATIC
PRINT, ''
PRINT, ''
PRINT, ''
PRINT, ' |=================================================================================|'
PRINT, ' |                                                                                 |'
PRINT, ' |  SSJ                                                                            |'
PRINT, ' |                                                                                 |'
PRINT, ' |=================================================================================|'
PRINT, ' |                                                                                 |'
PRINT, ' |  DIMENTSIONS  bins = 19 (energy bins 1:30keV ~ 19:30eV)                         |'
PRINT, ' |               sod = 86400 (seconds of day)  -> index 0 corresponds 00:00:00     |'
PRINT, ' |                                                                                 |'
PRINT, ' |=================================================================================|'
PRINT, ' |  TAG NAME[DIMENSION]  |                   DESCRIPTION[UNIT]                     |'
PRINT, ' |-----------------------+---------------------------------------------------------|'
PRINT, ' |  .JE[bins, sod]       |  electron differential number flux [1/eV cm^2 s ster]   |'
PRINT, ' |  .JEE[bins, sod]      |  electron differential energy flux [eV/eV cm^2 s ster]  |'
PRINT, ' |  .JTOTI[sod]          |  electron total number flux [1/cm^2 s ster]             |'
PRINT, ' |  .JETOTE[spd]         |  electron total energy flux [eV/cm^2 s ster]            |'
PRINT, ' |  .JI[bins, sod]       |  ion differential number flux [1/eV cm^2 s ster]        |'
PRINT, ' |  .JEI[bins, sod]      |  ion defferential energy flux [eV/eV cm^2 s ster]       |'
PRINT, ' |  .JTOTI[sod]          |  ion total number flux [1/cm^2 s ster]                  |'
PRINT, ' |  .JETOTI[sod]         |  ion total energy flux [eV/cm^2 s ster]                 |'
PRINT, ' |  .EE[sod]             |  electron average energy[eV] <- JETOTE / JTOTE          |'
PRINT, ' |  .EI[sod]             |  ion average energy [eV] <- JETOTI / JTOTI              |'
PRINT, ' |  .T[sod]              |  unix time [s]                                          |'
PRINT, ' |  .EBIN[bins]          |  central energy for each channel [eV]                   |'
PRINT, ' |  .SAT                 |  space craft flight number                              |'
PRINT, ' |  .SSJ                 |  ssj sensor number 4 or 5                               |'
PRINT, ' |=================================================================================|'
PRINT, ''
PRINT, ''
PRINT, ''
PRINT, ''
PRINT, ''
PRINT, ' |=================================================================================|'
PRINT, ' |                                                                                 |'
PRINT, ' |  SSM MFR(Magnetic Field Record)                                                 |'
PRINT, ' |                                                                                 |'
PRINT, ' |=================================================================================|'
PRINT, ' |                                                                                 |'
PRINT, ' |  DIMENSION  sod = 86400 (soconds of day) -> index 0 corresponds 00:00:00        |'
PRINT, ' |                                                                                 |'
PRINT, ' |=================================================================================|'
PRINT, ' |  TAG NAME[DIMENSION]   |                   DESCRIPTION[UNIT]                    |' 
PRINT, ' |------------------------+--------------------------------------------------------|'
PRINT, ' |  .GLAT[sod]            |  SSM geographic latitude                               |'
PRINT, ' |  .GLON[sod]            |  SSM geographic longitude                              |'
PRINT, ' |  .ALTI[sod]            |  SSM altitude [km]                                     |'
PRINT, ' |                        |   !NOTE                                                |'
PRINT, ' |                        |      magnetic field is in spacecraft coordinate        |'
PRINT, ' |  .BX[sod]              |  x-component of the magnetic field [nT]                |'
PRINT, ' |  .BY[sod]              |  y-component of the magnetic field [nT]                |'
PRINT, ' |  .BZ[sod]              |  z-component of the magnetic field [nT]                |'
PRINT, ' |  .DBX[sod]             |  x-component of the magnetic field minus IGRF model[nT]|'
PRINT, ' |  .DBY[sod]             |  y-component of the magnetic field minus IGRF model[nT]|'
PRINT, ' |  .DBZ[sod]             |  z-component of the magnetic field minus IGRF model[nT]|'
PRINT, ' |  .MLAT[sod]            |  AACGM magnetic latitude                               |'
PRINT, ' |  .MLON[sod]            |  AACGM magnetic longitude                              |'
PRINT, ' |  .MLT[sod]             |  AACGM magnetic local time                             |'
PRINT, ' |=================================================================================|'
;PRINT, ''
;PRINT, ''
;PRINT, ' |=================================================================================|'
;PRINT, ' |                                                                                 |'
;PRINT, ' |  SSIES EDR(Environmental Data Record)                                           |'
;PRINT, ' |                                                                                 |'
;PRINT, ' |=================================================================================|'
;PRINT, ' |                                                                                 |'
;PRINT, ' |  DIMENSION  sod = 86400 (soconds of day) -> index 0 corresponds 00:00:01        |'
;PRINT, ' |                                                                                 |'
;PRINT, ' |=================================================================================|'
;PRINT, ' |  TAG NAME[DIMENSION]   |                   DESCRIPTION[UNIT]                    |' 
;PRINT, ' |------------------------+--------------------------------------------------------|'
;PRINT, ' |  .P_DENS[sod]          |  primary plasma density[/cc] --> 1 second value        |'
;PRINT, ' |  .IDRIFT_HOR[sod]      |  horizontal ion drift velocity [m/s] -> 1 second value |'
;PRINT, ' |  .IDRIFT_VER[sod]      |  vertical ion drift velocity [m/s] -> 1 second value   |'
;PRINT, ' |  .E_DENS[sod]          |  electron density [/cc] -> 4 second value              |'
;PRINT, ' |  .E_TEMP[sod]          |  electron temperature [K] -> 4 second value            |'
;PRINT, ' |  .O_DENS[sod]          |  O+ density [/cc] -> 4 seconds value                   |'
;PRINT, ' |  .TLI_DENS[sod]        |  total light ion density [/cc] -> 4 seconds value      |'
;PRINT, ' |  .I_FLAG[sod]          |  light ion flag -> 4second value                       |'
;PRINT, ' |                        |                |- 0 : no light ion                     |'
;PRINT, ' |                        |                |- 1 : light ion is H+                  |'
;PRINT, ' |                        |                |- 2 : light ion is He+                 |'
;PRINT, ' |  .I_TEMP[sod]          |  ion temperature [K] -> 4 seconds value                |'
;PRINT, ' |  .TI_DENS[sod]         |  total ion density [/cc] -> 4 seconds value            |'
;PRINT, ' |=================================================================================|'
;PRINT, ''
PRINT, ''
PRINT, ''
PRINT, ''
END
