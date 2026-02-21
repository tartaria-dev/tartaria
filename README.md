<p align="center">
  <img src="https://raw.githubusercontent.com/tartaria-dev/.github/refs/heads/main/142.svg" alt="Tartaria Logo" width="400">
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch Bootc / Niri / Noctalia</h3>
<p align="center">
  <img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/b501237a-7b30-4949-985a-f2314a9107a9" />
</p>


## What's Tartaria?
Tartaria is a custom Arch bootc image built for (optimized) general-day-to-day usage.
Bundled with:

- the standard CachyOS kernel (`linux-cachyos`),
- AppArmor application security enabled by default,
- an opinionated and mostly GTK-based app suite,
- a containerized shell powered by a minimal Arch container,
- the Niri scrollable tiling Wayland compositor,
- and the modern, fluid Noctalia desktop shell,

Tartaria aims to provide a modern and unobtrusive experience for its users that lets them get their work done.
Not many apps or extra bells and whistles are installed by default, as extra configuration is left up to the user.
The name is inspired by my favorite species of cherries, the [Black Tartarian](https://shop.arborday.org/treeguide/210) species - tender, juicy, and sweet.


## How can I switch?
At the moment, only rebasing (e.g. from Fedora Silverblue) is supported - ISO support will come soon.

Before you rebase, however, please check if your CPU supports the [`x86_64-v3`](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) microarchitecture level - this is necessary for reasons detailed under the Notice section.

You may check by running the following command in your terminal:

`/lib/ld-linux-x86-64.so.2 --help | grep -F "v3 (supported, searched)"`

If the above command produced no output, you cannot run Tartaria. Sorry!

If it did, however, you're good to go!

To rebase, use the following command in your terminal:

`sudo bootc switch ghcr.io/tartaria-dev/tartaria`

...and you'll be on your (jolly) way!


## Notice
This OS is only compatible and intended for devices with AMD/Intel graphics, and the kernel has optimizations for CPUs supporting the [`x86_64-v3`](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) microarchitecture level.

Due to these kernel optimizations, this custom image will only work on CPUs that support the [`x86_64-v3`](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) microarchitecture level.

Support for the [`x86_64-v4`](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) and [`znver4`](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels) microarchitecture levels is being considered.

Support for NVIDIA graphics will not be looked into under any circumstances; I will leave that to the user to integrate into a fork of Tartaria.


## Thanks!
Many thanks to the [Bootcrew team](https://discord.gg/52Qcb4x2w3) for making this project possible (and for general help), and the [XeniaOS](https://github.com/XeniaMeraki/XeniaOS/) and [Zirconium](https://github.com/zirconium-dev/zirconium/) projects for inspiring the creation of Tartaria!
