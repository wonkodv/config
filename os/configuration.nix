# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  all-deps, # from flake
  config,
  lib,
  pkgs,
  inputs,

  ...
}:
{

  imports =
    [
    ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs; 
    nixpkgsStable.flake = inputs.nixpkgsStable; 
  };

  hardware.graphics.enable = true;

  networking.hostName = "deepthought"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
    "en_DK.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_DK.UTF-8";
    LANG = "en_US.UTF-8";
  };

  console.colors = [
    "002b36"
    "dc322f"
    "859900"
    "b58900"
    "268bd2"
    "d33682"
    "2aa198"
    "eee8d5"
    "002b36"
    "cb4b16"
    "586e75"
    "657b83"
    "839496"
    "6c71c4"
    "93a1a1"
    "fdf6e3"
  ];

  services.libinput.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce = {
    enable = true;
    noDesktop = true;
    enableXfwm = false;
  };

  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      vicious
    ];
  };

  services.displayManager.defaultSession = "xfce+awesome";

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mr";

  services.xserver.xkb.layout = "us,de";
  services.xserver.xkb.variant = "altgr-intl,";
  services.xserver.xkb.options = "caps:toggle";

  # 2024-05-01: Reperiert das screen tear? => Nein
  services.xserver.deviceSection = ''Option "TearFree" "true"''; # For amdgpu.

  # 2025-02-19: Repariert dieses villeicht VSync?
  services.picom = {
    enable = true;
    vSync = true;
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };
  services.udev.packages = [ pkgs.sane-airscan ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  users.users.mr = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "lp"
      "dialout"
    ];
    hashedPassword = "$y$j9T$AjsEFU2u5ZJwewZMKCdfV0$lueB4RwUlC0TrO30RYuh9v5e7Cn0Zcf4LVGoFp6GzO6";
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "/run/current-system/sw/bin/efibootmgr -n 0001";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/poweroff";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    efibootmgr
    kbd
    nextcloud-client
    xsane
    git
    neovim
  ] ++ all-deps;

  nixpkgs.config.packageOverrides = pkgs: {
    xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];

  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  programs.ausweisapp.enable = true;
  services.pcscd.enable = true;
  services.pcscd.plugins = [ pkgs.pcsc-cyberjack ];

  virtualisation.virtualbox.host.enable = true;
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ]; # TODO: workaround because kvm seems to be enabled now and VB don't like it
  users.extraGroups.vboxusers.members = [ "mr" ];

  # programs.virt-manager.enable = true;
  # users.groups.libvirtd.members = ["mr"];
  # virtualisation.libvirtd.enable = true;
  # virtualisation.spiceUSBRedirection.enable = true;

  # List services that you want to enable:
  systemd.services.numLockOnTty = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = lib.mkForce (
        pkgs.writeShellScript "numLockOnTty" ''
          for tty in /dev/tty{1..6}; do
              ${pkgs.kbd}/bin/setleds -D +num < "$tty";
          done
        ''
      );
    };
  };
  systemd.user.timers."numlockx_boot" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnStartupSec = "1us";
      AccuracySec = "1us";
      Unit = "numlockx.service";
    };
  };

  systemd.user.services."numlockx" = {
    script = ''${pkgs.numlockx}/bin/numlockx on '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  services.gnome.gnome-keyring.enable = true;

  services.openssh.enable = true;

  security.pam.u2f.settings.cue = true;
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-emoji
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
