# dotfiles

## TL;DR

```
curl https://raw.githubusercontent.com/mikedfunk/dots/master/install.sh | sh
```

My Bash, Neovim ([LazyVim](https://www.lazyvim.org)), Git, and other dotfiles. Managed by [yadm](https://thelocehiliosan.github.io/yadm/docs).

Dark mode:

<img width="2560" alt="Screenshot 2024-05-13 at 1 49 13 PM" src="https://github.com/mikedfunk/dots/assets/661038/16bb53de-46d5-4f90-a0ed-3d198b391642">

Light mode:

<img width="2560" alt="Screenshot 2024-05-13 at 1 49 43 PM" src="https://github.com/mikedfunk/dots/assets/661038/e54a29ae-d6bc-4e8e-95f5-19bc968d192c">

## Key files, annotated

- [Yadm bootstrap file - script to install/upgrade everything](.config/yadm/bootstrap)
- [Homebrew packages, casks, and mac store apps](Brewfile)
- [Lazyvim config](.config/nvim/lua/config/lazy.lua) ([more info](https://dotfyle.com/mikedfunk/dots-config-nvim))
- Luasnip php snippets: [lua](.config/nvim/luasnippets/php.lua) and [json](.config/nvim/snippets/php.json)
- [Zshrc](.zshrc), [Zsh plugins](.zsh_plugins.txt)
- [P10k prompt config](.p10k.zsh)
- [Git config](.config/git/config), [Tig config](.config/tig/config)
- [Tmux config and tmux plugins](.config/tmux/tmux.conf), [Home smug layout](.config/smug/home.yml)
