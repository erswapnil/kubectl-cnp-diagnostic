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
4. Add `C:\kubectl-plugins` to your system's **PATH** environment variable.

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
* **Database Stats**: The following is collected for **every** database in the cluster:
    * `SHOW ALL` configuration parameters.
    * Table and Index bloat reports.
    * Extension lists and Database version.
    * Live/Dead tuple statistics and user table stats.
    * Active/Idle session counts.

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

### Generated Result Structure:
```
.
├── cluster_info
│   ├── cluster_status.txt
│   └── namespace_events.txt
├── operator_info
│   ├── logs/operator.log
│   ├── operator_manifest.yaml
│   └── operator_version.txt
├── pods
│   └── postgresql-advanced-cluster-1
│       ├── describe_result.txt
│       └── postgresql
│           ├── db_app/ (Bloat, Extensions, Table Stats)
│           ├── db_edb/ (Bloat, Extensions, Table Stats)
│           ├── postgres.log
│           ├── replication.out
│           ├── running_activity.out
│           └── show_all.out
└── storage/ (PV and PVC listings)
```
