let
  username = "billyzaelanimalik";
in

{
  imports = [ ../home-manager.nix ];
  system.primaryUser = username;
  users.users.${username} = {
    home = "/Users/${username}";
  };
  home-manager.users.${username} = import ./home.nix;
}
