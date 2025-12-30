<p align="center">
  <img src="https://raw.githubusercontent.com/tartaria-dev/.github/refs/heads/main/142.svg" alt="Tartaria Logo" width="400">
</p>

<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch Bootc / Niri / Noctalia</h3>

<p align="center">
  <img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/c967e9ee-c0d6-40f8-9231-1433f1ba3318" />
</p>

# What's Tartaria?
A custom arch-bootc image built for container usage, general development, and day-to-day usage, making use of the [Niri](https://github.com/YaLTeR/niri) compositor and the [Noctalia](https://noctalia.dev/) desktop shell to provide a usable TWM experience OOTB that does not sacrifice on looks.


# How can I use this?
At the moment, only rebasing is supported. Fair warning, rebasing has been highly untested, although stock Fedora Silverblue has worked best in my experience as a base.
Use the following command on any Fedora based system that supports `bootc`:
```
sudo bootc switch ghcr.io/tartaria-dev/tartaria
```
...and you'll be on your (jolly) way!

# Can I customize this?
Absolutely! Although we've worked to provide good defaults OOTB, you can still customize the looks to your liking.


# Features

- Based on CachyOS/Arch with bootc support

- Niri, a scrollable tiling window manager that doesnt sacrifice on looks

- Noctalia, an extremely customizable shell similar to that of [DMS](https://danklinux.com/)

- CachyOS-v3 kernel with v3 cpu optimizations and the Bore scheduler

- The default GNOME app suite for all your basic needs (including OBS for recording stuffs)

- Foot terminal for a blazing-fast TUI experience along with Oh-My-Posh for looks

- Flatpak/AppImage support OOTB with Bazaar/Warehouse (software store, flatpak manager) and Gear Lever (AppImage manager)

- Distrobox and Podman for containerization, along with DistroShelf (GUI container manager)

- Zed, a high-performance rust-based IDE for code editing, supports Devpod (not included)

- Zen, a beautiful Firefox-based browser with vertical tabs and a design similar to that of Arc Browser

- ZRAM enabled by default (can't be running out of RAM now, can we)


# Notice
This OS is only compatible and intended for desktop PCs with AMD/Intel graphics, and has optimizations for [V3 cpus](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels). An image with NVIDIA drivers OOTB is in the works.


# Contact
Tartaria is headed by me, certifiedfooliolol. You may contact me via my Discord handle, `shartmunk`. Creative username, I know.

Many thanks to the [Bootcrew Discord](https://discord.gg/52Qcb4x2w3) for general help/support and the developers of Zirconium and XeniaOS for inspiring this project!
