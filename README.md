# Particle-Intensity-Analysis-3D
MATLAB script to quantify background-subtracted particle intensities from 3D images

This script enables paired intensity measurements for individual particles imaged in two fluorescence channels. Open and run `particleIntensities3D.m` in MATLAB. Locate a particle of interest in the z-stack. Hold down **Ctrl** and **click** the particle to select it. Repeat the selection for each particle of interest.

For each selected particle, the script uses its spatial coordinates to extract background-subtracted integrated intensity. Both measurements correspond to the same manually selected particle, allowing its fluorescence intensity to be assessed in each channel.
