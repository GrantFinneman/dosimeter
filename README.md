# Dosimeter
Repo for the 2018 dosimeter project

***
## General Information
A Detector was developed with scintilating plastic. A collection of 64 bars on the end of a 64 channel SiPM. Each bar is about 8mm long, 5mm wide, 2.5mm thick.


## Data Collected in Ohio
The data collected in ohio by Alex is in the directory ohio_data/runs. The detector was rotated for each run which is denoted by \_r in the filename. The data files given by the photoniq software is pretty cluttered so the extracted data is stored in ohio_data/extracted with the same naming scheme as before.


## Gate Data
- Renamed to gate_data since the geant data was all bad and was just deleted, was called geant_data

This is where all of the extracted runs of the simulation are held. The file names hold all of the information we need about thei files from the beam width and height to the angle and if it is a cube or bar run.

## Gate Simulations
Here is where I will be creating the new geant4 simulations with the opengate collaboration wrapper. The geant runs from luke and them are all wrong. The Issue was the script we used to manipulate the simulation's start and end.

## Supplimentary Material
This is the directory that is going to contain any picture referenced in any notebook in the repository. With locations possibly changing places and images getting overwitten, put all pictures you want to place in a notebook in here so they never get changed by accident.

# Notebooks
***
## data_procesing.ipynb
The notebook used to extract the data from the original photoniq files is named data_processing.ipynb

## plotting.ipynb
The notebook that will be responsible for creating all of the plots of the energy deposition

