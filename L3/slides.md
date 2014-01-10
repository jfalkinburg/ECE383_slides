# ECE383 - Embedded Systems II

## Basic Language Constructs of VHDL



# Lesson Outline

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



# Lexical Elements and Program Format


## Lexical Elements

- Basic syntactical units in a VHDL program
- Types of elements:
  - Comments
  - Identifiers
  - Reserved words
  - Numbers
  - Characters
  - Strings


## Comments

- Starts with `--`
- Comments for the remainder of the line
- Added for program clarity and documentation
- VHDL 2008 supports C-style block commenting `/* ... */`

```vhdl
--*****************************************
-- Example to show the caveat of the out mode
--*****************************************

architecture correct of entity_name is
  signal x_i : std_logic; -- Internal signal
begin
  x_i <= a and b;
  x <= x_i; -- Connect the internal signal to the output
  y <= not x_i;
end correct;
```


## Identifier

- Identifier is the name of na object
- Basic rules:
  - Can only contain alphabetic letters, decimal digits, and underscore
  - The first character must be a letter
  - Two successive underscores are not allowed
- Valid: `A10`, `next_state`, `NextState`
- Invalid: `sig#3`, `_X10`, `7segment`, `X10_`, `hi__there`
- VHDL is case _insensitive_: {`nextstate`, `NextState`, `NEXTSTATE`, `nEXTsTATE`} are all the same


## Reserved Words

