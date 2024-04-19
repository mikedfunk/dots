# dotfiles

## TL;DR

```
curl https://raw.githubusercontent.com/mikedfunk/dots/master/install.sh | sh
```

My Bash, Neovim ([LazyVim](https://www.lazyvim.org)), Git, and other dotfiles. Managed by [yadm](https://thelocehiliosan.github.io/yadm/docs).

Dark mode:

<img width="2560" alt="Screenshot 2024-04-19 at 11 58 58 AM" src="https://github.com/mikedfunk/dots/assets/661038/1339be46-bd53-4c19-9ae2-b879aad1878d">


Light mode:

<img width="2560" alt="Screenshot 2024-04-19 at 11 59 16 AM" src="https://github.com/mikedfunk/dots/assets/661038/67825b45-9ffb-4d98-82f7-0fcc211bb5fd">


## Key files, annotated

- [Yadm bootstrap file - script to install/upgrade everything](.config/yadm/bootstrap)
- [Homebrew packages, casks, and mac store apps](Brewfile)
- [Lazyvim config](.config/nvim/lua/config/lazy.lua)
- Luasnip php snippets: [lua](.config/nvim/luasnippets/php.lua) and [json](.config/nvim/snippets/php.json)
- [Zshrc](.zshrc), [Zsh plugins](.zsh_plugins.txt)
- [P10k prompt config](.p10k.zsh)
- [Git config](.config/git/config), [Tig config](.config/tig/config)
- [Tmux config and tmux plugins](.config/tmux/tmux.conf), [Home smug layout](.config/smug/home.yml)
