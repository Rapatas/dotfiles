#!/bin/bash

sudo apt install -y tilda

tilda &
sleep 3
pkill tilda
sleep 3

TILDACONF="$HOME/.config/tilda/config_0"

sed -i '/^font=/s/=.*/="DejaVuSansMono Nerd Font Mono 9"/'  $TILDACONF
sed -i '/^key=/s/=.*/="<Super>Escape"/'  $TILDACONF
sed -i '/^increase_font_size_key=/s/=.*/="<Control>equal"/'  $TILDACONF
sed -i '/^decrease_font_size_key=/s/=.*/="<Control>minus"/'  $TILDACONF
sed -i '/^normalize_font_size_key=/s/=.*/="<Control>0"/'  $TILDACONF
sed -i '/^max_width=/s/=.*/=1920/' $TILDACONF
sed -i '/^max_height=/s/=.*/=834/' $TILDACONF
sed -i '/^scrollbar_pos=/s/=.*/=2/' $TILDACONF
sed -i '/^scroll_history_infinite=/s/=.*/=true/' $TILDACONF
sed -i '/^scrollbar=/s/=.*/=false/' $TILDACONF
sed -i '/^enable_transparency=/s/=.*/=true/' $TILDACONF
sed -i '/^grab_focus=/s/=.*/=true/' $TILDACONF
sed -i '/^animation=/s/=.*/=true/' $TILDACONF
sed -i '/^transparency=/s/=.*/=0/' $TILDACONF
sed -i '/^back_alpha=/s/=.*/=52415/' $TILDACONF

echo "Done"
