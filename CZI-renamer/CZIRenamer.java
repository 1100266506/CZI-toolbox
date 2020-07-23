import java.util.Scanner;
import java.io.File;
import java.nio.file.Files;

/*
 * CZI-reanmer
 * This program searches a folder containing folders that contain a CZI file.
 * These CZI files will be renamed such that there are no spaces in the name.
 * @author Benjamin Ahn
 * @version 1.0
 */

class CZIRenamer {

    public static void main(String[] args) {

        //take in input of large file directory that contains files with CZI's
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter file directory with CZI's");
        String filepath_string = scan.nextLine();

        File filepath = new File(filepath_string);
        File[] subfolderList = filepath.listFiles();
        //for each sub folder...
        for (int i = 0; i < subfolderList.length; i++) {
            //create a default CZI and now find the real one
            File CZI = new File("blank.txt");
            File subfolder = subfolderList[i];
            File[] fileList = subfolder.listFiles(); //creates a list of files
            System.out.println(subfolder.getName());

            //search the files in the subfolder and find the czi
            for (File file : fileList) {
                if (file.getName().endsWith((".czi"))) {
                    CZI = file;
                }
            }

            String last = CZI.getName().substring(0, 32);
            File targetFile = new File(filepath_string + "/" + subfolderList[i].getName() + "/" + last + "ApoTomeRAWConvert.czi");
            CZI.renameTo(targetFile);
            System.out.println(targetFile.getName());
        }
    }
}
