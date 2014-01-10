# ECE383 - Embedded Systems II

## Sequential Circuits in VHDL



# Lesson Outline

- VHDL `process`
- Synchronous Circuits (Chapter 8)
- Sequential Signal Assignment Statement
- Variable Assignment Statement
- `if` Statement
- `case` Statement
- Simple `for` Loop Statement



# VHDL `process`


## VHDL `process`

- Contains a set of sequential statements to be executed sequentially
- The whole `process` is a concurrent statement
- Can be interpreted as a circuit part enclosed inside of a black box
- May or may not be able to be mapped to physical hardware
- Two types of `process` statements:
  - A `process` with a sensitivity list
  - A `process` with a `wait` statement


## VHDL `process` with Sensitivity List

- A process is like a circuit part, which can be:
  - active (known as _activated_)
  - inactive (known as _suspended_)
- A process is activated when a signal in the sensitivity list changes its value
- Its statements will be executed sequentially until the end of the process
- For a combinational circuit, _all inputs_ should be included in the sensitivity list

```vhdl
process (sensitivity_list) is
  declarations;
begin
  sequential statement;
  sequential statement;
  ...
end process;
```

```vhdl
process (a, b, c) is
begin
  y <= a and b and c;
end process;
```


## VHDL `process` With `wait` Statement

- Process has no sensitivity list
- Process continues the execution until a `wait` statement is reached and then suspended
- Forms of `wait` statement:
  - `wait on signals;`
  - `wait until boolean_expression;`
  - `wait for time_expression;`
- A process can have multiple `wait` statments
- **Process with sensitivity list is preferred for synthesis**

```vhdl
process is
begin
  y <= a and b and c;
  wait on a, b, c;
end process;
```



# Synchronous Circuits (Chapter 8)


## Synchronous Circuits (Chapter 8)

- One of the most difficult design aspects of a sequential circuit: **how to satisfy timing constraints**
- The Big Idea
  - Group all DFFs together with a single clock: synchronous methodology
  - Only need to deal with the timing constraint of **one** memory element


## Synchronous Circuits (Chapter 8)

- Basic block diagram
  - State register (memory elements)
  - Next-state logic (combinational circuit)
  - Output logic (combinational circuit)
- Operation
  - At the rising edge of the clock, `state_next` sampled and stored into the register (and becomes the new value of `state_reg`)
  - The next-state logic determines the new value (new `state_next`) and the output logic generates the output
  - At the rising edge of the clock, the new value of `state_next` sampled and stored into the register
- Glitches have no effect as long as the `state_next` is stable at the sampling edge

**Image**


## D Latch

```vhdl
process (c, d, q_latch) is
begin
  if (c = '1') then
    q_latch <= d;
  else
    q_latch <= q_latch;
  end if;
  q <= q_latch;
end process;
```


## D Flip Flop

```vhdl
process (clk) is
begin
  if (reset = '1') then
    q <= '0';
  elsif rising_edge(clk) then
    q <= d;
  end if;
end process;

process (clk) is
begin
  if (reset = '1') then
    q <= '0';
  elsif falling_edge(clk) then
    q <= d;
  end if;
end process;
```

**Note:** You can use `std_logic_vector` for `d` and `q`.



# Sequential Signal Assignment Statement


## Simple Signal Assignment

- Syntax:
  - `signal_name <= value_expression;`
- Syntax is identical to the simple concurrent signal assignment
- Caution: inside a process, a signal can be assigned multiple times, but only _the last assignment takes effect_
- A signal can only be set in _one_ process or combinational statement

```vhdl
process (a, b, c, d) is
begin
  y <= a or c;
  y <= a and b;
  y <= c and d;
end process;
```
**is equivalent to:**
```vhdl
process (a, b, c, d) is
begin
  y <= c and d;
end process;
```

What would happen if the three statements were concurrent statements?



# Variable Assignment Statement


## Variable Assignment Statement

- 
