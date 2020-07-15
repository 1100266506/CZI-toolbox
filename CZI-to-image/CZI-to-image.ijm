/*
 * CZI-to-image
 * The following program uses the bioformats plugin in image J
 * and converts a CZI z-stack into individual images.
 * The motivation for this program was to create background-adjusted
 * images for the mmqt (microglia morphology quantification toolbox)
 * analysis. The following images are read by the mmqt. 
 * @author Benjaminn Ahn
 * @version 2.0 using filter instead of min/max
 */

//path to folder holding folders to czi's
 samplePath = '/media/benjamin/Windows/Users/Benja/Documents/Research/imaging/ctx_reducedbackground/ctx_reducedbackground';
 sampleDir = getFileList(samplePath);

 for (i = 0; i < sampleDir.length; i++) {
 	//individual image 
 	imgPath = samplePath + "/" + sampleDir[i];
 	imgDir = getFileList(imgPath);

 	//create folder to hold imageJ images 
 	File.makeDirectory(imgPath + "/adjusted_stacks");

	czi = "blank";
	//find czi file 
	for (j = 0; j < imgDir.length; j++) {
		file = File.getName(imgDir[j]);
		ending = substring(file, lengthOf(file)-4, lengthOf(file));
		if (ending=='.czi') {
			czi = file;
		}
	}
 	//run bio-formats to open czi
 	filePath = imgPath + czi;
 	run("Bio-Formats Importer", "open=" + filePath + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCTZ");
	run("HiLo");

	//REMOVE BACKGROUND 

	//method 1 - set a min and max across zstack
	overall_mean = 0;
	getDimensions(width, height, channels, slices, frames);
	for (k = 0; k < slices; k++) {
		Stack.setSlice(k);
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		overall_mean = overall_mean + mean;
	}
	overall_mean = overall_mean/slices;
	print(overall_mean);
	
	value = overall_mean;
	value1 = 100;

	run("Median...", "radius=0.5 stack");
	run("Min...", "value=" + value + " stack");
	run("Max...", "value=" + value1 + " stack");

	


	
	//method 2 - use filter
	//run("Median...", "radius=0.5 stack");	

	//remove region in slice with apotome streaks
	/*
	getDimensions(width, height, channels, slices, frames);
	for (k = 0; k < slices; k++) {
		Stack.setSlice(k);
		makeRectangle(441, 0, 471, 374);
		run("Clear", "slice");
	}
	*/

	//method 3 - set a unique min and max for each slice 
	/*
	getDimensions(width, height, channels, slices, frames);
	for (k = 0; k < slices; k++) {
		Stack.setSlice(k);
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		minvalue = 1.5 * mean;
		
		run("Min...", "value=" + minvalue + " slice");
	}
	*/

	//save each z stack in the czi as a tiff
	savePath = imgPath + "adjusted_stacks/" + substring(czi,0, lengthOf(czi)-4) + ".tif";
 	run("Bio-Formats Exporter", "save=" + savePath + " write_each_z_section write_each_channel export compression=Uncompressed");
 	close();

 	}
