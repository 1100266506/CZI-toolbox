import java.util.Scanner;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/*
 * Folder Creator
 * This program is used to set up the mmqt-master pipeline by creating a folder and
 * moving a CZI file into that individual file
 * @author Benjamin Ahn
 * @version 1.0
 */

class FolderCreator {
    public static void main(String[] args) throws Exception {
        //This will create the folders to hold each CZI
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter project directory");
        String projDirectory = scan.nextLine();
        System.out.println("Creating folders under " + projDirectory);
        File projDirFolder = new File(projDirectory);
        projDirFolder.mkdir();

        System.out.println("Where are the CZI files? Enter path:");
        String cziPath = scan.nextLine();
        File cziDirectory = new File(cziPath);

        //Create individual folders and move CZI files into them
        int count = 0;
        for (File image : cziDirectory.listFiles()) {
            String image_name = image.getName();
            String sub_image = image_name.substring(0, 32);

            //is my image a ctx or ca?
            String mini = sub_image.substring(sub_image.length() - 4, sub_image.length() - 1);
            if (mini.equals("CTX")) {
                System.out.println(sub_image);
            } else {
                sub_image = sub_image.substring(0, 31);
            }
            String filePath = projDirectory + "/" + sub_image;
            System.out.println(filePath);
            File individualFile = new File(filePath);
            individualFile.mkdir();

            Path fileTarget = Paths.get(filePath + "/" + image.getName());
            Path fileSource = Paths.get(image.getPath());
            Files.move(fileSource, fileTarget);
            count++;
        }

        System.out.println("Created " + count + " folders.");
    }
}
