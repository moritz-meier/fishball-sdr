{ ... }:
{
  services.openssh.settings.PermitRootLogin = "yes";
  users.users.root.initialPassword = "root";
}
