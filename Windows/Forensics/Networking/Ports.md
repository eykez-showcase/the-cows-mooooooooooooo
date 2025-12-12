# **Ports**

## Table of Contents
 * [Overview](/Windows/Forensics/Networking/Ports.md#Overview)
 * [Protocols](/Windows/Forensics/Networking/Ports.md#Protocols)
 * [Common Ports](/Windows/Forensics/Networking/Ports.md#Common-Ports)
 * [Finding Open Ports](/Windows/Forensics/Networking/Ports.md#Finding-Open-Ports)
 * [TCPView](/Windows/Forensics/Networking/Ports.md#TCPView)
 * [Closing Ports](/Windows/Forensics/Networking/Ports.md#Closing-Ports)
 * [Additional Resources](/Windows/Forensics/Networking/Ports.md#Additional-Resources)

## **Overview**
Windows ports are communication endpoints that allow system services or applications on a host to communicate across a network, essentially the doors to the computer. Ports can range from **0-65535** and are usually tied to a program or service. In almost all situations the best practice is to close all unnecessary ports.


Key tools include:
- **GUI:** Windows Defender Firewall → Advanced Settings, **TCPView (Sysinternals)**  
- **CMD:** `netstat -ano`, `netsh advfirewall`  
- **PowerShell:** `Get-NetTCPConnection`, `Get-NetUDPEndpoint`
---

## **Protocols**
In most contexts, ports will use either TCP or UDP to communicate, below is a quick chart comparing the two.

| Aspect | TCP | UDP |
|--------|-----|-----|
| Type | Connection Based | Data Based |
| Reliability | Confirmation | No Confirmation |
| Integrity | Extensive | Basic |
| Order | Included | Not guaranteed | 
| Speed | Relatively slower | Faster, simpler, and more efficient |
| Retransmission | Possible | Not Possible |
| Protocols | HTTP, HTTPs, FTP, SMTP, Telnet | DNS, DHCP, TFTP, SNMP, RIP, VoIP |
| application | Reliable, safe long term communication | Short term communication where dependability doesn't matter |

## **Common Ports**

| Port | Protocol | Purpose |
| ----- | -------- | ------- |
| 20/21 | TCP | FTP |
| 22 | TCP | SSH |
| 23 | TCP | Telnet |
| 53 | TCP/UDP | DNS |
| 80 | TCP | HTTP |
| 443 | TCP | HTTPS |
| 445 | TCP | SMB file sharing |
| 3389 | TCP | RDP |

## **Finding Open Ports**

Open ports indicate that a Service or program is communicating over a network. Unauthorized open ports mean that without your knowledge a program might be sending critical information to bad actors.

### **Netstat (Command Prompt)**
| Command | What it Does |
| ------- | ------------ |
| ` netstat -ano ` | Shows all listening ports |
| ` tasklist \| findstr <PID> ` | Find a Process name |
| ` netstat -ano \| findstr :<Port Number> ` | Find a specific port |

### **Powershell**
| Command | What it Does |
| ------- | ------------ |
| ` Get-NetTCPConnection ` | List all TCP Connections |
| ` Get-NetTCPConnection -State Listen ` | List only listening |

### **Resource Moniter**

1. Open Task Manager → Performance
2. Open Resource Moniter
3. Check Network → Listening Ports

### **Windows Firewall**
While not showing actual open ports, Windows Firewall shows what's allowed through

1. Open Windows Defender Firewall
2. Click Advanced settings
3. Check inbound and outbound rules

## **TCPView**
This is the main tool you will want to use for searching through ports. It shows open ports, applications etc through an easy graphical interface.

### **Installing TCPView**

1. Search "Sysinternals TCPView" (Official Micorosoft Site)
2. Download the ZIP.
3. Extract the file
4. Run **TCPView.exe**
5. Run as Admin for full visibility (Recommended)

### **Interface Overview**

#### **Columns**

* **Process** - Program associated
* **PID** - Process ID
* **Protocol** - TCP or UDP
* **Local Address:Port** - What's listening
* **Remote Address:Port** - Where It's connected to
* **State** - State of the connection

---

#### **Color Coding**

| Color      | Meaning                   |
| ---------- | ------------------------- |
| **Green**  | New connection opened     |
| **Yellow** | Connection changing state |
| **Red**    | Connection closing        |

#### **Sorting & Investigating**

##### Sorting

1. Click **Local Port**
2. Inspect every listening port
3. Ask: “Do I need this?”
4. If not → Investigate → Disable → Firewall block if needed

##### More Info

* **Properties** → View path, description, company, command line
* **Close Connection**
* **End Process** (careful!)
* **Search Online**
* If a port is suspicious:
  1. Right-click → Properties
  2. Check path and description
  3. If unknown → disable or remove the software

## **Closing Ports**

### **Disable Services**
```powershell
Stop-Service -Name "Telnet"
Set-Service -Name "Telnet" -StartupType Disabled
```

### **Block with Windows Firewall**

```powershell
Net-NetFirewallRule -DisplayName "Block Port 23" -Direction Inbound -LocalPort 23 -Protocol TCP -Action Block
```

### **Uninstall or Disable the Program**

If TCPView shows a program you don’t need, remove it or disable its auto-start.

## **Quick Terms**

| Terms | Definition |
| -------- | ------------------------ |
| **Port** | A communication endpoint |
| **Service** | Background system program |
| **PID** | Process ID |
| **TCP/UDP** | Transport layer protocols |
| **LISTENING** | A service is waiting for connections |

## **Additional Resources**

* Microsoft Sysinternals Suite
* NIST Security/Hygiene Guides
* Official   Training Material
