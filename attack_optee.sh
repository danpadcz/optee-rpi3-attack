#!/bin/sh
insmod dma-writer.ko addr=269504764 data=905969279 \
&& rmmod dma-writer.ko \
&& insmod dma-writer.ko addr=269503448 data=889188511 \
&& rmmod dma-writer.ko  \
&& insmod dma-writer.ko addr=269504540 data=3942645791 \
&& rmmod dma-writer.ko \
&& insmod dma-writer.ko addr=269503036 data=905967455 \
&& rmmod dma-writer.ko

