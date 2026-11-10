{ pkgs, ... }:
{
  extraPackages = [ pkgs.imagemagick ];

  plugins.render-markdown = {
    enable = true;
    settings = {
      # also render avante's chat panel
      file_types = [
        "markdown"
        "Avante"
      ];
    };
  };

  plugins.bullets.enable = true;

  plugins.lz-n.enable = true;

  plugins.image = {
    enable = true;
    # setup needs a real terminal, so it fails in headless checks
    lazyLoad.settings.ft = [ "markdown" ];
    settings = {
      backend = "kitty";
      processor = "magick_cli";
      integrations.markdown.only_render_image_at_cursor = false;
    };
  };
}
