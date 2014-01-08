# ECE383 - Embedded Systems II

## Basic Language Constructs of VHDL



## Lesson Outline

1. Basic VHDL Program
2. Lexical Elements and Program Format
3. VHDL Objects
4. Data Types and Operators
5. Synthesis Guidelines



# Basic VHDL Program


## Design Unit

- Building blocks in a VHDL program
- Each design unit is analyzed and stored independently
- Types of design unit:
  - entity declaration
  - architecture body
  - package declaration
  - package body
  - configuration


## Entity Declaration

- Simplified syntax
- Mode:
  - `in:` flow into circuit
  - `out:` flow out of circuit
  - `inout:` bi-directional flow

```vhdl
entity entity_name is
  port(
    port_names : mode data_type;
    port_names : mode data_type;
    ...
    port_names : mode data_type;
  );
end entity_name;
```

```vhdl
entity even_detector is
  port(
    a : in std_logic_vector(2 downto 0);
    even : out std_logic;
  );
end even_detector;
```


## Common Mistake with Mode

**Image**

```vhdl
entity mode_demo is
  port(
    a, b : in std_logic;
    x, y : out std_logic;
  );
end mode_demo;
```

```vhdl
architecture wrong of mode_demo is
begin
  x <= a and b;
  y <= not x;
end wrong;
```

```vhdl
...

architecture correct of mode_demo is
  signal x_i : std_logic;
begin
  x_i <= a and b;
  x <= x_i;
  y <= not x_i;
end correct;
```


## Architecture Body

- Simplified syntax
- An `entity`  declaration can be associated with multiple `architecture` bodes

```vhdl
architecture arch_name of entity_name is
  declarations;
begin
  concurrent statement;
  concurrent statement;
  concurrent statement;
  ...
end arch_name;
```

```vhdl
architecture sop_arch of even_detector is
  signal p1, p2, p3, p4 : std_logic;
begin
  even <= (p1 or p2) or (p3 or p4);
  p1 <= (not a(2)) and (not a(1)) and (not a(0));
  p2 <= (not a(2)) and a(1) and a(0);
  p3 <= a(2) and (not a(1)) and a(0);
  p4 <= a(2) and a(1) and (not a(0));
end sop_arch;
```


## Other Design Units

- _Package declaration/body_ - collection of commonly used items:
  - Data Types
  - Subprograms
  - Components
- _Configuration_ - specify which `architecture` body is to be bound with the `entity` declaration 
- _VHDL Library_ - a place to store the analyzed design units
  - Normally mapped to a folder on host computer
  - Default library: "work"
  - Library "IEEE" is used for many IEEE packages

```vhdl
-- Invoke library named IEEE
library ieee;

-- Make std_logic_1164 visible to all design units in current file
use ieee.std_logic_1164.all;
```


## Processing of VHDL Code

- Analysis
  - Performed on "design unit" basis
  - Check the syntax and translate the unit into an intermediate form
  - Store design unit in a library
- Elaboration
  - Bind architecture body with entity
  - Substitute the instantiated components with architecture description
  - Create a "flattened" description
- Execution
  - Simulation or synthesis
