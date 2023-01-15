# filename: fulladder.tcl

set BUILD_DATE [ clock format [ clock seconds ] -format %m%d%Y ]
set BUILD_TIME [ clock format [ clock seconds ] -format %H%M%S ]

# Global Settings
set PROJ_NM "fulladder"
set PART_NM "XC7A35TICSG324-1L"

# Define the output directory
set OUTPUT_DIR ../output/$PROJ_NM

# Create the output dir
file mkdir $OUTPUT_DIR
set FILES [glob -nocomplain "$OUTPUT_DIR/*"]
if {[llength $FILES] != 0} {
    # Clear folder contents
    puts "Deleting contents of $OUTPUT_DIR"
    file delete -force {*}[glob -directory $OUTPUT_DIR *]
}

file mkdir $OUTPUT_DIR/post_synth
file mkdir $OUTPUT_DIR/post_opt
file mkdir $OUTPUT_DIR/post_place
file mkdir $OUTPUT_DIR/post_place_physopt
file mkdir $OUTPUT_DIR/post_route

# User Settings

# Synthesis related settings
set SYNTH_ARGS ""
append SYNTH_ARGS " " -flatten_hierarchy " " rebuilt " "
append SYNTH_ARGS " " -gated_clock_conversion " " off " "
append SYNTH_ARGS " " -bufg " {" 12 "} "
append SYNTH_ARGS " " -fanout_limit " {" 10000 "} "
append SYNTH_ARGS " " -directive " " Default " "
append SYNTH_ARGS " " -fsm_extraction " " auto " "
append SYNTH_ARGS " " -resource_sharing " " auto " "
append SYNTH_ARGS " " -control_set_opt_threshold " " auto " "
append SYNTH_ARGS " " -shreg_min_size " {" 5 "} "
append SYNTH_ARGS " " -max_bram " {" -1 "} "
append SYNTH_ARGS " " -max_dsp " {" -1 "} "
append SYNTH_ARGS " " -cascade_dsp " " auto " "
append SYNTH_ARGS " " -verbose

set DEFINES ""
append DEFINES -verilog_define " " USE_DEBUG " "

set TOP_MODULE "fulladder"

# Build Design

# Assign part to in-memory project
set_part $PART_NM

# Read all the design files
read_verilog ../hdl/fulladder.v

# Read the constraint files
read_xdc ../constraints/fulladder.xdc

# Synthesize Design
eval "synth_design $DEFINES $SYNTH_ARGS -top $TOP_MODULE -part $PART_NM"
report_timing_summary -file $OUTPUT_DIR/post_synth/${PROJ_NM}_post_synth_tim.rpt
report_utilization -file $OUTPUT_DIR/post_synth/${PROJ_NM}_post_synth_util.rpt
write_checkpoint -force $OUTPUT_DIR/post_synth/${PROJ_NM}_post_synth.dcp

# Optimize Design
opt_design -directive Explore
report_timing_summary -file $OUTPUT_DIR/post_opt/${PROJ_NM}_post_opt_tim.rpt
report_utilization -file $OUTPUT_DIR/post_opt/${PROJ_NM}_post_opt_util.rpt
write_checkpoint -force $OUTPUT_DIR/post_opt/${PROJ_NM}_post_opt.dcp
# Upgrade DSP connection warnings to an error because this is an error post route
set_property SEVERITY {ERROR} [get_drc_checks DSPS-*]
# Run DRC on opt design to catch early issues like comb loops
report_drc -file $OUTPUT_DIR/post_opt/${PROJ_NM}_post_opt_drc.rpt

# Place Design
place_design -directive Explore
report_timing_summary -file $OUTPUT_DIR/post_place/${PROJ_NM}_post_place_tim.rpt
report_utilization -file $OUTPUT_DIR/post_place/${PROJ_NM}_post_place_util.rpt
write_checkpoint -force $OUTPUT_DIR/post_place/${PROJ_NM}_post_place.dcp

# Post Place Phys Opt
# phys_opt_design -directive AggressiveExplore
# report_timing_summary -file $OUTPUT_DIR/${PROJ_NM}_post_place_physopt_tim.rpt
# report_utilization -file $OUTPUT_DIR/${PROJ_NM}_post_place_physopt_util.rpt
# write_checkpoint -force $OUTPUT_DIR/${PROJ_NM}_post_place_physopt.dcp

# Post Place Phys Opt Looping
set NLOOPS 5
set WNS_PREV 0

set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
if {$WNS < 0.000} {
    # Add over constraining
    set_clock_uncertainty 0.200 [get_clocks VCLK]

    for {set i 0} {$i < $NLOOPS} {incr i} {
        phys_opt_design -directive AggressiveExplore

        set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]

        if {($WNS == $WNS_PREV && $i > 0) || $WNS >= 0.000} {
            break
        }
        set WNS_PREV $WNS

        phys_opt_design -directive AggressiveFanoutOpt
        set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
        if {($WNS == $WNS_PREV && $i > 0) || $WNS >= 0.000} {
            break
        }
        set WNS_PREV $WNS

        phys_opt_design -directive AlternateReplication
        set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
        if {($WNS == $WNS_PREV) || $WNS >= 0.000} {
            break
        }
        set WNS_PREV $WNS
    }
}

# Remove over constraining
set_clock_uncertainty 0 [get_clocks VCLK]

report_timing_summary -file $OUTPUT_DIR/post_place_physopt/${PROJ_NM}_post_place_physopt_tim.rpt
report_utilization -file $OUTPUT_DIR/post_place_physopt/${PROJ_NM}_post_place_util.rpt
report_design_analysis -logic_level_distribution -of_timing_paths [get_timing_paths -max_paths 10000 -slack_lesser_than 0] -file $OUTPUT_DIR/post_place_physopt/${PROJ_NM}_post_place_physopt_vios.rpt
write_checkpoint -force $OUTPUT_DIR/post_place_physopt/${PROJ_NM}_post_place_physopt.dcp

# Route Design
route_design -directive Explore
report_timing_summary -file $OUTPUT_DIR/post_route/${PROJ_NM}_post_route_tim.rpt
report_utilization -hierarchical -file $OUTPUT_DIR/post_route/${PROJ_NM}_post_route_util.rpt
report_route_status -file $OUTPUT_DIR/post_route/${PROJ_NM}_post_route_status.rpt
report_io -file $OUTPUT_DIR/post_route/${PROJ_NM}_post_route_io.rpt
report_power -file $OUTPUT_DIR/post_route/${PROJ_NM}_post_route_power.rpt
report_design_analysis -logic_level_distribution -of_timing_paths [get_timing_paths -max_paths 10000 -slack_lesser_than 0] -file $OUTPUT_DIR/post_route/${PROJ_NM}_post_route_vios.rpt
write_checkpoint -force $OUTPUT_DIR/post_route/${PROJ_NM}_post_route.dcp

set WNS [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
puts "Post Route WNS = $WNS"

# Write out bitfile
write_debug_probes -force $OUTPUT_DIR/${PROJ_NM}_${BUILD_DATE}_${BUILD_TIME}_${WNS}ns.ltx
write_bitstream -force $OUTPUT_DIR/${PROJ_NM}_${BUILD_DATE}_${BUILD_TIME}_${WNS}ns.bit -bin_file