{ pkgs, lib, ... }:

let
  fromGitHub = ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
in

  {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      (fromGitHub "HEAD" "bluz71/vim-moonfly-colors")
      vim-sleuth
      gitsigns-nvim
      which-key-nvim
      ts-comments-nvim
      conform-nvim
      todo-comments-nvim
      mini-nvim
      oil-nvim
      nvim-autopairs
      nvim-ts-autotag

      nvim-cmp
      # nvim-cmp deps
      luasnip
      friendly-snippets
      cmp_luasnip
      cmp-nvim-lsp
      cmp-path

      typescript-tools-nvim

      nvim-lspconfig # Also needed by typescript-tools-nvim
      # nvim-lspconfig dps
      fidget-nvim
      cmp-nvim-lsp

      lazydev-nvim
      # lazydev deps
      (fromGitHub "HEAD" "Bilal2453/luvit-meta")

      telescope-nvim
      # telescope  deps
      plenary-nvim
      telescope-fzy-native-nvim
      telescope-ui-select-nvim
      nvim-web-devicons
      (fromGitHub "HEAD" "nvim-telescope/telescope-live-grep-args.nvim")

      # Totally going to work dap stuff
      nvim-dap
      nvim-dap-ui
      nvim-dap-go
      (fromGitHub "HEAD" "Weissle/persistent-breakpoints.nvim")
      nvim-dap-virtual-text
      (fromGitHub "HEAD" "ldelossa/nvim-dap-projects")
    ];

    extraPackages = with pkgs; [
      fzf # Used by telescope
      ripgrep # Used by telescope
      stylua # Used to format lua
      lua-language-server
      nil # nix LSP
      typescript-language-server # TS/JS lsp
      nixfmt-rfc-style # Nix formatter

      # Daps
      delve # Go debugger
      vscode-js-debug # JS/TS debugger by M$
    ];
  };
}
