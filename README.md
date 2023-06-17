# digicam-import

Import files from connected digicam that supports Picture Transport Protocol (PTP).

## Usage

- Download run script to have `digicam-import` command available:
  ```bash
  sudo curl --fail --location --show-error https://raw.githubusercontent.com/suckowbiz/digicam-import/master/digicam-import.sh -o /usr/local/bin/digicam-import && sudo chmod +x /usr/local/bin/digicam-import
  ```
- Attach USB device that contains the pictures to access it.
- Unmount USB device (e.g. in file browser using `right click > Unmount`) to remove OS lock.
- Open a terminal and change into a directory to download photos to.
- Run `digicam-import` from command line and follow the help text to use the proper USB port that is read out and suggested. (Example: `/usr/local/bin/digicam-import -p usb:003,007`).
