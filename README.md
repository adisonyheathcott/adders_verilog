# Verilog Adders

This project was created to practice using Tcl scripts to generate Vivado projects and to better understand timing analysis.

```
├── tcl
│   └── Tcl Script Files
├── hdl
│   └── Verilog Source Files
├── tb
│   └── Verilog Testbench Files
├── constraints
│   └── Constraint Files (Arty A7-35T)
├── .gitignore
└── README.md
```

### How to compile

Launch vivado in tcl mode, point the command line to the directory with the tcl file, type `source fulladder.tcl`

### Running Simulation

Launch vivado in tcl mode, point the command line to the directory with the tcl file, type `source fulladder_tb.tcl`
When Vivado opens go to File->Simulation Waveform->New Configuration.
Add the inputs and outputs to the waveform, simulate for the needed time.

## Full Adder

A single bit full adder.

- Tcl Script
    - tcl/fulladder.tcl
    - tcl/fulladder_tb.tcl
- Sources
    - hdl/fulladder.v
- Simulation
    - tb/fulladder_tb.v
- Constraints
    - constraints/fulladder.xdc

## Ripple Carry Adder

An 8-bit ripple carry adder

- Tcl Script
    - tcl/rcadder.tcl
    - tcl/rcadder_tb.tcl
- Sources
    - tcl/rcadder.v
- Simulation
    - tb/rcadder_tb.v

## Carry Lookahead Adder

A 4-bit carry lookahead adder

- Tcl Script
    - tcl/cladder.tcl
    - tcl/cladder_tb.tcl
- Sources
    - tcl/cladder.v
- Simulation
    - tb/cladder_tb.v