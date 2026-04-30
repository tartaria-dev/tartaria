<p align="center">
  <img src="https://raw.githubusercontent.com/tartaria-dev/.github/refs/heads/main/142.svg" alt="Tartaria Logo" width="400">
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch Bootc / Niri / Noctalia</h3>
<p align="center">
  <img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/608f2ed5-77e8-4e25-bad8-e3e0b4812f24" />
</p>


## Description
Tartaria is a custom Arch bootc image built for (optimized) general-day-to-day usage, bundled with:

- AppArmor application security enabled by default
- An opinionated and mostly GTK-based app suite
- A containerized shell powered by a minimal Arch container
- The Niri scrollable tiling Wayland compositor
- The modern, fluid Noctalia desktop shell

Tartaria aims to provide a modern and unobtrusive experience for its users that lets them get their work done.

Not too many apps or extra bells and whistles are installed by default, and extra configuration is left up to the user.

The name is inspired by my favorite species of cherries, the [Black Tartarian](https://shop.arborday.org/treeguide/210) species - tender, juicy, and sweet.


## Variants
Two versions of Tartaria are built within this repository:

- `stable`: A version of Tartaria built weekly, or when a release is published. Considered stable and is recommended for usage.
- `unstable`: A version of Tartaria built daily, or every time a change is made. Considered unstable and not recommended for usage, unless you are testing changes and/or like to live on the edge. Be aware that your system may break at any moment in time.

We also offer two different kernel options:

- `arch`: Standard Arch kernel, compatible with all devices.
- `cachy`: Optimized version of the Arch kernel only compatible with CPUs that support the [`x86_64-v3`](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) microarchitecture. Only choose this if you know what you are doing.

In total, there are four different variants of Tartaria:

- `stable-arch`
- `stable-cachy`
- `unstable-arch`
- `unstable-cachy`

Note that all times and dates above are based un the UTC timezone.


## Switching
At the moment, only rebasing (i.e. from Fedora Silverblue) is supported - ISO support will come soon.

To rebase, use the following command in your terminal:

`sudo bootc switch ghcr.io/tartaria-dev/tartaria:<variant>`

If you are unsure as to what variant to choose, please refer to [Variants](https://github.com/tartaria-dev/tartaria#variants).


## Forking
You can absolutely fork this project! There are some extra steps involved, though:

- When forking this repository, select the "live" branch to be cloned from the dropdown - NOT the "dev" branch.
- Once you've forked this repository, go into the `.github/workflows` folder and delete the file `build-tartaria-unstable.yml`.

The reason for these steps is to delete the workflow for the unstable version of Tartaria entirely, something most users won't need.
Note that these steps are NOT required, and you may keep the unstable workflow if you choose to.


## NVIDIA
Support for NVIDIA graphics will not be looked into currently due to the fact that I lack a machine with an NVIDIA card to support/test such changes. Those with such hardware are welcome to contribute changes.


## Credits to...
...the [Bootcrew team](https://discord.gg/52Qcb4x2w3) for making this project possible (and for general help), and the [XeniaOS](https://github.com/XeniaMeraki/XeniaOS/) and [Zirconium](https://github.com/zirconium-dev/zirconium/) projects for inspiring the creation of Tartaria!
