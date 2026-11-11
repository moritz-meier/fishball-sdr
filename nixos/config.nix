{ pkgs, ... }: {
  networking.dhcpcd.enable = false;
  networking.firewall.enable = false;
  networking.useDHCP = false;

  systemd.network = {
    enable = true;
    networks."99-main" = {
      matchConfig.Name = "br* en* eth* wl* ww*";
      DHCP = "yes";
      networkConfig.LLMNR = false;
      networkConfig.LinkLocalAddressing = "yes";
      networkConfig.MulticastDNS = true;
    };
  };

  users.users.root.initialPassword = "root";

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  environment.systemPackages = with pkgs; [
    libiio
  ];
}
