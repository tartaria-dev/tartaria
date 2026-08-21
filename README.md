<p align="center">
  <img src="https://raw.githubusercontent.com/tartaria-dev/.github/refs/heads/main/142.svg" alt="Tartaria Logo" width="400">
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch Bootc / Niri / Noctalia</h3>
<p align="center">
  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/833bd2bd-bd2d-4f90-a2d3-80e9f08a6a12" />
</p>


## Description
Tartaria is a custom Arch bootc image built for (optimized) general-day-to-day usage, providing:

- AppArmor application security enabled by default
- An opinionated and mostly GTK-based app suite
- A containerized shell powered by a minimal Arch container
- The Niri scrollable tiling Wayland compositor
- The modern, fluid Noctalia desktop shell

Overall, Tartaria aims to provide a sleek, modern, unobtrusive experience that lets you get your work done.

The name is inspired by my favorite species of cherries, the [Black Tartarian](https://shop.arborday.org/treeguide/210) species - tender, juicy, and sweet.


## Variants
Variants are composed as follows:

```
tartaria:<base>-<flavor>
```

Two bases of Tartaria are built within this repository:

- `stable`: A base of Tartaria built every 72 hours and on every new repository tag (new repository tags are made every release). Considered stable and recommended for usage.
- `unstable`: A base of Tartaria built daily and every time a new change is made. Considered unstable and not recommended for usage, unless you are testing changes and/or like to live on the edge. Be aware that your system may break at any moment in time.

Alongside those bases, we offer two different flavors:

- `arch`: A flavor of Tartaria based on Arch Linux and the Arch kernel. Compatible with all hardware.
- `cachy`: A flavor of Tartaria based on CachyOS-v3 and the CachyOS-v3 kernel. Ensure your CPU supports the [`x86_64-v3`](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) microarchitecture to use this flavor.

In total, there are four different variants of Tartaria:

- `stable-arch`
- `stable-cachy`
- `unstable-arch`
- `unstable-cachy`

Each variant also has a corresponding variant with NVIDIA GPU support, just suffix `-nvidia` to any of the variant names above (e.g., `stable-arch-nvidia`).


## Switching
At the moment, only rebasing is supported - ISO support will come soon. Rebasing from Fedora Silverblue/Kinoite, Aurora, or Bluefin is recommended to prevent unwanted issues, though it doesn't matter.

To rebase, use the following command in your terminal:

`sudo bootc switch ghcr.io/tartaria-dev/tartaria:<variant>`

If you are unsure what variant to choose, please refer to [Variants](https://github.com/tartaria-dev/tartaria#variants).


## Forking
Forking is not recommended for most use cases; you may want to pull this image in your custom image template instead.

If the changes you need to make require a direct fork, however, here's some recommended steps to follow afterwards:

- After forking this repository, go into `.github/workflows` and delete the file `build-tartaria-stable.yml`.
- Then, edit `build-tartaria-unstable.yml` and replace lines 5-7 within the file with the following:

  ```
  pull_request:
    branches:
      - live
    paths-ignore:
      - "**/README.md"
      - "**/.devcontainer.json"
      - "**/cleanup.yml"
      - "**/dependabot.yml"
      - "**/renovate.json5"
      - "**/artifacthub-repo.yml"
  push:
    branches:
      - live
    paths-ignore:
      - "**/README.md"
      - "**/.devcontainer.json"
      - "**/cleanup.yml"
      - "**/dependabot.yml"
      - "**/renovate.json5"
      - "**/artifacthub-repo.yml"
  ```

Note that these steps are NOT required; you may keep the stable workflow if you choose to.


## Credits
Thank you to the [Bootcrew](https://discord.gg/52Qcb4x2w3) team for making this project possible (and for general help)! I'd also like to thank the [XeniaOS](https://github.com/XeniaMeraki/XeniaOS/) and [Zirconium](https://github.com/zirconium-dev/zirconium/) projects for inspiring the creation of Tartaria!
