DEFAULT_ISO:='bin/alpine-standard-3.19.0-x86_64.iso'
IMG:='bin/control-vm.luks'
SECRET:='secrets/secret.txt'
SHARED:='payloads/'

@create-pass PASS:
    if [ ! -f "{{SECRET}}" ]; \
    then echo {{PASS}} >> {{SECRET}} | base64 {{SECRET}} >> {{SECRET}}.b64 && gpg -c {{SECRET}}.b64 && rm -f {{SECRET}} && rm -f {{SECRET}}.b64\
    ;else echo "{{SECRET}} already exists! Cleanup first!"; fi    

@create-img IMAGE:
    if [ ! -f "{{IMAGE}}" ] && [ -f "{{SECRET}}.b64.gpg" ]; \
    then gpg {{SECRET}}.b64.gpg &&\
    qemu-img create -f luks --object secret,id=sec0,file={{SECRET}}.b64,format=base64 -o key-secret=sec0 {{IMG}}  2G\
    && rm -f {{SECRET}}.b64 \
    ;else echo "{{IMG}} already exists! Cleanup first!"; fi

init PASS:
    just create-pass {{PASS}}
    just create-img {{IMG}}

install ISO=DEFAULT_ISO:
    if [ -f "{{ISO}}" ] && [ -f "{{IMG}}" ]; \
    then gpg {{SECRET}}.b64.gpg &&\
    qemu-system-x86_64 -m 2g -drive file={{IMG}},key-secret=sec0 -cdrom {{ISO}} --object secret,id=sec0,file={{SECRET}}.b64,format=base64 -net user,smb={{SHARED}} \
    && rm {{SECRET}}.b64\
    ;else echo "you must download ISO with alpine linux image";fi
    
run:
    if [ -f "{{IMG}}" ]; \
    then  gpg {{SECRET}}.b64.gpg &&\
    qemu-system-x86_64 -m 2g -drive file={{IMG}},key-secret=sec0 --object secret,id=sec0,file=secrets/secret.txt,format=base64 -virtfs local,path={{SHARED}},mount_tag=host0,security_model=passthrough,id=host0\
    && rm {{SECRET}}.b64\
    ;else echo "you must run init first";fi

[confirm]
cleanup:
    rm -f {{IMG}}
    rm -f {{SECRET}}
    rm -f {{SECRET}}.b64
    rm -f {{SECRET}}.b64.gpg

check :
    if [ -f "{{IMG}}" ] && [ -f "{{SECRET}}.gpg" ] && [ -f "{{DEFAULT_ISO}}" ]; then echo "everything is set up correctly"; else echo "you must run init first"; fi
