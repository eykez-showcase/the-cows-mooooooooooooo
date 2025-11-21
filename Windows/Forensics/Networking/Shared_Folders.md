# **Shared Folders**

## Table of Contents
 * [Overview](/Windows/Forensics/Networking/Shared_Folders.md#Overview)
 * [GUI](/Windows/Forensics/Networking/Shared_Folders.md#GUI)
 * [Command Line](/Windows/Forensics/Networking/Shared-Folders.md#Command-Line)
 * []

## Overview

Windows Shared Folders allow SMB-based remote access to local resources.  
Key administrative tools include:

- **GUI:** `fsmgmt.msc`
- **CMD:** `net share`, `net session`, `openfiles`
- **PowerShell:** `Get-SmbShare`, `Get-SmbSession`
---

## GUI

### Launching the Shared Folders Console

1. Press **Win + R**  
2. Enter:
```

fsmgmt.msc

````
3. Press **Enter**  
4. Approve the UAC admin prompt if shown

This opens the **Shared Folders MMC**.

---

### Shared Folders MMC Structure

The console exposes three primary nodes:

| Node          | Purpose                                                              |
|---------------|----------------------------------------------------------------------|
| **Shares**    | Lists all shared folders, paths, description, and connection counts  |
| **Sessions**  | Displays active SMB user sessions                                    |
| **Open Files**| Shows files currently opened via SMB                                  |

All nodes support right-click actions for administrative control.

---

### Shares

The **Shares** node shows every SMB share on the system:

Default Shares:
- `C$`
- `ADMIN$`
- `IPC$`

### Viewing Share Details
Right-click a share → Properties
Displays:
- Share permissions  
- Security (NTFS ACLs)  
- Path  
- Active connections  

### Stopping a Share
Right-click → **Stop Sharing**

### Creating a New Share
Right-click **Shares** → **New Share**  
Configure:
- Folder path  
- Share name  
- Offline caching  
- Share permissions  

**Note**
Windows **Home** editions limit creation of **administrative shares**, but standard shares work normally.

---

### Open Files

Displays files opened through network shares.

For each file:
- File path  
- Accessing user  
- System lock status  
- # of locks  

### Closing an Open File
Right-click → **Close Open File**  
Useful to:
- Release file locks  
- Stop misuse of shared resources  
- Force-close malicious or suspicious access  

---

## Command Line

Command-line tools provide fast, scriptable auditing and remote administration.

---

### View All Shares

```cmd
net share
````

Displays share name, path, and description.

---

### Create a Share

```cmd
net share Sharename=C:\Path\Folder /GRANT:User,READ
```

Examples of permission options:

* `/GRANT:User,READ`
* `/GRANT:User,FULL`

---

### Delete a Share

```cmd
net share Sharename /delete
```

---

### List Active SMB Sessions

```cmd
net session
```

Displays:

* Remote clients
* Usernames
* Open file counts
* Idle time

### Close a Specific Session

```cmd
net session \\RemoteHost /delete
```

---

### View Open Files (CMD)

First enable tracking on client OS:

```cmd
openfiles /local on
```

**A reboot is required.**

### After reboot: list open files

```cmd
openfiles /query
```

### Close an open file

```cmd
openfiles /disconnect /id <ID>
```

`<ID>` is from `openfiles /query`.

---

## PowerShell

PowerShell provides more advanced SMB management, especially on Server editions.

### List Shares

```powershell
Get-SmbShare
```

### View Share Permissions

```powershell
Get-SmbShareAccess -Name Sharename
```

### View SMB Sessions

```powershell
Get-SmbSession
```

### View Open Files

```powershell
Get-SmbOpenFile
```

---

### Administrative Shares

Windows creates hidden administrative shares by default:

| Share    | Purpose                              |
| -------- | ------------------------------------ |
| `C$`     | Root drive access for administrators |
| `ADMIN$` | Remote management tools              |
| `IPC$`   | Named pipe communication             |

These shares are **normal and expected** on:

* Windows 10/11 Home
* Windows 10/11 Pro
* Windows Server 2019/2022

They should *not* be removed during forensic review; simply monitor access.

---

## Misc.

### Event Logs

Access events appear under:

**Event Viewer → Windows Logs → Security**

Relevant event IDs:

* **5140** — Network share accessed
* **5142** — Share created
* **5143** — Share modified
* **5144** — Share deleted
* **5145** — File accessed via SMB

### Network Enumeration

From another machine:

```cmd
net view \\hostname
```

### Unauthorized Share Indicators

* Newly created shares with unusual names
* Shares pointing to sensitive directories
* Unexpected SMB sessions
* High numbers of open files

---

## Reference Table

| Task                 | GUI (FSMGMT)                  | CMD                              |
| -------------------- | ----------------------------- | -------------------------------- |
| View shares          | Shares                        | `net share`                      |
| Create new share     | Right-click → New Share       | `net share ...`                  |
| Stop/delete a share  | Right-click → Stop Sharing    | `net share <name> /delete`       |
| View active sessions | Sessions                      | `net session`                    |
| Close session        | Right-click → Close Session   | `net session \\host /delete`     |
| View open files      | Open Files                    | `openfiles /query`               |
| Close open file      | Right-click → Close Open File | `openfiles /disconnect /id <ID>` |

---

## OS Compatibility

| Windows Edition          | Shared Folders Support                    |
| ------------------------ | ----------------------------------------- |
| Windows 10/11 Home       | FSMGMT supported; admin shares restricted |
| Windows 10/11 Pro        | Full feature set                          |
| Windows Server 2019/2022 | Full SMB, share creation, AD integration  |

---
