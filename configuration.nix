{ pkgs, ... }: {

    environment.systemPackages = with pkgs; [ terraform_1 terragrunt ];

   users.extraUsers.root.password = "topsecret";

}
