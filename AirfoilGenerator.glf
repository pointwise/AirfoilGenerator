#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################

# ===============================================
# NACA 4-SERIES AIRFOIL GENERATOR
# ===============================================
# Written by Travis Carrigan
#
# v1: Dec 15, 2010
# v2: May 30, 2013
#

# Load Pointwise Glyph package and Tk
package require PWI_Glyph
pw::Script loadTk

# AIRFOIL GUI INFORMATION
# -----------------------------------------------
set naca 0012
set sharp 1
wm title . "Airfoil Generator"
grid [ttk::frame .c -padding "5 5 5 5"] -column 0 -row 0 -sticky nwes
grid columnconfigure . 0 -weight 1; grid rowconfigure . 0 -weight 1
grid [ttk::labelframe .c.lf -padding "5 5 5 5" -text "NACA 4-Series Airfoil Generator"]
grid [ttk::label .c.lf.nacal -text "NACA"] -column 1 -row 1 -sticky e
grid [ttk::entry .c.lf.nacae -width 5 -textvariable naca] -column 2 -row 1 -sticky e
grid [ttk::frame .c.lf.te] -column 3 -row 1 -sticky e
grid [ttk::radiobutton .c.lf.te.sharprb -text "Sharp" -value 1 -variable sharp] -column 1 -row 1 -sticky w
grid [ttk::radiobutton .c.lf.te.bluntrb -text "Blunt" -value 0 -variable sharp] -column 1 -row 2 -sticky w
grid [ttk::button .c.lf.gob -text "CREATE" -command airfoilGen] -column 4 -row 1 -sticky e
foreach w [winfo children .c.lf] {grid configure $w -padx 10 -pady 10}
focus .c.lf.nacae
::tk::PlaceWindow . widget
bind . <Return> {airfoilGen}

proc airfoilGen {} {

# AIRFOIL INPUTS
# -----------------------------------------------
# m = maximum camber 
# p = maximum camber location 
# t = maximum thickness
set m [expr {[string index $::naca 0]/100.0}]  
set p [expr {[string index $::naca 1]/10.0}] 
set a [string index $::naca 2]
set b [string index $::naca 3]
set c "$a$b"
scan $c %d c
set t [expr {$c/100.0}]
set s $::sharp

# GENERATE AIRFOIL COORDINATES
# -----------------------------------------------
# Initialize Arrays
set x {}
set xu {}
set xl {}
set yu {}
set yl {}
set yc {0}
set yt {}

# Airfoil step size
set ds 0.001

# Check if airfoil is symmetric or cambered
if {$m == 0 && $p == 0 || $m == 0 || $p == 0} {set symm 1} else {set symm 0}

# Get x coordinates
for {set i 0} {$i < [expr {1+$ds}]} {set i [expr {$i+$ds}]} {lappend x $i}

# Calculate mean camber line and thickness distribution
foreach xx $x {

	# Mean camber line definition for symmetric geometry
	if {$symm == 1} {lappend yc 0}

	# Mean camber line definition for cambered geometry
	if {$symm == 0 && $xx <= $p} {
		lappend yc [expr {($m/($p**2))*(2*$p*$xx-$xx**2)}]
	} elseif {$symm == 0 && $xx > $p} {
		lappend yc [expr {($m/((1-$p)**2)*(1-2*$p+2*$p*$xx-$xx**2))}]
	}

	# Thickness distribution
    if {$s} {
	    lappend yt [expr {($t/0.20)*(0.29690*sqrt($xx)-0.12600*$xx- \
	                      0.35160*$xx**2+0.28430*$xx**3-0.1036*$xx**4)}]
    } else {
	    lappend yt [expr {($t/0.20)*(0.29690*sqrt($xx)-0.12600*$xx- \
	                      0.35160*$xx**2+0.28430*$xx**3-0.1015*$xx**4)}]
    }

	# Theta
	set dy [expr {[lindex $yc end] - [lindex $yc end-1]}]
	set th [expr {atan($dy/$ds)}]

	# Upper x and y coordinates
	lappend xu [expr {$xx-[lindex $yt end]*sin($th)}]
	lappend yu [expr {[lindex $yc end]+[lindex $yt end]*cos($th)}]

	# Lower x and y coordinates
	lappend xl [expr {$xx+[lindex $yt end]*sin($th)}]
	lappend yl [expr {[lindex $yc end]-[lindex $yt end]*cos($th)}]

}

# GENERATE AIRFOIL GEOMETRY
# -----------------------------------------------
# Create upper airfoil surface
set airUpper [pw::Application begin Create]
set airUpperPts [pw::SegmentSpline create]

for {set i 0} {$i < [llength $x]} {incr i} {
	$airUpperPts addPoint [list [lindex $xu $i] [lindex $yu $i] 0]
}

set airUpperCurve [pw::Curve create]
$airUpperCurve addSegment $airUpperPts
$airUpper end

# Create lower airfoil surface
set airLower [pw::Application begin Create]
set airLowerPts [pw::SegmentSpline create]

for {set i 0} {$i < [llength $x]} {incr i} {
	$airLowerPts addPoint [list [lindex $xl $i] [lindex $yl $i] 0]
}

set airLowerCurve [pw::Curve create]
$airLowerCurve addSegment $airLowerPts
$airLower end

if {!$s} {
    # Create flat trailing edge
    set airTrail [pw::Application begin Create]
    set airTrailPts [pw::SegmentSpline create]
    $airTrailPts addPoint [list [lindex $xu end] [lindex $yu end] 0]
    $airTrailPts addPoint [list [lindex $xl end] [lindex $yl end] 0]
    set airTrailCurve [pw::Curve create]
    $airTrailCurve addSegment $airTrailPts
    $airTrail end
}

# Zoom to airfoil geometry
pw::Display resetView

exit

}

# END SCRIPT

#############################################################################
#
# This file is licensed under the Cadence Public License Version 1.0 (the
# "License"), a copy of which is found in the included file named "LICENSE",
# and is distributed "AS IS." TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE
# LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO
# ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE.
# Please see the License for the full text of applicable terms.
#
#############################################################################
