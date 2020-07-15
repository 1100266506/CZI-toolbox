/*
 * BJA Update: this has been adapted such that: 
 * 1. the image is binned 3x3 to reduce size of files
 * 2. The DAPI channel is also included in the export. The MMQT requires the image stack to contain two channels
 * 3. Import CZI's using Bio-formats instead of the regular "open" method, to allow for automated processing
 * 4. Save and Import files are adapted to fit the MMQT pipeline
 * THIS IS A GOOD ONE! 7/14/2020
 */

//this experiment path is the main directory that holds several folders, each containing it's own czi
experiment_path = "/media/benjamin/Windows/Users/Benja/Documents/Research/imaging/female/ctx_reducedbackground/round3_imagej/";
//experiment_path = getDirectory("");

//savepath = "C:/Users/lweinstock3/Box/Benjamin Ahn/IHC/2020_02_26_exp1_1_0_female/TIFpostprocessCTX_ldw/";
//savepath = "/media/benjamin/Windows/Users/Benja/Documents/Research/imaging/female/Laura/TIFpostprocessCTX_ldw/";
//setBatchMode(true);

//list of all the zstack files within input directory
brain_list = getFileList(experiment_path);
//print(brain_list[3]);
//j=5;
for (j = 0; j < brain_list.length; j++) {
	brain_path = brain_list[j];


	if (matches(brain_path, ".*CTX.*")) {
		print(brain_path);

		//BJA
		subname = substring(brain_path, 0, lengthOf(brain_path) - 1);
		run("Bio-Formats Importer", "open=" + experiment_path + brain_path + subname + ".czi");

		//images were not binned in Zen, so must bin now
		//run("Bin...", "x=3 y=3 bin=Average");
		//BJAend
		
		//open(brain_path);
		name1 = File.nameWithoutExtension();
		File.makeDirectory(experiment_path + brain_path + "/" + name1 + "dapi");
		File.makeDirectory(experiment_path + brain_path +  "/" + name1 + "iba1");
		name2 = getTitle();
		run("Split Channels");

		//BJA select DAPI channel and export
		selectWindow("C2-" + name2); //select DAPI channel	
		run("Bin...", "x=3 y=3 bin=Average");	
		imageSave = experiment_path + brain_path + "/" + name1 + "dapi" + "/" + name1 + ".tif";
		run("Bio-Formats Exporter", "save=" + imageSave + " write_each_z_section export compression=Uncompressed");//save stack of images
		//BJA
		
		selectWindow("C1-"+name2);

		blocksize = 127; histogram_bins = 256;
		maximum_slope = 3; mask = "*None*";
		fast = true; process_as_composite = false;
		 
		getDimensions( width, height, channels, slices, frames );
		isComposite = channels > 1;
		parameters =
		  "blocksize=" + blocksize +
		  " histogram=" + histogram_bins +
		  " maximum=" + maximum_slope +
		  " mask=" + mask;
		if ( fast )
		  parameters += " fast_(less_accurate)";
		if ( isComposite && process_as_composite ) {
		  parameters += " process_as_composite";
		  channels = 1;
		}
		for ( c=1; c<=channels; c++ ) {
			for ( f=1; f<=frames; f++ ) {
			  Stack.setFrame( f );
			  for ( s=1; s<=slices; s++ ) {
			    Stack.setSlice( s );
			    //if ( c==1 ) {
			      Stack.setChannel( c );

			      /*original
			      run("Subtract Background...", "rolling = 40");
			      
			      run( "Enhance Local Contrast (CLAHE)", parameters );
			      run("Subtract Background...", "rolling = 40");
			      run( "Enhance Local Contrast (CLAHE)", parameters );
			      run("Min...", "value=90");
			      */

//test 2
			      run("Subtract Background...", "rolling = 40");
			      getRawStatistics(nPixels, mean, min, max, std, histogram);
			      setMinAndMax(mean*1.5, max);
			      run("Enhance Contrast...", "saturated=.3 equalize");
			      

			      
			    //}
			    //if ( c==2 ) {
				//	run("Subtract Background...", "rolling = 50");
				// }
		  		}
			}}

			      
		//run("Add...", "value=1");

		run("Bin...", "x=3 y=3 bin=Average");
		
		
		//imageSave = savepath+name1+"/"+name1+"00.tif"; BJA
		imageSave = experiment_path + brain_path + "/" + name1 + "iba1" + "/" + name1 + ".tif";
		
		print(imageSave);
		//BJA save Iba1 run("Image Sequence... ", "format=TIFF name="+name1+ "_c0_" + " digits=2 save=["+imageSave+"]");	
		run("Bio-Formats Exporter", "save=" + imageSave + " write_each_z_section export compression=Uncompressed");//save stack of images
		run("Close All");

//test2 part 2
		print(experiment_path + brain_path + substring(brain_path, 0, lengthOf(brain_path) - 1) + "iba1/" + brain_path + "_Z0.tif");
		run("Image Sequence...", "open=" + experiment_path + brain_path + substring(brain_path, 0, lengthOf(brain_path) - 1) + "iba1/" + substring(brain_path, 0, lengthOf(brain_path) - 1) + "_Z0.tif" + " sort");
		run("Unsharp Mask...", "radius=10 mask=0.60 stack");
		run("Subtract Background...", "rolling=10 stack");
		

		File.makeDirectory(experiment_path + brain_path +  "/" + name1 + "iba1_new");
		//imageSave = savepath+name1+"/"+name1+"00.tif"; BJA
		imageSave = experiment_path + brain_path + "/" + name1 + "iba1_new" + "/" + name1 + ".tif";
		
		print(imageSave);
		//BJA save Iba1 run("Image Sequence... ", "format=TIFF name="+name1+ "_c0_" + " digits=2 save=["+imageSave+"]");	
		run("Bio-Formats Exporter", "save=" + imageSave + " write_each_z_section export compression=Uncompressed");//save stack of images
		run("Close All");
	}
}

print("DONE");
//}