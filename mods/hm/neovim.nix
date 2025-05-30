# hm/neovim: configure neovim, lsp and tools
{nixvim, ...}: {pkgs, ...}: let
  modes-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "modes-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mvllow";
      repo = "modes.nvim";
      rev = "v0.3.0";
      sha256 = "2gvne46/aHzVxcxXXBsdg6wVtlnhowYCKfAn4Wero+8=";
    };
  };
in {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    opts = {
      background = "dark";

      number = true;
      relativenumber = true;

      expandtab = true;
      autoindent = true;
      smartindent = true;

      shiftwidth = 2;

      list = true;
      listchars = "trail:◦,tab:↠ ";
    };

    colorschemes.nightfox = {
      enable = true;
      flavor = "terafox";
    };

    clipboard.register = "unnamedplus";

    plugins.comment.enable = true;
    plugins.todo-comments.enable = true;

    plugins.lualine = {
      enable = true;
    };

    plugins.web-devicons.enable = true;
    plugins.telescope = {
      enable = true;

      keymaps = {
        "<leader>fg" = "live_grep";
        "<C-p>" = "git_files";
      };
    };

    plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap.preset = "enter";

        completion = {
          accept.auto_brackets.enabled = true;

          documentation.auto_show = true;

          list.selection.auto_insert = false;
          ghost_text.enabled = true;
        };

        signature.enabled = true;
      };
    };

    #- Language servers and highlighting

    diagnostic.settings = {
      severity_sort = true;
      virtual_lines = {
        only_current_line = true;
      };
    };

    plugins.crates.enable = true;
    plugins.treesitter = {
      enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        c
        cpp
        rust
        nix
        json
        yaml
        toml
      ];

      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
        indent.enable = true;
        incremental_selection.enable = true;
      };
    };

    plugins.lsp-signature.enable = true;
    plugins.lsp-status.enable = true;
    plugins.lsp-format.enable = true;
    plugins.lsp-lines.enable = true;
    plugins.lsp = {
      enable = true;

      inlayHints = true;

      servers = {
        yamlls.enable = true;
        tilt_ls.enable = true;

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
        diagnostic = {
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };

        lspBuf = {
          "K" = "hover";
          "F" = "format";
          "T" = "type_definition";
          "gD" = "references";
          "ca" = "code_action";
          "gd" = "definition";
          "gi" = "implementation";
          "rn" = "rename";
        };
      };
    };

    #- Misc

    extraPlugins = [modes-nvim];
    extraConfigLua = ''
      require('modes').setup()
    '';
  };
}
