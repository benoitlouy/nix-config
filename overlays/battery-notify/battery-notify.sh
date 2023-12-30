SLEEP_TIME=30
full_flag=0
low_flag=0
crit_flag=0
vcrit_flag=0
BAT=BAT0
id=""
replace_args=()
while [ true ]; do
  cap_thresh=$(cat /sys/class/power_supply/$BAT/charge_stop_threshold)
  capc=$(cat /sys/class/power_supply/$BAT/capacity)
  if [[ $(cat /sys/class/power_supply/$BAT/status) != "Discharging" ]]; then # -- charging state
    # shutdown -c                                                               # -- closing the pending shutdowns from critical shutdown action
    low_flag=0
    crit_flag=0
    vcrit_flag=0
    if (($capc == $cap_thresh)); then
      if ((full_flag != 1)); then
        id=$(notify-send --icon battery-full "Battery full" -p "${replace_args[@]}")
        replace_args=('-r' "$id")
        full_flag=1
      fi
    fi
    SLEEP_TIME=30

  else # -- discharging state

    full_flag=0
    if (($capc >= 60)); then
      SLEEP_TIME=40
    else
      SLEEP_TIME=30
      if (($capc <= 10)); then
        SLEEP_TIME=20
        if ((low_flag != 1)); then
          id=$(notify-send --icon battery-low "Battery low" -u low -t 6000 -p "${replace_args[@]}")
          replace_args=('-r' "$id")
          low_flag=1
        fi

      fi
      if (($capc <= 5)); then
        SLEEP_TIME=15
        if ((crit_flag != 1)); then
          id=$(notify-send --icon battery-caution "Battery critical" -u critical -t 8000 -p "${replace_args[@]}")
          replace_args=('-r' "$id")
          crit_flag=1
        fi
      fi
      if (($capc <= 3)); then
        SLEEP_TIME=10
        if ((vcrit_flag != 1)); then
          id=$(notify-send --icon battery-empty "Battery empty" -u critical -t 10000 -p "${replace_args[@]}")
          replace_args=('-r' "$id")
          # shutdown
          vcrit_flag=1
        fi

      fi
    fi

  fi
  # echo "$capc sl_time = $SLEEP_TIME"
  sleep $SLEEP_TIME
done
