raspi_config_file="/boot/config.txt"
autostart_file="/boot/config.txt"

# Copy 3.5inch dpi drivers (https://www.waveshare.net/wiki/3.5inch_DPI_LCD) to raspbian
echo "Copy 3.5inch dpi drivers..."
cp 3.5DPI-dtbo/* /boot/overlays/

# Add configs
valid_choice=false

# Function to insert text into a file
insert_text() {
    local file="$1"
    local text="$2"

    # Check if the text already exists in the file
    if grep -qF "$text" "$file"; then
        echo "Text already exists in $file:  $text"
    else
        # Insert the text at the end of the file
        echo "$text" >> "$file"
        echo "$text >> $file."
    fi
}

# Setup on Raspberry Pi OS Bookworm/Bullseye
SetupOnAboveBullseye() {
    echo "Add driver config..."
    insert_text "$raspi_config_file" "dtoverlay=vc4-kms-v3d"
    insert_text "$raspi_config_file" "dtoverlay=vc4-kms-DPI-35inch"
    insert_text "$raspi_config_file" "dtoverlay=waveshare-35dpi-3b-4b"
    insert_text "$raspi_config_file" "dtoverlay=waveshare-35dpi-3b"
    insert_text "$raspi_config_file" "dtoverlay=waveshare-35dpi-4b"
    insert_text "$raspi_config_file" "dtoverlay=waveshare-35dpi"
    insert_text "$raspi_config_file" "dtoverlay=waveshare-touch-35dpi"
}

# Setup on Raspberry Pi OS Buster/Ubuntu
SetupOnOthers() {
    echo "Add driver config..."
    insert_text "$raspi_config_file" "gpio=0-9=a2"
    insert_text "$raspi_config_file" "gpio=12-17=a2"
    insert_text "$raspi_config_file" "gpio=20-25=a2"
    insert_text "$raspi_config_file" "dtoverlay=dpi18"
    insert_text "$raspi_config_file" "enable_dpi_lcd=1"
    insert_text "$raspi_config_file" "display_default_lcd=1"
    insert_text "$raspi_config_file" "extra_transpose_buffer=2"
    insert_text "$raspi_config_file" "dpi_group=2"
    insert_text "$raspi_config_file" "dpi_mode=87"
    insert_text "$raspi_config_file" "dpi_output_format=0x6f006"
    insert_text "$raspi_config_file" "hdmi_timings=640 0 20 10 10 480 0 10 5 5 0 0 0 60 0 60000000 1"
    insert_text "$raspi_config_file" "dtoverlay=waveshare-35dpi-3b-4b"
    insert_text "$raspi_config_file" "dtoverlay=waveshare-35dpi-3b"
    insert_text "$raspi_config_file" "dtoverlay=waveshare-35dpi-4b"
}

SetupChromiumAutoStart(){
    echo "Add autostart config..."
    sudo mkdir -p ~/.config/autostart
    # Add autostart config
    sudo cp config/raspi-macintosh-clock.desktop ~/.config/autostart/raspi-macintosh-clock.desktop
    sudo chmod +x ~/.config/autostart/raspi-macintosh-clock.desktop
}


while [ "$valid_choice" = false ]; do
    echo "Select your OS system:"
    echo "1: Raspberry Pi OS Bookworm/Bullseye"
    echo "2: Raspberry Pi OS Buster/Ubuntu"
    read -p "Input the number: " choice

    case $choice in
        1)
            SetupOnAboveBullseye
            valid_choice=true
            ;;
        2)
            SetupOnOthers
            valid_choice=true
            ;;
        *)
            echo "Invalid input!"
            ;;
    esac
done

SetupChromiumAutoStart
read -rp "Setup up finish. Press Enter to reboot:"
sudo reboot
