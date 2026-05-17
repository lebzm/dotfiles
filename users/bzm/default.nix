let
  username = "bzm";
in

{
  imports = [ ../home-manager.nix ];
  users.users.${username} = {
    home = "/Users/${username}";
  };
  home-manager.users.${username} = import ./home.nix;
}
