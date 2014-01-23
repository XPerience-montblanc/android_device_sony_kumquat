# HW configuration file for kumquat
# Touch FW loader
cyttsp_fwloader -dev /sys/bus/spi/devices/spi9.0 -fw /etc/firmware/ttsp_fw.hex

# Audio jack configuration
dev=/sys/devices/platform/simple_remote.0
echo 0,301,1901 > $dev/accessory_min_vals
echo 300,1900  > $dev/accessory_max_vals
echo 0,51,251,511,851 > $dev/button_min_vals
echo 50,250,510,850,5000  > $dev/button_max_vals

# Proximity sensor configuration
dev=/sys/bus/i2c/devices/2-0054/
val_cycle=2
val_nburst=0
val_freq=2
val_threshold=5
val_filter=0

echo $val_cycle > $dev/cycle    # Duration Cycle. Valid range is 0 - 3.
echo $val_nburst > $dev/nburst  # Numb er of pulses in burst. Valid range is 0 - 15.
echo $val_freq > $dev/freq      # Burst frequency. Valid range is 0 - 3.

if `ls /data/etc/threshold > /dev/null`; then
    cat /data/etc/threshold > $dev/threshold # Use value from calibration
    rm /data/etc/threshold # Remove temp file
else # No value from calibration, use default value
    echo $val_threshold > $dev/threshold # sensor threshold. Valid range is 0 - 15 (0.12V - 0.87V)
fi

if `ls /data/etc/filter > /dev/null`; then
    cat /data/etc/filter > $dev/filter # Use value from calibration
    rm /data/etc/filter # Remove temp file
else # No value from calibration, use default value
    echo $val_filter > $dev/filter  # RFilter. Valid range is 0 - 3.
fi




#XPERIENCE CONFIGS
# Configure governor based on system property
governor_name=`getprop ro.cpufreq.governor`
case "$governor_name" in
    "interactive")
        echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 800000 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
        echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
        chown system /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
        chown system /sys/devices/system/cpu/cpufreq/interactive/timer_rate
       ;;
    *)
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
        echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
        echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        chown system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
        chown system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
        chown system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
      ;;
esac

#XPE_Modules_BACKPORTED TO XPeria GO
insmod /system/lib/modules/axperiau_ondemandax.ko
insmod /system/lib/modules/axperiau_pegasusq.ko
insmod /system/lib/modules/axperiau_sio_iosched.ko
insmod /system/lib/modules/axperiau_smartass2.ko
insmod /system/lib/modules/axperiau_vr_iosched.ko
insmod /system/lib/modules/axperiau_lulzactiveq.ko

# free pagecache, dentries and inodes
sync && echo 3 > /proc/sys/vm/drop_caches

#XPE fast GPU
dev=/system/lib/elg
echo 1 > $dev/libEGL_mali.so
