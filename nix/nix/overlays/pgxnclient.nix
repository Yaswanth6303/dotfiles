# nix/overlays/pgxnclient.nix
final: prev: {
  pgxnclient = final.python3Packages.buildPythonApplication rec {
    pname = "pgxnclient";
    version = "1.3.2";
    pyproject = true;

    src = final.fetchPypi {
      inherit pname version;
      sha256 = "b0343e044b8d0044ff4be585ecce0147b1007db7ae8b12743bf222758a4ec7d9";
    };

    build-system = with final.python3Packages; [setuptools];
    propagatedBuildInputs = with final.python3Packages; [six];
    doCheck = false;

    postPatch = ''
      sed -i "s/setup_requires=\['pytest-runner'\],//g" setup.py
      sed -i "s/'pytest-runner'//g" setup.py
    '';

    meta = with final.lib; {
      description = "A command line client for the PostgreSQL Extension Network";
      homepage = "https://github.com/pgxn/pgxnclient";
      license = licenses.bsd3;
    };
  };
}
