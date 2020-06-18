{ pkgs, python }:

self: super:
let
  addBuildInputs = packages: old: {
    buildInputs = old.buildInputs ++ packages;
  };
  pipInstallIgnoresInstalled = old: {
    pipInstallFlags = [ "--ignore-installed" ];
  };
  addSingleBuildInput = package: addBuildInputs [ package ];
  overridePythonPackage = name: overrides:
    let
      combinedOverrides = old:
        pkgs.lib.fold (override: previous: previous // override previous) old
        overrides;
    in super."${name}".overridePythonAttrs combinedOverrides;
in {
  "fancycompleter" = overridePythonPackage "fancycompleter"
    [ (addBuildInputs [ self."setuptools-scm" self."setupmeta" ]) ];

  "flake8-debugger" = overridePythonPackage "flake8-debugger"
    [ (addBuildInputs [ self."pytest-runner" ]) ];

  "jsonschema" = overridePythonPackage "jsonschema"
    [ (addBuildInputs [ self."setuptools-scm" ]) ];

  "keyring" =
    overridePythonPackage "keyring" [ (addBuildInputs [ self."toml" ]) ];

  "mccabe" = overridePythonPackage "mccabe"
    [ (addBuildInputs [ self."pytest-runner" ]) ];

  "pdbpp" = overridePythonPackage "pdbpp"
    [ (addBuildInputs [ self."setuptools-scm" ]) ];

  "pip" = overridePythonPackage "pip" [ pipInstallIgnoresInstalled ];

  "py" =
    overridePythonPackage "py" [ (addBuildInputs [ self."setuptools-scm" ]) ];

  "setuptools" =
    overridePythonPackage "setuptools" [ pipInstallIgnoresInstalled ];

  "wheel" = overridePythonPackage "wheel" [ pipInstallIgnoresInstalled ];

  "zipp" = overridePythonPackage "zipp" [ (addBuildInputs [ self."toml" ]) ];
}
