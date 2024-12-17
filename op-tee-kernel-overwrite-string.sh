#!/bin/sh
insmod dma-writer.ko addr=269821235 data=1852990795
rmmod dma-writer.ko
insmod dma-writer.ko addr=269821239 data=1327524965
rmmod dma-writer.ko
insmod dma-writer.ko addr=269821243 data=2003985782
rmmod dma-writer.ko
insmod dma-writer.ko addr=269821247 data=1953786226
rmmod dma-writer.ko
insmod dma-writer.ko addr=269821251 data=560883060
rmmod dma-writer.ko

