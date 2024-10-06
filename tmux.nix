# Extremely heavily inspired by https://gitlab.com/hmajid2301/nixicle/-/blob/main/modules/home/cli/multiplexers/tmux/default.nix
{ pkgs, lib, ... }:

{
  # options.cli.multiplexers.tmux = with types; {
  #   enable = mkBoolOpt false "enable tmux multiplexer";
  # };

  home.packages = with pkgs; [
    # sesh
    # lsof
    # # for tmux super fingers
    # python311
    tmux-sessionizer
  ];

  programs.tmux = {
    enable = true;
    # shell = "${pkgs.bash}/bin/bash";
    terminal = "tmux-256color";
    historyLimit = 100000;
    keyMode = "vi";
    prefix = "C-a";
    sensibleOnTop = true;
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      better-mouse-mode
      yank
      tmux-thumbs
      # {
      #   plugin = mkTmuxPlugin {
      #     pluginName = "tmux-super-fingers";
      #     version = "unstable-2023-10-03";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "artemave";
      #       repo = "tmux_super_fingers";
      #       rev = "518044ef78efa1cf3c64f2e693fef569ae570ddd";
      #       sha256 = "1710pqvjwis0ki2c3mdrp2zia3y3i8g4rl6v42pg9nk4igsz39w8";
      #     };
      #   };
      #   extraConfig = ''
      #     set -g @super-fingers-key F
      #   '';
      # }
      {
        plugin = mkTmuxPlugin {
          pluginName = "tmux.nvim";
          version = "unstable-2024-02-12";
          src = pkgs.fetchFromGitHub {
            owner = "aserowy";
            repo = "tmux.nvim";
            rev = "9c02adf16ff2f18c8e236deba91e9cf4356a02d2";
            sha256 = "0lg3zcyd76qfbz90i01jwhxfglsnmggynh6v48lnbz0kj1prik4y";
          };
        };
      }
      # must be before continuum edits right status bar
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_modules_right "directory meetings date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{pane_current_path}"
          # set -g @catppuccin_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
          set -g @catppuccin_date_time_text "%H:%M"
          set -g status-position bottom
        '';
      }
      {
        plugin = resurrect;
        extraConfig =
          ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-save 'S'
            set -g @resurrect-restore 'R'
          ''
          + ''
            # Taken from: https://github.com/p3t33/nixos_flake/blob/5a989e5af403b4efe296be6f39ffe6d5d440d6d6/home/modules/tmux.nix
            resurrect_dir="$XDG_CACHE_HOME/.tmux/resurrect"
            set -g @resurrect-dir $resurrect_dir

            set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'
          '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      set-environment -g TMUX_PLUGIN_MANAGER_PATH '~/.local/share/tmux/plugins'

      # I thinhk the config does this
      # unbind C-b
      # bind-key C-a send-prefix

      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r H resize-pane -L 5
      bind -r L resize-pane -R 5

      # Address vim mode switching delay (http://superuser.com/a/252717/65504)
      set -s escape-time 50

      # Increase tmux messages display duration from 750ms to 4s
      set -g display-time 4000

      # Refresh 'status-left' and 'status-right' more often, from every 15s to 5s
      set -g status-interval 5

      # Emacs key bindings in tmux command prompt (prefix + :) are better than
      # vi keys, even for vim users
      set -g status-keys emacs

      # Focus events enabled for terminals that support them
      set -g focus-events on

      # Super useful when using "grouped sessions" and multi-monitor setup
      setw -g aggressive-resize on

      set -g base-index 1

      # bind-key -r s display-pop -E "tms"
      bind-key -r s display-pop -E "tms switch"

      # forget the find window.  That is for chumps
      # bind-key f run-shell "tmux neww ~/.local/scripts/tmux-sessionizer"
      bind-key f display-pop -E "tms"
      # bind-key i run-shell "tmux neww ~/.local/scripts/tmux-cht.sh"

      set -g status-right " #(tms sessions)"
      bind -r '(' switch-client -p\; refresh-client -S
      bind -r ')' switch-client -n\; refresh-client -S

      unbind x
      bind-key x confirm-before -p "Kill #S (y/n)?" "run-shell 'tmux switch-client -n \\\; kill-session -t \"#S\"'"

      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # Clear history
      bind C-k clear-history

      # Set CWD
      bind C-d attach-session -c "#{pane_current_path}"

      set -g @themepack-status-left-area-middle-format "#(whoami)"
    '';
  };
}
