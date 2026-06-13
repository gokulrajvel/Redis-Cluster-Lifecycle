# Redis Cluster Deployment Assignment

This project provides a multi-node Redis Cluster orchestrated using Docker Compose and automated using Ansible.

## 1. Project Structure

The project layout is structured as follows:
*   [infra/](file:///home/pain/Documents/zohoassignment/submission/infra/): Infrastructure definitions
    *   [compose.yml](file:///home/pain/Documents/zohoassignment/submission/infra/compose.yml): Launches 6 containers on a custom network.
    *   [Dockerfile](file:///home/pain/Documents/zohoassignment/submission/infra/Dockerfile): Defines the SSH-enabled Ubuntu base image for the Redis nodes.
    *   [id_rsa](file:///home/pain/Documents/zohoassignment/submission/infra/id_rsa) / [id_rsa.pub](file:///home/pain/Documents/zohoassignment/submission/infra/id_rsa.pub): SSH keys for passwordless automation access.
*   [ansible/](file:///home/pain/Documents/zohoassignment/submission/ansible/): Ansible configuration & plays for automated provisioning.
*   [output/](file:///home/pain/Documents/zohoassignment/submission/output/): Captured terminal executions and verification outputs.
*   [redis_cluster_architecture.png](file:///home/pain/Documents/zohoassignment/submission/redis_cluster_architecture.png): Visual topology diagram.

---

## 2. Container Network & Node Configuration

All nodes are connected to a dedicated bridge network `redis-net` on subnet `10.10.0.0/24`.

| Service Name | Hostname | IP Address | Host SSH Port | Host Redis Port | Cluster Role |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `redis-node-1` | `redis-node-1` | `10.10.0.11` | `2201` | `6371` | **Master 1** |
| `redis-node-2` | `redis-node-2` | `10.10.0.12` | `2202` | `6372` | **Master 2** |
| `redis-node-3` | `redis-node-3` | `10.10.0.13` | `2203` | `6373` | **Master 3** |
| `redis-node-4` | `redis-node-4` | `10.10.0.14` | `2204` | `6374` | **Replica 1** (backup of Node-1) |
| `redis-node-5` | `redis-node-5` | `10.10.0.15` | `2205` | `6375` | **Replica 2** (backup of Node-2) |
| `redis-node-6` | `redis-node-6` | `10.10.0.16` | `2206` | `6376` | **Replica 3** (backup of Node-3) |

---

## 3. Logical Topology (Mermaid)

```mermaid
graph TD
    classDef master fill:#2b6cb0,stroke:#2b6cb0,color:#fff,stroke-width:2px;
    classDef replica fill:#4a5568,stroke:#4a5568,color:#fff,stroke-width:2px;
    classDef network fill:#1a202c,stroke:#a0aec0,color:#fff,stroke-width:1px,stroke-dasharray: 5 5;

    subgraph Cluster_M ["Master Nodes"]
        M1["redis-node-1<br>IP: 10.10.0.11"]:::master
        M2["redis-node-2<br>IP: 10.10.0.12"]:::master
        M3["redis-node-3<br>IP: 10.10.0.13"]:::master
    end

    subgraph Cluster_R ["Replica Nodes"]
        R1["redis-node-4<br>IP: 10.10.0.14"]:::replica
        R2["redis-node-5<br>IP: 10.10.0.15"]:::replica
        R3["redis-node-6<br>IP: 10.10.0.16"]:::replica
    end

    %% Sync
    M1 <-->|Cluster Bus - 16379| M2
    M2 <-->|Cluster Bus - 16379| M3
    M3 <-->|Cluster Bus - 16379| M1

    %% Replication
    M1 -.->|Replicates to| R1
    M2 -.->|Replicates to| R2
    M3 -.->|Replicates to| R3

    %% Net
    Net[("redis-net Subnet: 10.10.0.0/24")]:::network
    M1 --- Net
    M2 --- Net
    M3 --- Net
    R1 --- Net
    R2 --- Net
    R3 --- Net
```

---

## 4. Visual Topology Diagram

![Redis Cluster Architecture](./redis_cluster_architecture.png)
