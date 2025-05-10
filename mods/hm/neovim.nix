# hm/neovim: configure neovim, lsp and tools
{inputs, pkgs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    clipboard.register = "unnamedplus";

    opts = {
      number = true;
      relativenumber = true;

      expandtab = true;
      autoindent = true;
      smartindent = true;

      shiftwidth = 2;

      list = true;
      listchars = "trail:◦";
    };

    plugins.comment.enable = true;
    plugins.todo-comments.enable = true;

    plugins.treesitter = {
      enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        c
        cpp
        rust
        nix
        yaml
        toml
        javascript
      ];

      settings = {
        incremental_selection.enable = true;
        highlight.enable = true;
        highlight.additional_vim_regex_highlighting = false;
        indent.enable = true;
      };
    };

    plugins.crates-nvim.enable = true;
    # plugins.rustaceanvim.enable = true;

    plugins.lsp-signature.enable = true;
    plugins.lsp-status.enable = true;
    plugins.lsp-lines.enable = true;
    plugins.lsp = {
      enable = true;

      servers = {
        yamlls.enable = true;

        nil_ls = {
          enable = true;
          settings.formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
        };

        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
        };
      };

      keymaps = {
        lspBuf = {
          "K" = "hover";
          "F" = "format";
          "gd" = "definition";
          "gi" = "implementation";
          "gt" = "type_definition";
        };
      };
    };

    extraPlugins = [pkgs.vimPlugins.gruvbox];
    colorscheme = "gruvbox";
  };
}
