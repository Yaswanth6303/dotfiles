return {
  settings = {
    nixd = {
      nixpkgs = { expr = "import <nixpkgs> { }" },
      formatting = { command = { "alejandra" } },
      options = {
        nixos = {
          expr = '(builtins.getFlake "/path/to/flake").nixosConfigurations.HOSTNAME.options',
        },
        home_manager = {
          expr = '(builtins.getFlake "/path/to/flake").homeConfigurations."USER@HOSTNAME".options',
        },
      },
    },
  },
}
