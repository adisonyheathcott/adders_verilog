# Verilog Adders

This project was created to practice using Tcl scripts to generate Vivado projects and to better understand timing analysis.

.
├── tcl
│   └── fulladder.tcl
├── hdl
│   ├── 
│   └── fulladder.v
├── .gitignore
└── README.md

### How to compile

Launch vivado in tcl mode, point the command line to the directory with the tcl file, type `source fulladder.tcl`

### Running Simulation

Launch vivado in tcl mode, point the command line to the directory with the tcl file, type `source fulladder_tb.tcl`
When Vivado opens go to File->Simulation Waveform->New Configuration.
Add the inputs and outputs to the waveform, simulate for the needed time.

## Full Adder

A simple full adder.

- Tcl Script
    - tcl/fulladder.tcl
- Sources
    - hdl/fulladder.v