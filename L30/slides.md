# ECE383 - Embedded Systems II

## Clock and Synchronization



# Lesson Outline

- Clock Distribution Network and Skew
- Multiple Clock System
- Metastability and Synchronization Failure
- Synchronizer
- Synthesis Guidelines



# Clock Distribution Network and Skew


## Clock Distribution Network and Skew



# Multiple Clock System


## Multiple Clock System



# Metastability and Synchronization Failure


## Metastability and Synchronization Failure



# Synchronizer


## Synchronizer



# Synthesis Guidelines


## Synthesis Guidelines

**Section 9.5**

- Asynchronous reset, if used, should be only for system initialization.  It should not be used to clear the registers during regular system operation
- Do not manipulate or gate the clock signal.  Most desired operations can be achieved by using a register with an enable signal
- LFSR is an effective way to construct a counter.  It can be used when the counting patterns are not important
- Throughput and delay are two performance criteria.  Adding a pipeline to a combinational circuit can increase the throughput but not reduce the delay
- The main task of adding a pipeline to acombinatioralcircuit is to divide the circuit into balanced stages.  Software with retiming capability can aid in this task


## Synthesis Guidelines

**Section 16.11 - Use of a Clock**

- Do Not manipulate the clock signal in regular RTL design and synthesis
- Minimize the number of clock signals in a system
- Minimize the number of clock domains (i.e. the number of independent clock signals).  Use a derived clock signal when possible
- If a derived clock signal is needed, manually derive and instantiate the circuit and separate it from the regular synthesis


## Synthesis Guidelines

**Section 16.11 - Synchronizer Guidelines**

- Synchronize a signal in a single place
- Avoid synchronizing related signals
- Use a glitch-free signal for synchronization
- Reanalyze and examine the synchronizer and MTBF when the device is changed or the clock rate is revised


## Synthesis Guidelines

**Section 16.11 - Interface Between Clock Domains**

- Clearly identify the boundary of the clock domain and the signals that cross the domain
- Separate the synchronization circuits and asynchronous interface from the synchronous subsystems, and instantiate them as individual modules
- Use a reliable synchronizer design to provide sufficient metastability resolution time
- Analyze the data transfer protocol over a wide range of scenarios, including faster and slower clock frequencies and different data rates
