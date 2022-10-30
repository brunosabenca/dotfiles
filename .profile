[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || export QT_QPA_PLATFORMTHEME="qt5ct"

export VDPAU_DRIVER=radeonsi

#export BEMENU_BACKEND=wayland
export XDG_CURRENT_DESKTOP="Unity"

export NVIM_GTK_NO_HEADERBAR=1
export MOZ_ENABLE_WAYLAND=0
export MOZ_WEBRENDER=1

export GDK_DPI_SCALE=1
export GDK_SCALE=1
#export GDK_SCALE_DPI=192
export GDK_SCALE_DPI=157

export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1

export XDG_CONFIG_HOME="$HOME/.config"

export TERM=xterm-termite

export EDITOR=nvim

export VISUAL=nvim

export SSH_ASKPASS=ssh-askpass

export _JAVA_AWT_WM_NONREPARENTING=1

export QT_WAYLAND_FORCE_DPI=physical
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

export GOPATH="$HOME/go"

appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="$PATH:$1"
    esac
}

MY_BIN="$HOME/bin"
MY_SCRIPTS="$HOME/bin/scripts:$PATH"
COMPOSER="$HOME/.config/composer/vendor/bin"
N="$HOME/n/bin"
GO="$HOME/go/bin"
RUBY="$(ruby -e 'print Gem.user_dir')/bin"
CARGO="$HOME/.cargo/bin"
JVM="/usr/lib/jvm/default/bin"
PERL="/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
BSPWM="$HOME/.config/bspwm"
SYMFONY="$HOME/.symfony/bin:$PATH"

appendpath $MY_BIN
appendpath $MY_SCRIPTS
appendpath $RUBY
appendpath $COMPOSER
#appendpath $N
appendpath $GO
appendpath $CARGO
appendpath $JVM
appendpath $PERL
appendpath $BSPWM
appendpath $SYMFONY

unset appendpath

export PATH
