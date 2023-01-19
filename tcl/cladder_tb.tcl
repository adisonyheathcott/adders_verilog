
set PROJ_NM "cladder"
set OUTPUT_DIR ../output/$PROJ_NM/sim

file mkdir $OUTPUT_DIR
set FILES [glob -nocomplain "$OUTPUT_DIR/*"]
if {[llength $FILES] != 0} {
    puts "Deleting contents of $OUTPUT_DIR"
    file delete -force {*}[glob -directory $OUTPUT_DIR *]
}

cd $OUTPUT_DIR

exec xvlog ../../../hdl/fulladder.v ../../../hdl/cladder.v ../../../tb/cladder_tb.v
exec xelab -debug typical cladder_tb
exec xsim -gui cladder_tb

cd ../../../tcl