#! /bin/bash
#
# Increase disk/mem limits in /etc/policy/ImageMagick-6/policy.xml
#
# Disable PNG conversion in gscan2pdf preferences because it loses the DPI.
#
# Add an external tool: /path/to/script %i
#
# gscan2pdf user-defined tool variables:
#  %i     input filename
#  %o     output filename
#  %r     resolution
# An image can be modified in-place by just specifying %i.

IN="$1"

# Equivalent to GIMP merge grain
# https://blog.desdelinux.net/en/limpiar-documentos-escaneados-con-gimp/
# https://legacy.imagemagick.org/discourse-server/viewtopic.php?t=25085
T1=$(mktemp --suffix=.png)
convert "${IN}" "${IN}" \
	-compose Mathematics -define compose:args=0,1,1,-0.5 \
	-composite "${T1}"

T2=$(mktemp --suffix=.pnm)
unpaper --overwrite "${T1}" "${T2}"

rm -f "${T1}" "${IN}"
convert "${T2}" "${IN}"

rm -f "${T2}"
