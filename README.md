💡 Key Architectural Features

Isotropic Optimization: 
Grouping symmetric kernel entries (Center W, Lateral W_L, and Corner W_C) allows pre-addition of matching pixel positions, cutting required multipliers by 66%

Streaming Line Buffer (SIPO): 
Converts a continuous 8-bit serial pixel stream into a parallel 3 x 3 pixel window every clock cycle using two cascaded 61-element Shift Registers (LUTRAMs).

Pipelined Arithmetic Unit: 
RCA-based Adder Trees: Adds 4 lateral pixels (10-bit unsigned result) and 4 corner pixels (10-bit unsigned result).

Custom 10 x 8-bit Multipliers: Signed "pencil-and-paper" shift-and-add multipliers supporting two's-complement kernel coefficients.

Carry-Save Adder (CSA): 3-input 18-bit CSA tree for fast accumulation of products into a 20-bit signed output pixel.

Finite State Machine (FSM): Controls dynamic kernel loading, pipeline warm-up latency tracking (132 clock cycles), edge/border cropping logic (62 x 62 output without padding), and output data validation (Valid flag).


🧪 Simulation & Image Filtering Verification

The IP Core was validated through behavioral and post-implementation timing simulations against a Golden C Reference model using the standard Lena (64 x 64) test image:

Laplacian Edge Detection Filter (W=4, W_L=-1, W_C=0): Successfully extracted image high-frequency edges.
Gaussian Smoothing Filter ($=4, W_L=2, W_C=1): Successfully demonstrated weighted spatial noise reduction and blurring.