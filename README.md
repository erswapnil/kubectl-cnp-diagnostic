# 📊 EDB/CNP Diagnostic plugin for `kubectl`

A specialized `kubectl` plugin designed to collect deep diagnostic information from EDB Postgres for Kubernetes (CNP) and CloudNativePG (CNPG) clusters.

## 🐧 Mac OS and Linux Installation

Install the plugin globally using the following command:

```
curl -sSfL [https://github.com/erswapnil/cnp-diagnostic/raw/main/install.sh](https://github.com/erswapnil/cnp-diagnostic/raw/main/install.sh) | sudo sh
```

> **Note**: This script downloads the `kubectl-edbdiag` binary and installs it to `/usr/local/bin`.

## 🪟 Windows Installation

1. Download the `kubectl-edbdiag` file from this repository.
2. Create a folder for your plugins (e.g., `C:\kubectl-plugins`).
3. Move the file into that folder and rename it to `kubectl-edbdiag.exe`.
4. Add the folder path to your system's **PATH** environment variable.

---

## 🛠 Usage

Once installed, trigger the diagnostic collection by running:

```
kubectl edbdiag
```

### What is collected?
The tool generates a comprehensive `.tar.gz` package including:
* **Cluster Level**: Status, full YAML manifests, and namespace events.
* **Operator Level**: Version tags, deployment manifests, and controller logs.
* **Pod Level**: Container logs and `describe` outputs.
* **Database Stats**: Collected for **every** database in the cluster:
    * **Performance**: Detailed lock analysis (`pg_locks`) and session activity (`pg_stat_activity`).
    * **Blocking Analysis**: Advanced detection of blocked PIDs and blocking statements.
    * **Storage**: Table and Index bloat reports with live/dead tuple counts.
    * **Maintenance**: Extension lists, database versions, and `SHOW ALL` parameters.
---

## 📋 Usage Example

### Execution Flow:
```
$ kubectl edbdiag
Enter the Namespace of the Cluster: default
Enter the Cluster Name: postgresql-advanced-cluster
Select Operator Variant:
1) CNP (Cloud Native Postgres - EDB)
2) CNPG (CloudNativePG - Community)
Enter choice [1 or 2]: 1

--- Processing Pod: postgresql-advanced-cluster-1 ---
   -> Collecting from Database: postgres
   -> Collecting from Database: edb
   -> Collecting from Database: app
...
Collection complete: edb_diag_postgresql-advanced-cluster_20260331_132227.tar.gz
```
---

## 📋 Generated Result Structure

The tool organizes results by pod and database for easy troubleshooting:

```
.
├── cluster_info/
│   ├── cluster_status.txt      # High-level health and node roles
│   └── namespace_events.txt    # K8s events (Pod restarts, OOMKills, etc.)
├── operator_info/
│   ├── logs/operator.log       # EDB/CNPG Operator controller logs
│   └── operator_version.txt    # Current operator image version
├── pods/
│   └── <pod-name>/
│       └── postgresql/
│           ├── activity_counts.out   # Summary: Active vs Idle vs Total sessions
│           ├── show_all.out          # Full list of GUCs/Parameters (SHOW ALL)
│           ├── replication.out       # Streaming and Slot status
│           ├── db_<database_name>/
│           │   ├── blocking_analysis_detailed.out  # Deep dive into "Who is blocking whom"
│           │   ├── blocking_summary.out            # Quick list of PIDs being blocked
│           │   ├── pg_locks.out                    # Raw internal lock state [cite: 22]
│           │   ├── pg_stat_activity.out            # Full process list for this specific DB [cite: 22]
│           │   ├── database_bloat.out              # Table-level dead tuples and size
│           │   ├── index_bloat.out                 # Index size and scan frequency
│           │   └── table_tuples.out                # Live vs Dead tuple counts
│           └── postgres.log          # Raw database engine log file
└── storage/
    └── pvc_list.txt            # PVC/PV status and disk allocations
```
