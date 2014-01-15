# ECE383 - Embedded Systems II

## Writing VHDL Test Benches



# Lesson Outline

- Test Bench Overview
- VHDL Tools: `record`, `array`, `assert`, `wait`
- VHDL File I/0
- `and` Gate Test Bench Examples



# Test Bench Overview


## Test Bench Overview

- Simulate circuit behavior and verify functionality
- _Simulated_ therefore full VHDL language available - not just the synthesizable subset
- Basic test bench: view / verify waveforms
  - Simple to learn and implement
  - Tedious because it requires "man in the loop"
- "Real World" test bench: automatic
  - More difficult to learn and implement
  - Completely automated test with result summary


## Simulation Clock Generation

```vhdl
signal clk : std_logic := 'U';
constant clk_period : time := 20 ns;
...
process is
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;
```

```vhdl
signal clk : std_logic := '0';
constant clk_period : time := 20 ns;
...
clk <= not clk after clk_period/2;
```


## Self-Checking Testbench - and2 gate

```vhdl
architecture sim of tb is
...
begin
  dut : entity work.and2 port map(a,b,y);

  process begin
    a <= '0'; b <= '0'; wait for 10 ns;
    assert y = '0' report "00 failed";

    a <= '0'; b <= '1'; wait for 10 ns;
    assert y = '0' report "01 failed";
    ...
  end process;
end sim;
```

How do we handle multiple outputs?


## Self-Checking Testbench - DFF

```vhdl
architecture sim of tb is
  signal clk : std_logic := '0';
  constant clk_period : time := 20 ns;
  signal d, q : std_logic := 'U';
begin
  dut : entity work.dff port map (clk, d, q);
  
  clk <= not clk after clk_period / 2;

  process is
  begin
    wait for clk_period / 4;

    d <= '0'; wait for clk_period;
    assert q = '0' report "TV0 failed";

    d <= '1'; wait for clk_period;
    assert q = '1' report "TV1 failed";
  end process;
end sim;
```



# Verification of Large Designs


## Verification of Large Designs

- How many test vectors are needed for the following:
  - n input combinational? 2^n
  - n input sequential with m flip flops? 2^(n+m), ignoring sequence
  - n = 10, m = 10: 1,048,576
  - n = 20, m = 20: 1.0995*10^12
- **Brute force method does not scale well**
- Solution: Test a subset of conditions
  - Normal operating conditions
  - "Corner" cases
  - Random inputs
- Result: design "probably" works correctly


## Lab 1 Testbench Example

- 640x480 pixel image
- Each pixel is 8-bits
- Pixels generated in sequence
- Over a period of _more_ than (640*480)=307,200 clock cycles

**Image**



# VHDL Tools: `record`, `array`, `assert`, `wait`


## VHDL `record`

- A `record` is a collection of elements
  - Similar to a `struct` in C

```vhdl
type my_record_type is record
  field_1 : data_type;
  field_2 : data_type;
  ...
  field_n : data_type;
end record;

...

signal my_signal : my_record_type;

...

my_signal.field_1 <= "Hello World";
```


## VHDL `array`

- Similar to arrays in C

```vhdl
type my_array_type is array (index_type) of data_type; -- prototype
```

```vhdl
type my_array_type is array (natural range <>) of std_logic;

constant my_array : my_array_type := ('0', '1', '0');

...

for i in my_array'range loop
  out_1 <= my_array(i);
end loop;
```


## VHDL `assert`

- 
