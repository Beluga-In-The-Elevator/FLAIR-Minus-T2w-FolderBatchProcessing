macro "FLAIR minus T2 from subfolders" {

    parentDir = getDirectory("Choose parent folder containing 1e_/1f_/2e_/2f_/3e_/3f_ folders");
    if (parentDir=="") exit("No parent folder selected.");

    sat = 0.35;
    Dialog.create("Settings");
    Dialog.addNumber("Enhance Contrast saturated (%):", sat);
    Dialog.show();
    sat = Dialog.getNumber();

    setBatchMode(true);

    folderList = getFileList(parentDir);

    processTimepointFromFolders(folderList, parentDir, "1e", "1f", "Results_Timepoint1", sat);
    processTimepointFromFolders(folderList, parentDir, "2e", "2f", "Results_Timepoint2", sat);
    processTimepointFromFolders(folderList, parentDir, "3e", "3f", "Results_Timepoint3", sat);

    setBatchMode(false);
    showMessage("Done", "Finished processing available timepoints.");
}

function processTimepointFromFolders(folderList, parentDir, prefixE, prefixF, resultsFolderName, sat) {
    subfolderE = "";
    subfolderF = "";

    for (i = 0; i < folderList.length; i++) {
        name = folderList[i];
        fullPath = parentDir + name;

        if (!File.isDirectory(fullPath))
            continue;

        lowerName = toLowerCase(name);

        if (startsWith(lowerName, prefixE))
            subfolderE = name;
        else if (startsWith(lowerName, prefixF))
            subfolderF = name;
    }

    if (subfolderE=="" || subfolderF=="") {
        print("Skipping " + resultsFolderName + " : missing matching subfolders for " + prefixE + " and/or " + prefixF);
        return;
    }

    fileE = findFirstNifti(parentDir + subfolderE);
    fileF = findFirstNifti(parentDir + subfolderF);

    if (fileE=="" || fileF=="") {
        print("Skipping " + resultsFolderName + " : missing NIfTI in one or both subfolders.");
        return;
    }

    outDir = parentDir + resultsFolderName + File.separator;
    File.makeDirectory(outDir);

    open(fileE);
    titleE = getTitle();

    open(fileF);
    titleF = getTitle();

    selectWindow(titleE);
    run("Enhance Contrast", "saturated=" + sat);

    selectWindow(titleF);
    run("Enhance Contrast", "saturated=" + sat);

    imageCalculator("Subtract create stack", titleE, titleF);
    resultTitle = getTitle();

    selectWindow(resultTitle);
    run("Enhance Contrast", "saturated=" + sat);

    labelE = stripExtension(File.getName(fileE));
    labelF = stripExtension(File.getName(fileF));
    savePath = outDir + prefixE + "_MINUS_" + prefixF + "_" + labelE + "_minus_" + labelF + ".nii";

    run("NIfTI-1", "save=[" + savePath + "]");

    close(resultTitle);
    close(titleE);
    close(titleF);

    print("Saved: " + savePath);
}

function findFirstNifti(folderPath) {
    if (!endsWith(folderPath, File.separator))
        folderPath = folderPath + File.separator;

    innerList = getFileList(folderPath);

    for (j = 0; j < innerList.length; j++) {
        item = innerList[j];
        lowerItem = toLowerCase(item);

        if (!File.isDirectory(folderPath + item)) {
            if (endsWith(lowerItem, ".nii") || endsWith(lowerItem, ".nii.gz"))
                return folderPath + item;
        }
    }

    return "";
}

function stripExtension(name) {
    lower = toLowerCase(name);
    if (endsWith(lower, ".nii.gz"))
        return substring(name, 0, lengthOf(name)-7);
    if (endsWith(lower, ".nii"))
        return substring(name, 0, lengthOf(name)-4);

    dot = lastIndexOf(name, ".");
    if (dot==-1) return name;
    return substring(name, 0, dot);
}