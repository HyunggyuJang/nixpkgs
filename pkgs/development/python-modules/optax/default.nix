{ lib
, absl-py
, buildPythonPackage
, chex
, fetchFromGitHub
, jaxlib
, numpy
, callPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "optax";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vimsVZV5Z11euLxsu998pMQZ0hG3xl96D3h9iONtl/E=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  buildInputs = [
    jaxlib
  ];

  propagatedBuildInputs = [
    absl-py
    chex
    numpy
  ];

  postInstall = ''
    mkdir $testsout
    cp -R examples $testsout/examples
  '';

  pythonImportsCheck = [
    "optax"
  ];

  # check in passthru.tests.pytest to escape infinite recursion with flax
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Gradient processing and optimization library for JAX";
    homepage = "https://github.com/deepmind/optax";
    changelog = "https://github.com/deepmind/optax/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
