# Storage Systems Guide: Partition Tables and Filesystems

IBM - 1983 - PC DOS version 2.0
    first disk segmentation -   1986 - CP-67 as minidisk

## Table of Contents
1. [Partition Table Types/Schemas](#partition-table-types)
2. [Microsoft Filesystems](#microsoft-filesystems)
3. [Apple Filesystems](#apple-filesystems)
4. [Linux Filesystems](#linux-filesystems)
5. [Feature Comparison](#feature-comparison)
6. [Common Use Cases](#common-use-cases)
7. [Performance Characteristics](#performance-characteristics)
8. [Advanced Features](#advanced-features)
9. [Compatibility](#compatibility)
10. [Best Practices](#best-practices)

## Partition Table Types/Schemas

### APM (Apple Partition Map)
- Used by older Apple systems
- Limited to 32 bits worth of logical blocks - 2TB
- Mainly obsolete now

### MBR (Master Boot Record) - IBM - 1983
- Traditional partition table
- Max 2TB disk size
- 4 primary partitions only
- Legacy BIOS systems
- The MBR consists of 512 or more bytes located in the first sector of the drive.

### GPT (GUID Partition Table) - Intel - 1990 
GUID - Globally Unique IDentifier)
- Modern standard
- Supports >2TB disks
- Up to 128 partitions
- Part of UEFI - Unified extensible firmware interface
- Has backup partition table
- Macs and Windows allowed to boot from EFI Firmware,
- Linux allows both bios and EFI firmware

#Files System
- Standards of organizg data on disk storage and applied to format disks
## Microsoft Filesystems

### FAT (File Allocation Table)
- Very basic filesystem
- Max file size: 2GB
- No permissions
- Used in old systems
- Replaced with NTFS in Windows XP
- commonly used for small-capacity solid-state storage SD cards 

### FAT32
- Max file size: 4GB
- Max volume: 2TB
- No permissions
- Used for USB/EFI
- Wide compatibility

### exFAT
- Large file support
- No size limits
- No permissions
- Good for external drives
- Cross-platform compatible

### NTFS (New Technology File System)
- Windows native filesystem
- Permissions support
- Journaling
- File compression
- Max file size: 16EB

## Apple Filesystems

### APFS (Apple File System)
- Modern Apple filesystem - uses GPT
- SSD optimized
- Snapshots
- Encryption
- supporting over 9 quintillion files (263) on a single volume.
- Used in macOS/iOS

Features:
- Space sharing
- Fast directory sizing
- Native encryption
- Copy-on-write

## Linux Filesystems

### ext2
- Basic Linux filesystem
- No journaling
- Simple structure
- Still used for flash drives

### ext3
- Added journaling to ext2
- Max file size: 2TB
- Max volume: 32TB
- Backward compatible

### ext4
- Current Linux standard
- Max file size: 16TB
- Max volume: 1EB
- Better performance
- Extents support

----------------------------------
# Storage Management Solution

### LVM (Logical Volume Management) - Volume Manager
- Dynamic volume management
- Can resize partitions easily
- Supports snapshots
- Can span multiple disks

### ZFS (Zetabyte File System) - File System + Volume Manager
- Advanced filesystem
- Built-in RAID (Redundant array of independent disks)
- Snapshots
- Data integrity
- Volume management

### LVM VS ZFS
Snapshot - LVM is slower than ZFS that us copy-on-write(CoW) approach

## Feature Comparison

### Journaling Support
- Supported: NTFS, ext3, ext4, APFS, ZFS
- Not Supported: FAT, FAT32, exFAT, ext2

### Maximum File Sizes
- FAT: 2GB
- FAT32: 4GB
- exFAT: 16EB
- NTFS: 16EB
- ext4: 16TB
- ZFS: 16EB

### Permissions Support
- Supported: NTFS, ext2/3/4, APFS, ZFS
- Not Supported: FAT, FAT32, exFAT

## Common Use Cases

### USB Drives
- FAT32 (compatibility)
- exFAT (large files)

### System Drives
- NTFS (Windows)
- ext4 (Linux)
- APFS (Mac)

### Enterprise Storage
- ZFS
- ext4
- NTFS

## Performance Characteristics

### Best for SSDs
- APFS
- ext4
- ZFS

### Best for HDDs
- ext4
- NTFS
- ZFS

### Best for Small Files
- ext4
- NTFS
- APFS

### Best for Large Files
- ZFS
- exFAT
- NTFS

## Advanced Features

### Snapshots
- ZFS
- APFS
- LVM

### Compression
- ZFS
- NTFS
- APFS

### Data Integrity
- ZFS (checksums)
- APFS
- ext4 (limited)

### Volume Management
- ZFS
- LVM
- APFS

## Compatibility

### Windows
- Native: NTFS, FAT32, exFAT
- Read-only: ext2/3/4 (with tools)

### Linux
- Native: ext2/3/4, ZFS
- Read/Write: FAT32, exFAT, NTFS
- Limited: APFS

### macOS
- Native: APFS, HFS+
- Read/Write: FAT32, exFAT
- Read-only: NTFS

## Best Practices

### System Drives
- Windows: NTFS
- Linux: ext4
- Mac: APFS

### External Drives
- Cross-platform: exFAT
- Small drives: FAT32
- Large drives: NTFS/ext4

### Server Storage
- ZFS for data integrity
- ext4 for standard use
- LVM for flexibility

## Important Notes

1. Choose based on:
   - Use case
   - File sizes
   - Compatibility needs
   - Performance requirements
2. Consider future needs
3. Backup before changing
4. Check OS compatibility
