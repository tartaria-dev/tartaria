<p align="center">
  <img src="https://raw.githubusercontent.com/tartaria-dev/.github/refs/heads/main/142.svg" alt="Tartaria Logo" width="400">
</p>

<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch/CachyOS Bootc / Niri / Noctalia</h3>

<p align="center">
  <img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/55b44546-2718-4888-928a-88815d9f91f4" />
</p>

# What's Tartaria?
A custom arch-bootc image built for container usage, general development, and day-to-day usage, making use of the [Niri](https://github.com/YaLTeR/niri) compositor and the [Noctalia](https://noctalia.dev/) desktop shell to provide a usable TWM experience OOTB that does not sacrifice on looks.


# How can I use this?
At the moment, only rebasing is supported. Rebasing from XeniaOS or Zirconium is highly encouraged.
To rebase, use the following command:
```
sudo bootc switch ghcr.io/tartaria-dev/tartaria
```
...and you'll be on your (jolly) way!


# Features

- Based on CachyOS/Arch with bootc support

- CachyOS-v3 kernel with v3 cpu optimizations and the Bore scheduler

- The default GNOME app suite for all your basic needs

- ZRAM enabled by default (can't be running out of RAM now, can we)

- Niri, a simple scrollable tiling Wayland compositor designed for productivity and efficiency in your workflow

- Noctalia, a quickshell desktop shell with amazing looks by default and all the functionality you need

- Kitty terminal for a blazing-fast, gpu-powered terminal experience along with Starship for looks

- Flatpak/AppImage support OOTB with Bazaar/Warehouse (software store, flatpak manager) and Gear Lever (AppImage manager)

- Distrobox/Podman/Docker for containerization, along with DistroShelf (GUI container manager) and DevPod (devcontainers!)

- JetBrains Toolbox, the official manager for all JetBrains IDE's along with JetBrains Gateway for DevPod/ssh compatibility

- Zen, a beautiful Firefox-based browser with vertical tabs focused on productivity and zero AI features


# Notice
This OS is only compatible and intended for desktop PCs with AMD/Intel graphics, and has optimizations for [V3 cpus](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels), meaning this custom image will only work on V3 cpus. Support for V2 cpus will be looked into.

Tartaria is headed by me, certifiedfooliolol. You may contact me via my Discord handle, `shartmunk`. Creative username, I know.

Many thanks to the [Bootcrew Discord](https://discord.gg/52Qcb4x2w3) for general help/support and the developers of Zirconium and XeniaOS for inspiring this project!
