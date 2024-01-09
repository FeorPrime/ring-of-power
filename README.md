# ring-of-power

This is simple bootstrapping script for making VM with qemu, with encrypted disk.
Also includes bootstrapping for ansible.

## Requirements

1. Qemu - guess why)
2. gpg - to secure your private key fo FS
3. Justfile - to make everything work, cuz it write on just.
4. Alpine Linux ISO - to spin up vm. (You can also use any other distro of your choice, but i guess part of this instructions may be different for you)

## SET UP GUIDE

1. Download linux image and extract it to a bin subdirectory
2. Init vm via command `just init <secret-password>`
3. Change `justfile` parameter `DEFAULT_ISO` to `bin/<your_iso_image_with_linux.iso>`
4. Run vm installation mode via command `just install`
5. Copy and run next commands:

````bash
mkdir /mnt/ext
mount -t 9p -o trans=virtio,version=9p2000.L host0 /mnt/ext
````

## Known issues

* your secret key for FS is not so secret while VM is running. Need to learn how to cleanup secrets asynchronously while vm starts.
