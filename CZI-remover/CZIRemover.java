import java.util.Scanner;
import java.io.File;
import java.nio.file.Files;

/*
 * CZIRemover
 * This program searches a folder containing folders that contain a CZI file.
 * These CZI files can be very large in memory and after analysis, are no longer
 * needed. This program will search for the CZI and delete it.
 * @author Benjamin Ahn
 * @version 1.0
 */

class CZIRemover {

    public static void main(String[] args) {

        //take in input of large file directory that contains files with CZI's
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter file directory");
        String filepath_string = scan.nextLine();

        File filepath = new File(filepath_string);
        File[] subfolderList = filepath.listFiles();

        //for each sub folder...
        for (int i = 0; i < subfolderList.length; i++) {
            //remove the czi
            File CZI = null;
            File subfolder = subfolderList[i];
            File[] fileList = subfolder.listFiles(); //creates a list of files
            for (File file : fileList) {
                if (file.getName().endsWith((".czi"))) {
                    CZI = file;
                }
            }
            String CZI_noExt;
            if (CZI != null) {
                System.out.println(CZI);
                CZI.delete();
                CZI_noExt = CZI.getName().substring(0, CZI.getName().length() - 4);

            }
            else {
                System.out.println("No CZI found");
                CZI = fileList[0];
                CZI_noExt = CZI.getName().substring(0, CZI.getName().length() - 15);
            }


            System.out.println("Making empty txt with CZI name");

            //create a blank txt file with the czi name
            System.out.println(CZI_noExt);
            String CZI_txt = CZI_noExt + ".czi";
            File file = new File(subfolder.getPath() +"/" + CZI_txt);
            try {
                file.createNewFile();
            }
            catch (Exception e) {
                System.out.println("Could not make CZI");
            }

        }
    }
}
