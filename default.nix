{ pkgs ? import <nixpkgs> {} }:

let
  ruby = pkgs.ruby;
  stdenv = pkgs.stdenv;
  _name = "mydj";

  env = pkgs.bundlerEnv {
    name = "${_name}-env";
    inherit ruby;
    gemfile  = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset   = ./gemset.nix;
  };

in stdenv.mkDerivation rec {
  version = "0.0.1";
  name = "${_name}-${version}";

  inherit ruby;

  buildInputs = with pkgs; [
    env
  ];

  propagatedBuildInputs = with pkgs; [
    bundler
    ruby
  ];

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    install -m0755 bin/woot $out/bin/woot
  '';

  meta = with pkgs.lib; {
    description = "Delayed Job in Ruby";
    homepage    = https://rubygems.org/;
    license     = with licenses; gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
