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
    makeWrapper
  ];
  installPhase = ''
    mkdir -p $out/bin/
    cp ./git-semver.sh $out/bin/git-semver
    wrapProgram "$out/bin/git-semver" \
      --set SYSTEM_CERTIFICATE_PATH "${cacert}/etc/ssl/certs"
  '';
}
