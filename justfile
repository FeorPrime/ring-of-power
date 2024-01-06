DEFAULT_ISO:="bin/alpine-standard-3.19.0-x86_64.iso"
IMG:="bin/control-vm.luks"
SECRET:="secrets/secret.txt"

create-pass PASS:
    if [ ! -f "{{SECRET}}" ]; \
    then echo {{PASS}} | base64 -o {{SECRET}} \
    ;else echo "{{SECRET}} already exists! Cleanup first!"; fi

init PASS:
    just create-pass {{PASS}}
    if [ ! -f "{{IMG}}" ]; \
    then qemu-img create -f luks --object secret,id=sec0,file={{SECRET}},format=base64 -o key-secret=sec0 {{IMG}}  2G \
    ;else echo "{{IMG}} already exists! Cleanup first!"; fi

install ISO=DEFAULT_ISO:
    if [ -f "{{ISO}}" ]; \ 
    then qemu-system-x86_64 -m 2g -drive file={{IMG}},key-secret=sec0 -cdrom {{ISO}} --object secret,id=sec0,file={{SECRET}},format=base64\
    ;else echo "you must download ISO with alpine linux image"; fi

run:
    if [ -f "{{IMG}}" ]; \
    then qemu-system-x86_64 -m 2g -drive file={{IMG}},key-secret=sec0 --object secret,id=sec0,file=secrets/secret.txt,format=base64\
    ;else echo "you must run init first";fi

[confirm]
cleanup:
    rm -f {{IMG}}
    rm -f {{SECRET}}

check :
    if [ -f "{{IMG}}" ] && [ -f "{{SECRET}}" ] && [ -f "{{DEFAULT_ISO}}" ]; then echo "everything is set up correctly"; else echo "you must run init first"; fi
