# **Shared Folders**

## Table of Contents
 * [Overview](/Windows/Forensics/Networking/Shared_Folders.md#Overview)
 * [GUI](/Windows/Forensics/Networking/Shared_Folders.md#GUI)
 * [Command Line](/Windows/Forensics/Networking/Shared-Folders.md#Command-Line)
 * [Powershell](/Windows/Forensics/Networking/Shared-Folders.md#PowerShell)
 * [Misc](/Windows/Forensics/Networking/Shared-Folders.md#Misc)
 * [Reference Table](/Windows/Forensics/Networking/Shared-Folders.md#Reference-Table)
 * [OS Compatibility](/Windows/Forensics/Networking/Shared-Folders.md#OS-Compatibility)

## Overview

Windows Shared Folders allow SMB-based remote access to local resources.  
Key administrative tools include:

- **GUI:** `fsmgmt.msc`
- **CMD:** `net share`, `net session`, `openfiles`
- **PowerShell:** `Get-SmbShare`, `Get-SmbSession`
---

## GUI

### Launching the Shared Folders Console

1. Press **Windows + R**  
2. Enter:
```win+r
fsmgmt.msc
```
3. Press OK
4. Approve the UAC admin prompt if shown

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

#### Viewing Share Details
Right-click a share → Properties
Displays:
- Share permissions  
- Security (NTFS ACLs)  
- Path  
- Active connections  

#### Stopping a Share
Right-click → **Stop Sharing**

#### Creating a New Share
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
- \# of locks  

#### Closing an Open File
Right-click → **Close Open File**  
Useful to:
- Release file locks  
- Stop misuse of shared resources  
- Force-close malicious or suspicious access  

---

## Command Line

The command line offers greater control in a much more resource efficient way

---

### Share Commands

|                   | **Command**                                     | Extra Info                                                                              |
| ----------------- | ----------------------------------------------- | --------------------------------------------------------------------------------------- |
| View All Shares   | `net share`                                     | Displays share name, path, and description.                                             |
| Create a Share    | `net share <sharename>=<path>`                  | Creates a share called \<sharename> at path \<path>. Make sure \<path> is absolute path |
| Grant Permissions | `net share <sharename> \GRANT:<user>,<options>` | Options include read, change and full                                                   |
| Delete Share      | `net share <sharename> /delete`                 | Deletes active share \<sharename>                                                       |

---

### Session Commands

|                     | **Command**                    | **Extra Info**                                             |
| ------------------- | ------------------------------ | ---------------------------------------------------------- |
| List Active session | `net session`                  | Displays: Remote clients, Usernames, Open files, Idle time |
| Close a session     | `net session \\<name> /delete` | Closes an active session                                   |
| Close all session   | `net session /delete`          | closes all active sessions on the computer                 |

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

`<ID>` can be obtained from `openfiles /query`.

---

## PowerShell

PowerShell provides a more powerful command line interface. [Link to more info](/Windows/Scripting/Readme.md)


| Action                 | **Command**                          |
| ---------------------- | ------------------------------------ |
| List Shares            | `Get-SmbShare`                       |
| View Share Permissions | `Get-SmbShareAccess -Name Sharename` |
| View SMB Sessions      | Get-SmbSession                       |
| View Open Files        | Get-SmbOpenFile                      |

---

### Administrative Shares

Windows creates default & hidden administrative shares by default:

| Share    | Purpose                              |
| -------- | ------------------------------------ |
| `C$`     | Root drive access for administrators |
| `ADMIN$` | Remote management tools              |
| `IPC$`   | Named pipe communication             |

---

## Misc.

### Event Logs

Access events appear under:

**Windows + R → eventvwr.msc → Event Viewer → Windows Logs → Security → Open**

Relevant event IDs:

| ID   | Meaning                |
| ---- | ---------------------- |
| 5140 | Network Share Accessed |
| 5142 | Share Created          |
| 5143 | Share Modified         |
| 5144 | Share Deleted          |
| 5145 | File Accessed via SMB  |

---
### Network Enumeration

From another machine:

```cmd
net view \\hostname
```

Find hostname on host computer:

```cmd
hostname
```

### Indicators of an Attack

* Newly created shares
* Shared sensitive directories
* Unexpected/Unknown SMB sessions
* High number of open files

---

## Reference Table

|                      | GUI                                                                                     | CMD                                       |
| -------------------- | --------------------------------------------------------------------------------------- | ----------------------------------------- |
| View shares          | Shares                                                                                  | `net share`                               |
| Create new share     | Right-click → New Share                                                                 | `net share <name>=<absolute path>`        |
| Grant Permissions    | Share Properties → Share Permissions → Add user → set **Read / Change / Full Control**. | `net share <name>  /GRANT:<user>,<perms>` |
| Stop a share         | Right-click → Stop Sharing                                                              | `net share <name> /delete`                |
| View active sessions | Sessions                                                                                | `net session`                             |
| Close active session | Right-click → Close Session                                                             | `net session \\host /delete`              |
| View open files      | Open Files                                                                              | `openfiles /query`                        |
| Close open file      | Right-click → Close Open File                                                           | `openfiles /disconnect /id <ID>`          |

---

## OS Compatibility

| Windows Edition          | Shared Folders Support                        |
| ------------------------ | --------------------------------------------- |
| Windows 10/11 Home       | FSMGMT.MSC supported; admin shares restricted |
| Windows 10/11 Pro        | Full SMB, share creation, AD integration      |
| Windows Server 2019/2022 | Full SMB, share creation, AD integration      |

---
