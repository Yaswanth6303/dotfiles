# nix/modules/macos-defaults.nix
#
# Declarative macOS system defaults — captured from the live machine state
# on 2026-05-27. Validated against the nix-darwin option schema.
#
# To lift a new setting after changing it in System Settings:
#   defaults read <domain> <key>
# then add the key under the matching `system.defaults.<domain>` block,
# or under `CustomUserPreferences` if it isn't in the typed schema.
{config, ...}: {
  system.defaults = {
    # ── Global UI / input ────────────────────────────────────────────────
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowScrollBars = "Automatic";
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;

      "com.apple.trackpad.scaling" = 0.875;
      "com.apple.swipescrolldirection" = true; # natural scrolling
    };

    # ── Dock ─────────────────────────────────────────────────────────────
    dock = {
      autohide = true;
      autohide-time-modifier = 0.5;
      orientation = "bottom";
      tilesize = 16;
      largesize = 128;
      magnification = true;
      mru-spaces = false; # don't auto-rearrange Spaces by recent use
      show-recents = false;
      wvous-br-corner = 14; # bottom-right hot corner → Quick Note
      showDesktopGestureEnabled = false; # click wallpaper to show desktop: off
      showMissionControlGestureEnabled = true;
    };

    # ── Finder ───────────────────────────────────────────────────────────
    finder = {
      AppleShowAllFiles = false;
      FXDefaultSearchScope = "SCcf"; # search current folder, not "This Mac"
      FXPreferredViewStyle = "Nlsv"; # list view
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      NewWindowTarget = "Documents";
    };

    # ── Screenshots ──────────────────────────────────────────────────────
    screencapture = {
      location = "/Users/${config.system.primaryUser}/Pictures/Screenshots";
      type = "png";
      show-thumbnail = true;
    };

    # ── Menu-bar clock ───────────────────────────────────────────────────
    menuExtraClock = {
      IsAnalog = false;
      ShowAMPM = true;
      ShowDate = 2;
      ShowDayOfWeek = false;
      ShowSeconds = true;
    };

    # ── Trackpad ─────────────────────────────────────────────────────────
    trackpad = {
      Clicking = true; # tap to click
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
      TrackpadThreeFingerTapGesture = 0;
      FirstClickThreshold = 1; # 0 light, 1 medium, 2 firm
      SecondClickThreshold = 1;
    };

    # ── Stage Manager / window grouping ─────────────────────────────────
    WindowManager = {
      GloballyEnabled = false; # Stage Manager off
      AutoHide = false;
      HideDesktop = true; # hide desktop icons (click wallpaper to show)
      StageManagerHideWidgets = false;
      StandardHideWidgets = false;
    };

    # ── Software updates ─────────────────────────────────────────────────
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    # ── Login window ─────────────────────────────────────────────────────
    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
    };

    # ── Outliers not covered by typed modules ───────────────────────────
    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleLocale = "en_IN";
        AppleLanguages = ["en-IN" "te-IN"];
        AppleMiniaturizeOnDoubleClick = 0;
        NSAllowContinuousSpellChecking = 0;
        "com.apple.mouse.scaling" = 1.5;
        "com.apple.sound.beep.flash" = 0;
      };
      "com.apple.dock" = {
        "wvous-br-modifier" = 0; # hot-corner modifier keys
      };
      "com.apple.finder" = {
        WarnOnEmptyTrash = false;
      };
      "com.apple.loginwindow" = {
        # Suppress the "MiniBuddy" welcome assistant after macOS updates
        MiniBuddyLaunch = 0;
        # Don't reopen apps after restart
        TALLogoutSavesState = 0;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticDownload = 1;
        ConfigDataInstall = 1;
        CriticalUpdateInstall = 1;
      };
    };
  };
}
