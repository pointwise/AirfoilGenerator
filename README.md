# AirfoilGenerator
A Glyph script for generating NACA 4-series airfoil geometries.

![AirfoilGenGUI](https://raw.github.com/pointwise/AirfoilGenerator/master/ScriptImage.png)

## Generating Geometry
This script provides a way to generate NACA 4-Series airfoil geometries within Pointwise without relying on external coordinate files. Simply input the 4 digits defining a NACA 4-Series airfoil and click CREATE. In the current implementation, this script only generates airfoils with a finite trailing edge.

### NACA 4-Series Geometry Description
* The 1st digit is the maximum camber
* The 2nd digit is the maximum camber location 
* The 3rd and 4th digits represent the maximum thickness

### Notes
* All digits are a percentage of the chord length
* Maximum thickness occurs at 30% of the chord
* Chord length fixed to a unit length
* All airfoils have a flat trailing edge

### Example, NACA 2412
* Maximum camber is 2% of the chord
* Maximum camber located at 40% of the chord
* Maximum thickness is 12% of the chord (located at 30% of the chord)

![NACA2412](https://raw.github.com/pointwise/AirfoilGenerator/master/NACAImage.png)

## Disclaimer
Scripts are freely provided. They are not supported products of Pointwise, Inc. Some scripts have been written and contributed by third parties outside of Pointwise's control.

TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, WITH REGARD TO THESE SCRIPTS. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THESE SCRIPTS EVEN IF POINTWISE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE FAULT OR NEGLIGENCE OF POINTWISE.

