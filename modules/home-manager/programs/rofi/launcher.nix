{ pkgs, ... }:

''
#!${pkgs.bash}/bin/bash

${pkgs.rofi-wayland}/bin/rofi -show drun -modi drun
''
