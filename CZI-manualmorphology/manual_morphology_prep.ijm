/*
 * Manual Morphology Prep
 * This program takes in a czi zstack and creates a Maximum Intensity Projection
 * after subtracting background (Min function, histogram equalization) and 
 * binarizing the image. A nondestructive grid is then applied to allow for 
 * random selection of microglia cells. The MIP's can then be used for manual 
 * microglia morphology analysis
 * 
 * @author Benjamin Ahn
 * @version 1.0
 */

//access path with folders containing czi's
samplePath = "/media/benjamin/Windows/Users/Benja/Documents/Research/imaging/ctx_manual_morphology/ctxmale_manual_morphology";
sampleFiles = getFileList(samplePath);

//create folder to hold all MIPs
mipPath = samplePath + "/" + "MIP";
File.makeDirectory(mipPath);

//parse through samples
for (i = 0; i < sampleFiles.length; i++) {
	imagePath = samplePath + "/" + sampleFiles[i];
	imageFiles = getFileList(imagePath);

	//parse through each file in the image folder, and find the czi 
	cziFile = "";
	for (j = 0; j < imageFiles.length; j++) {
		currentFileName = imageFiles[j];

		//does the file have a czi ending?
		czi_ending = substring(currentFileName, lengthOf(currentFileName) - 3, lengthOf(currentFileName));

		//if the file does have a czi ending, assign it to the cziFile variable
		if (czi_ending == "czi") {
			cziFile = currentFileName;
		}
	}

	//if the czi file is found, continue
	if (cziFile !="") {
		//open czi using bioformats
		cziFileFullName = imagePath + cziFile;
		run("Bio-Formats Importer", "open=" + cziFileFullName + " autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

		//export in separate channels
		File.makeDirectory(imagePath + "separate_channels");
		cziName = substring(cziFileFullName, lengthOf(imagePath), lengthOf(cziFileFullName) - 4);
		cziName = cziName + ".tif";		
		saveFilePath = imagePath + "separate_channels/" + cziName;
		print(cziName);
		run("Bio-Formats Exporter", "save=" + saveFilePath + " write_each_channel export compression=Uncompressed");
		close();

		//open up microglia channel
		savePath = imagePath + "separate_channels";
		saveFiles = getFileList(savePath);
		microglia_images = "";
		for (a = 0; a < saveFiles.length; a++) {
			//parse through each file
			currentFile = saveFiles[a];
			end_tag = substring(currentFile, lengthOf(currentFile) - 6, lengthOf(currentFile) - 4);

			//if the file has this ending, then it is the microglia image stack
			if (end_tag == "C0") {
				//assign the microglia image stack
				microglia_images = currentFile;
			}
		}
		microglia_path = savePath + "/" + microglia_images;
		open(microglia_path);

		//create MIP
		run("Z Project...", "projection=[Max Intensity]");
		
		//adjust background using Min function and histogram equalization 
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		run("Min...", "value=" + mean);
		run("Enhance Contrast...", "saturated=0.3 equalize");
			

		//binarize and add nondestructive grid
		run("Make Binary");
		run("Grid...", "type = lines area = 6");

		//save MIP in the folder and in a main repository folder
		mipSavePath = imagePath + "separate_channels/" + "MIP" + cziName;
		saveAs("tiff", mipSavePath);

		mipSavePath2 = mipPath + "/MIP" + cziName;
		saveAs("tiff", mipSavePath2);
		close(); //close out of MIP
		close(); //close out of microglia image stack
		
	}

	//if no czi is found then move to the next one 
	else {
		print("No czi found! Moving to next image");
	}
}
