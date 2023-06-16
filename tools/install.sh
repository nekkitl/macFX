#!/bin/bash
rm -f ~/.config/fish/functions/macfx.fish
curl https://api.nekkit.xyz/macfx/app > ~/.config/fish/functions/macfx.fish && source