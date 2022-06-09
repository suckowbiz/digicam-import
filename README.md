# digicam-import

Import files from connected digicam that supports Picture Transport Protocol (PTP).

## Usage

- Attach device to access it
- Unmount device to remove OS lock
- Open a terminal and change into a directory to download photos to.
- Download run script to have `digicam-import` available:
  ```bash
  sudo curl --fail --location --show-error https://raw.githubusercontent.com/suckowbiz/digicam-import/master/digicam-import.sh -o /usr/local/bin/digicam-import && sudo chmod +x /usr/local/bin/digicam-import
  ```
