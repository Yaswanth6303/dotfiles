# nix/overlays/pgxnclient.nix
#
# Why this overlay exists:
#   pgxnclient is not packaged in nixpkgs (verified against nixpkgs-unstable).
#   Upstream is effectively abandoned — last release 1.3.2 (May 2021).
#
# Why doCheck = false:
#   The upstream test suite (`tests/`) requires:
#     1. Network access to pgxn.org (fetching package metadata)
#     2. A live PostgreSQL cluster for the install-extension tests
#   Both are unavailable inside the Nix build sandbox, so the suite cannot
#   be honestly run here. Instead, we use `versionCheckHook` to verify the
#   produced binary actually launches and reports a version — that catches
#   import errors, missing deps, and "completely broken at build time" without
#   pretending the full suite ran.
#
# What to do if upstream ever moves again:
#   - Bump `version`, refresh `hash` via `nix-prefetch-pypi pgxnclient <ver>`.
#   - If `setup.py` no longer references `pytest-runner`, drop `postPatch`.
final: prev: {
  pgxnclient = final.python3Packages.buildPythonApplication rec {
    pname = "pgxnclient";
    version = "1.3.2";
    pyproject = true;

    src = final.fetchPypi {
      inherit pname version;
      hash = "sha256-sDQ+BEuNAET/S+WF7M4BR7EAfbeuixJ0O/IidYpOx9k=";
    };

    # pytest-runner is the deprecated setup_requires shim; removing it lets
    # setuptools resolve setup.py without trying to fetch from PyPI at build.
    postPatch = ''
      sed -i "s/setup_requires=\['pytest-runner'\],//g" setup.py
      sed -i "s/'pytest-runner'//g" setup.py
    '';

    build-system = with final.python3Packages; [setuptools];
    propagatedBuildInputs = with final.python3Packages; [six];

    # See header for why the upstream `tests/` suite is skipped.
    doCheck = false;

    # Smoke-check that the produced binary actually runs. Cheap, sandbox-safe,
    # and catches the class of regression (import errors, broken setup.py)
    # that `doCheck = false` would otherwise hide.
    doInstallCheck = true;
    nativeInstallCheckInputs = [final.versionCheckHook];
    versionCheckProgramArg = "--version";

    meta = with final.lib; {
      description = "Command line client for the PostgreSQL Extension Network";
      homepage = "https://github.com/pgxn/pgxnclient";
      license = licenses.bsd3;
      mainProgram = "pgxnclient";
      platforms = platforms.unix;
    };
  };
}
