# nix/modules/networking.nix
#
# Single source of truth for machine identity. `networking.hostName` is set
# in flake.nix; every other macOS hostname surface follows from it here so
# they cannot drift apart.
#
# Surfaces tied together:
#   - networking.hostName        → kernel/POSIX hostname (`hostname`)
#   - networking.localHostName   → Bonjour `<name>.local`
#   - networking.computerName    → friendly name (System Settings → About)
#   - system.defaults.smb.NetBIOSName
#   - system.defaults.smb.ServerDescription
{
  config,
  lib,
  ...
}: let
  hostName = config.networking.hostName;
  computerName = "Yaswanth's MacBook Air";
in {
  networking.computerName = computerName;
  networking.localHostName = hostName;

  system.defaults.smb = {
    # smbd canonicalizes NetBIOS names to uppercase per the SMB protocol.
    # Setting uppercase here keeps our declared state == live state on rebuilds.
    NetBIOSName = lib.toUpper hostName;
    ServerDescription = computerName;
  };
}
