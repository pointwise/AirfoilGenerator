# AirfoilGenerator
Copyright 2021 Cadence Design Systems, Inc. All rights reserved worldwide.

A Glyph script for generating NACA 4-series airfoil geometries.

![AirfoilGenGUI](https://raw.github.com/pointwise/AirfoilGenerator/master/ScriptImage.png)

## Generating Geometry
This script provides a way to generate NACA 4-Series airfoil geometries within Pointwise without relying on external coordinate files. Simply input the 4 digits defining a NACA 4-Series airfoil and click CREATE. Airfoils can be generated with either sharp or blunt trailing edges.

### NACA 4-Series Geometry Description
* The 1st digit is the maximum camber
* The 2nd digit is the maximum camber location 
* The 3rd and 4th digits represent the maximum thickness

### Notes
* All digits are a percentage of the chord length
* Maximum thickness occurs at 30% of the chord
* Chord length fixed to a unit length

### Example, NACA 2412
* Maximum camber is 2% of the chord
* Maximum camber located at 40% of the chord
* Maximum thickness is 12% of the chord (located at 30% of the chord)

![NACA2412](https://raw.github.com/pointwise/AirfoilGenerator/master/NACAImage.png)

## Disclaimer
This file is licensed under the Cadence Public License Version 1.0 (the "License"), a copy of which is found in the LICENSE file, and is distributed "AS IS." 
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE. 
Please see the License for the full text of applicable terms.

