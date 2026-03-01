{ username, ... }:

{
  system.primaryUser = username;

  users.users.${username} = {
    home = "/Users/${username}";
  };

  home-manager.users.${username} = import ./${username};
}
