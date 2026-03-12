##How it works

This project implements a tiny matrix multiplication accelerator inspired by the Tensor Processing Unit (TPU) architecture used in machine learning accelerators.

The design multiplies two 2×2 matrices with 8-bit signed elements and produces a 16-bit signed result matrix.

The architecture uses a 2×2 systolic array, where data flows through a grid of Processing Elements (PEs) that perform Multiply-Accumulate (MAC) operations.

Each Processing Element performs:

C = C + (A × B)

To improve the hardware design, the multiplication inside each PE is implemented using a Braun Array Multiplier, which generates partial products and sums them through an adder array.

Main Components

The system contains several hardware modules:

1. Memory (memory.v)

Stores the matrix elements before computation.

Memory layout:

Address	Stored value
0	A00
1	A01
2	A10
3	A11
4	B00
5	B01
6	B10
7	B11

Each element is 8 bits wide.

2. Control Unit (control_unit.v)

The control unit manages the entire computation using a Finite State Machine (FSM).

States include:

IDLE – waiting for input

LOAD – loading matrix elements into memory

COMPUTE – performing matrix multiplication

OUTPUT – sending results to output pins

3. Matrix Feeder (mmu_feeder.v)

Feeds matrix data from memory into the systolic array.

It supplies:

a_data0
a_data1
b_data0
b_data1

These values are streamed into the processing elements.

4. Systolic Array (systolic_array_2x2.v)

The systolic array consists of four Processing Elements arranged in a grid.

       b0      b1
        ↓       ↓

a0 →  PE00 → PE01
        ↓       ↓
a1 →  PE10 → PE11

Each PE computes partial results which propagate through the array.

The outputs are:

c00
c01
c10
c11

5. Processing Element (pe_braun.v)

Each PE performs a multiply-accumulate operation.

Inputs:

Signal	Description
clk	clock
rst	reset
a_in	input value
b_in	weight value

Outputs:

Signal	Description
a_out	forwarded input
b_out	forwarded weight
c_out	accumulated result

The multiplication is performed by the Braun multiplier.

6. Braun Multiplier (braun_multiplier.v)

The Braun multiplier performs 8-bit × 8-bit multiplication.

It generates partial products using AND gates and adds them using an array of adders to produce a 16-bit result.

Data Flow

The computation follows these steps:

Matrix elements are loaded into memory.

The control unit activates the feeder.

The feeder sends data to the systolic array.

Processing elements compute multiply-accumulate operations.

Final matrix results are sent to the output pins.

##How to test

The design can be simulated using a Verilog testbench.

Step 1 — Reset the design

Set reset low and then high.

rst_n = 0
rst_n = 1
Step 2 — Load Matrix A

Example matrix:

A = |1 2|
    |3 4|

Load values in order:

A00
A01
A10
A11
Step 3 — Load Matrix B

Example matrix:

B = |5 6|
    |7 8|

Load values:

B00
B01
B10
B11
Step 4 — Wait for computation

After the inputs are loaded, the systolic array begins computation automatically.

The result matrix is:

C = A × B

Example result:

C = |19 22|
    |43 50|
Step 5 — Observe outputs

The outputs appear on:

uo_out
uio_out

Each element is 16 bits and may be transmitted over multiple clock cycles depending on the interface.

Simulation

Example simulation command:

iverilog -o sim tb.v src/*.v
vvp sim

Waveforms can be viewed using:

gtkwave tb.fst

##External hardware

The chip requires an external controller such as a microcontroller, FPGA, or development board to provide the clock signal and input data.

The external hardware performs the following tasks:

Provides the clock signal (clk) required for synchronous operation.

Controls the reset signal (rst_n) to initialize the system.

Sends matrix elements through the ui_in input pins.

Reads computed results from the uo_out output pins.

Optionally uses the uio bidirectional pins for additional data exchange.

A simple microcontroller (such as an Arduino, Raspberry Pi Pico, or FPGA board) can easily interface with the chip by toggling the input pins on clock edges and collecting the output values.

During operation, the controller loads the matrix elements sequentially, waits for the computation to complete, and then reads the resulting matrix elements from the output interface.
