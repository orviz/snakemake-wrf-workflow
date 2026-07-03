#!/bin/bash 

### ==============================================================================
### Altamira HPC Environment Setup Script
### ==============================================================================

# 1. Source the core WPS/WRF cluster environment modules from the original path
source /gpfs/users/fernandezv/repos/snakemake-wrf-workflow/config/source_files/wps_josipa.sh

# 2. Automated Dependency Verification
echo "[INFO] Verifying NetCDF library bindings for WRF/WPS..."
if command -v real.exe >/dev/null 2>&1; then  
    echo "[INFO] Found real.exe. Checking shared libraries:"  
    ldd "$(which real.exe)" | grep -E "netcdf|not found"  
else  
    echo "[WARNING] real.exe not found in the current PATH. Compilation might be required."  
fi

echo "[INFO] Environment successfully prepared for Snakemake."  
echo "------------------------------------------------------------------------"