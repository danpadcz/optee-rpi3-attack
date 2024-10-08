# How to replicate the attack from the "[Attacking TrustZone](https://link.springer.com/article/10.1007/s11416-021-00413-y)" paper

This is a tutorial for OP-TEE 4.3.0, which at the time of writing this README is the latest release version of OP-TEE.

## Step 1 - Build OP-TEE and run it on the Raspberry Pi 3 Model B+

### Pre-built

Use the rpi3-sdcard.img that is in this git to flash OP-TEE on your Raspberry Pi. 

### Build it yourself

For easy building, follow the tutorial at the [OP-TEE documentation](https://optee.readthedocs.io/en/latest/building/gits/build.html#get-and-build-the-solution).
When selecting a manifest, choose the version 4.3.0. Compared to the 3.13.0 version, this version doesn't need to be built in a VM. If you do choose to do so, I used a fully updated Pop!\_OS 22.04 LTS release.

### After building

To flash OP-TEE on the RPI use the command `sudo dd if=/path/to/this/git/repo/rpi3-sdcard.img of=/dev/<name-of-my-sd-card> bs=1024k conv=fsync status=progress`.

For more info use the [RPI3 part of the OP-TEE documentation](https://optee.readthedocs.io/en/latest/building/devices/rpi3.html#build-instructions).

## Step 2 - replace the hello\_world TA with the attacking TA

Now that we have OP-TEE running on the RPI3, we can replace the hello world trusted application (`8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta`) with our attacking TA.

### Pre-built

Once again if you prefer, the pre-build TA is in this repo at `Changed TA/8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta`.

### Build it yourself 

Before you build the TA, you also have to change the private key the TA gets signed with. To do that, go to the optee_os directory at `your_optee_build_dir/optee_os/keys/`.
Here move the existing `default.pem` file somewhere else (or delete it if you know you won't need it) and generate a new RSA 2048 bit key called `default.pem` (`openssl genrsa -out default.pem 2048`).

Now, go to the directory `your_optee_build_dir/optee_os/` and rebuild the OP-TEE OS using the command:

```
make     CFG_ARM64_core=y     CFG_TEE_BENCHMARK=n     CFG_TEE_CORE_LOG_LEVEL=3     CROSS_COMPILE=aarch64-linux-gnu-     CROSS_COMPILE_core=aarch64-linux-gnu-     CROSS_COMPILE_ta_arm32=arm-linux-gnueabihf-     CROSS_COMPILE_ta_arm64=aarch64-linux-gnu-     O=out/arm     PLATFORM=rpi3
```
Note: you might have to put into your path the `aarch64-linux-gnu-` and `arm-linux-gnueabihf-` toolkits, you'll find the bin directories at `your_optee_build_dir/toolchains/aarch32/bin/` and `your_optee_build_dir/toolchains/aarch64/bin/`.

Lastly, you have to edit the TA source code to print any string you prefer. You'll find the TA source code at `your_optee_build_dir/optee_examples/hello_world/ta/hello_world_ta.c` and in this file edit the "Hello World!" string. Then build the new TA using this make command: `make CROSS_COMPILE=aarch64-linux-gnu- PLATFORM=rpi3 TA_DEV_KIT_DIR=/path/to/your_optee_build_dir/optee_os/out/arm/export-ta_arm64/`

### After getting the built TA

After building, you have to copy the `8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta` file to the `/lib/optee_armtz/` directory on the RPI and overwrite the original hello_world TA. You can back-up the original TA if you want to.

## Step 3 - get the attack kernel module + script.

The authors of the paper have a module that enables us to use DMA transactions to read and write any place in memory. We use the writing module to rewrite four specific places in memory to enable our attack.

### Pre-built

Once again, the kernel module and script to use it is available as a pre-built module in the `DMA Module/` directory. 

### Build it yourself 

Clone the [DMA repo](https://github.com/ronst22/dma_repo.git) and apply the `changes.patch` file in the dma_repo directory using the `git patch path/to/changes.patch` command. Since you really only need the one_writer module, enter its directory and then in the `Makefile` change the path in the make command to `your_optee_build_dir/linux`. Then run the command `make` in the one_writer directory.

### After building the module

Copy the built `dma-writer.ko` file to your RPI3.

## Step 4 - do the attack

Copy the `attack_optee.sh` from this repo to your RPI3. Then on your RPI3, from the directory with the DMA kernel module, run the `attack_optee.sh` script.
Then simply call `optee_example_hello_world` and you'll hopefully see the new output string you determined when building the TA! If you used the pre-built option, you'll see "Attack succeeded!".

A common issue is that the kernel panics instead of running the attack. Simply reboot the Raspberry and re-do step 4 again. This should be enough to fix the panic.
