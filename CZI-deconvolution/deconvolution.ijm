/**
 * Microglia Deconvolution
 * This macro takes in a directory of MIPs and uses the rolling ball algorithm to reduce out-of-focus light around microglia. 
 * It then saves the new images in a folder called "Deconvolved" with the image name prefix, "Decon"
 * @author Benjamin Ahn
 * @version 1.0
 */

mip_pathway = getDirectory("/media/benjamin/UGA/2020_02_26_exp1_1_0_female/MIP_Images");
mip_images = getFileList(mip_pathway);
File.makeDirectory("/home/benjamin/CS/Deconvolved");

for (i = 0; i < 4 /*mip_images.length*/; i++) {
	image_path = mip_pathway + mip_images[i];
	open(image_path);
	run("Split Channels");
	close(); //close out of dapi channel
	selectWindow(mip_images[i] + " (red)");
	close();
	run("Subtract Background...", "radius = 40");
	name = getTitle();
	saveAs("Tiff", "/home/benjamin/CS/Deconvolved/" + "Decon" + name);
	close();
}
