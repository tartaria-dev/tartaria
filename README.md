<p align="center">
  <img src="system_files/usr/share/pixmaps/tartaria-text-logo.svg" alt="Tartaria Logo" width="450">
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch/CachyOSv3 Bootc | Niri | Noctalia</h3>
<p align="center">
  <img width="1920" height="1080" alt="Desktop image" src="https://github.com/user-attachments/assets/833bd2bd-bd2d-4f90-a2d3-80e9f08a6a12" />
</p>


## Description

Tartaria is a custom Arch/CachyOSv3 bootc image built for general day-to-day usage, providing a nice modern experience that lets you get stuff done.

Note that despite my best efforts, this image is still **largely experimental** as a whole, with some aspects being more so than others.

The name is inspired by the **[Black Tartarian](https://shop.arborday.org/treeguide/210)** cherry species - tastes great, and it sounds cool.


## Variants

In total, Tartaria has sixteen variants. You've got choices.

Variants are composed as `tartaria:<channel>-<edition>-<flavor>`.

### Channels

| Channel    | Description                                                                                            |
|------------|--------------------------------------------------------------------------------------------------------|
| `stable`   | **Built every 72 hours** and on **every new release**; lags slightly behind new changes for stability  |
| `unstable` | **Built daily** and on **every new change**; may break at any moment, so use only for testing          |

### Editions

| Edition | Description                                              |
|---------|----------------------------------------------------------|
| `arch`  | **Arch Linux** with the standard Arch kernel             |
| `cachy` | **CachyOS-v3** with the CachyOS-v3 BORE scheduler kernel |

### Flavors

| Flavor    | Layout                                                                                           | Secure Boot | NVIDIA drivers |
|-----------|--------------------------------------------------------------------------------------------------|:-----------:|:--------------:|
| `berbere` | [Standard](https://docs.fedoraproject.org/uk/bootc/filesystem/)                                  | ✗           | ✗              |
| `amchoor` | [Standard](https://docs.fedoraproject.org/uk/bootc/filesystem/)                                  | ✗           | ✓              |
| `maraska` | [Sealed](https://bootc.dev/bootc/bootc-experimental-composefs.7.html#how-sealed-images-work)     | ✓           | ✗              |
| `saffron` | [Sealed](https://bootc.dev/bootc/bootc-experimental-composefs.7.html#how-sealed-images-work)     | ✓           | ✓              |

### Notes

**[Standard](https://bootc.dev/bootc/bootc-filesystem.7.html)** images are only installable via rebasing.

**[Sealed](https://bootc.dev/bootc/bootc-experimental-composefs.7.html#how-sealed-images-work)** images are only installable via ISO, **and are highly experimental.**

You **cannot** rebase to a sealed image, and **cannot** install a standard image via ISO.


## Installing

### ISO

ISO installation is **highly experimental**. Install with caution and an expectation for something to go **kaboom**.

Run the following in a Linux terminal and go through the selection/download process:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tartaria-dev/tartaria/refs/heads/live/iso-downloader.sh)"
```

On first boot, you will see a prompt for enrolling MOK keys; `maraska` has one key, `saffron` has two.

They are necessary for Secure Boot to work, so enroll them. The passwords for both are `tartaria`.

### Rebasing

If you are already running an OS such as Fedora Atomic or one of the Universal Blue projects, you can rebase with one of the following commands:

```
bootc switch ghcr.io/tartaria-dev/tartaria:<variant> # fedora atomic and universal blue projects
```
```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/tartaria-dev/tartaria:<variant> # fedora atomic only
```

### Notes

Refer to the **[Variants](https://github.com/tartaria-dev/tartaria#Variants)** section above for choosing a variant.

Ensure you choose the **correct installation method** for the variant you choose, **otherwise things can and will go kaboom.**


## Credits

Thank you to the **[Bootcrew](https://discord.gg/52Qcb4x2w3)** team for making this project possible (and for general help)!

I'd also like to thank the super duper cool **[XeniaOS](https://github.com/XeniaMeraki/XeniaOS/)** and **[Zirconium](https://github.com/zirconium-dev/zirconium/)** projects for inspiring the creation of Tartaria!


## Stars

<a href="https://www.star-history.com/?repos=tartaria-dev%2Ftartaria&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=tartaria-dev/tartaria&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=tartaria-dev/tartaria&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=tartaria-dev/tartaria&type=date&legend=top-left" />
 </picture>
</a>
