# -*- mode: nix -*-
{
  description = "Python interpreter bundled with packages";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      withSystem = f:
        builtins.listToAttrs (builtins.map (system: {
          name = system;
          value = f system;
        }) systems);
    in {
      defaultPackage =
        withSystem (system: self.packages."${system}".interpreter);
      packages = withSystem (system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          python = pkgs.python3;
          commonBuildInputs = with pkgs; [ openssl libffi ];
          generatedPackages = self: {

            "yarl" = python.pkgs.buildPythonPackage {
              pname = "yarl";
              version = "1.4.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/d6/67/6e2507586eb1cfa6d55540845b0cd05b4b77c414f6bca8b00b45483b976e/yarl-1.4.2.tar.gz";
                sha256 =
                  "58cd9c469eced558cd81aa3f484b2924e8897049e06889e8ff2510435b7ef74b";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ multidict idna ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "Yet another URL library";
              };
            };

            "pytest" = python.pkgs.buildPythonPackage {
              pname = "pytest";
              version = "5.4.3";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/8f/c4/e4a645f8a3d6c6993cb3934ee593e705947dfafad4ca5148b9a0fde7359c/pytest-5.4.3.tar.gz";
                sha256 =
                  "7979331bfcba207414f5e1263b5a0f8f521d0f457318836a7355531ed1a4c7d8";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                setuptools-scm
                wheel
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [
                py
                packaging
                attrs
                more-itertools
                pluggy
                wcwidth
                importlib-metadata
              ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "pytest: simple powerful testing with Python";
              };
            };

            "sphinxcontrib-serializinghtml" = python.pkgs.buildPythonPackage {
              pname = "sphinxcontrib-serializinghtml";
              version = "1.1.4";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/ac/86/021876a9dd4eac9dae0b1d454d848acbd56d5574d350d0f835043b5ac2cd/sphinxcontrib-serializinghtml-1.1.4.tar.gz";
                sha256 =
                  "eaa0eccc86e982a9b939b2b82d12cc5d013385ba5eadcc7e4fed23f4405f77bc";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "sphinxcontrib-serializinghtml is a sphinx extension which outputs "
                  serialized " HTML files (json and pickle).";
              };
            };

            "aiohttp-cors" = python.pkgs.buildPythonPackage {
              pname = "aiohttp-cors";
              version = "0.7.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/44/9e/6cdce7c3f346d8fd487adf68761728ad8cd5fbc296a7b07b92518350d31f/aiohttp-cors-0.7.0.tar.gz";
                sha256 =
                  "4d39c6d7100fd9764ed1caf8cebf0eb01bf5e3f24e2e073fda6234bc48b19f5d";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ aiohttp ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "CORS support for aiohttp";
              };
            };

            "more-itertools" = python.pkgs.buildPythonPackage {
              pname = "more-itertools";
              version = "8.4.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/67/4a/16cb3acf64709eb0164e49ba463a42dc45366995848c4f0cf770f57b8120/more-itertools-8.4.0.tar.gz";
                sha256 =
                  "68c70cc7167bdf5c7c9d8f6954a7837089c6a36bf565383919bb595efb8a17e5";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "More routines for operating on iterables, beyond itertools";
              };
            };

            "docutils" = python.pkgs.buildPythonPackage {
              pname = "docutils";
              version = "0.16";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz";
                sha256 =
                  "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.publicDomain;
                description = "Docutils -- Python Documentation Utilities";
              };
            };

            "urllib3" = python.pkgs.buildPythonPackage {
              pname = "urllib3";
              version = "1.25.9";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz";
                sha256 =
                  "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "HTTP library with thread-safe connection pooling, file post, and more.";
              };
            };

            "cffi" = python.pkgs.buildPythonPackage {
              pname = "cffi";
              version = "1.14.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz";
                sha256 =
                  "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ pycparser ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Foreign Function Interface for Python calling C code.";
              };
            };

            "pyaml" = python.pkgs.buildPythonPackage {
              pname = "pyaml";
              version = "19.4.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/bf/0c/bf62f049446da78498eb607bc8cbb0604cf1e8d618f2f733e538dcb6e0bc/pyaml-19.4.1.tar.gz";
                sha256 =
                  "c79ae98ececda136a034115ca178ee8bf3aa7df236c488c2f55d12f177b88f1e";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ pyyaml ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = "WTFPL";
                description =
                  "PyYAML-based module to produce pretty and readable YAML-serialized data";
              };
            };

            "intreehooks" = python.pkgs.buildPythonPackage {
              pname = "intreehooks";
              version = "1.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/f9/a5/5dacebf93232a847970921af2b020f9f2a8e0064e3a97727cd38efc77ba0/intreehooks-1.0.tar.gz";
                sha256 =
                  "87e600d3b16b97ed219c078681260639e77ef5a17c0e0dbdd5a302f99b4e34e1";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ pytoml ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Load a PEP 517 backend from inside the source tree";
              };
            };

            "pytest-runner" = python.pkgs.buildPythonPackage {
              pname = "pytest-runner";
              version = "5.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/5b/82/1462f86e6c3600f2471d5f552fcc31e39f17717023df4bab712b4a9db1b3/pytest-runner-5.2.tar.gz";
                sha256 =
                  "96c7e73ead7b93e388c5d614770d2bae6526efd997757d3543fe17b557a0942b";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                wheel
                setuptools-scm
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Invoke py.test as distutils command with dependency resolution";
              };
            };

            "pdbpp" = python.pkgs.buildPythonPackage {
              pname = "pdbpp";
              version = "0.10.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/3f/82/4b6c5b9128bbbad48a52c6d639c84e3c453e75953ed123b6e9338420dcec/pdbpp-0.10.2.tar.gz";
                sha256 =
                  "73ff220d5006e0ecdc3e2705d8328d8aa5ac27fef95cc06f6e42cd7d22d55eb8";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ fancycompleter wmctrl pygments ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "pdb++, a drop-in replacement for pdb";
              };
            };

            "pluggy" = python.pkgs.buildPythonPackage {
              pname = "pluggy";
              version = "0.13.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz";
                sha256 =
                  "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                setuptools-scm
                wheel
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ importlib-metadata ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "plugin and hook calling mechanisms for python";
              };
            };

            "markupsafe" = python.pkgs.buildPythonPackage {
              pname = "markupsafe";
              version = "1.1.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz";
                sha256 =
                  "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "Safely add untrusted strings to HTML/XML markup.";
              };
            };

            "fancycompleter" = python.pkgs.buildPythonPackage {
              pname = "fancycompleter";
              version = "0.9.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/a9/95/649d135442d8ecf8af5c7e235550c628056423c96c4bc6787348bdae9248/fancycompleter-0.9.1.tar.gz";
                sha256 =
                  "09e0feb8ae242abdfd7ef2ba55069a46f011814a80fe5476be48f51b00247272";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ pyrepl ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "colorful TAB completion for Python prompt";
              };
            };

            "async-timeout" = python.pkgs.buildPythonPackage {
              pname = "async-timeout";
              version = "3.0.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz";
                sha256 =
                  "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "Timeout context manager for asyncio programs";
              };
            };

            "twine" = python.pkgs.buildPythonPackage {
              pname = "twine";
              version = "3.1.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/7e/2f/e2a91a8ab97e8c9830ce297132631aef5dcd599f076123d1ebb26f1941b6/twine-3.1.1.tar.gz";
                sha256 =
                  "d561a5e511f70275e5a485a6275ff61851c16ffcb3a95a602189161112d9f160";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                wheel
                setuptools-scm
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [
                pkginfo
                readme-renderer
                requests
                requests-toolbelt
                setuptools
                tqdm
                keyring
                importlib-metadata
              ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description =
                  "Collection of utilities for publishing packages on PyPI";
              };
            };

            "babel" = python.pkgs.buildPythonPackage {
              pname = "babel";
              version = "2.8.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/34/18/8706cfa5b2c73f5a549fdc0ef2e24db71812a2685959cff31cbdfc010136/Babel-2.8.0.tar.gz";
                sha256 =
                  "1aac2ae2d0d8ea368fa90906567f5c08463d98ade155c0c4bfedd6a0f7160e38";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ pytz ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "Internationalization utilities";
              };
            };

            "attrs" = python.pkgs.buildPythonPackage {
              pname = "attrs";
              version = "19.3.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz";
                sha256 =
                  "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ setuptools wheel ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Classes Without Boilerplate";
              };
            };

            "sphinx" = python.pkgs.buildPythonPackage {
              pname = "sphinx";
              version = "3.1.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/1b/2f/d53f8292784836e64125917e571b689698e838d8b88f210edef2f9c93970/Sphinx-3.1.1.tar.gz";
                sha256 =
                  "74fbead182a611ce1444f50218a1c5fc70b6cc547f64948f5182fb30a2a20258";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [
                sphinxcontrib-applehelp
                sphinxcontrib-devhelp
                sphinxcontrib-jsmath
                sphinxcontrib-htmlhelp
                sphinxcontrib-serializinghtml
                sphinxcontrib-qthelp
                jinja2
                pygments
                docutils
                snowballstemmer
                babel
                alabaster
                imagesize
                requests
                setuptools
                packaging
              ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "Python documentation generator";
              };
            };

            "chardet" = python.pkgs.buildPythonPackage {
              pname = "chardet";
              version = "3.0.4";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz";
                sha256 =
                  "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.lgpl2;
                description = "Universal encoding detector for Python 2 and 3";
              };
            };

            "requests" = python.pkgs.buildPythonPackage {
              pname = "requests";
              version = "2.24.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz";
                sha256 =
                  "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ chardet idna urllib3 certifi ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "Python HTTP for Humans.";
              };
            };

            "coverage" = python.pkgs.buildPythonPackage {
              pname = "coverage";
              version = "5.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/fe/4d/3d892bdd21acba6c9e9bec6dc93fbe619883a0967c62f976122f2c6366f3/coverage-5.1.tar.gz";
                sha256 =
                  "f90bfc4ad18450c80b024036eaf91e4a246ae287701aaa88eaebebf150868052";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "Code coverage measurement for Python";
              };
            };

            "idna" = python.pkgs.buildPythonPackage {
              pname = "idna";
              version = "2.9";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz";
                sha256 =
                  "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "Internationalized Domain Names in Applications (IDNA)";
              };
            };

            "mccabe" = python.pkgs.buildPythonPackage {
              pname = "mccabe";
              version = "0.6.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz";
                sha256 =
                  "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "McCabe checker, plugin for flake8";
              };
            };

            "packaging" = python.pkgs.buildPythonPackage {
              pname = "packaging";
              version = "20.4";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz";
                sha256 =
                  "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ pyparsing six ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "Core utilities for Python packages";
              };
            };

            "pyyaml" = python.pkgs.buildPythonPackage {
              pname = "pyyaml";
              version = "5.3.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz";
                sha256 =
                  "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "YAML parser and emitter for Python";
              };
            };

            "pathspec" = python.pkgs.buildPythonPackage {
              pname = "pathspec";
              version = "0.8.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/93/9c/4bb0a33b0ec07d2076f0b3d7c6aae4dad0a99f9a7a14f7f7ff6f4ed7fa38/pathspec-0.8.0.tar.gz";
                sha256 =
                  "da45173eb3a6f2a5a487efba21f050af2b41948be6ab52b6a1e3ff22bb8b7061";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mpl20;
                description =
                  "Utility library for gitignore style pattern matching of file paths.";
              };
            };

            "pyflakes" = python.pkgs.buildPythonPackage {
              pname = "pyflakes";
              version = "2.2.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/f1/e2/e02fc89959619590eec0c35f366902535ade2728479fc3082c8af8840013/pyflakes-2.2.0.tar.gz";
                sha256 =
                  "35b2d75ee967ea93b55750aa9edbbf72813e06a66ba54438df2cfac9e3c27fc8";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "passive checker of Python programs";
              };
            };

            "imagesize" = python.pkgs.buildPythonPackage {
              pname = "imagesize";
              version = "1.2.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/e4/9f/0452b459c8ba97e07c3cd2bd243783936a992006cf4cd1353c314a927028/imagesize-1.2.0.tar.gz";
                sha256 =
                  "b1f6b5a4eab1f73479a50fb79fcf729514a900c341d8503d62a62dbc4127a2b1";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Getting image size from png/jpeg/jpeg2000/gif file";
              };
            };

            "sphinxcontrib-devhelp" = python.pkgs.buildPythonPackage {
              pname = "sphinxcontrib-devhelp";
              version = "1.0.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/98/33/dc28393f16385f722c893cb55539c641c9aaec8d1bc1c15b69ce0ac2dbb3/sphinxcontrib-devhelp-1.0.2.tar.gz";
                sha256 =
                  "ff7f1afa7b9642e7060379360a67e9c41e8f3121f2ce9164266f61b9f4b338e4";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "sphinxcontrib-devhelp is a sphinx extension which outputs Devhelp document.";
              };
            };

            "toml" = python.pkgs.buildPythonPackage {
              pname = "toml";
              version = "0.10.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/da/24/84d5c108e818ca294efe7c1ce237b42118643ce58a14d2462b3b2e3800d5/toml-0.10.1.tar.gz";
                sha256 =
                  "926b612be1e5ce0634a2ca03470f95169cf16f939018233a670519cb4ac58b0f";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Python Library for Tom's Obvious, Minimal Language";
              };
            };

            "wmctrl" = python.pkgs.buildPythonPackage {
              pname = "wmctrl";
              version = "0.3";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/01/c6/001aefbde5782d6f359af0a8782990c3f4e751e29518fbd59dc8dfc58b18/wmctrl-0.3.tar.gz";
                sha256 =
                  "d806f65ac1554366b6e31d29d7be2e8893996c0acbb2824bbf2b1f49cf628a13";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "A tool to programmatically control windows inside X";
              };
            };

            "pip" = python.pkgs.buildPythonPackage {
              pname = "pip";
              version = "20.1.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/08/25/f204a6138dade2f6757b4ae99bc3994aac28a5602c97ddb2a35e0e22fbc4/pip-20.1.1.tar.gz";
                sha256 =
                  "27f8dc29387dd83249e06e681ce087e6061826582198a425085e0bf4c1cf3a55";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ setuptools wheel ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "The PyPA recommended tool for installing Python packages.";
              };
            };

            "jinja2" = python.pkgs.buildPythonPackage {
              pname = "jinja2";
              version = "2.11.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz";
                sha256 =
                  "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ markupsafe ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "A very fast and expressive template engine.";
              };
            };

            "certifi" = python.pkgs.buildPythonPackage {
              pname = "certifi";
              version = "2020.4.5.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/b4/19/53433f37a31543364c8676f30b291d128cdf4cd5b31b755b7890f8e89ac8/certifi-2020.4.5.2.tar.gz";
                sha256 =
                  "5ad7e9a056d25ffa5082862e36f119f7f7cec6457fa07ee2f8c339814b80c9b1";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mpl20;
                description =
                  "Python package for providing Mozilla's CA Bundle.";
              };
            };

            "zipp" = python.pkgs.buildPythonPackage {
              pname = "zipp";
              version = "3.1.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/ce/8c/2c5f7dc1b418f659d36c04dec9446612fc7b45c8095cc7369dd772513055/zipp-3.1.0.tar.gz";
                sha256 =
                  "c599e4d75c98f6798c509911d08a22e6c021d074469042177c8c86fb92eefd96";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                wheel
                setuptools-scm
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Backport of pathlib-compatible object wrapper for zip files";
              };
            };

            "effect" = python.pkgs.buildPythonPackage {
              pname = "effect";
              version = "1.1.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/31/7a/3c7a4568ed3a8fa463ffabbc70ed9471d82daad4e479b305d299bec72b49/effect-1.1.0.tar.gz";
                sha256 =
                  "7affb603707c648b07b11781ebb793a4b9aee8acf1ac5764c3ed2112adf0c9ea";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ attrs ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "pure effects for Python";
              };
            };

            "pytz" = python.pkgs.buildPythonPackage {
              pname = "pytz";
              version = "2020.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz";
                sha256 =
                  "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "World timezone definitions, modern and historical";
              };
            };

            "mypy" = python.pkgs.buildPythonPackage {
              pname = "mypy";
              version = "0.780";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/21/44/83f5310e042450e7d13c888f41bdd6ab0399c83c08fde13f7f3851efa2cd/mypy-0.780.tar.gz";
                sha256 =
                  "4ef13b619a289aa025f2273e05e755f8049bb4eaba6d703a425de37d495d178d";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ setuptools wheel ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ typed-ast typing-extensions mypy-extensions ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Optional static typing for Python";
              };
            };

            "click" = python.pkgs.buildPythonPackage {
              pname = "click";
              version = "7.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz";
                sha256 =
                  "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "Composable command line interface toolkit";
              };
            };

            "sphinxcontrib-htmlhelp" = python.pkgs.buildPythonPackage {
              pname = "sphinxcontrib-htmlhelp";
              version = "1.0.3";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/c9/2e/a7a5fef38327b7f643ed13646321d19903a2f54b0a05868e4bc34d729e1f/sphinxcontrib-htmlhelp-1.0.3.tar.gz";
                sha256 =
                  "e8f5bb7e31b2dbb25b9cc435c8ab7a79787ebf7f906155729338f3156d93659b";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "sphinxcontrib-htmlhelp is a sphinx extension which renders HTML help files";
              };
            };

            "keyring" = python.pkgs.buildPythonPackage {
              pname = "keyring";
              version = "21.2.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/a6/52/eb8a0e13b54ec9240c7dd68fcd0951c52f62033d438af372831af770f7cc/keyring-21.2.1.tar.gz";
                sha256 =
                  "c53e0e5ccde3ad34284a40ce7976b5b3a3d6de70344c3f8ee44364cc340976ec";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                wheel
                setuptools-scm
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ importlib-metadata secretstorage jeepney ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Store and access your passwords safely.";
              };
            };

            "flit-core" = python.pkgs.buildPythonPackage {
              pname = "flit-core";
              version = "2.2.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/77/72/5dda5dc417a4e702e0d7e4a77e9802792a0e4a2daec2aeed915ead7db477/flit_core-2.2.0.tar.gz";
                sha256 =
                  "4efb8bffc1a04d8e550e877f0c9acf53109a021cc27c2a89b1b467715dc1d657";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ intreehooks ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ pytoml ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "Distribution-building parts of Flit. See flit package for more information";
              };
            };

            "snowballstemmer" = python.pkgs.buildPythonPackage {
              pname = "snowballstemmer";
              version = "2.0.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/21/1b/6b8bbee253195c61aeaa61181bb41d646363bdaa691d0b94b304d4901193/snowballstemmer-2.0.0.tar.gz";
                sha256 =
                  "df3bac3df4c2c01363f3dd2cfa78cce2840a79b9f1c2d2de9ce8d31683992f52";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "This package provides 26 stemmers for 25 languages generated from Snowball algorithms.";
              };
            };

            "jsonschema" = python.pkgs.buildPythonPackage {
              pname = "jsonschema";
              version = "3.2.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz";
                sha256 =
                  "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                wheel
                setuptools-scm
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [
                attrs
                pyrsistent
                setuptools
                six
                importlib-metadata
              ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "An implementation of JSON Schema validation for Python";
              };
            };

            "sphinxcontrib-applehelp" = python.pkgs.buildPythonPackage {
              pname = "sphinxcontrib-applehelp";
              version = "1.0.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/9f/01/ad9d4ebbceddbed9979ab4a89ddb78c9760e74e6757b1880f1b2760e8295/sphinxcontrib-applehelp-1.0.2.tar.gz";
                sha256 =
                  "a072735ec80e7675e3f432fcae8610ecf509c5f1869d17e2eecff44389cdbc58";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
              };
            };

            "regex" = python.pkgs.buildPythonPackage {
              pname = "regex";
              version = "2020.6.8";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/b8/7b/01510a6229c2176425bda54d15fba05a4b3df169b87265b008480261d2f9/regex-2020.6.8.tar.gz";
                sha256 =
                  "e9b64e609d37438f7d6e68c2546d2cb8062f3adb27e6336bc129b51be20773ac";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.psfl;
                description =
                  "Alternative regular expression module, to replace re.";
              };
            };

            "sphinxcontrib-qthelp" = python.pkgs.buildPythonPackage {
              pname = "sphinxcontrib-qthelp";
              version = "1.0.3";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/b1/8e/c4846e59f38a5f2b4a0e3b27af38f2fcf904d4bfd82095bf92de0b114ebd/sphinxcontrib-qthelp-1.0.3.tar.gz";
                sha256 =
                  "4c33767ee058b70dba89a6fc5c1892c0d57a54be67ddd3e7875a18d14cba5a72";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "sphinxcontrib-qthelp is a sphinx extension which outputs QtHelp document.";
              };
            };

            "wcwidth" = python.pkgs.buildPythonPackage {
              pname = "wcwidth";
              version = "0.2.4";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/2e/30/268d9d3ed18439b6983a8e630cd52d81fd7460a152d6e801d1b8394e51a1/wcwidth-0.2.4.tar.gz";
                sha256 =
                  "8c6b5b6ee1360b842645f336d9e5d68c55817c26d3050f46b235ef2bc650e48f";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Measures the displayed width of unicode strings in a terminal";
              };
            };

            "setupmeta" = python.pkgs.buildPythonPackage {
              pname = "setupmeta";
              version = "2.7.8";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/77/27/1de17be230d693096ef2012f4244545a34b797e3dd6ec43ef4bf42f3dfc8/setupmeta-2.7.8.tar.gz";
                sha256 =
                  "48b8dbbdd8b85a8cc76b9bfe557d538384cfe1de1ef5112e54400f3bed49456c";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Simplify your setup.py";
              };
            };

            "pycodestyle" = python.pkgs.buildPythonPackage {
              pname = "pycodestyle";
              version = "2.6.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/bb/82/0df047a5347d607be504ad5faa255caa7919562962b934f9372b157e8a70/pycodestyle-2.6.0.tar.gz";
                sha256 =
                  "c58a7d2815e0e8d7972bf1803331fb0152f867bd89adf8a01dfd55085434192e";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Python style guide checker";
              };
            };

            "appdirs" = python.pkgs.buildPythonPackage {
              pname = "appdirs";
              version = "1.4.4";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz";
                sha256 =
                  "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "A small Python module for determining appropriate platform-specific dirs, e.g. a "
                  user data dir ".";
              };
            };

            "pkginfo" = python.pkgs.buildPythonPackage {
              pname = "pkginfo";
              version = "1.5.0.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/6c/04/fd6683d24581894be8b25bc8c68ac7a0a73bf0c4d74b888ac5fe9a28e77f/pkginfo-1.5.0.1.tar.gz";
                sha256 =
                  "7424f2c8511c186cd5424bbf31045b77435b37a8d604990b79d4e70d741148bb";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Query metadatdata from sdists / bdists / installed packages.";
              };
            };

            "bleach" = python.pkgs.buildPythonPackage {
              pname = "bleach";
              version = "3.1.5";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/a9/ac/dc881fca3ac66d6f2c4c3ac46633af4e9c05ed5a0aa2e7e36dc096687dd7/bleach-3.1.5.tar.gz";
                sha256 =
                  "3c4c520fdb9db59ef139915a5db79f8b51bc2a7257ea0389f30c846883430a4b";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ packaging six webencodings ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "An easy safelist-based HTML-sanitizing tool.";
              };
            };

            "typing-extensions" = python.pkgs.buildPythonPackage {
              pname = "typing-extensions";
              version = "3.7.4.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/6a/28/d32852f2af6b5ead85d396249d5bdf450833f3a69896d76eb480d9c5e406/typing_extensions-3.7.4.2.tar.gz";
                sha256 =
                  "79ee589a3caca649a9bfd2a8de4709837400dfa00b6cc81962a1e6a1815969ae";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.psfl;
                description =
                  "Backported and Experimental Type Hints for Python 3.5+";
              };
            };

            "parsley" = python.pkgs.buildPythonPackage {
              pname = "parsley";
              version = "1.3";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/06/52/cac2f9e78c26cff8bb518bdb4f2b5a0c7058dec7a62087ed48fe87478ef0/Parsley-1.3.tar.gz";
                sha256 =
                  "9444278d47161d5f2be76a767809a3cbe6db4db822f46a4fd7481d4057208d41";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Parsing and pattern matching made easy.";
              };
            };

            "jeepney" = python.pkgs.buildPythonPackage {
              pname = "jeepney";
              version = "0.4.3";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/74/24/9b720cc6b2a73c908896a0ed64cb49780dcfbf4964e23a725aa6323f4452/jeepney-0.4.3.tar.gz";
                sha256 =
                  "3479b861cc2b6407de5188695fa1a8d57e5072d7059322469b62628869b8e36e";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ flit-core ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Low-level, pure Python DBus protocol wrapper.";
              };
            };

            "pygments" = python.pkgs.buildPythonPackage {
              pname = "pygments";
              version = "2.6.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz";
                sha256 =
                  "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "Pygments is a syntax highlighting package written in Python.";
              };
            };

            "sortedcontainers" = python.pkgs.buildPythonPackage {
              pname = "sortedcontainers";
              version = "2.2.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/3b/fb/48f6fa11e4953c530b09fa0f2976df5234b0eaabcd158625c3e73535aeb8/sortedcontainers-2.2.2.tar.gz";
                sha256 =
                  "4e73a757831fc3ca4de2859c422564239a31d8213d09a2a666e375807034d2ba";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description =
                  "Sorted Containers -- Sorted List, Sorted Dict, Sorted Set";
              };
            };

            "setuptools" = python.pkgs.buildPythonPackage {
              pname = "setuptools";
              version = "47.3.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/95/fe/2687907be1d6291a84a9b51220595a4f89d9477032c57f21e7c633465540/setuptools-47.3.1.zip";
                sha256 =
                  "843037738d1e34e8b326b5e061f474aca6ef9d7ece41329afbc8aac6195a3920";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Easily download, build, install, upgrade, and uninstall Python packages";
              };
            };

            "pyparsing" = python.pkgs.buildPythonPackage {
              pname = "pyparsing";
              version = "2.4.7";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz";
                sha256 =
                  "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Python parsing module";
              };
            };

            "six" = python.pkgs.buildPythonPackage {
              pname = "six";
              version = "1.15.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz";
                sha256 =
                  "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Python 2 and 3 compatibility utilities";
              };
            };

            "wheel" = python.pkgs.buildPythonPackage {
              pname = "wheel";
              version = "0.34.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/75/28/521c6dc7fef23a68368efefdcd682f5b3d1d58c2b90b06dc1d0b805b51ae/wheel-0.34.2.tar.gz";
                sha256 =
                  "8788e9155fe14f54164c1b9eb0a319d98ef02c160725587ad60f14ddc57b6f96";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self; [ setuptools ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "A built-package format for Python";
              };
            };

            "flake8" = python.pkgs.buildPythonPackage {
              pname = "flake8";
              version = "3.8.3";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/99/eb/cc2bbe9b242a79d2c5820911f21875a138aafa3dc2c3b9b34ba714f9fef9/flake8-3.8.3.tar.gz";
                sha256 =
                  "f04b9fcbac03b0a3e58c0ab3a0ecc462e023a9faf046d57794184028123aa208";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ pyflakes pycodestyle mccabe importlib-metadata ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "the modular source code checker: pep8 pyflakes and co";
              };
            };

            "importlib-metadata" = python.pkgs.buildPythonPackage {
              pname = "importlib-metadata";
              version = "1.6.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/aa/9a/8483b77e2decd95963d7e34bc9bc91a26e71fd89b57d8cf978ca24747c7f/importlib_metadata-1.6.1.tar.gz";
                sha256 =
                  "0505dd08068cfec00f53a74a0ad927676d7757da81b7436a6eefe4c7cf75c545";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                wheel
                setuptools-scm
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ zipp ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "Read metadata from Python packages";
              };
            };

            "pyrepl" = python.pkgs.buildPythonPackage {
              pname = "pyrepl";
              version = "0.9.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/05/1b/ea40363be0056080454cdbabe880773c3c5bd66d7b13f0c8b8b8c8da1e0c/pyrepl-0.9.0.tar.gz";
                sha256 =
                  "292570f34b5502e871bbb966d639474f2b57fbfcd3373c2d6a2f3d56e681a775";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = "MIT X11 style";
                description =
                  "A library for building flexible command line interfaces";
              };
            };

            "aiohttp" = python.pkgs.buildPythonPackage {
              pname = "aiohttp";
              version = "3.6.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/00/94/f9fa18e8d7124d7850a5715a0b9c0584f7b9375d331d35e157cee50f27cc/aiohttp-3.6.2.tar.gz";
                sha256 =
                  "259ab809ff0727d0e834ac5e8a283dc5e3e0ecc30c4d80b3cd17a4139ce1f326";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ attrs chardet multidict async-timeout yarl ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "Async http client/server framework (asyncio)";
              };
            };

            "mypy-extensions" = python.pkgs.buildPythonPackage {
              pname = "mypy-extensions";
              version = "0.4.3";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz";
                sha256 =
                  "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Experimental type system extensions for programs checked with the mypy typechecker.";
              };
            };

            "webencodings" = python.pkgs.buildPythonPackage {
              pname = "webencodings";
              version = "0.5.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz";
                sha256 =
                  "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "Character encoding aliases for legacy web content";
              };
            };

            "tqdm" = python.pkgs.buildPythonPackage {
              pname = "tqdm";
              version = "4.46.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/a9/03/df1d77e852dd697c0ff7b7b1b9888739517e5f97dfbd2cf7ebd13234084c/tqdm-4.46.1.tar.gz";
                sha256 =
                  "cd140979c2bebd2311dfb14781d8f19bd5a9debb92dcab9f6ef899c987fcf71f";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Fast, Extensible Progress Meter";
              };
            };

            "hypothesis" = python.pkgs.buildPythonPackage {
              pname = "hypothesis";
              version = "5.16.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/32/9d/42ba5ef77c9e825067ea7c6e37494019556cfb52d1d36ca968e7fb967d73/hypothesis-5.16.1.tar.gz";
                sha256 =
                  "dcd97367571657e9155d78ea0b6c3abf67acf4eaa6440e861213cd1beab02714";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ attrs sortedcontainers ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mpl20;
                description = "A library for property-based testing";
              };
            };

            "requests-toolbelt" = python.pkgs.buildPythonPackage {
              pname = "requests-toolbelt";
              version = "0.9.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz";
                sha256 =
                  "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ requests ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description =
                  "A utility belt for advanced users of python-requests";
              };
            };

            "pycparser" = python.pkgs.buildPythonPackage {
              pname = "pycparser";
              version = "2.20";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz";
                sha256 =
                  "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "C parser in Python";
              };
            };

            "setuptools-scm" = python.pkgs.buildPythonPackage {
              pname = "setuptools-scm";
              version = "4.1.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/cd/66/fa77e809b7cb1c2e14b48c7fc8a8cd657a27f4f9abb848df0c967b6e4e11/setuptools_scm-4.1.2.tar.gz";
                sha256 =
                  "a8994582e716ec690f33fec70cca0f85bd23ec974e3f783233e4879090a7faa8";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ setuptools wheel ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ setuptools ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "the blessed package to manage your versions by scm tags";
              };
            };

            "readme-renderer" = python.pkgs.buildPythonPackage {
              pname = "readme-renderer";
              version = "26.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/13/d6/8e241e4e40404a1f83567d6a29798abee0b9b50b08c8efc815ce11c41df9/readme_renderer-26.0.tar.gz";
                sha256 =
                  "cbe9db71defedd2428a1589cdc545f9bd98e59297449f69d721ef8f1cfced68d";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ bleach docutils pygments six ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description =
                  "readme_renderer is a library for rendering " readme
                  " descriptions for Warehouse";
              };
            };

            "typed-ast" = python.pkgs.buildPythonPackage {
              pname = "typed-ast";
              version = "1.4.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/18/09/b6a6b14bb8c5ec4a24fe0cf0160aa0b784fd55a6fd7f8da602197c5c461e/typed_ast-1.4.1.tar.gz";
                sha256 =
                  "8c8aaad94455178e3187ab22c8b01a3837f8ee50e09cf31f1ba129eb293ec30b";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description =
                  "a fork of Python 2 and 3 ast modules with type comment support";
              };
            };

            "cryptography" = python.pkgs.buildPythonPackage {
              pname = "cryptography";
              version = "2.9.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/56/3b/78c6816918fdf2405d62c98e48589112669f36711e50158a0c15d804c30d/cryptography-2.9.2.tar.gz";
                sha256 =
                  "a0c30272fb4ddda5f5ffc1089d7405b7a71b0b0f51993cb4e5dbb4590b2fc229";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ setuptools wheel cffi ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ six cffi ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description =
                  "cryptography is a package which provides cryptographic recipes and primitives to Python developers.";
              };
            };

            "py" = python.pkgs.buildPythonPackage {
              pname = "py";
              version = "1.8.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/1b/2b/396ff4b82f58c1152daf3b335999b493541a9d141bf102e22b4294b3b6aa/py-1.8.2.tar.gz";
                sha256 =
                  "f3b3a4c36512a4c4f024041ab51866f11761cc169670204b235f6b20523d4e6b";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "library with cross-python path, ini-parsing, io, code, log facilities";
              };
            };

            "nix-prefetch-github" = python.pkgs.buildPythonPackage {
              pname = "nix-prefetch-github";
              version = "2.4";
              src = pkgs.fetchgit {
                url = "https://github.com/seppeljordan/nix-prefetch-github.git";
                sha256 = "1iig5llipz5br3dmiki6q598z83c2lz5v2chk7s56b5hzk6nksnb";
                rev = "dc3e2fd38a8f1844702937d01b910aab69738976";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs =
                (with self; [ attrs click effect jinja2 ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = "GPLv3";
                description =
                  "Prefetch source code from github for nix build tool";
              };
            };

            "multidict" = python.pkgs.buildPythonPackage {
              pname = "multidict";
              version = "4.7.6";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/65/d4/fabdcc5ee4451c8a8e177e27ddfd131a53a82ecc5a3b68468b7e9f8d70b4/multidict-4.7.6.tar.gz";
                sha256 =
                  "fbb77a75e529021e7c4a8d4e823d88ef4d23674a202be4f5addffc72cbb91430";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ pip setuptools wheel ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.asl20;
                description = "multidict implementation";
              };
            };

            "alabaster" = python.pkgs.buildPythonPackage {
              pname = "alabaster";
              version = "0.7.12";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/cc/b4/ed8dcb0d67d5cfb7f83c4d5463a7614cb1d078ad7ae890c9143edebbf072/alabaster-0.7.12.tar.gz";
                sha256 =
                  "a661d72d58e6ea8a57f7a86e37d86716863ee5e92788398526d58b26a4e4dc02";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "A configurable sidebar-enabled Sphinx theme";
              };
            };

            "bumpv" = python.pkgs.buildPythonPackage {
              pname = "bumpv";
              version = "0.3.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/2a/9d/bc43d47c45c789241fe71741e13fe7c741db3a0bf446ac390f96380dd02d/bumpv-0.3.0.tar.gz";
                sha256 =
                  "aebae7e77807b70c0155c7a677c8ad915dc2cb625d4243479876c695e07de44f";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ click pyaml ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "Version-bump your software with a single command!";
              };
            };

            "flake8-debugger" = python.pkgs.buildPythonPackage {
              pname = "flake8-debugger";
              version = "3.2.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/d5/e8/b3785700b0a7300fbce7e46df081cbe497f9d0dd0498fe8eaccc0dbb76f5/flake8-debugger-3.2.1.tar.gz";
                sha256 =
                  "712d7c1ff69ddf3f0130e94cc88c2519e720760bce45e8c330bfdcb61ab4090d";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ flake8 pycodestyle ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "ipdb/pdb statement checker plugin for flake8";
              };
            };

            "sphinxcontrib-jsmath" = python.pkgs.buildPythonPackage {
              pname = "sphinxcontrib-jsmath";
              version = "1.0.1";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz";
                sha256 =
                  "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "A sphinx extension which renders display math in HTML via JavaScript";
              };
            };

            "pyrsistent" = python.pkgs.buildPythonPackage {
              pname = "pyrsistent";
              version = "0.16.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/9f/0d/cbca4d0bbc5671822a59f270e4ce3f2195f8a899c97d0d5abb81b191efb5/pyrsistent-0.16.0.tar.gz";
                sha256 =
                  "28669905fe725965daa16184933676547c5bb40a5153055a8dee2a4bd7933ad3";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ six ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "Persistent/Functional/Immutable data structures";
              };
            };

            "isort" = python.pkgs.buildPythonPackage {
              pname = "isort";
              version = "4.3.21";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/43/00/8705e8d0c05ba22f042634f791a61f4c678c32175763dcf2ca2a133f4739/isort-4.3.21.tar.gz";
                sha256 =
                  "54da7e92468955c4fceacd0c86bd0ec997b0e1ee80d97f67c35a78b719dccab1";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "A Python utility / library to sort Python imports.";
              };
            };

            "pytest-cov" = python.pkgs.buildPythonPackage {
              pname = "pytest-cov";
              version = "2.10.0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/8c/0d/a2b62bbd80285ce9f1f308292eb2d5af852e7b57b6c096e91b8476ac0d5e/pytest-cov-2.10.0.tar.gz";
                sha256 =
                  "1a629dc9f48e53512fcbfda6b07de490c374b0c83c55ff7a1720b3fccff0ac87";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ pytest coverage ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description = "Pytest plugin for measuring coverage.";
              };
            };

            "pytoml" = python.pkgs.buildPythonPackage {
              pname = "pytoml";
              version = "0.1.21";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/f4/ba/98ee2054a2d7b8bebd367d442e089489250b6dc2aee558b000e961467212/pytoml-0.1.21.tar.gz";
                sha256 =
                  "8eecf7c8d0adcff3b375b09fe403407aa9b645c499e5ab8cac670ac4a35f61e7";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self;
                [

                ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "A parser for TOML-0.4.0";
              };
            };

            "secretstorage" = python.pkgs.buildPythonPackage {
              pname = "secretstorage";
              version = "3.1.2";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/fd/9f/36197c75d9a09b1ab63f56cb985af6cd858ca3fc41fd9cd890ce69bae5b9/SecretStorage-3.1.2.tar.gz";
                sha256 =
                  "15da8a989b65498e29be338b3b279965f1b8f09b9668bd8010da183024c8bff6";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [ setuptools wheel ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ cryptography jeepney ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.bsdOriginal;
                description =
                  "Python bindings to FreeDesktop.org Secret Service API";
              };
            };

            "flake8-unused-arguments" = python.pkgs.buildPythonPackage {
              pname = "flake8-unused-arguments";
              version = "0.0.4";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/f0/c6/fb99403c74e282e9a524abb7fab1d2b45860b6298d1df16f5b88d00bf515/flake8-unused-arguments-0.0.4.tar.gz";
                sha256 =
                  "dc0859711d5f48f3dfe37ef04117bf0ff5e1e740d286e35816cb750c1c96863e";
              };
              doCheck = false;
              format = "setuptools";
              nativeBuildInputs = with self;
                [

                ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [ flake8 ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description =
                  "flake8 extension to warn on unused function arguments";
              };
            };

            "black" = python.pkgs.buildPythonPackage {
              pname = "black";
              version = "19.10b0";
              src = pkgs.fetchurl {
                url =
                  "https://files.pythonhosted.org/packages/b0/dc/ecd83b973fb7b82c34d828aad621a6e5865764d52375b8ac1d7a45e23c8d/black-19.10b0.tar.gz";
                sha256 =
                  "c2edb73a08e9e0e6f65a0e6af18b059b8b1cdd5bef997d7a0b181df93dc81539";
              };
              doCheck = false;
              format = "pyproject";
              nativeBuildInputs = with self; [
                setuptools
                setuptools-scm
                wheel
              ];
              buildInputs = commonBuildInputs;
              propagatedBuildInputs = (with self; [
                click
                attrs
                appdirs
                toml
                typed-ast
                regex
                pathspec
              ]);
              meta = with pkgs.lib; {
                homepage = "";
                license = licenses.mit;
                description = "The uncompromising code formatter.";
              };
            };

          };
          overrides = with pkgs.lib;
            fold composeExtensions (self: super: { }) [

              (import "${self}/requirements_override.nix" {
                inherit pkgs python;
              })
            ];
          pythonPackages = with pkgs.lib;
            with builtins;
            # We need to remove the __unfix__ attribute since it
            # does not evaluate to a derivation and causes problems
            # when we want to select all packages from the set.
            removeAttrs (fix' (extends overrides generatedPackages))
            [ "__unfix__" ];
          interpreterWithPackages = selectPkgsFn:
            let selectedPackages = selectPkgsFn pythonPackages;
            in python.pkgs.buildPythonPackage {
              name = "python3-interpreter";
              buildInputs = [ pkgs.makeWrapper ] ++ selectedPackages;
              buildCommand = ''
                mkdir -p $out/bin
                ln -s ${python.interpreter} $out/bin/${python.executable}
                for dep in ${builtins.concatStringsSep " " selectedPackages}; do
                  if [ -d "$dep/bin" ]; then
                    for prog in "$dep/bin/"*; do
                      if [ -x "$prog" ] && [ -f "$prog" ]; then
                        ln -s $prog $out/bin/`basename $prog`
                      fi
                    done
                  fi
                done
                for prog in "$out/bin/"*; do
                  wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
                done
                pushd $out/bin
                ln -s ${python.executable} python
                ln -s ${python.executable} python3
                popd
              '';
              passthru.interpreter = pythonPackages.python;
            };
          interpreter = interpreterWithPackages builtins.attrValues;
        in { inherit python interpreterWithPackages interpreter; });
    };
}
