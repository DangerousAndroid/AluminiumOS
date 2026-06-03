# AluminiumOS

![Language: Bash](https://img.shields.io/badge/Language-Bash-blue?logo=GNU%20Bash)
![Platform: QEMU](https://img.shields.io/badge/Platform-QEMU-orange?logo=qemu&logoColor=white)
![Status: WIP](https://img.shields.io/badge/Status-Work_In_Progress-red)

## 📌 About the Project

**AluminiumOS** is an experimental project aimed at booting the leaked ALOS GSI image (by Mystic Leaks) onto x64/x86 architectures using QEMU. While the immediate focus is achieving a stable emulated boot, the long-term vision explores the possibility of native hardware booting.
**Current status** the image boots perfectly with and without trusty TEE, but gaphical output isnt avaliable yet due to the lack of virtio drivers on the kernel, when i manage to insert the drivers in the kernel (hopefully) we will have an image. The other problem its android security maintence hal, that after 400 sec (sometimes, almost randomly)
🚀 Key Features & Development Focus
**QEMU Emulation:** Adapting the environment to successfully emulate the GSI image on x86/x64 systems.\n
* **GICv3 Support:** Handling GICv3 driver initialization and related system interrupts.\n
**Logger:** This project logs everything to a local file inside logs/, but this feature can be turned on and off via the arg -l to deactivate it\n
**Build** It lets you open a build menu by using the -b arg, or you can just execute the neccesary scripts\n
**Update the IMGs** If there is a change, updating the super or disk images its pretty simple, just open the update menu via -u or update it manually executing the scripts\n
**Use trusty or not** The project can be used with trusty, which can download premake or build it yourself from source code, for using it use -t arg and for booting without it use -n\n
**Init console** If something its not working, boot it in debug mode ( -d ) so a console appears on the first stage of init\n
**Centralized script** The main script (script.sh) lets you make all the tasks without needing to search for the correct script in the code\n
**Help Menu** You can always execute the help menu via -h or via not passing any args to the script, and it will show you all the options\n
**WIP but working** Even if the status its WIP, the project boots with comet ramdisk and kernel (manual changes needed in the scripts), but not with cuttlefish yet :)\n

## 📋 TODO

- [X] Achieve a successful, fully stable boot.
- [X] Complete Trusty OS and GICv3 driver initialization.
- [ ] Clean up scripts and fix remaining bugs.
- [ ] Make the system native
- [ ] Make the system boot with cuttlefish kernel and ramdisk

## 🔗 Resources

* **XDA Thread:** [AluminiumOS in x86/x64 PCs (WIP)](https://xdaforums.com/t/aluminiumos-in-x86-x64-pcs-wip.4789078/)
