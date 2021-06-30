// FLIMPhasorAnalysis
// Macro by B. Christoffer Lagerholm and Falk Schneider (WIMM, University of Oxford)
// 06/06/2021
// The macro analyses ROIs selected on an intensity image (or RGB PhasorFastFLIM image), then applies the ROIs to an actual
// lifetime image and pulls the lifetimes per pixel per ROI out. 
// Requires: 1. Image for ROI selection (PhasorRGB or intensity image)
//			 2. Lifetime Image 
// Output: List of values for ROIs, ROIs on selection image, histograms for ROIs
//
//
// Update: 12/06/2021
// A little update. Let's also load and analyse the intensity image
// We gotta see if the lifetimes somehow relate to the counts and if we have a good justification to discard short lifetimes!


//Select Directory containing images
dir=getDirectory("Choose the directory where the files are");
waitForUser("Please select image for ROI drawing (phasor RGB or intensity image: CH0)")
open();
title=getTitle()
rename(title+"FLIMPhasor");
run("Enhance Contrast", "saturated=0.35");

//Create ROIs by manual drawing. Click ok when all ROIs have been selected
run("ROI Manager...");
roiManager("reset");
setTool("freehand");
waitForUser("Please draw and add ROIs. \n You can use any drawing tool (polygon, rectangle ...). \n Click Add[t] and then rename ROI in ROI manager. \n Click OK here when done with all ROIs")

//Show all ROIs + Create. Save image with labelled ROIs as TIFF
roiManager("show all with labels");
run("Flatten");
rename(title+"_FLIMPhasor_ROIs");
saveAs("Tiff",dir+title+"FLIMPhasor_ROIs");

//Export ROIs for possible future use
   	roiManager("Save", dir+title+"Histogram ROIs_"+"RoiSet.zip");

//Open FastFLIM image, convert to lifetime in nsec. Enhance contrast for display
waitForUser("Please open FastFLIM Image (CH1)")
open();
rename(title+"_FastFLIM");
run("32-bit");
// Converts pixel values to lifetime values in ns with 10 ps resolution
run("Divide...", "value=100");
//Enhance contrast
run("Enhance Contrast", "saturated=0.35");

//Create Histograms of Lifetime for each ROI. Exports histograms as TIFFs
roiManager("show all with labels");
roicount=roiManager("count");
 for (i=0; i<roicount; i++) {
 	selectWindow(title+"_FastFLIM");
 	roiManager("select", i); 	     
    	run("Histogram", "bins=256 use x_min=0 x_max=8 y_max=Auto");
   	rename(title+"Histogram ROI"+i+1);
   	saveAs("Tiff",dir+title+"Histogram ROI"+i+1);

// This macro generates a 256 bin histogram and
// displays the counts in the "Results" window.
//Saves values for each ROI as .csv file
  nBins = 256;
  run("Clear Results");
  row = 0;
  getHistogram(values, counts, nBins);
  for (j=0; j<nBins; j++) {
      setResult("Value", row, values[j]);
      setResult("Count", row, counts[j]);
      row++;
   }
  updateResults();
	saveAs("Results", dir+title+"Histogram ROI"+i+1+".csv");
    }
    
// Create lists of lifetime values for each ROI. 
// Extract x,y position and pixel value from FastFLIM image
// Save values as .csv file
run("Clear Results");
for (i=0; i<roicount; i++) {
 	selectWindow(title+"_FastFLIM");
 	roiManager("select", i); 
 	roi_name = Roi.getName ();
 	
    Roi.getBounds(rx, ry, width, height); 
	row = 0; 
//	print ("ROI_"+i+1+"_"+roi_name+"Bounds: rx: " + rx + " ry: " + ry + " width: " + width + " height: " + height); // Allows to follow progess if large number of ROIs is used
	for(y=ry; y<ry+height; y++) { 
    	for(x=rx; x<rx+width; x++) { 
        	if(Roi.contains(x, y)==1) {
        		if (getPixel(x, y)>0) { 		// only save pixel values that have a lifetime value. Discard zeros 
            		setResult("ROI_"+i+1+"_"+roi_name+"_X", row, x); 
            		setResult("ROI_"+i+1+"_"+roi_name+"_Y", row, y); 
            		setResult("ROI_"+i+1+"_"+roi_name+"_Lifetime", row, getPixel(x, y)); 
            		row++; 
        		}
            	
        	} 
    	} 
	}

}


//Open FastFLIM image, convert to lifetime in nsec. Enhance contrast for display
waitForUser("Please open Intensity Image (CH0)")
open();
rename(title+"_Intensity");
// Let's save the intenstiy results also to the table. 
for (i=0; i<roicount; i++) {
 	selectWindow(title+"_Intensity");
 	roiManager("select", i); 
 	roi_name = Roi.getName ();
 	
    Roi.getBounds(rx, ry, width, height); 
	row = 0; 
//	print ("ROI_"+i+1+"_"+roi_name+"Bounds: rx: " + rx + " ry: " + ry + " width: " + width + " height: " + height); // Allows to follow progess if large number of ROIs is used
	for(y=ry; y<ry+height; y++) { 
    	for(x=rx; x<rx+width; x++) { 
        	if(Roi.contains(x, y)==1) {
        		if (getPixel(x, y)>0) { 		// only save pixel values that have a lifetime value. Discard zeros 
            		setResult("ROI_"+i+1+"_"+roi_name+"_Intensity", row, getPixel(x, y)); 
            		row++; 
        		}
            	
        	} 
    	} 
	}

}
close() // closes active image: FastFLIM image with the ROIs


// Replace padded 0 by NaN values in the results table (NaNs are ignored by GraphPad or other downstram analysis applications)
n=nResults;
for (i=0; i<roicount; i++) {
 	selectWindow(title+"_FastFLIM");
 	roiManager("select", i); 
 	roi_name = Roi.getName ();
	for (j=0; j < n; j++)  {
		if (getResult("ROI_"+i+1+"_"+roi_name+"_Lifetime", j) == 0) {
			setResult("ROI_"+i+1+"_"+roi_name+"_X", j, "NaN"); 
        	setResult("ROI_"+i+1+"_"+roi_name+"_Y", j, "NaN"); 
 			setResult("ROI_"+i+1+"_"+roi_name+"_Lifetime", j, "NaN");
 			setResult("ROI_"+i+1+"_"+roi_name+"_Intensity", j, "NaN"); 
		}
	}
}
    
saveAs("Results", dir+title+"FLIMPhasor_Results.csv"); // moving this out of the loop makes the macro siginficantly faster
close() // closes active image: FastFLIM image with the ROIs

print ("All done!")
