#!/bin/csh -f

./Tools/ccsm_check_lockedfiles || exit -1

# NOTE - Are assumming that are already in $CASEROOT here
set CASE     = `./xmlquery CASE    -value`
set EXEROOT  = `./xmlquery EXEROOT -value`

# Reset all previous env_mach_pes settings if a previous setting exists

if ( -e env_mach_pes.xml.1 )  then
   rm env_mach_pes.xml.1 
endif

 NOTE - there is only one build for this case 

 Check that have at least one component with nthrds > 1
et NTHRDS_ATM  = `./xmlquery NTHRDS_ATM  -value`
et NTHRDS_LND  = `./xmlquery NTHRDS_LND  -value`
et NTHRDS_ROF  = `./xmlquery NTHRDS_ROF  -value`
et NTHRDS_WAV  = `./xmlquery NTHRDS_WAV  -value`
et NTHRDS_OCN  = `./xmlquery NTHRDS_OCN  -value`
et NTHRDS_ICE  = `./xmlquery NTHRDS_ICE  -value`
et NTHRDS_GLC  = `./xmlquery NTHRDS_GLC  -value`
et NTHRDS_CPL  = `./xmlquery NTHRDS_CPL  -value`

f ( $NTHRDS_ATM <= 1) then
  echo "WARNING: component ATM is not threaded, changing NTHRDS_ATM to 2" 
  xmlchange -file env_mach_pes.xml -id NTHRDS_ATM -val 2
ndif
f ( $NTHRDS_LND <= 1) then
  echo "WARNING: component LND is not threaded, changing NTHRDS_LND to 2" 
  xmlchange -file env_mach_pes.xml -id NTHRDS_LND -val 2
ndif
f ( $NTHRDS_ROF <= 1) then
  echo "WARNING: component ROF is not threaded, changing NTHRDS_ROF to 2" 
  xmlchange -file env_mach_pes.xml -id NTHRDS_ROF -val 2
ndif
f ( $NTHRDS_ICE <= 1) then
  echo "WARNING: component ICE is not threaded, changing NTHRDS_ICE to 2" 
  xmlchange -file env_mach_pes.xml -id NTHRDS_ICE -val 2
ndif
f ( $NTHRDS_OCN <= 1) then
  echo "WARNING: component OCN is not threaded, changing NTHRDS_OCN to 2" 
  xmlchange -file env_mach_pes.xml -id NTHRDS_OCN -val 2
ndif
f ( $NTHRDS_GLC <= 1) then
  echo "WARNING: component GLC is not threaded, changing NTHRDS_GOC to 2" 
  xmlchange -file env_mach_pes.xml -id NTHRDS_GLC -val 2
ndif
f ( $NTHRDS_CPL <= 1) then
  echo "WARNING: component CPL is not threaded, changing NTHRDS_CPL to 2" 
  xmlchange -file env_mach_pes.xml -id NTHRDS_CPL -val 2
ndif
f ( $NTHRDS_WAV <= 1) then
  echo "WARNING: component WAV is not threaded, changing NTHRDS_WAV to 2" 
  xmlchange -file env_mach_pes.xml -id NTHRDS_WAV -val 2
ndif

cp -f env_mach_pes.xml env_mach_pes.xml.1

# Since possibly changed the PE layout as above - must run cesm_setup -clean WITHOUT the -testmode flag
# in order for the $CASE.test script to be regenerated with the correct batch processor settings
./cesm_setup -clean 
./cesm_setup 

./$CASE.build
if ($status != 0) then
   echo "Error: build failed" >! ./TestStatus
   echo "CFAIL $CASE" > ./TestStatus
   exit -1    
endif 
