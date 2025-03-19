#!/bin/bash

USB_RULES_FILE="/etc/udev/rules.d/99-usb-block.rules"
SERVICE_FILE="/etc/systemd/system/usb-control.service"


disable_usb () {
    echo 'SUBSYSTEM=="usb", ATTR{removable}=="1", ATTR{authorized}="0", ATTR{authorized_default}="0"' | sudo tee /etc/udev/rules.d/99-usb-block.rules > /dev/null
    sudo udevadm control --reload-rules && sudo udevadm trigger
    echo "USB ports disabled"
}

enable_usb () {
    echo 'SUBSYSTEM=="usb", ATTR{authorized}="1"' | sudo tee /etc/udev/rules.d/99-usb-block.rules > /dev/null
    sudo udevadm control --reload-rules && sudo udevadm trigger
    echo "USB ports enabled"
}

create_service () {
    echo "Creating usb-control.service"
    sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=USB Control Service
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'if [ -f $USB_RULES_FILE ]; then udevadm control --reload-rules && udevadm trigger; fi'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable usb-control.service
    sudo systemctl start usb-control.service
    echo "Service created"
}

remove_service () {
    echo "Deleting usb-control.service"
    sudo systemctl stop usb-control.service
    sudo systemctl disable usb-control.service
    sudo rm -f $SERVICE_FILE
    sudo systemctl daemon-reload
    echo "Service deleted"
}

status_usb () {
    if [ -f "$USB_RULES_FILE" ]; then
        echo "As of now USB ports are DISABLED"
    else
        echo "As of now USB ports are ENABLED"
    fi
}

case "$1" in
    disable)
        disable_usb
        ;;
    enable)
        enable_usb
        ;;
    install)
        create_service
        ;;
    remove)
        remove_servce
        ;;
    status)
        status_usb
        ;;
    *)
        echo "Usage: $0 {install|remove|enable|disable|status}"
        ;;
esac
