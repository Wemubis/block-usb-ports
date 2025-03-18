# block-usb-ports

## **🛠 Features**
This script allows you to **enable or disable USB ports** for external or removable devices while keeping internal components (e.g., Bluetooth) active. However, if a device is already connected, it will remain accessible until it is unplugged.

It also provides an optional **systemd service** to **persist the changes after a reboot**.

---

## **Installation & Usage**
1 **Install & Remove the service (for persistence)**  
```bash
sudo bash usb.sh install
```

```bash
sudo bash usb.sh remove
```

2 **Usage** (Blocks external/removable devices)  
```bash
sudo bash usb.sh {install|remove|enable|disable|status}
```

---

## **Add Aliases for Quick Access**
To make the commands easier, add the following aliases to your `~/.bashrc` or `~/.zshrc`:
```bash
alias usb-on='sudo bash <PathToFile>/usb.sh enable'
alias usb-off='sudo bash <PathToFile>/usb.sh disable'
alias usb-status='sudo bash <PathToFile>/usb.sh status'
```
Then, apply the changes:
```bash
source ~/.bashrc
source ~/.zshrc
```

Now you can quickly manage USB access with:
```bash
usb-on     # Enable USB ports
usb-off    # Disable USB ports
usb-status # Check if USB is blocked
```

---

## **❗ Important Notes**
- The script requires root privileges or sudo permissions and **blocks only removable USB devices** (`ATTR{removable}=="1"`).
- If some devices are still working, modify the rules manually in `/etc/udev/rules.d/99-usb-block.rules`.
- If Bluetooth gets blocked, check with `lsusb -t` and adjust the rule to **whitelist** its bus ID.
