{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  mapLazy = map (pkg: {
    plugin = pkg;
    optional = true;
  }); # Takes a list of plugins and maps them to load lazily
  cfg = config.programs.neovim;
in
{
  config = mkIf cfg.enable {
    programs.neovim = {
      package = pkgs.neovim;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      viAlias = true;
      withRuby = false;
      withNodeJs = false;
      withPython3 = false;
      plugins =
        with pkgs.vimPlugins;
        [
          # -----LSP-----
          nvim-lspconfig
          tip-vim

          # -----Completion-----
          friendly-snippets
          lazydev-nvim

          # -----Workflow-----
          nvim-autopairs
          mini-nvim
          snacks-nvim
          vim-sleuth
          undotree

          obsidian-nvim
          image-nvim

          # -----UI-----
          which-key-nvim
          nvim-treesitter
        ]
        ++ mapLazy [
          # ----- Completion -----
          blink-cmp
          blink-compat

          # ----- Workflow -----
          conform-nvim
          luvit-meta
          trouble-nvim
          diffview-nvim
          neogit
          todo-comments-nvim
          img-clip-nvim

          nvim-ufo
          nvim-dap
          nvim-dap-ui

          # ----- UI -----
          lspsaga-nvim
          indent-blankline-nvim
          render-markdown-nvim
          nvim-treesitter-textobjects
          nvim-treesitter-context
          rainbow-delimiters-nvim
        ];
      extraLuaConfig =
        with config.syde.theming.palette-hex; # lua
        ''
          vim.loader.enable()
          _G.VARIANT = "${config.colorScheme.variant}"
          _G.PALETTE = {
            base00 = "${base00}", base01 = "${base01}", base02 = "${base02}", base03 = "${base03}",
            base04 = "${base04}", base05 = "${base05}", base06 = "${base06}", base07 = "${base07}",
            base08 = "${base08}", base09 = "${base09}", base0A = "${base0A}", base0B = "${base0B}",
            base0C = "${base0C}", base0D = "${base0D}", base0E = "${base0E}", base0F = "${base0F}",
          }
          _G.Config = { }
          require('syde')
        '';
    };
  };
}
