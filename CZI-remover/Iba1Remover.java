import java.util.Scanner;
import java.io.File;
import java.nio.file.Files;

class Iba1Remover {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter file directory:");
        String filepath_string = scan.nextLine();

        File filepath = new File(filepath_string);
        File[] subfolderList = filepath.listFiles();

        //for each subfolder...
        for (int i = 0; i < subfolderList.length; i++) {
            //find Iba1 folder
            String subfolder_path = filepath_string + "/" + subfolderList[i].getName();

            File subfolder = new File(subfolder_path);
            File[] subfolderContents = subfolder.listFiles();

            try{
                //parse through each file and find the Iba1 folder
                for (int j = 0; j < subfolderContents.length; j++) {
                    String subfolderContent = subfolderContents[j].getName();
                    String iba1FolderName = subfolderList[i].getName() + "iba1";

                    if (subfolderContent.equals(iba1FolderName)) {
                        //found Iba1 folder!
                        System.out.println("Deleting: " + subfolderContent);
                        //delete files
                        String subfolderContent_path = subfolder_path + "/" + subfolderContent;
                        File iba1File = new File(subfolderContent_path);
                        File[] iba1Files = iba1File.listFiles();
                        for (int k = 0; k < iba1Files.length; k++) {
                            iba1Files[k].delete();
                        }

                        //delete folder
                        iba1File.delete();
                    }
                }
            } catch (Exception e) {
                System.out.println("Failed to delete! Next");
            }
        }
    }
}
