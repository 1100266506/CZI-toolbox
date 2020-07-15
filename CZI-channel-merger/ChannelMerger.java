import java.util.Scanner;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/*
 * CZI-channel-merger
 * This is to be used with LDW CZI-toTif ImageJ script for the female data set.
 * This program takes 2 folders of exported image slices and combines it into one folder
 * Meant to be used before MMQT processing
 * @author Benjamin Ahn
 * @verion 1.0
 */

class ChannelMerger {
	public static void main(String args[]) {
		//take user input. Find working directory
		Scanner scan = new Scanner(System.in);
		System.out.println("Enter large directory folder (DAPI/Iba1):");
		String projDirectory = scan.nextLine();
		File projDirectoryFolder = new File(projDirectory);


		//parse through each image
		for (File imageFolder : projDirectoryFolder.listFiles()) {
			//establish image folder name ie. ./main/image1
			String imageFolderName = projDirectory + "/" + imageFolder.getName();

			//access each image
			String destinationFolderString =  imageFolderName + "/decon_histoeq";
			System.out.println(destinationFolderString);

			//create folder containing merged image slices
			File destionationFolder = new File(destinationFolderString);
			destionationFolder.mkdir(); 

			//access DAPI files
			String dapiFolderString = imageFolderName + "/" + imageFolder.getName() + "dapi";
			File dapiFolder = new File(dapiFolderString);

			//rename DAPI files and move
			File[] dapiImages = dapiFolder.listFiles();
			for (File image : dapiImages) {
				//rename image
				String imageName = image.getName();
				String imageName_core = imageName.substring(0, imageName.length() - 4);
				String imageName_new = imageName_core + "_c1.tif";
				String imageName_new_path = destinationFolderString + "/" + imageName_new;
				File image_newfile = new File(imageName_new_path);

				//finalize rename and move file
				image.renameTo(image_newfile);
			}

			//repeat for Iba1 files
			//access Iba1 files
			String iba1FolderString = imageFolderName + "/" + imageFolder.getName() + "iba1";
			File iba1Folder = new File(iba1FolderString);

			//rename Iba1 files and move
			File[] iba1Images = iba1Folder.listFiles();
			for (File image : iba1Images) {
				//rename image
				String imageName = image.getName();
				String imageName_core = imageName.substring(0, imageName.length() - 4);
				String imageName_new = imageName_core + "_c0.tif";
				String imageName_new_path = destinationFolderString + "/" + imageName_new;
				File image_newfile = new File(imageName_new_path);

				//finalize rename and move file
				image.renameTo(image_newfile);
			}
		}
	}
}