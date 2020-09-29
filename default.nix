let nixpkgs = import ./nixpkgs19.nix;
in
{
  pkgs ? import nixpkgs {}
}:
with pkgs;

stdenv.mkDerivation {
  name = "git-semver";
  src = ./.;
  dontBuild = true;
  propagatedBuildInputs = [
    git
    wrapProgram
  ];
  installPhase = ''
    mkdir -p $out/bin/
    cp ./git-semver.sh $out/bin/git-semver.sh
    wrapProgram "$out/bin/git-semver.sh" \
      --set SYSTEM_CERTIFICATE_PATH "${cacert}/etc/ssl/certs"
  '';
}
