{ config, pkgs, ... }:

{
  # Установка базовых пакетов
  environment.systemPackages = with pkgs; [
    vim
    fish
  ];

  # Базовые настройки системы
  system.stateVersion = "24.05"; # Необходимо установить актуальную версию NixOS

  # Настройка пользователя
  users.users.server = {
    isNormalUser = true;
    description = "Server User";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    home = "/home/server";
  };

  # Включение необходимых сервисов
  services.openssh.enable = true;
  
  # Настройки Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Установка временной зоны
  time.timeZone = "Europe/Moscow";
  
  # Локализация
  i18n.defaultLocale = "en_US.UTF-8";
  
  # Настройки консоли
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}