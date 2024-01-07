# ring-of-power

requirements: 
1. gpg - to secure your private key fo FS
2. 

SET UP GUIDE:

1. Download linux image and extract it to a bin subdirectory
2. Init vm via command `just init <secret-password>`
3. Change `justfile` parameter `DEFAULT_ISO` to `bin/<your_iso_image_with_linux.iso>`
4. Run vm installation mode via command `just install`
5. Copy and run next commands:

````bash
mkdir /mnt/ext
mount -t 9p -o trans=virtio,version=9p2000.L host0 /mnt/ext
````

# Known issues

* your secret key for FS is not so secret while VM is running