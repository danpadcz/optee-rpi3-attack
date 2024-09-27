# How to replicate the attack from the "[Attacking TrustZone](https://link.springer.com/article/10.1007/s11416-021-00413-y)" paper

## Step 1 - Build OP-TEE and run it on the Raspberry Pi 3 Model B+

### Pre-built

You can either use the `optee.zip` file that I provide for you at [my Google Drive](https://drive.google.com/file/d/1k0mB48RIh2ulVK3xNedkeFZ4rJizNBwS/view?usp=sharing), that already has the finished build done or build OP-TEE yourself.

### Build it yourself

There are a few catches to building it yourself. For easy building, follow the tutorial at the [OP-TEE documentation](https://optee.readthedocs.io/en/latest/building/gits/build.html#get-and-build-the-solution). Though when selecting a manifest, choose the version 3.13.0. Similarly, you should build OP-TEE on a fresh Ubuntu 20.04 LTS system, since this version should not crash when compiling.

## Step 2 - replace the hello_world TA with the attacking TA

Now that we have OP-TEE running on the RPI3, we can replace the hello world trusted application (`8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta`) with our attacking TA.

### Pre-built

Once again if you prefer, the pre-build TA is in this repo at `Changed TA/8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta`.

### Build it yourself 

If you would rather build it yourself, then first edit the TA source code to print any string you prefer. You'll find the TA source code at `your_optee_build_dir/optee_examples/hello_world/ta/hello_world_ta.c`. 

Before you build the TA, you also have to change the private key the TA gets signed with. To do that, go to the optee_os directory at `your_optee_build_dir/optee_os/keys/`. Here move the existing `.pem` file somewhere else (or delete it if you know you won't need it) and generate a new RSA 2048 bit key called default_ta.pem (`openssl genrsa -out default_ta.pem 2048`).

Now, in your optee_os directory, follow the (OP-TEE tutorial)[https://optee.readthedocs.io/en/latest/building/gits/optee_os.html#build-instructions] to rebuild the OP-TEE OS. Be sure to configure the make command correctly, I used:

`make     CFG_ARM64_core=y     CFG_TEE_BENCHMARK=n     CFG_TEE_CORE_LOG_LEVEL=3     CROSS_COMPILE=aarch64-linux-gnu-     CROSS_COMPILE_core=aarch64-linux-gnu-     CROSS_COMPILE_ta_arm32=arm-linux-gnueabihf-     CROSS_COMPILE_ta_arm64=aarch64-linux-gnu-     O=out/arm     PLATFORM=rpi3`

Lastly, to build the new TA, use this make command:

`make CROSS_COMPILE=aarch64-linux-gnu- PLATFORM=rpi3 TA_DEV_KIT_DIR=/path/to/your_optee_build_dir/optee_os/out/arm/export-ta_arm64/`

### After getting the built TA

After building, you have to copy the `8aaaf200-2450-11e4-abe2-0002a5d5c51b.ta` file to the `/lib/optee_armtz/` directory on the RPI and overwrite the original hello_world TA. You can back-up the original TA if you want to.

## Step 3 - get the attack kernel module + script.

The authors of the paper, have a module that enables us to use DMA transactions to read and write any place in memory. We use the writing module to rewrite four specific places in memory to enable our attack.

### Pre-built

Once again, the kernel module and script to use it is available as a pre-built module in the `DMA Module/` directory. 

### Build it yourself 

Clone the [DMA repo](https://github.com/ronst22/dma_repo.git). You really only need the one_writer directory, so enter that and then change the makefile to the makefile in the `DMA Module/Makefile` directory in this repo and edit the path to the linux directory in your OP-TEE build directory. Then run make in the one_writer directory on your Ubuntu 20.04 LTS system.

### After building the module

Copy the built `dma-writer.ko` file to your RPI3.

## Step 4 - do the attack

Copy the `attack_optee.sh` from this repo to your RPI3. Then on your RPI3, from the directory with the DMA kernel modules, run the `attack_optee.sh` script.
Then simply call `optee_example_hello_world` and you'll hopefully see the new output string you determined when building the TA! If you used the pre-built option, you'll see "Attack succeeded!".

A common issue is that the kernel panics instead of running the attack. Simply reboot the Raspberry and re-do step 4 again. This should be enough to fix the panic.
