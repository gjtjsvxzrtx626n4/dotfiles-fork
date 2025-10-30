#!/bin/bash

# Скрипт для настройки Ubuntu с помощью NixOS конфигурации

set -e  # Прервать выполнение при ошибке

echo "Начинаем настройку Ubuntu..."

# Проверяем, установлен ли curl (необходим для установки Nix)
if ! command -v curl &> /dev/null; then
    echo "Устанавливаем curl..."
    sudo apt update
    sudo apt install -y curl
fi

# Устанавливаем Nix, если он еще не установлен
if ! command -v nix &> /dev/null; then
    echo "Устанавливаем Nix..."
    curl -L https://nixos.org/nix/install | sh
    . ~/.nix-profile/etc/profile.d/nix.sh
    
    # Добавляем Nix в PATH для текущей сессии
    export PATH="$HOME/.nix-profile/bin:$PATH"
    
    # Включаем flakes
    mkdir -p ~/.config/nix
    echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
else
    echo "Nix уже установлен"
fi

# Проверяем, что мы в правильной директории (должна быть nix-darwin)
if [ ! -f "flake.ubuntu.nix" ]; then
    echo "Ошибка: Не найден файл flake.ubuntu.nix"
    echo "Пожалуйста, запустите этот скрипт из директории nix-darwin"
    exit 1
fi

# Применяем конфигурацию Ubuntu
echo "Применяем конфигурацию Ubuntu..."
sudo nixos-rebuild switch --flake ./flake.ubuntu.nix#ubuntu-system

echo "Настройка завершена! Перезагрузите систему для применения всех изменений."