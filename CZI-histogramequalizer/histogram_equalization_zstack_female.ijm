/*
 * Histogram equalization for czi zstacks
 * This program will parse through a zstack, use rolling ball to subtract background, 
 * and run the Enhance Contrast with 
 * histogram equalization option. It uses the bioformats plugin to import czi's
 * and to export them as individual tiffs for each zslice and channcel
 * @author Benjamin Ahn
 * @version 1.0
 * @version 2.0 adjusted for females since they have more out of focus light in images
 */

//access path with folders containing czi's
//Note - remember to change the path for the correct condition
samplePath = "/media/benjamin/Windows/Users/Benja/Documents/Research/imaging/female/ctx_reducedbackground/other";
sampleFiles = getFileList(samplePath);
print(sampleFiles.length);

//parse through each czi file 
for (i = 0; i < sampleFiles.length; i++) {
	//select an image 
	imagePath = samplePath + "/" + sampleFiles[i];
	imageFiles = getFileList(imagePath);

	//if there is a current histogram_equalized folder, delete it 
	oldDir = imagePath + "histogram_equalized";
	if (File.isDirectory(oldDir)) {
		print("Found: " + oldDir);
		oldFiles = getFileList(oldDir);
		for (d = 0; d < oldFiles.length; d++) {
			//must delete each file in folder
			File.delete(oldDir + "/" + oldFiles[d]);	
		}
		File.delete(oldDir);
	}

	//parse through each file in the image folder, and find the czi 
	cziFile = "";
	for (j = 0; j < imageFiles.length; j++) {
		currentFileName = imageFiles[j];
		
		//does the file have a czi ending?
		czi_ending = substring(currentFileName, lengthOf(currentFileName) - 3, lengthOf(currentFileName));

		if (czi_ending == "zed") {
			print(currentFileName);
		}
		//if the file does have a czi ending, assign it to the cziFile variable
		if (czi_ending == "czi") {
			cziFile = currentFileName;
		}
	}

	//if a czi file is found, then continue
	if (cziFile != "") {
		//open czi using bioformats
		cziFileFullName = imagePath + cziFile;
		run("Bio-Formats Importer", "open=" + cziFileFullName + " autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

		//images were not binned in Zen, so must bin now
		run("Bin...", "x=3 y=3 bin=Average");

		//adjust contrast and equalize histogram for each slice in the zstack 
		getDimensions(width, height, channels, slices, frames);
		for (k = 1; k <= slices; k++) {
			Stack.setSlice(k);
			
			//females use rolling ball background subtraction
			run("Subtract Background...", "radius=40");
			
			getRawStatistics(nPixels, mean, min, max, std, histogram);
			run("Min...", "value=" + mean * 1.5);
			run("Enhance Contrast...", "saturated=.3 equalize");
			
		}

		
		
		

		//export czi in individual tiffs using bioformats as to not change the actual values of the czi file 	
		File.makeDirectory(imagePath + "histogram_equalized");
		cziName = substring(cziFileFullName, lengthOf(imagePath), lengthOf(cziFileFullName) - 4);
		cziName = cziName + ".tif";
		saveFilePath = imagePath + "histogram_equalized/" + cziName;

		print(cziName);
		run("Bio-Formats Exporter", "save=" + saveFilePath + " write_each_z_section write_each_channel export compression=Uncompressed");
		close();
	}
	else {
		print("No czi file found! Moving to next folder");
	}
}

print("***********DONE***********");