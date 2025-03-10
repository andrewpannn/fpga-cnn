## Field programmable gate array (FPGA) accelerator for convolutional neural networks (CNN)

This project is an implementation of the accelerator described in *Optimizing FPGA-based accelerator design for deep convolutional neural networks* [1]. 

The goal is to create an accelerator for a single convolutional layer of an arbitrary size. This project explores the concepts of loop unrolling, loop pipelining, and ping-pong data transfer.

Currently uses non-synthesizable `shortreal` datatype. 

[1] C. Zhang, P. Li, G. Sun, Y. Guan, B. Xiao, and J. Cong, "Optimizing FPGA-based accelerator design for deep convolutional neural networks," FPGA’15, February 22–24, 2015, Monterey, California, USA.