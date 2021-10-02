# Kubernetes multi-cluster connectivity using Submariner

## Background

The current trend within Kubernetes-based platforms shows that companies are no longer focusing on building large multi-tenant cluster. Instead, it is becoming common to build individual clusters specific to a region/cloud. In this scenario, inter-cluster connectivity plays a crucial role. 

This architecture can be valuable in a vast number of use-cases. Some of the most prominent benefits include:

- **Increased scalability & availability, global distribution.** In a multi-cluster setup, an application can be distributed across different regions providing users with exceptional availability and a much better experience interacting with an app due to reduced latency.
- **Regulatory compliance.** Applications that involve dealing with user data must adhere to regulations like GDPR, CCPA, etc. Some of these regulations require user data to be stored within certain geographical limits and the multi-cluster setup can help achieve this.
- **Reduced vendor dependency.** Your application is no longer dependent on a single cloud provider and can easily move to an alternative vendor without substantial costs.
- **Vendor-specific features.** At the same time, your app can take advantage of a feature specific to a cloud provider without being fully locked-in.

The purpose of this project is to test the capabilities of Submariner and the multi-cluster multi-cloud architecture.

## Objectives
- [x] Deploy a Broker Kubernetes cluster in Azure (US Central region)
- [x] Deploy a Kubernetes cluster (Cluster-WestEurope) in Azure (West Europe region)
- [ ] Deploy a Kubernetes cluster (Cluster-USEast) in GCP (US East region)
- [ ] Deploy a Kubernetes cluster (Cluster-USWest) in AWS (US West region)
- [ ] Establish a secure multi-cluster (and multi-cloud) L3 network connection between the clusters using Submariner (manual)
- [ ] Automate Submariner setup
- [ ] Test the inter-cluster connectivity using CockroachDB features Geo-Distribution and Geo-Replication

## Architecture Overview
<img src="./docs/Architecture_Overview.png" alt="Architecture Overview" width="1000"/>

## Specs

### Network configuration
Submariner has a few prerequisites for clusters' network configuration, they can be found here: https://submariner.io/getting-started/

The example setup in this repository uses the following configuration:

| **Cluster**        | **Provider** | **Cluster Nodes CIDR** | **Pod CIDR** | **Service CIDR** | **DNS Service IP** |
|--------------------|--------------|------------------------|--------------|------------------|--------------------|
| Broker-USCentral   | Azure        | 192.168.1.0/24         | 10.42.0.0/16 | 10.43.0.0/16     | 10.43.0.10         |
| Cluster-WestEurope | Azure        | 192.168.1.0/24         | 10.0.0.0/16  | 10.1.0.0/16      | 10.1.0.10          |
| Cluster-USEast     | GCP          | 192.168.1.0/24         | 10.98.0.0/16 | 10.99.0.0/16     |                    |
| Cluster-USWest     | AWS          | 192.168.1.0/24         | 10.4.0.0/16  | 10.5.0.0/16      |                    |


## References
- The project is inspired by the article [Kubernetes Multi-Cloud and Multi-Cluster Connectivity with Submariner](https://www.linkedin.com/pulse/kubernetes-multi-cloud-multi-cluster-connectivity-gokul-chandra) by Gokul C.
- [Kubernetes Multi-Clusters: How & Why To Use Them](https://www.bmc.com/blogs/kubernetes-multi-clusters/) by Shanika W.




