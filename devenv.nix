{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    rustlings
  ];

  # https://devenv.sh/languages/
  languages.rust = {
    enable = true;
    # https://devenv.sh/reference/options/#languagesrustchannel
    channel = "stable";

    components = [
      "rustc"
      "cargo"
      "clippy"
      "rustfmt"
      "rust-analyzer"
    ];
    mold.enable = true;
    version = "1.95.0";
  };

  # https://devenv.sh/processes/
  processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    echo "🚀 Welcome to the Rust Development Environment!"
    echo "   Rust:    $(rustc --version)"
    echo "   Cargo:   $(cargo --version)"
    echo ""
    echo "💡 Run 'devenv tasks list'."
  '';

  # https://devenv.sh/tasks/
  tasks = {
    #   "myproj:setup".exec = "mytool build";
    #   "devenv:enterShell".after = [ "myproj:setup" ];
    "rust:compile" = {
      exec = "cargo build --release";
      execIfModified = [
        "src/**/*.rs"
        "Cargo.toml"
        "Cargo.lock"
      ];
    };
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;
  git-hooks.hooks = {
    rustfmt.enable = true;
    clippy.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
