----------------------------------------------
|TimView Plus - Universal PSX TIM Viewer     |
|Developer: [Lab 313]                        |
|Home page: http://lab313.ru                 |
----------------------------------------------

Main Functions:
 - TIM-files viewing;
 - Displaing and changing of CLUT;
 - Full support for transparency/translucency;
 - Fastest files scanner-ripper;
 - Correct converter TIM-files of any bit depth;
 - TIM into PNG export;
 - View of TIM-files in bit mode, other than the original.

Differences from other similar programs:
 - The correct view of all possible TIM-files;
 - Support for some "special" TIM-files;
 - The correct conversion of BMP to TIM. Input bitmap is not limited with color palettes;
 - The small size of the program, and high-speed of work;
 - Program can be installed as the primary viewer of TIM-files;
 - Responsive technical support.

Some notes:
  - TIM-files viewing: If some of the viewed file is displayed incorrectly or not displayed at all, but You are sure that IT is a good TIM-file, please report one of the authors of the program (see addresses below);

 - Changing CLUT: double-clicking at tab [CLUT] on the selected cell opens color selection dialog. The selected color will replace the existing one;

 - Viewing of 4-bit TIM-files with the selected "CLUT row": simply click on the appropriate line on the [CLUT] tab;

 - TIM-file scan-ripper: scanned file is placed completely in memory. Therefore, if the file is large - you will have to wait. The program may stop responding to the keys and the mouse. Just wait. Some types of TIM-files can not be displayed in the scan results, but these files can be viewed if you encounter such file outside the container file. This is done to ensure that the scanner will not found bad TIM-files.

 - When installing TimView Plus as the primary viewer of TIM-files and then open the file in the program, each TIM will be opened in an existing window.

 - Converter of BMP in TIM. Output TIM-file can be any bit depth (depends of the original TIM). Source BMP must be 32-bit. The main difference from other converters is that the program takes the parameters for the new TIM from the original TIM-file. To convert BMP in TIM you must to have original TIM and edited BMP. This program compares parameters of BMP and TIM. There is instruction for right use:
1) Copy your TIM and BMP files in the same folder;
2) Name this two files with the same name like this:
 - imagename.tim;
 - imagename.bmp;
3) Now you can to click on menu item "Convert BMP to TIM..." and select BMP file.
4) If all is OK, program will create TIM with "imagename_new.tim" name in original BMP folder!

First of all, the program was created, as the saying goes, "for the needs of the team." But then the project grew into a viewer. The next version of the program is planned to import BMP-files (really with correct way).

Authors of the program:
 - Dr. MefistO, AID_X.

Contacts are in the "About..." window of the program.

=================================

TimView Plus Version History:
0.6.1 beta:
  - Images again! The old features with new speed;
  - Added ability to not use a random palette if there is internal when viewing a file on non-original bit depth;
  - Save images for view is now in PNG;
  - Added skipping of audio- and video- streams in the image-files;
  - Removed saving CLUT in BMP as unnecessary;
  - Files not extracted during scanning - fixed!
  - A slight acceleration of the image drawing;
  - Fixed possible crashes of the program;
  - Fixed other bugs.
0.6 beta:
  - Added support for version = 01 for TIM-files;
  - Optimized work with TIM-files;
  - Totally Increased scanning speed;
  - It was decided to refuse work with image-files. If you really need to scan them. use version 0.5.8.1 Final;
  - In the list of files added column to display the image width and height;
  - Fixed bugs and errors.
0.5.8.1 Final:
 - Added additional conditions for bad TIM-files;
 - Save images in all palettes at once made as separate menu item;
 - Now the program is open-sourced. Development of the project is not terminated.
0.5.8 Final:
 - Now the mode of view you can select in the drop-down list, or by menu items or keyboard shortcuts;
 - Removed most of the command line options;
 - Changed the hotkey for transparency (conflict with other keys);
 - Saving of BMP-images (not for edit) is now performed only for the current palette
   with saving at "images" folder of directory with the program;
 - Fixed output of translucency;
 - Small cosmetic changes to the program window;
 - Fixed bug when dragging files to the program window;
 - Fixed other bugs.
0.5.7 Final:
 - Added ability to select "line" of palette (set of each 16 cells of color) for a 4-bit TIM-files;
 - Ability to disable creating of FSR-files;
 - Ability to translate the program to other languages using resource editors;
 - When you export BMP, edit files now stores in the folder "for_edit" of program's directory;
 - Fixed checkbox "Random" on Windows XP;
 - Fixed opening of files of 0 bytes;
 - Fixed some bugs found in previous versions;
 - Fixed images determination;
 - Removed viewing of videomemory (lack of functionality in compare with specialized prog22:20 14.10.2011rams).
0.5.6 Final:
 - Simplified main menu;
 - Simplified design of the program;
 - Fixed ability to display of bad-tims;
 - Added ability to drag-n-drop folders;
 - Now you can drop more than one file at a time into main window;
 - All files dragged into main window and opened by main menu will be scanned by default;
 - Now program displays the position of Tim in the file;
 - Now program shows path to the current file in the status bar;
 - Ability to run program from the disk. In this case work directory is the folder "TimViewPlus"
   in the folder "My Documents" of the current user. This path you can always look in the "About" window;
 - Viewing of the VRAM now in a separate menu item;
 - In mode "Scan Folder" with checked menu item "Search and View Bad TIMs" they are also displayed;
 - If you need to save only data of bin/cue-image in a separate file, now was added the keyboard shortcut Shift + Ctrl + D.
   It will need to click once before scanning. To disable you must to use the same keys.
   This file will be saved in a folder "dump" of program-directory;
 - Changed format of the FSR-files. Fixed loading of this format when rescanning;
 - Other minor fixes.
0.5.5 beta:
 - Saving the scan results (automatically). Instead of re-scanning, you can load results;
 - Fixed changing and saving colors in CLUT;
 - Fixed minor bugs.
0.5.4 beta:
 - Added ability to view and modify (by double clicking) CLUT directly in the program;
 - Displaing sell color at cursor;
 - Now when you replace the TIM-s program can create backup of the replaced file (optional);
 - Other minor improvements.
0.5.3 PreFinal:
 - Full support for transparency/translucency for TIM-view/import/export;
 - Directories scanner;
 - The scan log now appends to the existing file, if the selected file previously scanned;
 - Displaing of the loading file in memory for Scan process;
 - Added zoom mode x3.5 and x4.0;
 - Minor bug fixes.
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