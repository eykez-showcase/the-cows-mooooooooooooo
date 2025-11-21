# **Wireshark with a focus on Windows**

Wireshark is a packet capture and analysis tool used to inspect network traffic in real time or from saved capture files. You often use Wireshark to identify malicious traffic, misconfigurations, or insecure communication happening within the competition images.

## **Table of Contents**

1. [What Wireshark Is](/Windows/Forensics/Networking/Wireshark.md#what-wireshark-is)
2. [Installing Wireshark on Windows](/Windows/Forensics/Networking/Wireshark.md#installing-wireshark-on-windows)
3. [Key Wireshark Concepts](/Windows/Forensics/Networking/Wireshark.md#key-wireshark-concepts)
4. [Essential Filters](/Windows/Forensics/Networking/Wireshark.md#essential-filters)
5. [Common Tasks](/Windows/Forensics/Networking/Wireshark.md#common-tasks)
6. [Identifying Malicious Traffic](/Windows/Forensics/Networking/Wireshark.md#identifying-malicious-traffic)
7. [Exporting & Saving Evidence](/Windows/Forensics/Networking/Wireshark.md#exporting-saving-evidence)
8. [Performance Tips](/Windows/Forensics/Networking/Wireshark.md#performance-tips)
9. [Quick Reference Cheat Sheet](/Windows/Forensics/Networking/Wireshark.md#quick-reference-cheat-sheet)

---

# **What Wireshark Is**

Wireshark is a protocol analyzer that lets you inspect:

* Connections to the computer
* Network protocols (DNS, HTTP, SSH, SMB, etc.)
* Suspicous Connections
* Plaintext Conversations

Wireshark is used to **find malicious network behavior** such as:

* Unauthorized remote connections
* Unencrypted credential transmission
* Network Based Attacks(Flooding, DoS and DDoS)

---

# **Installing Wireshark on Windows**

### **1. Download Wireshark**

Wireshark for Windows is available at:
`https://www.wireshark.org/download.html`

### **2. Installation Notes**

During installation:

* **Install Npcap** if packet capture is necessary
* Do not install USBPcap unless required, it creates unneeded packets
* Say Yes to any other prompts

### **3. Verify Install**

Open a [PowerShell Window](/Windows/Scripting/Powershell.md):

```
wireshark -v
```

A version number confirms installation.

---

## You will either have a **PCAP files** with suspicious activity or need to capture **Live traffic**:

### **Opening Files**

  Go to **Files → Open a File**

### **Interfaces**

Under **Capture → Options**, you choose which network interface to monitor.
You commonly monitor:

* `Ethernet`
* `Wi-Fi`
* `Local Area Connection`

### **Packet Details Pane**

Wireshark windows are split into:

1. **Packet list pane** – summary
2. **Packet details pane** – protocol layers
3. **Packet bytes pane** – raw hex/text

---

# **Filters**

Wireshark filtering is the most important skill. Here are essential filters:

### **Host / IP Filters**

```
ip.addr == <Target IP>
```
Search for packets associated with Target IP in both Destination and Source

```
ip.src == <Target IP>
```
Search for packets sent from Target IP

```
ip.dst == <Target IP>
```
Search for packets sent to Target IP

### **Protocol Filters**
##### Some common Protocols to look for, listed in order of importance

```
ftp
dns
ssh
smtp
http
smb
icmp
https
```

### **Suspicious Traffic Filters**

```
http contains "password"
```
Looking through cleartext HTTPS for mention of a password
```
ftp && tcp.len > 0
```
Searches for FTP Packets, and only shows non-empty ones

```
tcp.flags.syn == 1 && tcp.flags.ack == 0
```
First part filters for connections attempting tp synchronize, Second part Filters for no response, indicating a failed connection attempt

```
icmp.type == 8
```
Looking for ping requests, which can indicate network mapping, reconnaissance or exfiltration

### **Cleartext Credential Filters**

```
ftp.request.command == "USER"
```
Searches for Packets that contain a Username

```
ftp.request.command == "PASS"
```
Searches for Packets that contain a Password

```
ftp.response.code == 230
```
Searches for packets returning a 230, this means that a succesful password was given.
View the entire conversation by **Right-Click → Follow Conversation → TCP**

### **Remove Noise**
#### Only Do this if you are unsure what protocol to look through

```
!(mdns || nbns || ipv6)
```
Removing the frequent and unusable data

---

# **Common Uses**

## **Identifying Unauthorized Remote Access**

Look for:

* SSH attempts (`tcp.port == 22`)
* RDP (`tcp.port == 3389`)
* Telnet (`tcp.port == 23`)
* VNC (`tcp.port == 5900`)

Check packet for:

* Plaintext Credentials
* Foreign Source IP
* Brute-force attempts(repeated attempts with slight changes)

---

## **2. Check for Unencrypted Credentials**

Common cleartext protocols:

* FTP
* HTTP
* Telnet
* POP3/SMTP (non-SSL)

Filters to look for:

```
ftp || http || telnet
```

Search for passwords:

```
frame contains "pass"
frame contains "login"
```

---

## **3. Detect Malware / Backdoor Behavior**

Signifiers of an attack:

* Repeated outbound connections to unknown IPs `tcp.flags.syn == 1`
* Traffic on high ports (>1024) `tcp.port >= 1024`
* Regular scanning every 5 seconds `ip.dst != 192.168.0.0/16`

---

## **4. Analyze DNS**

Signifiers of an error:

* DNS tunneling
* Long/excessive domain queries
* Random-looking subdomains

```
dns && dns.qry.name contains "."
```

Check for Strange IPs

---

# **Identifying Malicious Traffic**


| Behavior                            | Signifies?                  |
| ----------------------------------- | --------------------------- |
| Repeated SYN packets without ACKs   | Port scanning attempt       |
| Cleartext login attempts            | Password stealing           |
| Connections to foreign IPs          | Possible backdoors          |
| Rapid DNS queries                   | Malware communication       |
| FTP or Telnet usage                 | Plaintext Insecure protocols|
| HTTP sending base64-looking strings | Credential exfiltration     |

---

# **Saving Pcap Files**

### **Export a Single Packet**

**File → Export Packet Bytes**

### **Export Specific Conversations**

**Analyze → Follow TCP Stream**
Then click **Save As**.

### **Export filtered packets only**

Apply your desired filter if necessary, then:

```
File → Export Specified Packets
```

### **Save as a PCAP**

```
File → Save As → suspicious_traffic.pcapng
```

---

# **Quick Tips & Tricks**

* Pause capture when filtering to reduce lag
* [Disable IPv6](Windows/Settings/Networking/IPV6) on the system to reduce noise
* Use **“Follow TCP Stream”** frequently to understand full conversations
* Use display filters (not capture filters) unless necessary
* If Wireshark is lagging, increase scroll buffer size and restart capture

---

# **Quick Reference Cheat Sheet**

### **Filters**

```
http
ftp
ssh
icmp
tcp.port == 3389
ip.addr == <target>
frame contains "password"
tcp.flags.syn == 1
```

### **Analysis Tools**

* Follow TCP Stream
* Statistics → Endpoints
* Statistics → Protocol Hierarchy
* Statistics → Conversations
* Right-click → Apply as Filter
