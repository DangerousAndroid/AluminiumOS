# 💿 AluminiumOS

<p align="center">
  <img src="https://img.shields.io/badge/Language-Bash-blue?style=for-the-badge&logo=GNU%20Bash" alt="Bash">
  <img src="https://img.shields.io/badge/Platform-QEMU-orange?style=for-the-badge&logo=qemu&logoColor=white" alt="QEMU">
  <img src="https://img.shields.io/badge/Status-Work_In_Progress-red?style=for-the-badge" alt="WIP">
</p>

---

## 📌 About the Project

**AluminiumOS** is a new OS made from Google for the new Googlebooks, still not released, and its based on Android 17 for arm64 devices, but using QEMU and emulating the android boot stages and disk we can boot it on X86_64 devices! 

> 💡 **The Vision:** While the immediate milestone is achieving a rock-solid emulated boot, the ultimate, long-term horizon explores the thrilling possibility of running this system **natively on PC hardware**.

### ⚡ Current Status
> [!IMPORTANT]
> **What Works:** The image boots flawlessl in terminal and has video output!
> 
> **Bugs**    
> 1. **RILd:** Host features like wifi or bluetooth are very probably unfunctional, but is untested

---

## 🚀 Features

* **QEMU Emulation Core** — Sculpting a bespoke environment tailored to trick the ARM-focused GSI into running seamlessly on x86/x64 instruction sets.  
* **GICv3 Driver Support** — Precision-handling of complex GICv3 system interrupts and critical boot-stage initializations.  
* **Advanced Logger** — Tracks system lifecycles locally inside `logs/`. Easily silence it by passing the `-l` flag.  
* **Interactive Build Menu** — Fire up a streamlined, user-friendly compilation menu via `-b`, or run individual scripts directly.  
* **Dynamic Image Updates** — Need to swap out the `super` or `disk` partitions? Toggle the automated update menu via `-u` to handle backend modifications instantly.  
* **Trusty TEE Sandbox** — Fully modular security layer. Compile Trusty from source, download pre-made binaries with `-t`, or bypass it entirely using `-n`.  
* **Stage-1 Init Debugger** — Trapped in a bootloop? Drop right into a raw interactive console at the earliest phase of Android `init` using the `-d` flag.  
* **Centralized Command Center** — No more digging through nested folders. The master `script.sh` controls every single lifecycle process out of the box.  
* **Help Menu** — Drop the `-h` flag (or run the script with zero arguments) to pull up a cleanly formatted manual of all system flags.  
* **WIP but Functional** — Currently boots successfully using custom manual adaptations for the **Comet** ramdisk and kernel (Cuttlefish orchestration is coming next!).  

---

## 📋 TODO list

- [x]  Achieve a successful boot
- [x]  Build with trusty and GICv3
- [X]  Eliminate video bug
- [ ]  ELiminate all the rest of bugs (bt, wifi, ...)
- [X]  Boot with cuttlefish ramdisk and kernel
- [ ]  Execute it natively without a host OS (impossible??)

---

## 🔗 Links

* **XDA Thread:** [AluminiumOS in x86/x64 PCs (WIP)](https://xdaforums.com/t/aluminiumos-in-x86-x64-pcs-wip.4789078/) - For bug reports, questions or any information. Any contribution its appreciated!
* **My contact:** [DangerousAndroid in Telegram](https://t.me/@DangerousAndroid) - For errors or info that cannot be published on the main XDA thread

## ❤️ Credits
* **Mystic Leaks** for the leaked ALOS image
* **AOSP** for trusty source code and qemu for trusty binary 
* **Magisk** for the magiskboot binary
* **QEMU** for the framework that makes this project possible
* **Android CI** for cuttlefish files
* **Google** for comet files
* **All the XDA threads and web pages about documenting ARM64 in QEMU, GICv3 and android boot process** for their amazing info
