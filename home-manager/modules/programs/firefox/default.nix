{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (builtins) readFile;
  csshacks = inputs.firefox-csshacks + "/chrome";
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  readwise-highlighter = firefox-addons.buildFirefoxXpiAddon {
    pname = "readwise-highlighter";
    version = "0.15.23";
    addonId = "team@readwise.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/4222692/readwise_highlighter-0.15.23.xpi";
    sha256 = "sha256-Jg62eKy7s3tbs0IR/zHOSzLpQVj++wTUYyPU4MUBipQ=";
    meta = { };
  };
  betterfox = inputs.betterfox;
  cfg = config.programs.firefox;
  profile = "syde";
in
{
  config = lib.mkIf cfg.enable {
    syde.gui.browser = "firefox";
    programs.firefox = {
      profiles.${profile} = {
        name = profile;
        search = {
          default = "Kagi";
          privateDefault = "DuckDuckGo";
          force = true;
          order = [
            "Kagi"
            "DuckDuckGo"
          ];
          engines = {
            "Arch Wiki" = {
              urls = [
                {
                  template = "https://wiki.archlinux.org/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
              definedAliases = [ "@aw" ];
            };
            "Brave Search" = {
              urls = [
                {
                  template = "https://search.brave.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/favicon-16x16.341beadf.png";
              definedAliases = [ "@b" ];
            };
            "Kagi" = {
              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://assets.kagi.com/v1/favicon-16x16.png";
              definedAliases = [ "@k" ];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };
            "NixOS Wiki" = {
              urls = [
                {
                  template = "https://nixos.wiki/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "Youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://www.youtube.com/s/desktop/fa273944/img/favicon_144x144.png";
              definedAliases = [ "@yt" ];
            };
            "Google".metaData.alias = "@g";
            "Bing".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            "Twitter.com".metaData.hidden = true;
          };
        };

        settings = {
          # Searching
          "browser.search.region" = "DK";
          "browser.search.suggest.enabled" = false;
          # Privacy
          "app.shield.optoutstudies.enabled" = false;
          "browser.contentblocking.category" = "strict";
          "browser.formfill.enable" = false;
          "browser.laterrun.enabled" = true;
          "cookiebanners.service.mode" = 2;
          "cookiebanners.service.mode.privateBrowsing" = 2;
          "datareporting.healthreport.uploadEnabled" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "extensions.getAddons.cache.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.pocket.enabled" = false;
          "extensions.update.autoUpdateDefault" = false;
          "extensions.update.enabled" = false;
          "extensions.autoDisableScopes" = 0;
          "general.useragent.locale" = "en-US";
          "places.history.enabled" = true;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.sessions" = false;
          "privacy.fingerprintingProtection" = true;
          "privacy.history.custom" = true;
          "privacy.resistFingerprinting" = false;
          "privacy.sanitize.pending" = # json
            ''
              [{"id":"shutdown","itemsToClear":["cache","formdata","downloads"],"options":{}}]
            '';
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "media.peerconnection.enabled" = false; # remove WebRTC IP leak

          "signon.autofillForms" = false;
          "signon.rememberSignons" = false;

          # Networking and DNS
          "network.dns.disablePrefetch" = true;
          "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
          "network.trr.uri" = "https://base.dns.mullvad.net/dns-query";
          # "network.trr.mode" = 3;
          "network.predictor.enabled" = false;
          "network.prefetch-next" = false;

          # Look and feel
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "doh-rollout.doneFirstRun" = true;
          "app.normandy.first_run" = false;
          "devtools.everOpened" = true;
          "browser.bookmarks.addedImportButton" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
          "browser.startup.page" = 3;
          "browser.newtabpage.pinned" = "[]";
          "browser.aboutConfig.showWarning" = false;
          "browser.uidensity" = 1;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;

          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.location" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.open-uri" = 1;
          "widget.use-xdg-desktop-portal.settings" = 1;
        };

        extensions = with firefox-addons; [
          # ---Privacy---
          ublock-origin
          cookie-autodelete
          istilldontcareaboutcookies
          noscript

          # ---Workflow---
          sponsorblock
          export-cookies-txt
          multi-account-containers
          news-feed-eradicator
          lastpass-password-manager
          proton-pass
          vimium
          kagi-search
          readwise-highlighter

          # ---UI---
          darkreader
          sidebery
          stylus
          firefox-color
        ];
        userChrome =
          readFile "${csshacks}/window_control_placeholder_support.css"
          + readFile "${csshacks}/hide_tabs_toolbar.css"
          + readFile "${csshacks}/privatemode_indicator_as_menu_button.css"
          + readFile "${csshacks}/window_control_force_linux_system_style.css"
          + readFile "${csshacks}/overlay_sidebar_header.css";
        userContent = readFile ./userContent.css;
        extraConfig = readFile "${betterfox}/Fastfox.js";
      };
    };
  };
}
