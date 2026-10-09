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
Tartaria is a custom Arch/CachyOSv3 bootc image built for general-day-to-day usage, providing a nice modern experience that lets you get stuff done.

The name is inspired by the **[Black Tartarian](https://shop.arborday.org/treeguide/210)** cherry species - tender, juicy, and sweet. Also sounds cool.


## Variants

In total, there are sixteen variants of Tartaria.

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

- `berbere`: **[Standard](https://bootc.dev/bootc/bootc-filesystem.7.html)** image layout with nothing extra.
- `amchoor`: **[Standard](https://bootc.dev/bootc/bootc-filesystem.7.html)** image layout with preinstalled NVIDIA drivers.
- `maraska`: **[Sealed](https://bootc.dev/bootc/bootc-experimental-composefs.7.html#how-sealed-images-work)** image layout with Secure Boot support.
- `saffron`: **[Sealed](https://bootc.dev/bootc/bootc-experimental-composefs.7.html#how-sealed-images-work)** image layout with Secure Boot support and preinstalled NVIDIA drivers.

### Notes

**[Standard](https://bootc.dev/bootc/bootc-filesystem.7.html)** images are only installable via rebasing. **[Sealed](https://bootc.dev/bootc/bootc-experimental-composefs.7.html#how-sealed-images-work)** images are only installable via ISO, **and are highly experimental.** You cannot rebase to a sealed image, and cannot install a standard image via ISO.


## Installing

### ISO

> [!WARNING]
> ISO installation is highly experimental. Install with caution and an expectation for something to go **kaboom**.

> [!IMPORTANT]
> When booting Tartaria after ISO installation, you will see a prompt for enrolling MOK keys (`maraska` has one key, `saffron` has two). They are necessary for Secure Boot to work, so enroll them. The passwords for both are `tartaria`.

Run the following in a Linux terminal and go through the selection/download process:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tartaria-dev/tartaria/refs/heads/live/iso-downloader.sh)"
```

### Rebasing

> [!IMPORTANT]
> Standard variants have no secure boot support at the moment, but may come in the future once ISO installation is available for them.

If you are already running an OS such as Fedora Atomic or one of the Universal Blue projects, you can rebase with one of the following commands:

```
bootc switch ghcr.io/tartaria-dev/tartaria:<variant> # fedora atomic and universal blue projects
```
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/tartaria-dev/tartaria:<variant> # fedora atomic only
```

### Notes

Refer to the **[Variants](https://github.com/tartaria-dev/tartaria#Variants)** section above for choosing a variant. Ensure you choose the **correct installation method** for the variant you choose, **otherwise unexpected behavior can occur.**


## Credits
Thank you to the **[Bootcrew](https://discord.gg/52Qcb4x2w3)** team for making this project possible (and for general help)! I'd also like to thank the (now archived :<) **[XeniaOS](https://github.com/XeniaMeraki/XeniaOS/)** and (not archived :>) **[Zirconium](https://github.com/zirconium-dev/zirconium/)** projects for inspiring the creation of Tartaria!


## Metrics
![Alt](https://repobeats.axiom.co/api/embed/e1ddc95a13421c83c1bb9958fb3fc28c8fb02cce.svg "Repobeats analytics image")
