# dotfiles

## TL;DR

```
curl https://raw.githubusercontent.com/mikedfunk/dots/master/install.sh | sh
```

My Bash, Neovim ([LazyVim](https://www.lazyvim.org)), Git, and other dotfiles. Managed by [yadm](https://thelocehiliosan.github.io/yadm/docs).

Dark mode:

![Screen Shot 2022-04-12 at 8 52 24 PM](https://user-images.githubusercontent.com/661038/163096875-7340f006-2855-4dd1-ba67-9f514317d328.png)

Light mode:

![Screen Shot 2022-04-12 at 8 52 55 PM](https://user-images.githubusercontent.com/661038/163096859-651baedc-8bb2-4f4d-96d7-62e320346f80.png)

## Key files, annotated

- [Yadm bootstrap file - script to install/upgrade everything](.config/yadm/bootstrap)
- [Homebrew packages, casks, and mac store apps](Brewfile)
- [Lazyvim config](.config/nvim/lua/config/lazy.lua)
- Luasnip php snippets: [lua](.config/nvim/luasnippets/php.lua) and [json](.config/nvim/snippets/php.json)
- [Zshrc](.zshrc), [Zsh plugins](.zsh_plugins.txt)
- [P10k prompt config](.p10k.zsh)
- [Git config](.config/git/config), [Tig config](.config/tig/config)
- [Tmux config and tmux plugins](.tmux.conf), [Home smug layout](.config/smug/home.yml)
