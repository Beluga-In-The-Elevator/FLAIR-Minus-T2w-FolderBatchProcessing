# FLAIR-Minus-T2w-FolderBatchProcessing

FLAIR minus T2 ImageJ Macro README
This macro batch-processes paired NIfTI datasets stored in timepoint-labeled subfolders and saves subtraction outputs into matching results folders. It is designed for parent directories that contain subfolders whose names begin with 1e, 1f, 2e, 2f, 3e, or 3f, such as 3e_38836, with the actual .nii or .nii.gz file located one level inside each subfolder.

What the macro does
For each available timepoint, the macro scans the selected parent directory, looks for matching e and f subfolders by prefix, opens the first NIfTI file inside each matching subfolder, subtracts F from E using ImageJ's Image Calculator stack workflow, enhances contrast on the result, and saves the output as a new NIfTI file.

If a complete pair exists for a timepoint, the macro creates a results folder in the same parent directory:

Results_Timepoint1 for 1e and 1f

Results_Timepoint2 for 2e and 2f

Results_Timepoint3 for 3e and 3f

Folder creation is supported through ImageJ macro file utilities such as File.makeDirectory(...), and directory scanning is commonly done with getFileList(...) plus directory checks like File.isDirectory(...).

Expected folder structure
The macro expects a parent folder like this:

text
ParentFolder/
├── 1e_12345/
│   └── 12345_grp1.nii
├── 1f_12346/
│   └── 12346_grp1.nii
├── 2e_38744/
│   └── 38744_grp1.nii
├── 2f_38745/
│   └── 38745_grp1.nii
├── 3e_38836/
│   └── 38836_grp1.nii
└── 3f_38837/
    └── 38837_grp1.nii
Only the prefix matters for pairing, so names like 3e_38836 and 3f_38837 are valid because they begin with 3e and 3f respectively.

--------------
How to use it
Open Fiji or ImageJ.

Open the Script Editor and paste the macro.

Save it as an .ijm file.

Run the macro.

When prompted, select the parent folder that contains the 1e_*, 1f_*, 2e_*, 2f_*, 3e_*, and 3f_* subfolders.

Enter the desired contrast saturation value.

The macro scans available timepoints, performs the subtraction for each matched pair, and writes results into the corresponding Results_TimepointX folder.

Output behavior
The macro only creates a results folder when both matching subfolders exist and each subfolder contains a readable NIfTI file. If a timepoint is incomplete, it is skipped and a message is printed to the ImageJ log instead of stopping the entire run.

Example output layout:

text
ParentFolder/
├── 2e_38744/
├── 2f_38745/
└── Results_Timepoint2/
    └── 2e_MINUS_2f_38744_grp1_minus_38745_grp1.nii
Assumptions and caveats
The subtraction step assumes the paired NIfTI volumes are compatible in dimensions, slice count, and alignment, because ImageJ stack subtraction is intended for corresponding images or stacks.

The macro currently uses the first .nii or .nii.gz file found inside each matched subfolder. If a subfolder contains multiple NIfTI files, a stricter filename-matching rule may be needed to avoid selecting the wrong file.

The save step relies on the installed NIfTI plugin command run("NIfTI-1", "save=[...]"), so Fiji/ImageJ must have NIfTI input/output support available for the export step to work.

Possible next improvements
Potential refinements include:

Matching specific filenames instead of taking the first NIfTI in a subfolder.

Recursing through deeper directory trees if data are nested more than one level down.

Writing a CSV or log summary of processed and skipped pairs.

Supporting more than three timepoints by generalizing the prefix list.
