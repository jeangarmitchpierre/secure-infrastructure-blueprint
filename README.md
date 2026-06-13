# Secure Infrastructure & Network Operations Blueprint
**Project Focus:** Critical Infrastructure Segmentation, Endpoint Hardening, and Technical Operational Frameworks
**Author:** Jean Garmitch Pierre
**Certifications Aligned:** IBM Cybersecurity Architecture | Google Data Analytics

---

## Executive Summary
Modern critical infrastructure environments require absolute logical isolation to eliminate vector paths for lateral threat movement. If an auxiliary network peripheral (such as an endpoint operational printer) or a public-facing communication segment is breached, traditional flat network topologies fail to restrict the blast radius. 

This repository documents the logical architecture, physical and logical access controls, explicit hardware hardening standards, and analytical audit structures required to safeguard high-availability, high-stakes enterprise operational networks.

---

## Phase 1: Core Network Architecture & Hardware Topology

To implement an uncompromising zero-trust boundary across the operational environment, the local network is isolated into distinct **Virtual Local Area Networks (VLANs)**. All inter-VLAN communications are restricted via an explicit stateful Layer 3 Firewall Router, ensuring that untrusted public nodes can never interact with internal execution paths or terminal devices.


### Logically Segmented Network Map

```text
                     [ WAN / Core Internet Gateway ]
                                    │
                           ┌────────┴────────┐
                           │ Layer 3 Firewall│ <── Statefully Drops Inter-VLAN Traffic
                           └────────┬────────┘
                                    │ (802.1Q Dot1Q VLAN Trunk Link)
                           ┌────────┴────────┐
                           │ Managed Switch  │ <── Layer 2 Port Security Active
                           └─┬─────────────┬─┘
                             │             │
              ┌──────────────┴──┐       ┌──┴──────────────┐
              │     VLAN 10     │       │     VLAN 20     │
              │ Secure Ops Zone │       │ Peripheral Zone │
              └───────┬─────────┘       └───────┬─────────┘
                      │                         │
           [Kiosk / Admin Terminal]     [Network Printer Subsystem]
           [Static IP: 10.0.10.5]       [MAC-Reserved IP: 10.0.20.100]
```
       ### Logical Network Configuration Matrix

| VLAN ID | Subnet Range | Security Access Level | Connected Operational Assets |
| :--- | :--- | :--- | :--- |
| **VLAN 10** | `10.0.10.0/24` | Secure Corporate Internal | Administrative desktop terminals, primary operational databases, core check-in workstations. |
| **VLAN 20** | `10.0.20.0/24` | Secure Peripheral Zone | Critical hardware assets: high-volume boarding pass printers, baggage tag printers, digital scale matrices. |
| **VLAN 90** | `192.168.90.0/24`| Unsecure Public Isolated | Free public Wi-Fi access network. Completely barred from routing to secure internal infrastructure. |

---

## Phase 2: Hardware Hardening & Endpoint Protection

### 1. Managed Layer 2/3 Switch Security Configuration
* **Sticky Port Security:** Physical edge interfaces mapped to permanent administrative terminals are locked to authorized MAC addresses via the switch operating software. If a physical link state drops and a rogue MAC address is detected on that interface, the port immediately triggers a `shutdown` state, logging a violation flag to the centralized security server.
* **Unused Interface Mitigation:** All unassigned physical ports on the patch panels and switch matrix are explicitly set to an administrative `shutdown` state. Interfaces are never left active or open for opportunistic physical exploitation.

### 2. Peripheral Hardening Blueprint (Network Printers & Scales)
Networked printers are historically weak entry vectors frequently utilized by threats for lateral pivoting. The peripheral infrastructure is hardened through the following mandatory deployment criteria:
* **IP Allocation & Address Binding:** Managed explicitly via strict **DHCP Reservations** on the core controller, tied permanently to the device's unique physical MAC address. This ensures continuous asset visibility and tracking without exposing localized configurations.
* **Management Interface Decoupling:** Legacy cleartext communication methods—specifically **Telnet (Port 23)** and unencrypted **HTTP (Port 80)**—are globally deactivated. Network management operations are restricted strictly to secure command channels.
* **Transit Data Cryptography:** All production data flows and print streams are wrapped securely in **Internet Printing Protocol over SSL/TLS (IPP Secure, Port 631)**, preventing passive data sniffing or inline modification on the local wire.

---

## Phase 3: Tactical Threat Modeling & Incident Playbook
To demonstrate actionable incident resolution capabilities aligned with professional cybersecurity standards, the following structured containment protocols have been established for immediate execution during a localized physical breach attempt.

### Incident Profile: Physical Link Manipulation & Lateral Scans
* **Threat Vector:** An unauthorized entity physically decouples an internal network printer from its patch point and connects a malicious machine to perform a rogue subnet sweep and internal target scanning.

### Incident Response Lifecycle
1. **Identification:** The Layer 2 Managed Switch registers a sudden mismatch between the configured MAC address signature on the specific physical port interface and the unauthorized incoming machine packet structure.
2. **Containment:** The switch triggers localized port security policies, shifting the interface status instantly to an `error-disabled` state. The link state drops completely, severing the attacker’s physical bridge to the infrastructure before lateral network mapping can occur.
3. **Eradication & System Override:** System administrators execute administrative privilege overrides using native environment isolation sets (`takeown` and `icacls` parameters found in the accompanying repository scripts) to protect directory integrity, lock localized shares, change access controls, and flush volatile system route tables.
4. **Recovery:** Security teams execute a full hardware integrity sweep of the physical area, reset interface session state criteria via the core management terminal using manual `shutdown` and `no shutdown` sequences, and carefully re-authenticate the authorized peripheral.

---

## Phase 4: Operations Auditing & Data Log Analytics
Network protection is incomplete without evaluating the behavioral data generated by infrastructure devices. Applying structured data analytics allows raw router firewall logs to be converted into prioritized actionable data insights.

### Firewall Traffic Pattern Analysis Matrix
Detailed connection behavior can be cross-referenced via the raw `firewall_logs.csv` dataset in this repository.

| Timestamp (UTC) | Source Node IP | Target Node IP | Destination Port | Action Code | Log Data Analytics Interpretation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 11:42:01 | `10.0.10.14` | `10.0.10.1` | 22 (SSH) | **ALLOW** | Standard administrative access validation loop from authorized console terminal. |
| 11:43:15 | `192.168.90.55` | `10.0.10.5` | 445 (SMB) | **DROP** | **Anomaly Detected:** Isolated guest public node attempting direct traversal to internal secure zone database. System firewall rules successfully dropping packet. |
| 11:45:22 | `10.0.20.100` | `8.8.8.8` | 53 (DNS) | **DROP** | **High Alert Anomaly:** Hardened peripheral network printer attempting external outbound requests to public recursive DNS. Indicative of beaconing malware. Flagged for immediate physical isolation. |

### Operational Metrics & Key Performance Indicators (KPIs)
* **Malicious Edge Traversal Attempts:** Aggregated drops of external or public nodes trying to probe internal IP address spaces (Target Metric: 0 network leaks allowed).
* **Peripheral Log Deviation:** Statistical monitoring of network data volumes transmitted by printers or scales to identify unauthorized payload caching or data exfiltration attempts.