[List from Xilinx](http://www.xilinx.com/itp/xilinx10/isehelp/ite_r_vhdl_reserved_words.htm)


## Numbers, Characters, and Strings

- Number:
  - Integer: 0, 1234, 98E7
  - Real: 0.0, 1.23456, 9.87E6
  - Base 2: 2#101101#
- Character:
  - 'A', 'Z', '1'
- Strings:
  - "Hello", "101101"
- Note:
  - 0 and '0' are different
  - 2#101101# and "101101" are different


## Program Format

- VHDL is "free-format": blank space, tab, new-line (i.e. "white space") can be freely inserted
- The following are the same:

```vhdl
architecture correct of entity_name is
  signal x_i : std_logic;
begin
  x_i <= a and b;
  x <= x_i;
  y <= not x_i;
end correct;
```

```vhdl
architecture correct of entity_name is
signal x_i : std_logic; begin x_i <= a and b; x <= x_i; y <= not x_i; end
correct;
```



# VHDL Objects


## Objects

- A named item that holds a value of specific data type
- Four kinds of objects:
  - Signal
  - Variable
  - Constant
  - File (cannot be synthesized)
- Related construct
  - Alias


## Signal

- Declared in the architecture body's declaration section
- Signal declaration:
  - `signal sig1, sig2, ... : data_type;`
- Signal assignment:
  - `signal name <= projected_waveform;`
- Ports in entity declaration are considered as signals
- Can be interpreted as wires or "wires with memory" (e.g. FFs, latches, etc.)


## Variable

- Declared and used inside a process
- Variable declaration:
  - `variable var1, var2, ... : data_type;`
- Variable assignment:
  - `variable_name := value_expression;`
- Contains no "timing info" (immediate assignment)
- Used in traditional PLs: a "symbolic memory location" where a value can be stored and modified
- No direct hardware counterpart


## Constant

- Value cannot be changed
- Constant declaration:
  - `constant const_name, ... : data_type := value_expression;`
- Used to enhance readability

```vhdl
constant BUS_WIDTH : integer := 32;
constant BUS_BYTDL : integer := BUS_WIDTH / 8;
```


## Constant Example

```vhdl
architecture beh1_arch of even_detector is
  signal odd : std_logic;
begin
  ...
  tmp := '0';
  for i in 2 downto 0 loop
    tmp := tmp xor a(i);
  end loop
...
```

**Avoid Hard Literals**

```vhdl
architecture beh1_arch of even_detector is
  signal odd : std_logic;
  constant BUS_WIDTH : integer := 3;
begin
  ...
  tmp := '0';
  for i in (BUS_WIDTH-1) downto 0 loop
    tmp := tmp xor a(i);
  end loop
...
```


## Alias

- Not an object
- Alternative name for an object
- Used to enhance readability

```vhdl
signal word : std_logic_vector(15 downto 0);
alias op : std_logic_vector(6 downto 0) is word(15 downto 9);
alias reg1 : std_logic_vector(2 downto 0) is word(8 downto 6);
alias reg2 : std_logic_vector(2 downto 0) is word(5 downto 3);
alias reg3 : std_logic_vector(2 downto 0) is word(2 downto 0);
```



# Data Types and Operators


## Data Types and Operators

- Standard VHDL
- IEEE1164_std_logic package
- IEEE numeric_std package


## Data Type

- Definition of data type
  - A set of vlaues that an object can assume
  - A set of operations that can be performed on objects of this data type
- VHDL is a _strongly-typed_ language
  - An object can only be assigned with a value of its type
    - Error: `int_var := char_var;`
    - Correct: `int_var := to_integer(char_var);`
  - Only the operations defined with the data type can be performed on the object


## Data Types in Standard VHDL

- `integer`
  - Minimal range: -(2^31-1) to 2^31-1
  - Two subtypes: natural, positive
- `boolean`
  - False, True
- `bit`
  - 0, 1
  - Not capable enough!
- `bit_vector`
  - One-dimensional array of bits


## Operators in Standard VHDL

**Image**


## Operators in Standard VHDL

**Image**


## IEEE `std_logic_1164` package

- What's wrong with `bit`?
- New data type: `std_logic`, `std_logic_vector`
- `std_logic`: 9 values: ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-')
  - '0', '1': forcing logic 0 and forcing logic 1
  - 'Z': high-impedance, as in a tri-state buffer
  - 'L', 'H': weak logic 0 and weak logic 1, as in _wired logic_
  - 'X', 'W': "unknown" and "weak unknown"
  - 'U': for uninitialized
  - '-': don't-care


## IEEE `std_logic_1164` package

- `std_logic_vector`
  - an array of elements with `std_logic` data type
  - **implies a bus**
- Example declaration
  - `signal a : in std_logic_vector(7 downto 0)`
- Another form (less desired)
  - `signal a : in std_logic_vector(0 to 7);`
- Need to invoke package to use the data type:

```vhdl
library ieee;
use ieee.std_logic_1164.all;
```


## IEEE `std_logic_1164` package - Overloaded Operators

- Which standard VHDL operators can be applied to `std_logic` and `std_logic_vector`?
- _Overloading_: same operator for different data types
- Overloaded operators in `std_logic_1164` package

**Image**


## IEEE `std_logic_1164` package - Conversion Functions

- Provides functions to convert between data types

**Image**

```vhdl
signal s1, s2, s3 : std_logic_vector(7 downto 0);
signal b1, b2 : bit_vector(7 downto 0);
s1 <= to_stdlogicvector(b1);
b2 <= to_bitvector(s1 and s2);
s3 <= to_stdlogicvector(b1) or s2;
s3 <= to_stdlogicvector(b1 or to_bitvector(s2));
```


## Array Data Type Operators

- Relational operators for array
  - Operands must have the same element type but their lengths may differ
  - Two arrays are compared element by element, from the left-most element
  - All of the follwoing return true
    - "011"="011", "011">"010", "011">"00010", "0110">"011"
- Concatentation operator (&)
  - `y <= "00" & a(7 downto 2)`
  - `y <= a(7) & a(7) & a(7 downto 2)`
  - `y <= a(1 downto 0) & a(7 downto 2);`


## Array Aggregate

- Aggregate is a VHDL construct to assign a value to an array-typed object

```vhdl
a <= "10100000";
a <=  (7 => '1', 6 => '0', 0 => '0', 1 => '0',
      5 => '1', 4 => '0', 3 => '0', 2 => '1');
a <= (7|5 => '1', 6|4|3|2|1|0 => '0');
a <= (7|5 => '1', others => '0');
a <= "00000000";
a <= (others => '0');
```


## IEEE `numeric_std` package

- How to infer arithmetic operators?
- In standard VHDL:

```vhdl
signal a, b, sum: integer;
...
sum <= a + b;
```

- What's wrong with `integer` data type?


## IEEE `numeric_std` package

- IEEE `numeric_std` package: define integer as an array of elements of `std_logic`
- Two data types: unsigned, signed
- The array interpreted as an unsigned or signed binary number
  - `signal x, y: signed(15 downto 0)`
- Need to invoke package to use the data type

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
```


## IEEE `numeric_std` package - Overloaded Operators

**Image**


## IEEE `numeric_std` package - New Functions

**Image**


## IEEE `numeric_std` package - Type Conversion

- `std_logic_vector`, `unsigned`, `signed` are defined as an array of elements of `std_logic`
- Considered as three different data types in VHDL
- Type conversion between data types:
  - Type conversion functions
  - Type casting (for "closely related" data types)

**Image**


## Casting vs. Conversion

- **Type Casting** (language primitive) is available between _related_ types
  - `bit`, `std_logic`
  - `bit_vector`, `std_logic_vector`, `unsigned`, `signed`1
  - `integer`, `natural`, `positive`
- **Conversion Functions** (library add-ons) must be used when type casting is not available
- **Best Reference**: C:\Xilinx\xx.x\ISE_DS\vhdl\src


## Non-IEEE Packages

- Packages by Synopsys
- `std_logic_arith`
  - Similar to `numeric_std`
  - New data types: `unsigned`, `signed`
  - Details are different
- `std_logic_unsigned` / `std_logic_signed`
  - Treat `std_logic_vector` as `unsigned` and `signed` numbers
  - Overload `std_logic_vector` with `arith` operations
- Vendors typically store these packages in the IEEE library
- Only one type (`unsigned` / `signed`) can be used per VHDL file
- `unsigned` / `signed` defeat the motivation behind strong typing
- **`numeric_std` is preferred** (required in this class)



# Synthesis Guidelines


## Guidelines for General VHDL

- Use the `std_logic_vector` and `std_logic` instead of `bit_vector` and `bit` data types
- Use the `numeric_std` package and the `unsigned` and `signed` data types for synthesizing arithmetic operations
- Only use `downto` in array specification (e.g. `unsigned`, `signed`, `std_logic_vector`)
- Use parentheses to clarify the intended order of operations
- Don't use user-defined types unless there is a compelling reason
- Don't use immediate assignment (i.e. `:=`) to assign an initial value to a signal
- Use operands with identical lengths for relational operators


## Guidelines for General VHDL

- Include an informational header for each file
- Be consistent with use of case
- Use proper spaces, blank lines, and indentations to make the code clear
- Add necessary comments
- Use symbolic constant names to replace hard literals in VHDL code
- Use a suffix to indicate a signal's special property:
  - `_n` for active-low signals
  - `_i` for internal signals (tied to an output signal to make it readable)
- Keep the line width within 72 characters so code can be displayed and printed properly by various editors and printers without wrapping
