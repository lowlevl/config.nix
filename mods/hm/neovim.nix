# hm/neovim: configure neovim, lsp and tools
{nixvim, ...}: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [nixvim.homeManagerModules.nixvim];

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
        "<leader>d" = "diagnostics";
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
      virtual_lines = true;

      signs = {
        text = config.lib.nixvim.mkRaw ''
          {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰟃"
          }
        '';
      };
    };

    plugins.gitsigns.enable = true;
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
        html
        css
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
        rust_analyzer = {
          enable = true;

          package = null;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;

          settings = {
            cargo.features = "all";

            check = {
              command = "clippy";
              workspace = true;
            };

            assist = {
              emitMustUse = true;
              preferSelf = true;
            };

            diagnostics = {
              experimental.enable = true;
              styleLints.enable = true;
            };
          };
        };

        nil_ls = {
          enable = true;
          settings.formatting.command = ["${lib.getExe pkgs.alejandra}"];
        };

        yamlls = {
          enable = true;

          settings = {
            redhat.telemetry.enabled = false;

            validate = true;
            format.enable = true;
            schemaStore.enable = true;
          };
        };
      };

      keymaps = {
        extra = [
          {
            key = "[d";
            action = config.lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=-1, float=false }) end";
          }
          {
            key = "]d";
            action = config.lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=1, float=false }) end";
          }
        ];

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

    #- Extra plugins configuration

    extraPlugins = let
      modes-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "modes-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "mvllow";
          repo = "modes.nvim";
          rev = "v0.3.0";
          sha256 = "2gvne46/aHzVxcxXXBsdg6wVtlnhowYCKfAn4Wero+8=";
        };
      };
    in [modes-nvim];
    extraConfigLua = ''
      require('modes').setup()
    '';
  };
}
