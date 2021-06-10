# Naming of generated files
The filenames of the extracted data and the generatted data are exactly the same except the extracted files have an `extracted` on the end. The W and H stand for the width and height of the beam. The A portion denotes the angle by which the detector has been rotated.

#### *NOTE*
- Upon the discovery that ALL of the Geant data was wrong (see the figures in the figures directory), all of the geant data was deleted due to being cluttering. This allowes this direcotry to be renamed to reflect the useable data contained within, the Gate data

## Example of Un-Extracted Gate Output
This stuff will extend for about $12$ million lines to a size of $250$ Mb. I formatted it using tabulate in python just so you could see what is happening. The text editor in the picture is Vim.
![Formatted output from simulation](../supplimentary_material/raw_gate_output.png)

***
## All of this is obsolete now since the geant data was broken

These files can still be found here but the directory is hidden.
## Geant Bars
The name of each file totEDBars\_#\_#.txt signifies the shape of the beam hitting the detector. The beam is a rectangle centered on the detector with a length and width defined by the first and second numbers respectively. The second number gives the thickness of the beam which is shows up as more pixels being activated on the detector. It gets wider
![title](../supplimentary_material/proof_of_geant_beam_width.png)

## Geant Cubes
Same naming scheme as the bars, The beam follows the same order as the bars.

- Example of totEDCubes:

`0 0 0 2.49451
1 0 0 3.13366
2 0 0 0.818008
3 0 0 1.78182
4 0 0 0.0120127
5 0 0 1.19679`

- Col1: CubeID in dimension x
- Col2: CubeID in dimension y
- Col3: cubeID in dimension z
- Col4: Energy Deposition in the specific cube