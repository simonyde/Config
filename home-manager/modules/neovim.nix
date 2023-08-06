{ config, pkgs, ... }:
let
  unstablePlugins = pkgs.unstable.vimPlugins;
in
{
  programs.neovim = {
    package = pkgs.unstable.neovim-unwrapped;
    vimAlias = true;
    viAlias = true;
    extraConfig = ''
      set runtimepath^=${config.home.homeDirectory}/.config/nvim
      lua require('syde')
    '';
    plugins = with pkgs.vimPlugins; [
      # LSP
      nvim-lspconfig
      lspkind-nvim
      lspsaga-nvim
      nvim-cmp
      cmp-cmdline
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp_luasnip
      luasnip
      fidget-nvim
      copilot-lua

      harpoon
      nvim-autopairs
      undotree
      vim-fugitive
      gitsigns-nvim
      nvim-surround
      comment-nvim

      which-key-nvim
      vim-be-good

      # Fuzzy Finder
      unstablePlugins.telescope-nvim
      unstablePlugins.plenary-nvim

      # Language plugins
      unstablePlugins.nvim-treesitter.withAllGrammars
      unstablePlugins.nvim-treesitter-textobjects
      unstablePlugins.nvim-treesitter-context
      unstablePlugins.telescope-fzf-native-nvim
      nvim-ts-rainbow2
      ltex_extra-nvim

      # UI
      lualine-nvim
      indent-blankline-nvim
      nvim-web-devicons
      nvim-tree-lua
      nui-nvim
      catppuccin-nvim
    ];
  };
}
