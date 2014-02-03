# ECE383 - Embedded Systems II

## Register Transfer Methodology



# Lesson Outline

- Introduction
- Overview of FSMD
- FSMD Design of a Repetitive-Addition Multiplier
- Timing and Performance Analysis of FSMD
- Synthesis Guidelines



# Introduction


## Introduction

- How to realize an algorithm in hardware?
- Two characteristics of an algorithm:
  - Use of variables (symbolic memory location)
    - Example: `n = n + 1` (when programming in C)
  - Sequential execution
    - (execution order is important)


## Dataflow Implementation

- "Dataflow" implementation in VHDL
  - Convert the algorithm in to combinational circuit
  - No memory elements 
  - The sequence is embedded into the "flow of data"
- Problems with dataflow implementation: 
  - Can only be applied to trivial algorithm 
  - Not flexible
    - Can we just share one adder in a time-multiplexing fashion to save hardware resources
    - What happen if input size is not fixed (i.e., size is determined by an external input)


## Dataflow Example

- Algorithm:
  - Sum 4 numbers
  - Divide the result by 8
  - Round the final result

```vhdl
size = 4;
sum = 0;
for i in (0 downto size-1) do
    sum = sum + a(i);
q = sum / 8;
r = sum rem 8;
if (r > 3)
    q = q+1;
outp = q;
```

```vhdl
sum <= 0;
sum0 <= a(0);
sum1 <= sum0 + a(1);
sum2 <= sum1 + a(2);
sum3 <= sum2 + a(3);
q <= "000" & sum3(8 downto 3);
r <= "00000" & sum3(2 downto 0);

outp <= q + 1 when (r > 3) else
        q; 
```

**Image**


## Register Transfer Methodology

- Realized algorithm in hardware
- Use register to store intermediate data and imitate variable
- Use a datapath to realize all register  operations
- Use a control path (FSM) to specify the order of register operation
- The system is specified as sequence of data manipulation/transfer among registers
- Realized by FSM with a datapath (FSMD)



# Overview of FSMD


## Overview of FSMD

- Basic form:
  - **(equation)**
- Interpretation:
- At the rising edge of the clock, the output of registers , , etc. are available
- Outputs are passed to a combinational circuit that performs 
- At the next rising edge of the clock, result is stored into 
  - **(equation)**
  - **(equation)**


## Implementation Example - Single RT Operation

**Image**


## Implementation Example - Multiple RT Operations

**Image**


## FSM as a Control Path

- FSM is a good to control RT operation
  - State transition is on clock-by-clock basis
  - FSM can enforce order of execution
  - FSM allows branches on execution sequence
- Normally represented in an extended ASM chart known as ASMD (ASM with datapath) chart

**Image**

**Note:** New value of r1 is only available when the FSM _exits_ s1 state.


## Basic Block Diagram of FSMD

**Image**



# FSMD Design of a Repetitive-Addition Multiplier


## FSMD Design - Repetitive-Addition Multiplier

- Basic algorithm:  7*5 = 7+7+7+7+7

```vhdl
-- pseudo code
if ((a_in = 0) or (b_in = 0)) then
     r = 0;
else
     a = a_in;
     n = b_in;
     r = 0;
     while (n != 0)
          r = r + a;
          n = n - 1;
return r; 
```

```vhdl
-- ASMD-friendly code
if ((a_in = 0) or (b_in = 0)) then
      r = 0;
else
      a = a_in;
      n = b_in;
      r = 0;
op:   r = r + a;
      n = n-1;
      if (n = 0)
            goto stop;
      else
      goto op;
stop: return r;
```


## FSMD Design - Repetitive-Addition Multiplier

- Input:
  - `a_in`, `b_in`: 8-bit unsigned
  - `clk`, `reset` 
  - `start`: command
- Output:
  - `r`: 16-bit unsigned
  - `ready`: status 
- ASMD chart
  - Default RT operation: keep the previous value 
  - Note the parallel execution in op state

```vhdl
if ((a_in = 0) or (b_in = 0)) then
      r = 0;
else
      a = a_in;
      n = b_in;
      r = 0;
op:   r = r + a;
      n = n-1;
      if (n = 0)
            goto stop;
      else
      goto op;
stop: return r;
```

**Image**


## FSMD Design - Repetitive-Addition Multiplier

- Construction of the data path
  - List all RT operations
  - Group RT operation according to the destination register
  - Add combinational circuit/mux 
  - Add status circuits
- RT operations with the
  - `r` register
    -  (in the `idle` state)
    -  (in the `load` and `op` states)
    -  (in the `op` state)
  - `n` register
    -  (in the `idle` state)
    -  (in the `load` and `ab0` states)
    -  (in the `op` state)
  - `b` register
    -  (in the `idle` and `op` states)
    -  (in the `load` and `ab0` states)


## FSMD Design - Repetitive-Addition Multiplier

Circuit associated with `r` register:

**Image**


## FSMD Design - Repetitive-Addition Multiplier

- VHDL Code
  - `multiplier.vhd`
  - Various code segments can be combined 
  - Should always separate registers from combinational logic
  - May be a good idea to isolate the main functional units

**Image**



# Timing and Performance Analysis of FSMD


## Timing and Performance Analysis of FSMD

- Maximal clock rate
  - More difficult to analyze because of two interactive loops
  - The boundary of the clock rate can be found
- Best-case scenario: 
  - Control signals needed at late stage 
  - Status signal available at early stage 

**Image**


## Timing and Performance Analysis of FSMD

**Image**

**Equations**


## Timing and Performance Analysis of FSMD

- Performance of FSMD
  - Tc: Clock period
  - K: # clock cycles to compete the computation
  - Total time = K * Tc 
- K determined by algorithm, input patterns, etc.
- Example:
  - 8-bit input
    - Best: b=0, K=2
    - Worst: b=255, K=2 + 255*2
  - N-bit input: 
    - Worst: K=2+2*(2n-1)

**Image**



# Synthesis Guidelines


## Synthesis Guidelines

- As with any sequential circuit, the registers of the FSMD should be separated from the combinational circuits.
- Be aware that an RT operation exhibits a delayed-store behavior.  Use of a register in a decision box should be carefully examined.
- The variables used in Boolean expressions of a pseudo algorithm normally correspond to the next values of the registers used in an ASMD.
- The function units are normally the most dominant components in a FSMD design.  To exercise more control, we may need to isolate them from the rest of the code.
- Separate the control path from the code if FSM optimization is needed later.
