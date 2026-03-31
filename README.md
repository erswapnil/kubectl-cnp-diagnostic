# EDB/CNP Diagnostic plugin for `kubectl`

Plugin for `kubectl` to troubleshoot Kubernetes clusters and databases deployed with EDB Postgres for Kubernetes (CNP) or CloudNativePG (CNPG).

## Mac OS and Linux install

You can install the plugin in your system with:

```
curl -sSfL \
  https://github.com/erswapnil/cnp-diagnostic/raw/main/install.sh | \
  sudo sh -s -- -b /usr/local/bin
```

## Windows install

To install the plugin on Windows, download the `kubectl-cnp-diagnostic` file from this repository.

1. Create a folder for your plugins (e.g., `C:\kubectl-plugins`).
2. Move the `kubectl-cnp-diagnostic` file into that folder.
3. Add the folder path to your system's **PATH** environment variable.
4. Rename the file to `kubectl-cnp-diagnostic.exe` if using a terminal that requires extensions.

## Usage

Once installed, you can trigger the diagnostic collection using the following command:

```
kubectl cnp-diagnostic
```

The tool will prompt you for the **Namespace**, **Cluster Name**, and **Operator Variant** (CNP or CNPG). It will then generate a comprehensive `.tar.gz` package containing:

* **Cluster Info**: Status, YAML definitions, and namespace events.
* **Operator Info**: Version, manifests, and controller logs.
* **Pod Diagnostics**: Logs, descriptions, and PostgreSQL configurations.
* **Database Stats**: Bloat reports, extensions, activity counts, and table statistics for **all** databases in the cluster.

