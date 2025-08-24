# 🌐 GCP VPC with 1 Public + 2 Private Subnets

This Terraform project provisions a **custom VPC architecture** in Google Cloud:  
- **VPC** named `srikanth-vpc`  
- **1 Public Subnet** + **2 Private Subnets**  
- **Cloud Router & Cloud NAT** for private outbound internet  
- **Firewall Rules** for internal traffic + public ingress (SSH/HTTP/HTTPS/ICMP)  

---

## ✅ Prerequisites (GCP Console Setup)

1. **Google Cloud Account**  
   - Sign in / sign up at https://console.cloud.google.com

2. **Create a Project**  
   - Project Selector → **New Project**  
   - Note the **Project ID** (e.g., `srikanth-gcp-470012`) and set it in `variables.tf` as `project_id`.

3. **Enable Required APIs**  
   - **APIs & Services → Library** → enable:  
     - `Compute Engine API` (`compute.googleapis.com`)

4. **IAM Permissions**  
   - Your user/service account should have:  
     - `Compute Admin`  
     - `Network Admin`

---

## 🧩 Component Prerequisites (2–3 key points each)

### 1) VPC
- Use a unique name (`srikanth-vpc`).  
- `auto_create_subnetworks = false` to avoid default subnets.  
- Compute Engine API must be enabled in the project.

### 2) Subnets
- Define **CIDRs** and **region** (defaults in `variables.tf`).  
- Public subnet can have external IPs.  
- Private subnets use `private_ip_google_access = true` for Google APIs without public IPs.

### 3) Routes & NAT
- Default route uses the **default internet gateway**.  
- **Cloud Router** is required for **Cloud NAT**.  
- NAT applies to **private** subnets only for outbound internet.

### 4) Firewall
- Allow internal traffic across the three subnets.  
- Public ingress: SSH(22), HTTP(80), HTTPS(443), ICMP to **public-tagged** VMs.  
- Private VMs can egress to public subnet services. Use network tags: `public-subnet`, `private-subnet`.

---

## 🗺️ Architecture Diagram

### Mermaid (preferred)
> Renders automatically on GitHub, GitLab, and many Markdown viewers.

```mermaid
flowchart LR
  Internet((🌍 Internet))

  subgraph VPC["VPC: srikanth-vpc"]
    direction TB

    subgraph Public["Public Subnet (10.10.1.0/24)"]
      PubVM["VM(s) w/ tag: public-subnet\nExternal IP: Yes\nIngress: 22,80,443,ICMP"]
    end

    subgraph PrivateA["Private Subnet A (10.10.2.0/24)"]
      PvaVM["VM(s) w/ tag: private-subnet\nExternal IP: No"]
    end

    subgraph PrivateB["Private Subnet B (10.10.3.0/24)"]
      PvbVM["VM(s) w/ tag: private-subnet\nExternal IP: No"]
    end

    Router["Cloud Router"]
    NAT["Cloud NAT\n(Private outbound only)"]
  end

  Internet ---|"Default route 0.0.0.0/0\n(tags: public-subnet)"| Public
  PrivateA --> NAT
  PrivateB --> NAT
  NAT --- Router
