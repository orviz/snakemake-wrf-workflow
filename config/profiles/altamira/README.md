### Altamira HPC Profile Configuration

This directory contains the Slurm cluster profile and environment deployment scripts tailored specifically for the Altamira HPC infrastructure. 

### Environment Validation & NetCDF Binding

Before launching any heavy simulation rules, it is critical to verify that the Intel compilers and NetCDF libraries are correctly loaded and mapped to the WRF executables. 

The automation task `pixi run run-hpc` will first source the local environment script (`wps_josipa.sh`). However, you should manually verify the shared library bindings at least once using `ldd`: 

```bash 
# 1. Load the environment manually for testing
source wps\_josipa.sh 

# 2. Check that real.exe resolves to the Spack NetCDF paths
ldd $(which real.exe) | grep netcdf  
``` 

### Expected Output Example

The output must explicitly resolve the NetCDF Fortran and C libraries against the cluster's Spack installation paths, similar to this: 

`text libnetcdff.so.7 => /gpfs/projects/meteo/opt/spack/opt/spack/linux-almalinux9-zen2/intel-2021.10.0/netcdf-fortran-4.6.1-qkxq3x6syfzslfo24e5wzcgllfrpisum/lib/libnetcdff.so.7 libnetcdf.so.19 => /gpfs/projects/meteo/opt/spack/opt/spack/linux-almalinux9-zen2/intel-2021.10.0/netcdf-c-4.9.2-r7sfzbgpbqtqpxlk5l5swrdxoej7mh4c/lib/libnetcdf.so.19`  

**Warning**: If any of these lines show `not found` or point to a generic system directory (like `/usr/lib64`), do not run the workflow. Review the module paths inside `wps_josipa.sh` first.* 

### Cluster Resources

The queue system parameters, maximum execution times, and memory limits are fully customizable and managed directly inside the `config.yaml` file in this directory.