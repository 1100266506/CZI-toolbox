# CZI toolbox
A library of scripts used to manage, edit, and image-process CZI zstack images. 

@author Benjamin Ahn

### Technologies
Python 3.6  
Java 11  
ImageJ with Bio-formats plug-in  

### Launch
All scripts can be used off the terminal or the ImageJ Application

### Table of Contents
* CZI-channel-merger
* CZI-deconvolution
* CZI-foldercreator
* CZI-histogramequalizer
* CZI-manualmorphology
* CZI-remover
* CZI-renamer
* CZI-to-image

### CZI-channel-merger
Takes a heiarchy of CZI files after using the ldw_bja histogramequalizer script. Merges 2 folders of exported tiff slices (one folder of Iba1, one folder of DAPI) and combines them into one folder. Expidtes the MMQT segmentation step

### CZI-deconvolution
Takes a CZI file and deconvolves it, reducing out-of-focus light

### CZI-foldercreator
Creates a folder heiarchy of CZI files, meant to be used with the MMQT analysis and 3D analysis pipeline.

### CZI-histogramequalizer
Adjusts CZI's to reduce background noise and boost signal using histogram equalization. Exports them as tiffs per slice per channel.  
The male script contains unique background-adjustment values fit for the Male exp1.1.0 dataset  
The female script contains unique background adjustment values fit for that datset  
The ldw_bja script was developed by Laura Weinstock (graduate student, Wood Lab) and adapted by Benjamin Ahn to optimize background subtraction, signal boosting, and image exporting to then be used by the MMQT analysis pipeline.

### CZI-manualmorphology
Adjusts CZI's for background noise, applies nondestructive grid, and creates a 2D Maximum Intensity Projection

### CZI-remover
Sifts through a folder heiarchy created by CZI-foldercreator and deletes CZI's and puts in place a txt file with the same name

### CZI-renamer
Sifts through a folder heiarchy created by CZI-foldercreator and renames CZI's to remove spaces in the name

### CZI-to-image
A generic file to image exporter. Adjusts CZI's for background noise using Min and Max adjustments and exports them as tiffs per slice per channel

### Credits
@author Benjamin Ahn  
@version 1.0  
@version 2.0 added CZI-to-image  
@version 3.0 added histogramequalizer and manual morphology  
@version 4.0 added CZI-deconvolution  
@version 4.1 updated CZI-histogramequalizer for gender
@version 5.0 added CZI-channel-merger
@version 5.1 updated CZI-histogramequalizer ldwbja to work with female data set