<p align="center">
  <img src="https://raw.githubusercontent.com/tartaria-dev/.github/refs/heads/main/142.svg" alt="Tartaria Logo" width="400">
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch Bootc / Niri / Noctalia</h3>
<p align="center">
  <img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/608f2ed5-77e8-4e25-bad8-e3e0b4812f24" />
</p>


## Description
Tartaria is a custom Arch bootc image built for (optimized) general-day-to-day usage, providing:

- AppArmor application security enabled by default
- An opinionated and mostly GTK-based app suite
- A containerized shell powered by a minimal Arch container
- The Niri scrollable tiling Wayland compositor
- The modern, fluid Noctalia desktop shell

Overall, Tartaria aims to provide a sleek, modern, unobtrusive experience for its users that lets them get their work done.

The name is inspired by my favorite species of cherries, the [Black Tartarian](https://shop.arborday.org/treeguide/210) species - tender, juicy, and sweet.


## Variants
Two versions of Tartaria are built within this repository:

- `stable`: A version of Tartaria built twice a week on Wed/Sat, or when a release is published, based on the latest repository tag. Considered stable and recommended for usage.
- `unstable`: A version of Tartaria built daily, or every time a new change is made. Considered unstable and not recommended for usage, unless you are testing changes and/or like to live on the edge. Be aware that your system may break at any moment in time.

We also offer two different kernel options:

- `arch`: Standard Arch kernel, compatible with all devices.
- `cachy`: Optimized version of the Arch kernel only compatible with CPUs that support the [`x86_64-v3`](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) microarchitecture. Only choose this if you know what you are doing.

In total, there are four different variants of Tartaria:

- `stable-arch`
- `stable-cachy`
- `unstable-arch`
- `unstable-cachy`

Each variant also has a corresponding variant with NVIDIA GPU support, just suffix `-nvidia` to any of the variant names above (e.g. `stable-cachy-nvidia`).

Note that all times and dates above are based on UTC.


## Switching
At the moment, only rebasing is supported - ISO support will come soon. Rebasing from Fedora Silverblue/Kinoite, Aurora, or Bluefin is recommended to prevent unwanted issues, though it doesn't matter.

To rebase, use the following command in your terminal:

`sudo bootc switch ghcr.io/tartaria-dev/tartaria:<variant>`

If you are unsure what variant to choose, please refer to [Variants](https://github.com/tartaria-dev/tartaria#variants).


## Forking
After forking, you may want to remove the workflow for the unstable version of Tartaria, since most users won't need it. To do so, perform the following:

- After forking this repository, go into `.github/workflows` and delete the file `build-tartaria-unstable.yml`.
- Then, edit `build-tartaria-stable.yml` and replace lines 5-7 within the file with the following:

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

Note that these steps are NOT required; you may keep the unstable workflow if you choose to.


## Credits
Thank you to the [Bootcrew team](https://discord.gg/52Qcb4x2w3) for making this project possible (and for general help)! I'd also like to thank the [XeniaOS](https://github.com/XeniaMeraki/XeniaOS/) and [Zirconium](https://github.com/zirconium-dev/zirconium/) projects for inspiring the creation of Tartaria!
