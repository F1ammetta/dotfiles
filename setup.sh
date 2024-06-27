
dotfiles_dir=$(pwd)

#install zsh plugins
echo "Installing zsh plugins ..."
cd .oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-history-substring-search.git
cd ..

# Install fonts
echo "Installing fonts ..."
pacman -S ttf-agave-nerd noto-fonts-cjk
cd $HOME
if [ ! -d ".fonts" ]; then
    mkdir .fonts
fi
cd .fonts
cp $dotfiles_dir/.fonts/* .
fc-cache -f -v

#create symlinks
cd $HOME
ln -s $dotfiles_dir/.zshrc
ln -s $dotfiles_dir/.oh-my-zsh

ln -s $dotfiles_dir/.tmux.conf
ln -s $dotfiles_dir/.tmux

if [ ! -d ".config" ]; then
    mkdir .config
fi
cd .config

ln -s $dotfiles_dir/.config/alacritty
ln -s $dotfiles_dir/.config/dunst
ln -s $dotfiles_dir/.config/bspwm
ln -s $dotfiles_dir/.config/sxhkd
ln -s $dotfiles_dir/.config/polybar
ln -s $dotfiles_dir/.config/nvim
ln -s $dotfiles_dir/.config/picom.conf
ln -s $dotfiles_dir/.config/rofi

#install packages
echo "Installing packages ..."
pacman -S $(cat $dotfiles_dir/packages.txt | tr '\n' ' ')

# Install paru
echo "Installing the mighty AUR helper (paru)..."
cd $HOME
if [ ! -d "repos" ]; then
    mkdir repos
fi
cd repos
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

paru -S $(cat $dotfiles_dir/paru.txt | tr '\n' ' ')

echo "Done!"
