<div align="center">
  <h1>Jellyfish</h1>
  <p>🪼 A simple <b>one-source</b> zig <b>IDE</b> targeted towards algorithmics. 🪼</p>
</div>

<div align="center">
  <img src="https://github.com/user-attachments/assets/51a9b1b7-d3f7-42ef-89ff-44a210bee80d" width="100%">
</div>

# 📖 About
This is mainly a project to further develop my skills in `zig` and `web technologies` and try out `webui`. 
It is very targeted towards algorithmics and will probably never become more than that (but I do have other fun stuff in the oven 😋). 
Any contributions are welcome as long as they do not drastically change the scope of the project.

# 🔧 HOW TO BUILD
For now we only support `linux` but `windows` and `macos` should be out soon. (`macos` could be made to run with minimal tweaks)
  
## 🐧 Linux
### ⚙️ Prerequisites
```
zig 0.13.0
bun (nodejs could also work with some tweaks)
wget tar
firefox (can be changed inside main.zig)
```
### ⚡ Running
```bash
git clone https://github.com/OsakiTsukiko/jellyfish
cd jellyfish
cd ui
bun install
bun add-zig-linux
bun run run
```
  
## 🪟 Windows
SOON

## 🍏 MacOS
SOON  

# 🗺️ TODO:
- [ ] Monaco Editor
  - [X] `ZIG` highlighting
  - [ ] More Themes
- [ ] Multiplayer
- [ ] Zig
  - [X] Run
  - [ ] Compile (and download?)
  - [X] Compiler arguments
  - [ ] Custom zig arguments
  - [X] Pre command wrapper
  - [ ] ?testing
- [ ] Cross Platform
  - [X] Linux
  - [ ] Windows
  - [ ] MacOS
- [X] Package:
  - [X] Indexed Archive (Scroll)
- [ ] Quality Of Life Impv.
  - [ ] Disable CTRL + S 

# [🪼 GALLERY](https://github.com/OsakiTsukiko/jellyfish/blob/main/GALLERY.md)
