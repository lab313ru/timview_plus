----------------------------------------------
|TimView Plus - Universal PSX TIM/VRAM Viewer|
|Developer: [Lab 313]                        |
----------------------------------------------

Main Functions:
 - TIM and VRAM -files viewing;
 - Files scanner-ripper;
 - Correct converter TIM-files of any bit depth;
 - TIM into BMP export and CLUT;
 - View of TIM-files in bit mode, other than the original;
 - Command line support. See parameters below.

Differences from other similar programs:
 - The correct view of all possible TIM-files;
 - Support for some "special" TIM-files;
 - The correct conversion of BMP to TIM. Input bitmap is not limited with color palettes;
 - The small size of the program, and high-speed of work;
 - Quick scanner & ripper;
 - Program can be installed as the primary viewer of TIM-files;
 - Responsive technical support.

Some notes:
  - TIM-files viewing: If some of the viewed file is displayed incorrectly or not displayed at all, but You are sure that IT is a good TIM-file,
please report one of the authors of the program (see addresses below);

 - TIM-file scan-ripper: scanned file is placed completely in memory. Therefore, if the file is large - you will have to wait.
The program may stop responding to the keys and the mouse. Just wait. Some types of TIM-files can not be displayed in the scan results,
but these files can be viewed if you encounter such file outside the container file.
This is done to ensure that the scanner will not found bad TIM-files.

 - When installing TimView Plus as the primary viewer of TIM-files and then open the file in the program, each TIM will be opened in an existing window.

- Converter of BMP in TIM. Output TIM-file can be any bit depth (depends of the original TIM). Source BMP must be 32-bit.
The main difference from other converters is that the program takes the parameters for the new TIM from the original TIM-file.
To convert BMP in TIM you must to have original TIM and edited BMP. This program compares parameters of BMP and TIM.
There is instruction for right use:
1) Copy your TIM and BMP files in the same folder;
2) Name this two files with the same name like this:
 - imagename.tim;
 - imagename.bmp;
3) Now you can to click on menu item "Convert BMP to TIM..." and select BMP file.
4) If all is OK, program will create TIM with "imagename_new.tim" name in original BMP folder!

 - The command line has the following format:

timviewp.exe [timfile.tim | vramfile.bin] [options]

Possible options are (without quotes):
"-c" = saves Clut of TIM-file in the BMP. If Clut does not exists in this file, or file is wrong, nothing happens.
"-i" = saves image of Tim-file in BMP-format in all available palettes. If the file is wrong - nothing happens.
"-e" = effects such as previous two keys together.
"-s" = Scans file for TIMs. creates a directory "output", in which throws extracted files.
"-sb" = same as the previous paragraph, but it may search for bad TIM-files, because program will not check length of the image block.
"-bt" = converts BMP in TIM. If the first parameter is specified BMP file, the output file will be INPUT_FILENAME_new.tim,
where INPUT_FILENAME is input BMP's name;
"-tb" = TIM converter to BMP.

First of all, the program was created, as the saying goes, "for the needs of the team." But then the project grew into a viewer.
The next version of the program is planned to import BMP-files (really with correct way).

Authors of the program:
 - Dr. MefistO, AID_X.

Contacts are in the "About..." window of the program.

=================================

TimView Plus Version History:
0.5.2 RC2: 
 - Added scanner of BIN/CUE-images; 
 - Added replacement tool for TIM-files directly in the image (with the calculation of ECC/EDC); 
 - Rewrote the tools of export and import images for editing. There is no need to use an alpha channel; 
 - Fixed the use of default-palette; 
 - Fixed saving of images; 
 - Fixed -e key for command line; 
 - Fixed bugs with 16 and 24 bit TIM-file with the palette; 
 - Logs are now stored in the "Logs" folder in the program's directory;
 - Other minor fixes.
0.5.1 RC1:
  - Added the export key for BMP (BMPx) files for the command line: -tb;
  - Finally, make a normal output to the screen without flicks when resizing the form and scrolling;
  - Great increase of the speed of files scanning;
  - Added tool to replace TIMs in file containers;
  - Ability to save the scan log;
  - Fixed many issues from previous versions;
  - Other minor improvements.
0.5.0 test:
 - Added test support for import BMP (BMPx) in TIM of all bit depth (for command-line you can use switch -bt);
 - Now you can select any file for view and scan in Open Dialog. There is no bind specifically to TIM and BIN now;
 - Changed the function of BMP images exporting;
 - Removed functions to work with BIN-images;
 - Other minor fixes.
0.4.3 test:
 - Added experimental support for the import of BMP files in 16 and 24-bit TIMs. About how this works, see above;
 - Fixed bug where scan results not showing if scanned file has not BIN (TIM)-extension;
 - Other minor fixes.
0.4.2 test:
 - Fixed view of scan results in a different bit depth;
 - Added a warning about the possible existence of more than one Tim in opened file;
 - Saving and loading of program settings;
 - Save the bitmap image is once for all palettes (as the key -i);
 - Button "Generate default palette" is now available in other modes of bit depth;
 - Checking of program association with TIM-files;
 - Changes to shortcuts of main menu;
 - Minor fixes.
0.4 test:
 - Added ability to view files in a different bit depth, including VRAM;
 - Program works faster;
 - Now the list of files are not cleared when you open a new file, and adds an opened file on this list;
 - Scan results are displayed in the same list;
 - Each TIM, opened by double-clicking (if file associations is enabled) is now open in an existing window;
 - Added zooming;
 - Added a view with black transparency;
 - Simplified design of the program, all the basic options can be found on the main menu;
 - Fixed a bug that appears when user frequently switchs between two results of scanning;
 - Minor bug fixes.
0.3.1 test:
 - Ability to search for bad TIM-files moved to separate menu item. For the command line is the key-sb (instead of-s);
 - Fixed displaying of information in the table;
 - Fixed behavior of default palette;
 - Minor bug fixes.
0.3 test - first Public release. Test version. Published in order to get feedback, find bugs.
0.2 - the program is grows. Never Published.
0.1 - first version. Never Published.