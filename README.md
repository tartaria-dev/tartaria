<p align="center">
  <img src="system_files/usr/share/pixmaps/tartaria-text-logo.svg" alt="Tartaria Logo" width="450">
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch/CachyOSv3 Bootc | Niri | Noctalia</h3>
<p align="center">
  <img width="1920" height="1080" alt="Desktop image" src="https://github.com/user-attachments/assets/833bd2bd-bd2d-4f90-a2d3-80e9f08a6a12" />
</p>


> [!WARNING]
> **Non-sealed variants have been removed.** In part of a restructure in support of moving to the experimental sealed layout, the non-sealed variants have been removed from this repository. A seperate repository containing all code for the non-sealed variants will be established soon.

> [!WARNING]
> Due to the restructuring, Tartaria is currently unstable and not safe to install. Please wait for v2 to exit beta.

## Description
Tartaria is a custom Arch/CachyOSv3 bootc image built for (optimized) general-day-to-day usage, providing a sleek, modern, unobtrusive experience that lets you get your work done.

The name is inspired by my favorite species of cherries, the [Black Tartarian](https://shop.arborday.org/treeguide/210) species - tender, juicy, and sweet.


## Variants

In total, there are eight variants of Tartaria.

Variants are composed as follows:

```
tartaria:<base>-<flavor>-<spice>
```

### Bases

- `stable`: A base of Tartaria built every 72 hours and on every new repository tag (new repository tags are made every release). Considered stable and recommended for usage, as it does not receive the latest, untested changes.
- `unstable`: A base of Tartaria built daily and every time a new change is made. Considered unstable and not recommended for usage, unless you are testing changes and/or like to live on the edge. Be aware that your system may break at any moment in time.

### Flavors

- `arch`: A flavor of Tartaria based on Arch Linux and the Arch kernel.
- `cachy`: A flavor of Tartaria based on CachyOS-v3 and the CachyOS-v3 kernel.

### Spices

- `mahleb`: A spice of Tartaria including secure boot support and the sealed image layout.
- `saffron`: A spice of Tartaria including secure boot support, the sealed image layout, and preinstalled NVIDIA drivers.


## Installing

### ISO

> [!WARNING]
> ISOs are still being tested. The below instructions will update over time. Refrain from using them right now.

Since our ISOs are stored in GHCR, we use the tool [Oras](https://oras.land/) to upload/download them.

To make things more convenient for you, the end user, run the following in a Linux terminal and go through the download process:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tartaria-dev/tartaria/refs/heads/live/iso-downloader.sh)"
```

If you find that the variant you installed doesn't fit you, run `synergy rebase` in the terminal and go through the selection process.

## Credits
Thank you to the [Bootcrew](https://discord.gg/52Qcb4x2w3) team for making this project possible (and for general help)! I'd also like to thank the [XeniaOS](https://github.com/XeniaMeraki/XeniaOS/) and [Zirconium](https://github.com/zirconium-dev/zirconium/) projects for inspiring the creation of Tartaria!
