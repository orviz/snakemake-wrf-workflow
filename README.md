### HPC Cluster Profiles & Environments (`hpc-profiles`)

This directory contains cluster scheduler profiles (namely Slurm), and environment setup scripts for the various High-Performance Computing (HPC) systems where the current Snakemake WRF/WPS simulation workflow is deployed.

This branch operates independently as an *orphan branch* within the repository to ensure the main scientific workflow branch (`main`) remains 100% portable, clean, and free of machine-specific absolute paths or system module dependencies.

* * *

### Directory Structure

Every cluster or HPC profile must have its own dedicated folder at the root of this branch, strictly adhering to the following standardized structure:

```text

    ├── README.md               # This global documentation file
    ├── altamira/               # Specific configurations for the Altamira HPC
    │   ├── README.md           # Local technical verification guide (e.g., ldd tests)
    │   ├── config.yaml         # Native Snakemake profile (Slurm settings, resources, partitions)
    │   └── set_env.sh          # [Optional] System module loading script (Intel, NetCDF, etc.)
```

* * *

### Cluster Profile Components

To maintain compatibility with the universal Pixi task (`pixi run hpc-profile <name>`), every cluster profile must follow these rules:

### 1. `config.yaml` (Required)

The official Snakemake profile for the cluster. It defines the executor (Slurm), the default resources for WRF/WPS rules (memory, execution time, partitions, billing accounts), and the maximum number of concurrent jobs allowed.

* *Target path:* `config/profiles/<profile>/config.yaml` (**once the worktree is mounted**).

### 2. `set_env.sh` (Optional)

A Bash script responsible for preparing the system environment variables before launching Snakemake. This is the place for `module load` commands, NetCDF/compiler path exports, or machine-specific MPI tweaks.

* **Design Note:** If a cluster manages all software dependencies natively via Pixi/Conda environments, this file **can be safely omitted**, and the workflow will skip environment sourcing automatically.

### 3. Local `README.md` (Recommended)

Each cluster folder should include a dedicated documentation file.

* * *

### Cluster Workflow Integration (Git Worktree)

To deploy these profiles into a production environment, navigate to the root of your `main` branch and execute:

```bash
git worktree add config/profiles hpc-profiles
``` 

### How to Update or Add Configurations from the HPC

If you modify a Slurm profile or an environment script directly on the cluster, you can commit and push those updates to this branch without affecting your scientific code history:

```bash
# 1. Navigate to the cluster profile directory
cd config/profiles/altamira

# 2. Modify the necessary files (e.g., config.yaml)
nano config.yaml

# 3. Commit and push directly to the infrastructure branch
git add config.yaml
git commit -m "perf(altamira): adjust Slurm runtime limits for WPS rules"
git push origin hpc-profiles    
```

Any changes pushed here will be immediately available to other cluster users by running a simple `git pull origin hpc-profiles` from within that profile folder.
