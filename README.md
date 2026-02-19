<p align="center">
  <img src="https://raw.githubusercontent.com/tartaria-dev/.github/refs/heads/main/142.svg" alt="Tartaria Logo" width="400">
</p>
<h3 align="center">/tɑːrˈtɛəriə/</h3>
<h3 align="center">Arch Bootc / Niri / Noctalia</h3>
<p align="center">
  <img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/b501237a-7b30-4949-985a-f2314a9107a9" />
</p>

<br>

<h1 align="center">What's Tartaria?</h1>
<p align="center">A custom Arch bootc image with the standard CachyOS kernel built for (optimized) general day-to-day usage, bundled with an opinionated and mostly GTK-based app suite, a containerized shell powered by a minimal Arch container (it's got some bells and whistles, don't worry), the Niri scrollable tiling Wayland compositor (ooo, infinite scrolling), and the Noctalia desktop shell - featureful, but made to stay out of your way (and very pretty).</p>

<br>

<h1 align="center">What inspired the name?</h1>
<p align="center">My favorite species of cherries, the <a href="https://shop.arborday.org/treeguide/210">Black Tartarian</a> species - tender, juicy, and sweet.</p>

<br>

<h1 align="center">How can I switch?</h1>
<p align="center">At the moment, only rebasing is supported. Rebasing from <a href="https://github.com/XeniaMeraki/XeniaOS/tree/main">XeniaOS</a> or <a href="https://github.com/zirconium-dev/zirconium/">Zirconium</a> is highly encouraged.<br>
ISO support will come soon.<br>
Before you rebase, however, please check if your CPU supports the <code>x86_64-v3</code> microarchitecture - this is necessary for reasons detailed under the Notice section.<br>
You may check by running the following command in your terminal:</p>

<div align="center">

`/lib/ld-linux-x86-64.so.2 --help | grep -F "v3 (supported, searched)"`

</div>

<p align="center">If the above command produced no output, you cannot run Tartaria. Sorry!<br>
If it did, however, you're good to go!</p>

<p align="center">To rebase, use the following command in your terminal:</p>

<div align="center">

`sudo bootc switch ghcr.io/tartaria-dev/tartaria`

</div>

<p align="center">...and you'll be on your (jolly) way!</p>

<br>

<h1 align="center">Notice</h1>
<p align="center">This OS is only compatible and intended for devices with AMD/Intel graphics, and the kernel has optimizations for CPUs supporting the <a href="https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels"><code>x86_64-v3</code></a> microarchitecture level.<br>
Due to such optimizations by the kernel, this custom image will only work on CPUs supporting the aforementioned microarchitecture level.<br>
Support for the <a href="https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels"><code>znver4</code></a> and <a href="https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels"><code>x86-64_v4</code></a> microarchitecture levels are being considered.<br>
Support for NVIDIA graphics will not be looked into under any circumstances; I will leave that to the user to integrate into a fork of Tartaria (sorry).</p>

<br>

<h1 align="center">Thanks!</h1>
<p align="center">Many thanks to the <a href="https://discord.gg/52Qcb4x2w3">Bootcrew Discord</a> for general help/support and the <a href="https://github.com/XeniaMeraki/XeniaOS/tree/main">XeniaOS</a> and <a href="https://github.com/zirconium-dev/zirconium/">Zirconium</a> projects for inspiring the creation of Tartaria!</p>
