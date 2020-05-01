#!/bin/bash
btmac="38_18_4C_03_D2_7C"
hssink="bluez_sink.$btmac.headset_head_unit"
hscard="bluez_card.$btmac"
hsprotocol="headset_head_unit"
hsnotifyicon="audio-headset"

a2dpprotocol="a2dp_sink"
a2dpsink="bluez_sink.$btmac.a2dp_sink"
a2dpcard="bluez_card.$btmac"
a2dpnotifyicon="audio-headphones"

if pacmd list-sinks | grep "$hsprotocol"; then
  tosetsink=$a2dpsink
  tosetcard=$a2dpcard
  tosetprotocol=$a2dpprotocol
  icon=$a2dpnotifyicon
else
  tosetsink=$hssink
  tosetcard=$hscard
  tosetprotocol=$hsprotocol
  icon=$hsnotifyicon
fi
echo "to $tosetcard | $tosetsink"
pactl set-card-profile "$tosetcard" "$tosetprotocol"
pacmd set-default-sink  "$tosetsink"

#move all inputs to the new sink
for app in $(pacmd list-sink-inputs | sed -n -e 's/index:[[:space:]]\([[:digit:]]\)/\1/p');
do
	pacmd "move-sink-input $app "$tosetsink""
done

notify-send -u normal -t 1000 -i "$icon" -c device "BT profile: $tosetprotocol"
