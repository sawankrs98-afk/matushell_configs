# Portable Vim for C and C++

This is plain Vimscript and works across Linux distributions. Open a file with:

```sh
vim -u /path/to/config_new/vim/vimrc main.cpp
```

The color scheme lives beside the config, so it travels with this folder. The
built-in file browser and editor features work without extra plugins. FZF
file/search pickers and clangd completion are enabled when their Vim plugins
are installed.

## C++ tools

Install these with your Linux distribution's package manager:

- GCC or Clang to compile and run C/C++ files
- `clang-format` for formatting
- `clangd` and the `vim-lsp` Vim plugin for C++ completion/navigation
- `fzf` and the `fzf.vim` Vim plugin for fuzzy file/search pickers
- `cppcheck` for the `Space cp` check
- `make` for projects with a Makefile

Use your distro's package names; they vary. Keep this `vim` folder in your
config repository and copy it to the next machine to carry the editor setup
across Linux installs.

## C++ keys

The leader key is Space. `Space cb` compiles, `Space cr` compiles and runs,
`Space ch` switches between a source and matching header, `Space cp` runs
cppcheck, and `Space cf` formats the current file. In insert mode, `Ctrl-Space`
requests clangd completion. Without a Makefile, compilation uses C++20,
warnings, and debug symbols.
