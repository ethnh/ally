# Ally

Ally is a contact networking, group-oriented document sharing (in the style of blogging) application written for the Veilid (https://www.veilid.com) distributed application platform. 

## Developers
Contributions welcome!

## Ally

This application is based on Ally. This work is copyleft

For more information about Ally: https://veilid.chat

For more information about the Veilid network protocol and app development platform: https://veilid.com

## Setup
While this is still in development, you must have a clone of the Veilid source checked out at `../veilid` relative to the working directory of this repository.

### For Linux Systems:
```
./setup_linux.sh
```

### For Mac Systems:
```
./setup_macos.sh
```

## Updating Code

### To update the WASM binary from `veilid-wasm`:
* Debug WASM: run `./wasm_update.sh`
* Release WASM: run `/wasm_update.sh release`

