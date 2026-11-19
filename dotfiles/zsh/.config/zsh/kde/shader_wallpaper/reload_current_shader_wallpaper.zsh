# ZSH_DESC - Recarrega e recompila o shader ativo no wallpaper do KDE Plasma

reload_current_shader_wallpaper() {

    local plugin_ui_dir="$HOME/.local/share/plasma/wallpapers/online.knowmad.shaderwallpaper/contents/ui"
    local shader_base="$SETUP_ESSENTIALS_DIR/kde/shaders/MatrixCustom.base.frag"
    local shader_file="$SETUP_ESSENTIALS_DIR/kde/shaders/MatrixCustom.frag"
    [[ -f "$shader_file" ]] || cp "$shader_base" "$shader_file"
    local target_shader="$(realpath --relative-to="$plugin_ui_dir" "$shader_file")"

    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
        var allDesktops = desktops();
        for (var i = 0; i < allDesktops.length; i++) {
            var d = allDesktops[i];
            if (d.wallpaperPlugin === 'online.knowmad.shaderwallpaper') {
                d.currentConfigGroup = ['Wallpaper', 'online.knowmad.shaderwallpaper', 'General'];
                d.writeConfig('selectedShaderPath', 'Shaders/Simple.frag');
                d.writeConfig('selectedShaderPath', '${target_shader}');
            }
        }
    "
}