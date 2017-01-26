with import <nixpkgs> {};
with import <nixhome> { inherit stdenv; inherit pkgs; };
let

  copyFilesInstallPhase = ''
    mkdir $out
    cp -a . $out
  '';

  dotfiles = stdenv.mkDerivation {
    name = "alibabzo-dotfiles";
    src = fetchFromGitHub {
      rev = "66dbdc47faa403917cd03b77e60ef3488404c6dd";
      repo = "dotfiles";
      owner = "alibabzo";
      sha256 = "1mbxkj3fl06a2r3ia6n4kyylz4qlbg1pvl6cxwyw34rr7lfxz5wv";
    };
    installPhase = copyFilesInstallPhase;
  };

  dein = stdenv.mkDerivation {
    name = "dein.vim";
    src = fetchFromGitHub {
      rev = "a825907ccc9d8be149bd6b2ea4fde014fbd6ca27";
      repo = "dein.vim";
      owner = "Shougo";
      sha256 = "1a94vis0jsankb3rq2qlmwwpqqa1n2zayqik1m4vlv9yyjspyawj";
    };
    installPhase = copyFilesInstallPhase;
  };
in
  mkHome {
    user = "alistair";
    files = {

      # neovim
      ".config/nvim/init.vim" = "${dotfiles}/nvim/.config/nvim/init.vim";
      ".cache/dein/repos/github.com/Shougo/dein.vim" = "${dein}";

      # xmonad
      ".xmonad/xmonad.hs" = "${dotfiles}/xmonad/.xmonad/xmonad.hs";
      ".xmonad/xmobar.hs" = "${dotfiles}/xmonad/.xmonad/xmobar.hs";

      # compton
      ".config/compton.conf" = "${dotfiles}/compton/.config/compton.conf";

      # rofi
      ".config/rofi/launcher" = "${dotfiles}/rofi/.config/rofi/launcher";

      # gtk
      ".themes/Arc-Dark" = "${pkgs.arc-theme}/share/themes/Arc-Dark";
      ".themes/Arc-Darker" = "${pkgs.arc-theme}/share/themes/Arc-Darker";

      # icons
      ".icons/Paper" = "${pkgs.paper-icon-theme}/share/icons/Paper";

      # termite
      ".config/termite/config-dark" = "${dotfiles}/termite/.config/termite/config-dark";
      ".config/termite/config-light" = "${dotfiles}/termite/.config/termite/config-light";

      # xkb
      ".xkb/symbols/poker" = "${dotfiles}/x/.xkb/symbols/poker";

      # zsh
      ".zshenv" = "${dotfiles}/zsh/.zshenv";
      ".config/zsh/.zshenv" = "${dotfiles}/zsh/.config/zsh/.zshenv";
      ".config/zsh/.zshrc" = "${dotfiles}/zsh/.config/zsh/.zshrc";
      ".config/zsh/.zimrc" = "${dotfiles}/zsh/.config/zsh/.zimrc";
    };
  }


