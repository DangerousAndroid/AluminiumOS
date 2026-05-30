# AluminiumOS

![Language: Bash](https://img.shields.io/badge/Language-Bash-blue?logo=GNU%20Bash)
![Platform: QEMU](https://img.shields.io/badge/Platform-QEMU-orange?logo=qemu&logoColor=white)
![Status: WIP](https://img.shields.io/badge/Status-Work_In_Progress-red)

## 📌 About the Project

**AluminiumOS** is an experimental project aimed at booting the leaked ALOS GSI image (by Mystic Leaks) onto x64/x86 architectures using QEMU. While the immediate focus is achieving a stable emulated boot, the long-term vision explores the possibility of native hardware booting.
**Current status** the image boots perfectly with and without trusty TEE, but gaphical output isnt avaliable yet due to the lack of virtio drivers on the kernel, when i manage to insert the drivers in the kernel (hopefully) we will have an image. The other problem its android security maintence hal, that after 400 sec (sometimes, almost randomly)
🚀 Key Features & Development Focus
**QEMU Emulation:** Adapting the environment to successfully emulate the GSI image on x86/x64 systems.
* **Trusty OS Integration:** Compiling and establishing communication with Trusty OS.
* **GICv3 Support:** Handling GICv3 driver initialization and related system interrupts.

## 📋 TODO

- [X] Achieve a successful, fully stable boot.
- [X] Complete Trusty OS and GICv3 driver initialization.
- [ ] Clean up scripts and fix remaining bugs.
- [ ] Make the system native

## 🔗 Resources

* **XDA Thread:** [AluminiumOS in x86/x64 PCs (WIP)](https://xdaforums.com/t/aluminiumos-in-x86-x64-pcs-wip.4789078/)
