# debug.tcl

puts "==== MSXBAS2ROM Debug Session ===="

# find first .noi file in current directory
set noi_files [glob -nocomplain *.noi]

if {[llength $noi_files] == 0} {
    puts "No .noi file found."
    return
}

# get first file
set noi_file [lindex $noi_files 0]

# remove extension to get ROM name
set rom [file rootname $noi_file]

puts "ROM base name: $rom"

puts "Loading debug symbols..."
debug load_symbols $noi_file

puts "Setting initial breakpoint..."
debug set_bp START_PGM

debug show

puts "Debugger ready."