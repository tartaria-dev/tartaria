<p align="center">
  <img src="system_files/usr/share/pixmaps/tartaria-text-logo.svg" alt="Tartaria Logo" width="450">
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch/CachyOSv3 Bootc | Niri | Noctalia</h3>
<p align="center">
  <img width="1920" height="1080" alt="Desktop image" src="https://github.com/user-attachments/assets/833bd2bd-bd2d-4f90-a2d3-80e9f08a6a12" />
</p>


> [!WARNING]
> Tartaria is currently unstable and not safe to install due to the efforts towards v2. Please wait for v2 to exit beta and release.

## Description
Tartaria is a custom Arch/CachyOSv3 bootc image built for (optimized) general-day-to-day usage, providing a sleek, modern, unobtrusive experience that lets you get your work done.

The name is inspired by my favorite species of cherries, the [Black Tartarian](https://shop.arborday.org/treeguide/210) species - tender, juicy, and sweet.


## Variants

In total, there are sixteen variants of Tartaria.

Variants marked as **sealed** are **only installable by an ISO.** Variants marked as **nonsealed** are **installable by ISO or rebasing.**

Variants are composed as follows:

```
tartaria:<channel>-<edition>-<flavor>
```

### Channels

- `stable`: Built every **72 hours** and on **every new release**. Does not receive the latest, untested changes immediately.
- `unstable`: Built **daily** and on **every new change**. Not recommended for usage, unless you are testing changes and/or like to live on the edge. Be aware that your system may break at any moment in time.

### Editions

- `arch`: Based on **Arch Linux** with the **Arch kernel**.
- `cachy`: Based on **CachyOS-v3** with the **CachyOS-v3 BORE kernel**.

### Flavors

- `berbere`: **Nonsealed** image layout and nothing extra.
- `amchoor`: **Nonsealed** image layout with preinstalled NVIDIA drivers.
- `maraska`: **Sealed** image layout with secure boot support.
- `saffron`: **Sealed** image layout with secure boot support, and preinstalled NVIDIA drivers.

### Notes

**Sealed** variants provide E2E integrity verification via UKIs, Secure Boot, and fs-verity–backed composefs on top of what nonsealed has. Sealed variants are only installable via ISO, and are experimental.

**Nonsealed** variants do not have E2E integrity verification but still get bootc's atomic updates, rollback, and composefs filesystem. Nonsealed variants are installable by rebasing or installing via an ISO.


## Installing

### ISO

> [!WARNING]
> ISO installation is still being tested/improved. The below instructions will update over time.

Run the following in a Linux terminal and go through the selection/download process:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tartaria-dev/tartaria/refs/heads/live/iso-downloader.sh)"
```

### Rebasing

If you are already running an OS such as Fedora Atomic or one of the Universal Blue projects, you can rebase with one of the following commands:

```
bootc switch ghcr.io/tartaria-dev/tartaria:<variant> # fedora atomic and universal blue projects
```
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/tartaria-dev/tartaria:<variant> # fedora atomic only
```

### Notes

If after installation you don't like the variant you chose, run `synergy rebase` in the terminal and go through the selection process.

Refer to the [Variants](https://github.com/tartaria-dev/tartaria#Variants) section above for choosing a variant.


## Credits
Thank you to the [Bootcrew](https://discord.gg/52Qcb4x2w3) team for making this project possible (and for general help)! I'd also like to thank the [XeniaOS](https://github.com/XeniaMeraki/XeniaOS/) and [Zirconium](https://github.com/zirconium-dev/zirconium/) projects for inspiring the creation of Tartaria!
