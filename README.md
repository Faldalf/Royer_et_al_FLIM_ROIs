# Royer et al. FLIM ROI Analysis

Repository for a FIJI Macro to generate and process ROIs from an exported PhasorFLIM Image (from Leica FALCON). <br/>
Code written by B. Christoffer Lagerholm and Falk Schneider (WIMM, University of Oxford). <br/>


**Used in the following publication:** <br/>


*“ASPP2 maintains the integrity of mechanically stressed pseudostratified epithelia during morphogenesis”* <br/>
Christophe Royer, Elizabeth Sandham, Elizabeth Slee, Falk Schneider, Christoffer B. Lagerholm, Jonathan Godwin, Nisha Veits, Holly Hathrell, Felix Zhou, Karolis Leonavicius, Jemma Garratt, Tanaya Narendra, Anna Vincent, Celine Jones, Tim Child, Kevin Coward, Chris Graham, Marco Fritzsche, Xin Lu, Shankar Srinivas<br/>
Nature Communications 13, 941 (2022) <br/>
[https://doi.org/10.1038/s41467-022-28590-4](https://doi.org/10.1038/s41467-022-28590-4) 


**Previous version:** <br/>


*"ASPP2/PP1 complexes maintain the integrity of pseudostratified epithelia undergoing remodelling during morphogenesis"*<br/>
Christophe Royer, Elizabeth Sandham, Elizabeth Slee, Jonathan Godwin, Nisha Veits, Holly Hathrell, Felix Zhou, Karolis Leonavicius, Jemma Garratt, Tanaya Narendra, Anna Vincent, Celine Jones, Tim Child, Kevin Coward, Chris Graham, Xin Lu, Shankar Srinivas<br/>
bioRxiv 2020.11.03.366906; doi: https://doi.org/10.1101/2020.11.03.366906 


**Detailed description and comments on the Macro!**<br/>


Briefly, the Macro takes an exported FLIM image (exported from Leica SP8 FALCON as .tiff). It requires either the intensity image or a corresponding RGB PhasorFLIM Image for ROI selection and the FLIM image to extract the lifetimes per defined ROI. Lifetimes are saved to a .csv-file. <br/>
**Contents of the repository**<br/>
FLIMPhasorAnalysis_BCL_FS.ijm
Original Macro as used in the paper. See Materials and Methods of the [publication](https://doi.org/10.1038/s41467-022-28590-4). 


FLIMPhasorAnalysis_BCL_FS_v02.ijm
Allows to also export the intensity values per pixel. (Takes the intensity image as additional input.) 

The folder "\Example_Image" contains one exemplary embryo measurement: RGB phasor-FLIM image (for segmentation), intensity image (ch0, for segmentation and assessment of photon counts) and lifetime image (ch1).
