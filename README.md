<p align="center">
  <img src="system_files/mainsys/usr/share/pixmaps/tartaria-text-logo.svg" alt="Tartaria Logo" width="450">
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch/CachyOSv3 Bootc | Niri | Noctalia</h3>
<p align="center">
  <img width="1920" height="1080" alt="Desktop image" src="https://github.com/user-attachments/assets/833bd2bd-bd2d-4f90-a2d3-80e9f08a6a12" />
</p>


## Description
Tartaria is a custom Arch/CachyOSv3 bootc image built for (optimized) general-day-to-day usage, providing:

- AppArmor application security enabled by default
- An opinionated and mostly GTK-based app suite
- A containerized shell powered by a minimal Arch container
- The Niri scrollable tiling Wayland compositor
- The modern, fluid Noctalia desktop shell

Overall, Tartaria aims to provide a sleek, modern, unobtrusive experience that lets you get your work done.

The name is inspired by my favorite species of cherries, the [Black Tartarian](https://shop.arborday.org/treeguide/210) species - tender, juicy, and sweet.


## Variants

> [!WARNING]
> If you are a Tartaria user on an old variant such as `stable-arch`, please read below and switch over ASAP.


In total, there are sixteen variants of Tartaria.

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

- `berbere`: A spice of Tartaria with no extra features; choose this if you do not need features provided by other spices.
- `amchoor`: A spice of Tartaria that includes preinstalled NVIDIA drivers.
- `mahleb`: A spice of Tartaria including secure boot support and the sealed image layout with a UKI. **Only installable via ISO.**
- `saffron`: A spice of Tartaria with the features of `amchoor` and `mahleb`. **Only installable via ISO.**


## Installing

### ISO

Since ISOs are stored in GHCR, the tool [Oras](https://oras.land/) is used to upload/download our ISOs.

To make things more convenient for you, the end user, run the following and go through the download process:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tartaria-dev/tartaria/refs/heads/live/iso-downloader.sh)"
```

### Rebasing

To rebase, use the following command in your terminal:

```
sudo bootc switch ghcr.io/tartaria-dev/tartaria:<variant>
```

If you are unsure what variant to choose, please refer to [Variants](https://github.com/tartaria-dev/tartaria#variants).


## Credits
Thank you to the [Bootcrew](https://discord.gg/52Qcb4x2w3) team for making this project possible (and for general help)! I'd also like to thank the [XeniaOS](https://github.com/XeniaMeraki/XeniaOS/) and [Zirconium](https://github.com/zirconium-dev/zirconium/) projects for inspiring the creation of Tartaria!
