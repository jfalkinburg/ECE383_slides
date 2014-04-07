# ECE383 - Embedded Systems II

## Timing Analysis



# Lesson Outline

- Combinational Timing Considerations
- Sequential Timing Analysis
- Synthesis Guidelines



# Combinational Timing Considerations


## Combinational Timing Considerations

- Propagation delay
- Synthesis with timing constraint
- Hazards
- Delay-sensitive design


## Propagation Delay - Overview

- *Delay* - time required to propagate a signal from an input port to a output port
- *Cell-level delay* - most accurate
- The impact of wire becomes more dominant

**Image**


## Propagation Delay - System Delay

- *System Delay* - the longest path (input to output) in the system
- *False path* - a path along which a signal cannot actually propagate
- Difficult if the design is mainly "random" logic
- Critical path can be identified if many complex operators (such as adders or multipliers) are used in the design.

![Critical Path](gates_critical_path.jpg)


## Propagation Delay - System Delay

![Critical Path](clouds_critical_path.jpg)


## Synthesis with Timing Constraint

- Multi-level synthesis is flexible
- It is possible to reduce by delay by adding extra logic
- Synthesis with timingconstraint:
  1. Obtain the minimal-area implementation
  2. Identify the critical path
  3. Reduce the delay by adding extra logic
  4. Repeat 2 & 3 until meeting the constraint


## Synthesis with Timing Constraint

![Optimizations](optimizations.jpg)


## Synthesis with Timing Constraint

Area-Delay Trade-Off Curve

![Area-Delay Trade-Off Curve](area_delay_tradeoff.jpg)


## Synthesis with Timing Constraint

Writing better RTL code

![Better RTL Code](better_rtl_code.jpg)


## Timing Hazards

- *Propagation delay* - time to obtain a stable output
- *Hazards* - the fluctuation occurring during the transient period
  - *Static hazard* - glitch when the signal should be stable
  - *Dynamic hazard* - a glitch in transition
- Due to the multiple converging paths of an output port



# Sequential Timing Analysis



# Synthesis Guidelines
