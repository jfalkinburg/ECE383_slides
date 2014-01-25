# ECE383 - Embedded Systems II

## Finite State Machines



# Lesson Outline

- Overview
- FSM Representation
- Timing and Performance of an FSM
- Moore vs. Mealy
- VHDL Description of a FSM
- State Assignment
- Moore Output Buffering



# Overview


## Overview

- Contain custom logic in next-state logic
- Used mainly used as a controller in a large system
- Mealy vs. Moore output 

![State Machines](state_machines.jpg)


# FSM Representation


## Representation of an FSM

- State Diagram

![State Notation](state_notation.jpg)


## Memory Controller State Diagram

![Memory Controller](memory_controller.jpg)



# Timing and Performance of an FSM


## Timing and Performance of an FSM

- Similar to a regular sequential circuit

![State Machines](state_machines.jpg)

![Equations](equations.jpg)


## Timing and Performance of an FSM

![Timing](timing.jpg)



# Moore vs. Mealy


## Moore vs. Mealy

- **Moore machine**: output is a function of state
- **Mealy machine**: output function of state and output
- From theoretical point of view, both machines have similar "computation capability"
- Implication of FSM as a controller?


## Example: Edge Detection Circuit

- A circuit to detect the rising edge of a slow "strobe" input and generate a "short" (about 1-clock period) output pulse.

![Edge Detection Circuit](edge_detect.jpg)


## Example: Edge Detection Circuit

- A circuit to detect the rising edge of a slow "strobe" input and generate a "short" (about 1-clock period) output pulse.

![Edge Detect Timing](edge_detect_timing.jpg)


## Moore vs. Mealy

- Comparison
  - Mealy machine uses fewer states
  - Mealy machine responds faster
  - Mealy machine may be transparent to glitches
- Which one is better?
- Types of control signal
  - Edge sensitive
    - e.g. enable signal of counter
    - Both can be used but Mealy is faster
  - Level sensitive
    - e.g. write enable signal of SRAM
    - Moore is preferred


## Moore vs. Mealy

- Comparison
  - Mealy machine uses fewer states
  - Mealy machine responds faster
  - Mealy machine may be transparent to glitches (Bad!)
- Which one is better?
- Types of control signal
  - Edge sensitive
    - Example: enable signal of counter
    - Both can be used but Mealy is faster
  - Level sensitive
    - Example: write enable signal of SRAM
    - Moore is preferred



# VHDL Description of an FSM


## VHDL Description of an FSM

- Follow the basic block diagram
- Code the next-state/output logic according to the state diagram/ASM chart
- Use _enumeration_ data type for states
- Can use Moore _output buffering_ to prevent glitches

![VHDL State Machine](vhdl_state_machine.jpg)


## Example

(see "memory_controller.vhd" Code Example)

![Memory Controller](memory_controller.jpg)



# State Assignment


## State Assignment

- State assignment: assign binary representations to symbolic states
- In a synchronous FSM
  - All assignments work
  - Good assignment reduce the complexity of next-state/output logic
- Typical assignment - Binary, Gray, one-hot, almost one-hot

![State Assignment](state_assignment.jpg)


## State Assignment in VHDL

- _Implicit_: use user attributes enum_encoding 

```vhdl
type mc_state_type is (idle, write, read1, read2, read3, read4);
attribute enum_encoding : string;
attribute enum_encoding of mc_state_type :
    type is "0000 0100 1000 1001 1010 1011";
```

- _Explicit_: use std_logic_vector for the register

```vhdl
constant idle  : std_logic_vector(3 downto 0) := "0000";
constant write : std_logic_vector(3 downto 0) := "0100";
constant read1 : std_logic_vector(3 downto 0) := "1000";
constant read2 : std_logic_vector(3 downto 0) := "1001";
constant read3 : std_logic_vector(3 downto 0) := "1010";
constant read4 : std_logic_vector(3 downto 0) := "1011";
signal state_reg, state_next : std_logic_vector(3 downto 0);
...
if (reset = '1') then
    state_reg <= idle;
else
    state_reg <= idle;
end if;
```


## Handling Unused States - "Phantom States"

- Many binary representations are not used
- What happens if the FSM enters an unused state?
  - Ignore the condition
  - Safe (Fault-tolerant) FSM: go to an error state or return to the initial state.
- Easy for the explicit state assignment
- No portable code for the enumerated data type



# Moore Output Buffering


## Moore Output Buffering

- FSM as control circuit 
  - Sometimes fast, glitch-free signal is needed
  - An extra output buffer can be added, but introduce one-clock delay
- Special schemes can be used for Moore output
  - Clever state assignment
  - Look-ahead output circuit
- Potential problems of the Moore output logic:
  - Potential hazards introduce glitches
  - Increase the Tco delay (Tco = Tcq + Toutput)
- Can we get control signals directly from the register?

![VHDL State Machine](vhdl_state_machine.jpg)


## Clever State Assignment

- Assigning state according to output signal patterns
- Output can be obtained from register directly 
- Extra register bits may be needed
- Must use explicit state assignment in VHDL code to access individual register bit
- Difficult to revise and maintain

![Clever Assignment](clever_assignment.jpg)


## Clever State Assignment

![Memory Controller](memory_controller.jpg)


## Look-Ahead Output Circuit

- Output buffer introduces one-clock delay
- The "next" value of Moore output can be obtained by using `state_next` signal 
- Buffer the next value cancel out the one-clock delay 
- More systematic and easier to revise and maintain

![Look Ahead](look_ahead.jpg)
