/*
 * Microglia manual morphology run
 * 
 * This program takes a folder of MIP's that have been preprocessed by the 
 * CZI-manualmorphology script and outputs the area and perimeter for each MIP.
 * Area and perimeter can be used to calculate circularity.
 * 
 * @author Benjamin Ahn
 * @version 1.0
 */

//find MIP's
mipPath = "/media/benjamin/Windows/Users/Benja/Documents/Research/imaging/ctx_manual_morphology/ctxmale_manual_morphology/MIP";
mipFiles = getFileList(mipPath);

//parse through each MIP
for (i = 0; i < mipFiles.length; i++) {
	//open up MIP
	image = mipFiles[i];
	imagePath = mipPath + "/" + image;
	open(imagePath);

	//set measurements to get area and perimeter
	run("Set Measurements...", "area perimeter redirect=None decimal=3");

	//analyze particles
	run("Analyze Particles...", "exclude clear include summarize");

	//close out of MIP
	close();
}

//the resulting table will hold the image names, area, and perimeter 
savePath = mipPath + "/MIP_rawdata.csv";
saveAs("Results", savePath);
