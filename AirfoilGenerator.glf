#
# Copyright 2010 (c) Pointwise, Inc.
# All rights reserved.
#
# This sample Glyph script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

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

# Load math constants for pi
package require math::constants

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

# Define pi
# The easy way; see the section named "Practical approximations" here: https://en.wikipedia.org/wiki/Approximations_of_π
# set pi [expr {355.0/113.0}]
# Another easy way that has a dependency: it requires the math::constants package
math::constants::constants pi

# Airfoil number of steps
set nsteps 1000
# Airfoil step size
set ds [expr {$pi/$nsteps}]

# Check if airfoil is symmetric or cambered
if {$m == 0 && $p == 0 || $m == 0 || $p == 0} {set symm 1} else {set symm 0}

# Get x coordinates; improved distribution explained here: http://airfoiltools.com/airfoil/naca4digit?MNaca4DigitForm%5Bcamber%5D=0&MNaca4DigitForm%5Bposition%5D=0&MNaca4DigitForm%5Bthick%5D=12&MNaca4DigitForm%5BnumPoints%5D=81&MNaca4DigitForm%5BcosSpace%5D=0&MNaca4DigitForm%5BcosSpace%5D=1&MNaca4DigitForm%5BcloseTe%5D=0&MNaca4DigitForm%5BcloseTe%5D=1&yt0=Plot
for {set i 0} {$i < [expr {$pi+$ds}]} {set i [expr {$i+$ds}]} {lappend x [expr {0.5*(1.0 - cos($i))}]}

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

# DISCLAIMER:
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
# ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
# TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, WITH REGARD TO THIS SCRIPT.  TO THE MAXIMUM EXTENT PERMITTED
# BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY
# FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES
# WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF
# BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE
# USE OF OR INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE HAS BEEN
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE
# FAULT OR NEGLIGENCE OF POINTWISE.
#
