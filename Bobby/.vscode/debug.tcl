#debug.tcl

puts "==== MSXBAS2ROM Run Session ===="

#-----------------------------------------------
# symbol load procedure
#-----------------------------------------------

proc load_symbols {} {
  global noi_file

  # clear previous loaded symbols
  if {![catch {debug symbols files} result]} {
    foreach entry $result {
      if {[dict exists $entry filename]} {
        set filename [dict get $entry filename]
        puts "Clearing symbols from $filename"
        debug symbols remove $filename
      }
    }
  }

  puts "Loading symbols from $noi_file" 
  debug symbols load $noi_file NoICE

  # search for program start address symbol
  if {[catch {debug symbols lookup} result]} {
    puts "No symbols found."
    return
  }

  # iterate and filter by name containing "LIN_"
  foreach entry $result {
    if {[dict exists $entry name] && [dict exists $entry value]} {
        set name [dict get $entry name]

        if {[string first "LIN_" $name] != -1} {
            set addr [dict get $entry value]
            puts "Setting breakpoint for $name at: $addr"
            debug breakpoint create -address $addr
        }
    }
  }

  puts "Debugger ready."
}

#-----------------------------------------------
# main procedure
#-----------------------------------------------

proc main {} {
  global fileBasenameNoExtension debugMode noi_file

  #-----------------------------------------------
  # show parameters
  #-----------------------------------------------

  unset fileBasenameNoExtension
  if {[llength $fileBasenameNoExtension] == 0} {
    puts "No .bas file found." 
    return  
  }
  puts "BAS base name: $fileBasenameNoExtension"

  unset debugMode
  puts "Debug mode: $debugMode"

  #-----------------------------------------------
  # get .rom files in current directory
  #-----------------------------------------------

  set rom_files [glob -nocomplain $fileBasenameNoExtension*.rom]
  if {[llength $rom_files] == 0} {
    puts "No .rom file found." 
    return 
  }
  set rom_file [lindex $rom_files 0]

  #-----------------------------------------------
  # load ROM into emulator
  #-----------------------------------------------

  puts "Loading ROM: $rom_file"
  cart $rom_file

  #-----------------------------------------------
  # run in debug mode
  #-----------------------------------------------

  if {$debugMode} {
    # get .noi files in current directory
    set noi_files [glob -nocomplain $fileBasenameNoExtension*.noi]
    if {[llength $noi_files] == 0} {
      puts "No .noi file found." 
      return 
    }
    set noi_file [lindex $noi_files 0]

    # run after emulator startup
    after 1000 load_symbols 
  }

  #-----------------------------------------------
  # delete parameters
  #-----------------------------------------------

  user_setting destroy fileBasenameNoExtension
  user_setting destroy debugMode
}

after 1000 main
    