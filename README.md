# 📊 EDB/CNP Diagnostic plugin for `kubectl`

A specialized `kubectl` plugin designed to collect deep diagnostic information from EDB Postgres for Kubernetes (CNP) and CloudNativePG (CNPG) clusters.

## 🐧 Mac OS and Linux Installation

Install the plugin globally using the following command:

```
curl -sSfL https://github.com/erswapnil/cnp-diagnostic/raw/main/install.sh | sudo sh
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
.
├── cluster_info/
│   ├── cluster_status.txt      # High-level health, node roles, and LSN
│   ├── cluster_definition.yaml  # Full YAML manifest of the Cluster resource
│   ├── available_backups.txt   # List of Barman/Cloud backups and their phases
│   └── namespace_events.txt    # Kubernetes events (OOMKills, restarts, etc.)
├── operator_info/
│   ├── operator_version.txt    # EDB/CNPG Operator image version
│   ├── operator_manifest.yaml  # Deployment manifest for the controller
│   ├── barman_plugin_version.txt # Version of the Barman Cloud plugin (if present)
│   └── logs/operator.log       # Live controller logs for the operator
├── pods/
│   └── <pod-name>/             # Data for each instance (Primary/Standbys)
│       ├── describe_result.txt # 'kubectl describe' output for the pod
│       └── postgresql/
│           ├── activity_counts.out # Breakdown: Active, Idle, and Total sessions
│           ├── db_version.out      # Full PostgreSQL version string
│           ├── show_all.out        # Full GUC/Parameter list (SHOW ALL)
│           ├── replication.out     # Streaming replication lag and state
│           ├── replication_slots.out # Status of physical/logical replication slots
│           ├── bgwriter.out        # Background writer and checkpointer stats
│           ├── archiver.out        # WAL archiving success/failure metrics
│           ├── db_<database_name>/ # Deep-dive for EVERY database in the cluster
│           │   ├── blocking_analysis_detailed.out # Detailed "Who is blocking whom" report
│           │   ├── blocking_summary.out # Quick list of blocked vs blocking PIDs
│           │   ├── pg_locks.out         # Raw lock state for the specific DB
│           │   ├── pg_stat_activity.out # Full process list for this specific DB
│           │   ├── database_bloat.out   # Table-level dead tuples and bloat size
│           │   ├── index_bloat.out      # Index size and scan frequency
│           │   ├── extensions.out       # List of installed PG extensions
│           │   └── table_tuples.out     # Live vs Dead tuple counts
│           └── postgres.log        # Raw engine logs from the 'postgres' container
└── storage/
    ├── pvc_list.txt            # PVC status, capacity, and storage class
    └── all_pv_list.txt         # Global PV list with reclaim policies
```
