# nix/overlays/default.nix
[
  (import ./pgxnclient.nix)
  # Add more overlays here as you create them
  # (import ./custom-package.nix)
]
