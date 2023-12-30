create-pass PASS:
    echo {{PASS}} | base64 -o secrets/secret.txt
init PASS:
    just create-pass {{PASS}}
    qemu-img create -f luks --object secret,id=sec0,file=secrets/secret.txt,format=base64 -o key-secret=sec0 bin/control-vm.luks  2G
run ISO="bin/alpine-standard-3.19.0-x86_64.iso":
    qemu-system-x86_64 -m 2g -drive file=bin/control-vm.luks,key-secret=sec0 -cdrom {{ISO}} --object secret,id=sec0,file=secrets/secret.txt,format=base64