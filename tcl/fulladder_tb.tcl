# filename: fulladder_tb.tcl

set PROJ_NM "fulladder"
set OUTPUT_DIR ../output/$PROJ_NM/sim

file mkdir $OUTPUT_DIR
set FILES [glob -nocomplain "$OUTPUT_DIR/*"]
if {[llength $FILES] != 0} {
    puts "Deleting contents of $OUTPUT_DIR"
    file delete -force {*}[glob -directory $OUTPUT_DIR *]
}

cd $OUTPUT_DIR

exec xvlog ../../../hdl/fulladder.v ../../../tb/fulladder_tb.v
exec xelab -debug typical fulladder_tb
exec xsim -gui fulladder_tb

cd ../../../tcl