{{ KOL MCK }// Do not remove this line!
{$DEFINE KOL_MCK}
unit uMain;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, KOL{$IF Defined(KOL_MCK)}{$ELSE}, mirror, Classes,
  Controls, mckCtrls, mckObjs, Graphics,
{$IFEND (place your units here->)}, err, KOLAdd, pngimage, ecc, edc, crc32,
  KOLDirDlgEx;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;
{$ENDIF}

type
  Header = packed record //TIM Header (8 bytes)
    Sign: byte; //$10 (1 byte)
    Version: Byte; //Any? (1 byte)
    Reserved1: byte; //Reserved byte 1 (1 byte)
    Reserved2: byte; //Reserved byte 2 (1 byte)
    Bpp: Byte; //Bit per Pixel  (1 byte)
    //variants:
    //[$08, $09, $0A, $0B, $02, $03, $00, $01]
    Reserved3: Byte; //Reserved byte 3 (1 byte)
    Reserved4: Byte; //Reserved byte 4 (1 byte)
    Reserved5: Byte; //Reserved byte 5 (1 byte)
  end;
type
  PalInfo = packed record //CLUT header (12+ bytes)
    ClutLen: cardinal; //Length of CLUT (4 bytes)
    PalX: word; //Palette coordinates in VRAM (by X) (2 bytes)
    PalY: word; //Palette coordinates in VRAM (by Y) (2 bytes)
    ClutColors: word; //Number of CLUT Colors (2 bytes)
    ClutNum: word; //Count of Palettes (2 bytes)
  end;
type
  ImgInfo = packed record //IMAGE Block Header (12+ bytes)
    ImgLen: cardinal; //Length of Image Block (4 bytes)
    ImgX: word; //Image Block Coordinates in VRAM (by X) (2 bytes)
    ImgY: word; //Image Block Coordinates in VRAM (by Y) (2 bytes)
    ImgWidth: word; //Image Width (not Real) (2 bytes)
    ImgHeight: word; //Image Height (Real) (2 bytes)
  end;

type
  Two4bits = record //Inner type for two parts of 1 Byte
    fhalf: byte; //First Half
    shalf: byte; //Second Half
  end;

type
  TReadType = (rtHead, rtPal, rtImage, rtOther);

type
  TccMode = (ccPlus, ccMinus);

type
  TSector = packed record //One Image Sector Type (2352 bytes)
    info1: array[1..24] of byte; //Info block (24 bytes)
    Data: array[1..2048] of byte; //Main data of sector (2048 bytes)
    eccedc: array[1..280] of byte; //ECCEDC block (28 bytes)
  end;

const //Sector constants
  info1 = 24;
  sectdata = 2048;
  eccedc = 280;
  Sector = info1 + eccedc + sectdata; //Size of Sector

const
  sTooBig = 'This image is very big (more then 746,9 MB)!' +
      #13#10 + 'Your Windows may not open this file.' + #13#10 +
      'Do you still want to open it?';
  sConfirmation = 'Confirmation';
  sTimExt = '.tim';
  sExtracted = 'extracted';
  sForEdit = 'for_edit';
  sResults = 'results';
  sPalettes = 'palettes';
  cMaxSize = 783216000;

type
{$IF Defined(KOL_MCK)}
{$I MCKfakeClasses.inc}
{$IFDEF KOLCLASSES}{$I TfrmMainclass.inc}{$ELSE OBJECTS}PfrmMain = ^TfrmMain;
{$ENDIF CLASSES/OBJECTS}
{$IFDEF KOLCLASSES}{$I TfrmMain.inc}{$ELSE}TfrmMain = object(TObj){$ENDIF}
    Form: PControl;
{$ELSE not_KOL_MCK}
  TfrmMain = class(TForm)
{$IFEND KOL_MCK}
    KOLproj: TKOLProject;
    frmKOL1: TKOLForm;
    lvInfo: TKOLListView;
    sbImage: TKOLScrollBox;
    pbImage: TKOLPaintBox;
    mmMain: TKOLMainMenu;
    dlgOpen: TKOLOpenSaveDialog;
    tcPages: TKOLTabControl;
    tpMain: TKOLTabPage;
    tpImage: TKOLTabPage;
    pnlList: TKOLPanel;
    lvListG: TKOLListView;
    pbScan: TKOLProgressBar;
    pnlScan: TKOLPanel;
    pnlCount: TKOLPanel;
    dlgOpenBMP: TKOLOpenSaveDialog;
    dlgOpenDir: TKOLOpenDirDialog;
    tpClut: TKOLTabPage;
    pbClut: TKOLPaintBox;
    dlgcColor: TKOLColorDialog;
    pnlRGBClut: TKOLPanel;
    pnlClut: TKOLPanel;
    btnStop: TKOLButton;
    pnlButtons: TKOLPanel;
    lblPos: TKOLLabel;
    pnlTools: TKOLPanel;
    lblZoom: TKOLLabel;
    cbbZoom: TKOLComboBox;
    lblIndex: TKOLLabel;
    cbbPalette: TKOLComboBox;
    lblBitDepth: TKOLLabel;
    cbbMode: TKOLComboBox;
    lblFiles: TKOLLabel;
    chkTransparency: TKOLCheckBox;
    tcGB: TKOLTabControl;
    tpGood: TKOLTabPage;
    tpBad: TKOLTabPage;
    lvListB: TKOLListView;
    pnlEdit: TKOLPanel;
    lblValue: TKOLLabel;
    edtValue: TKOLEditBox;
    btnSaveEdit: TKOLButton;
    pnlRandom: TKOLPanel;
    pnlZoom: TKOLPanel;
    edtListFilter: TKOLEditBox;
    pnlFilter: TKOLPanel;
    lblListFilter: TKOLLabel;
    ppList: TKOLPopupMenu;
    btnGenPal: TKOLButton;
    chkRandom: TKOLCheckBox;
    cbbRandPalNum: TKOLComboBox;
    btnSaveAsRandom: TKOLButton;
    pnlOffset: TKOLPanel;
    lblPalOffset: TKOLLabel;
    edtOffset: TKOLEditBox;
    btnMinus: TKOLButton;
    btnPlus: TKOLButton;
    procedure cbbPaletteChange(Sender: PObj);
    procedure mmMainmnExitMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmnCloseMenu(Sender: PMenu; Item: Integer);
    procedure frmKOL1DropFiles(Sender: PControl;
      const FileList: KOL_String; const Pt: TPoint);
    procedure frmKOL1Close(Sender: PObj; var Accept: Boolean);
    procedure mmMainmmScanRAWMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmnSaveImageMenu(Sender: PMenu; Item: Integer);
    procedure pbImagePaint(Sender: PControl; DC: HDC);
    procedure frmKOL1FormCreate(Sender: PObj);
    procedure btnGenPalClick(Sender: PObj);
    procedure btnStopClick(Sender: PObj);
    procedure lvListGKeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure mmMainmmAssocMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmmAboutMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmnSaveTIMMenu(Sender: PMenu; Item: Integer);
    procedure frmKOL1Show(Sender: PObj);
    procedure mmMainmnBMP2TIMMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmnCheckAssocMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmnBMPextractMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmnInsertAtPosMenu(Sender: PMenu; Item: Integer);
    procedure mnScanFolderMenu(Sender: PMenu; Item: Integer);
    procedure pbClutPaint(Sender: PControl; DC: HDC);
    procedure pbClutMouseDblClk(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure pbClutMouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure mmMainmnCreateBakMenu(Sender: PMenu; Item: Integer);
    procedure chkRandomClick(Sender: PObj);
    procedure pbClutMouseUp(Sender: PControl; var Mouse: TMouseEventData);
    procedure tpImageClick(Sender: PObj);
    procedure cbbModeChange(Sender: PObj);
    procedure mmMainmnForumMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmnSaveAllPalsMenu(Sender: PMenu; Item: Integer);
    function thScanThread(Sender: PThread): Integer;
    procedure lvListGColumnClick(Sender: PControl; Idx: Integer);
    function lvListCompareWH(Sender: PControl; Idx1,
      Idx2: Integer): Integer;
    function lvListSortBG(Sender: PControl; Idx1,
      Idx2: Integer): Integer;
    procedure cbbZoomChange(Sender: PObj);
    procedure chkTransparencyClick(Sender: PObj);
    procedure mmMainmnAutoExtractMenu(Sender: PMenu; Item: Integer);
    procedure tcGBClick(Sender: PObj);
    procedure lvListBClick(Sender: PObj);
    procedure lvInfoClick(Sender: PObj);
    procedure btnSaveEditClick(Sender: PObj);
    procedure lvListGClick(Sender: PObj);
    procedure mmMainmnChangeBackMenu(Sender: PMenu; Item: Integer);
    procedure lvInfoKeyUp(Sender: PControl; var Key: Integer;
              Shift: Cardinal);
    procedure edtListFilterChange(Sender: PObj);
    procedure mmMainmnClearFSRsMenu(Sender: PMenu; Item: Integer);
    procedure mmMainmnSaveAllImagesMenu(Sender: PMenu; Item: Integer);
    procedure btnMinusClick(Sender: PObj);
    procedure btnPlusClick(Sender: PObj);
    procedure edtOffsetKeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure edtOffsetKeyChar(Sender: PControl; var Key: KOLChar;
      Shift: Cardinal);
    procedure frmKOL1BeforeCreateWindow(Sender: PObj);
    procedure frmKOL1KeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure btnSaveAsRandomClick(Sender: PObj);
    procedure cbbRandPalNumChange(Sender: PObj);
  private
    head: Header; //For inner use (Header)
    pal: PalInfo; //For inner use (CLUT)
    img: ImgInfo; //For inner use (Image)
    ClutMas: array of array of cardinal; //Array of CLUT colors
    clutdat: array of word; //Array of CLUT bytes
    imgdat_4_8_16: array of word; //Array for Image bytes (4, 8, 16 bit)
    imgdat_24: array of cardinal; //Array for Image bytes (24 bit)
    bpp: byte; //For real equivalent of head.bpp
    cls: Boolean; //For ability to show image
    bmpImage: PBitmap; //Stores image of TIM
    pngImage: TPNGObject;
    stop: Boolean; //Exit variable (for scan interruption)
    imgRealWidth: word; //For Real Image Width
    FilePosesG: array of cardinal; //Array of TIM's positions in file
    FilePosesB: array of cardinal; //Array of TIM's positions in file
    FileNamesG: PStrList; //Stores names of TIM's
    FileNamesB: PStrList; //Stores names of TIM's
    ZoomValue: byte; //For zooming
    FastPaint: boolean; //Uses when rereading of TIM isn't needed
    ListForScan: PStrList; //List for multi-files mode
    ClutBMP: PBitmap; //Image for CLUT-tab
    MainPath: string; //Stores Main EXE path
    CurNum: cardinal;
    CurGBPage: Byte;
    ToChange: Byte;
    function InvertDWord(ImageScan: Boolean; Size: Cardinal; Start: PByte;
      var data: PByte): cardinal;
    function InvertWord(ImageScan: Boolean; Size: Cardinal; Start: PByte;
      var Data: PByte): word;
    function InvertThree(ImageScan: Boolean; Size: Cardinal; Start: PByte;
      var Data: PByte): cardinal;
    procedure ReadFromMem(ImageScan: Boolean; Size: cardinal;
      ReadType: TReadType; StartPos: PByte; var Data: PByte);
    procedure GetFilesList(const Folder: string; sList: PStrList);
    function ByteFrom4bits(bt1, bt2: byte): Byte;
    procedure AssocTim;
    function ColorTo2Bytes(Color: cardinal): word;
    function ColorTo3Bytes(Color: cardinal): cardinal;
    function AssociatedTIM: Boolean;
    procedure Config(Write: boolean);
    procedure ClearAll;
    procedure AfterScan;
    procedure HeadBpp2Bpp;
    procedure ReadBpp;
    function TwoBytesToColor(A: word): cardinal;
    function ThreeBytesToColor(A: cardinal): cardinal;
    function OneByte2Bits(A: byte): Two4bits;
    procedure PaintClut(Show: Boolean; FastClut: boolean);
    procedure PaintImage(Show: boolean = true);
    function ReadTIM(const FileName: string; Pos: integer; FlSize:
      cardinal; SkipHead: Boolean = false): boolean;
    function ReplaceInImage(const FileName: string): boolean;
    function ConvertBMP2Tim(const BMP: string): Boolean;
    procedure ConvertTIM2BMP(const SourceFile: string);
    procedure CopyTIM(const NewTim: string; Pos, Size: cardinal; CurPage: byte);
    function GetImageScan(const FileName: string): Boolean;
    procedure CheckCurrentPos(ImageScan: Boolean;
      Start: PByte; var Data: PByte; Mode: TccMode;
      Reading: boolean = false);
    function thPngSaving(Sender: PThread): Integer;
    function bin2bcd(P: Integer): Byte;
    procedure BuildAdress(LBA: Integer; var Dest);
    function DirCount(List: PStrList): cardinal;
  public

  end;

var
  frmMain{$IFDEF KOL_MCK}: PfrmMain{$ELSE}: TfrmMain{$ENDIF};

type
  OnNoOne = object(TObj)
    procedure GG(const cmd: string);
  end;

{$IFDEF KOL_MCK}
procedure NewfrmMain(var Result: PfrmMain; AParent: PControl);
{$ENDIF}

implementation

{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}

{$IFDEF KOL_MCK}
{$I uMain_1.inc}
{$ENDIF}

{$R Manifest.res}

procedure TfrmMain.CheckCurrentPos(ImageScan: Boolean; Start: PByte;
  var Data: PByte; Mode: TccMode; Reading: boolean = false);
begin
  if (not ImageScan) or Reading then Exit;

  if (Cardinal(data) - cardinal(Start)) = 0 then
    if Mode = ccPlus then
    begin
      Inc(Data, info1);
      Exit;
    end;

  if Mode = ccPlus then
    if (((Cardinal(data) - cardinal(Start)) + 280) mod sector) = 0 then
    begin
      Inc(Data, info1 + eccedc);
      exit;
    end;
  if Mode = ccMinus then
    if (((Cardinal(data) - cardinal(Start)) + 2328) mod sector) = 0 then
      Dec(Data, info1 + eccedc);
end;

//For ImageScan variable (checks for Image)

function TfrmMain.GetImageScan(const FileName: string): Boolean;
const
  ImgSign: array[0..2] of cardinal = ($FFFFFF00, $FFFFFFFF, $00FFFFFF);
var
  Sz: cardinal;
  pFile, pStart: PDWORD;
  hFile, hMap: THandle;
  i: Byte;
begin
  try
    result := false;
    Sz := FileSize(FileName);
    pFile := MapFileRead(FileName, hFile, hMap);
    if pFile = nil then Exit;
    pStart := pFile;

    for i := 0 to 2 do
    begin
      if pFile^ = ImgSign[i] then
      begin
        Inc(pFile);
        continue;
      end
      else
      begin
        UnmapFile(pStart, hFile, hMap);
        pStart := nil;
        hFile := 0;
        hMap := 0;
        exit;
      end;
    end;

    result := ((Sz mod Sector) = 0) and (Sz <> 0);
    UnmapFile(pStart, hFile, hMap);
    pStart := nil;
    hFile := 0;
    hMap := 0;
  except
    UnmapFile(pStart, hFile, hMap);
    pStart := nil;
    hFile := 0;
    hMap := 0;
    result := false;
  end;
end;

function TfrmMain.InvertDWord(ImageScan: Boolean; Size: Cardinal; Start: PByte;
  var data: PByte): cardinal;
var
  i, b: Byte;
begin
  try
    result := 0;
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);

    for i := 0 to 3 do
    begin
      if (Cardinal(data) - Cardinal(start)) < Size then
        b := data^
      else
      begin
        result := 0;
        Exit;
      end;
      result := result + (b shl (8 * (3 - i)));
      CheckCurrentPos(ImageScan, Start, data, ccMinus);
      if i < 3 then Dec(data);
    end;
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
  except
    result := 0;
  end;
end;

function TfrmMain.InvertWord(ImageScan: Boolean; Size: Cardinal; Start: PByte;
  var Data: PByte): word;
var
  i, b: Byte;
begin
  try
    result := 0;
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);

    for i := 0 to 1 do
    begin
      if (Cardinal(data) - Cardinal(start)) < Size then
        b := data^
      else
      begin
        result := 0;
        Exit;
      end;
      result := result + (b shl (8 * (1 - i)));
      CheckCurrentPos(ImageScan, Start, data, ccMinus);
      if i < 1 then Dec(data);
    end;
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
  except
    result := 0;
  end;
end;

function TfrmMain.InvertThree(ImageScan: Boolean; Size: Cardinal; Start: PByte;
  var Data: PByte): cardinal;
var
  i, b: Byte;
begin
  try
    result := 0;
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);

    for i := 0 to 2 do
    begin
      if (Cardinal(data) - Cardinal(start)) < Size then
        b := data^
      else
      begin
        result := 0;
        Exit;
      end;
      result := result + (b shl (8 * (2 - i)));
      CheckCurrentPos(ImageScan, Start, data, ccMinus);
      if i < 2 then Dec(data);
    end;
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
    Inc(data);
    CheckCurrentPos(ImageScan, Start, data, ccPlus);
  except
    result := 0;
  end;
end;

procedure TfrmMain.ReadFromMem(ImageScan: Boolean; Size: cardinal;
  ReadType: TReadType; StartPos: PByte; var Data: PByte);
begin
  if ReadType = rtHead then
  begin
    try
      CheckCurrentPos(ImageScan, StartPos, Data, ccPlus);
      if (Cardinal(data) - Cardinal(StartPos)) < Size then
        head.Sign := Data^
      else
        Exit;

      Inc(data);
      CheckCurrentPos(ImageScan, StartPos, Data, ccPlus);
      if (Cardinal(data) - Cardinal(StartPos)) < Size then
        head.Version := data^
      else
        Exit;

      Inc(data);
      CheckCurrentPos(ImageScan, StartPos, Data, ccPlus);
      if (Cardinal(data) - Cardinal(StartPos)) < Size then
        head.Reserved1 := data^
      else
        Exit;

      Inc(data);
      CheckCurrentPos(ImageScan, StartPos, Data, ccPlus);
      if (Cardinal(data) - Cardinal(StartPos)) < Size then
        head.Reserved2 := data^
      else
        Exit;

      Inc(data);
      CheckCurrentPos(ImageScan, StartPos, Data, ccPlus);
      if (Cardinal(data) - Cardinal(StartPos)) < Size then
        head.Bpp := data^
      else
        Exit;

      Inc(data);
      CheckCurrentPos(ImageScan, StartPos, Data, ccPlus);
      if (Cardinal(data) - Cardinal(StartPos)) < Size then
        head.Reserved3 := data^
      else
        Exit;

      Inc(data);
      CheckCurrentPos(ImageScan, StartPos, Data, ccPlus);
      if (Cardinal(data) - Cardinal(StartPos)) < Size then
        head.Reserved4 := data^
      else
        Exit;

      Inc(data);
      CheckCurrentPos(ImageScan, StartPos, Data, ccPlus);
      if (Cardinal(data) - Cardinal(StartPos)) < Size then
        head.Reserved5 := data^
      else
        Exit;

      Inc(data);
      Exit;
    except
      Exit;
    end;
  end;
  if ReadType = rtPal then
  begin
    pal.ClutLen := InvertDWord(ImageScan, Size, StartPos, Data);
    pal.PalX := InvertWord(ImageScan, Size, StartPos, Data);
    pal.PalY := InvertWord(ImageScan, Size, StartPos, Data);
    pal.ClutColors := InvertWord(ImageScan, Size, StartPos, Data);
    pal.ClutNum := InvertWord(ImageScan, Size, StartPos, Data);
    Exit;
  end;

  if ReadType = rtImage then
  begin
    img.ImgLen := InvertDWord(ImageScan, Size, StartPos, Data);
    img.ImgX := InvertWord(ImageScan, Size, StartPos, Data);
    img.ImgY := InvertWord(ImageScan, Size, StartPos, Data);
    img.ImgWidth := InvertWord(ImageScan, Size, StartPos, Data);
    img.ImgHeight := InvertWord(ImageScan, Size, StartPos, Data);
  end;
end;

//Returns Files list in Folder
function TfrmMain.DirCount(List: PStrList): cardinal;
var
  i: cardinal;
begin
  result := 0;
   for i := 1 to List.Count do
    if DirectoryExists(list.Items[i - 1]) then
      Inc(result);
end;

procedure TfrmMain.GetFilesList(const Folder: string; sList: PStrList);
var
  tmp: PDirList;
  i: integer;
begin
  tmp := NewDirList(Folder, '*', 0);
  tmp.Sort([sdrFoldersFirst]);
  sList.Text := tmp.FileList(#13#10, true, True);
  lblPos.Caption := 'Getting Filelist...';
  i := 0;

  while DirCount(sList) > 0 do
  begin
    if DirectoryExists(sList.Items[i]) then
    begin
      tmp.ScanDirectory(sList.Items[i], '*', 0);
      tmp.Sort([sdrFoldersFirst]);
      sList.Delete(i);
      sList.Text := sList.Text + tmp.FileList(#13#10, true, True);
      tmp.Sort([sdrFoldersFirst]);
    end
    else
      Inc(i);
    Form.ProcessPendingMessages;
  end;

  lblPos.Caption := '0000000000';
  Free_And_Nil(tmp);
 // tmp.Free;
end;

//Converts two 4bytes parts to one byte

function TfrmMain.ByteFrom4bits(bt1, bt2: byte): Byte;
begin
  result := ((bt2 and $F) shl 4) or (bt1 and $F);
end;

//Converts Delphi's Color to TIM's two bytes (CLUT)

function TfrmMain.ColorTo2Bytes(Color: cardinal): word;
var
  t, r, g, b, r1: byte;
  g1, b1, t1: word;
begin
  t := GetRValue(color) - (GetRValue(color) div 8) * 8;

  r := GetRValue(color) div 8;
  g := GetGValue(color) div 8;
  b := GetBValue(color) div 8;

  r1 := r;
  g1 := g shl 5;
  b1 := b shl 10;
  t1 := t shl 15;

  result := t1 + r1 + g1 + b1;
end;

//Converts Delphi's Color to TIM's three bytes (Image)

function TfrmMain.ColorTo3Bytes(Color: cardinal): cardinal;
var
  r, g, b: Byte;
begin
  r := GetRValue(color);
  g := GetGValue(color);
  b := GetBValue(color);

  result := RGB(r, g, b);
end;

//CheckForAssociation function

function TfrmMain.AssociatedTIM: Boolean;
var
  Reg: HKEY;
  a, b, c: Boolean;
begin
  Reg := RegKeyOpenRead(HKEY_CURRENT_USER, 'Software\Classes\.tim');
  a := RegKeyExists(Reg, '');
  RegKeyClose(reg);
  Reg := RegKeyOpenRead(HKEY_CURRENT_USER, 'Software\Classes\TimFile');
  b := RegKeyExists(Reg, '');
  RegKeyClose(reg);
  Reg := RegKeyOpenCreate(HKEY_CURRENT_USER,
    'Software\Classes\TimFile\shell\Open\Command');
  c := (RegKeyGetStr(Reg, '') = ('"' + ExePath + '" "%1"'));
  RegKeyClose(reg);
  result := (a and b and c);
end;

//Association function

procedure TfrmMain.AssocTim;
var
  Reg: HKEY;
begin
  Reg := RegKeyOpenCreate(HKEY_CURRENT_USER, 'Software\Classes\.tim');
  RegKeySetStr(Reg, '', 'TimFile');
  RegKeyClose(reg);
  Reg := RegKeyOpenCreate(HKEY_CURRENT_USER, 'Software\Classes\TimFile');
  RegKeySetStr(Reg, '', 'Tim File Format');
  Reg := RegKeyOpenCreate(Reg, 'DefaultIcon');
  RegKeySetStr(Reg, '', '"' + MainPath + '",0');
  RegKeyClose(reg);
  Reg := RegKeyOpenCreate(HKEY_CURRENT_USER,
    'Software\Classes\TimFile\shell\Open\Command');
  RegKeySetStr(Reg, '', '"' + ParamStr(0) + '" "%1"');
  RegKeyClose(reg);
end;

//Read/Write Config

procedure TfrmMain.Config(Write: boolean);
var
  ini: PIniFile;
  i: integer;
begin
  ini := OpenIniFile(ChangeFileExt(MainPath, '.ini'));
  if Write then
    ini.Mode := ifmWrite
  else
    ini.Mode := ifmRead;
  ini.Section := 'Main';

  if Write then
  begin
    ini.ValueBoolean('BlackTransp', chkTransparency.Checked);
    ini.ValueBoolean('ExtractTims',
      mmMain.Items[mnAutoExtract].Checked);
    ini.ValueBoolean('CheckAssoc',
      mmMain.Items[mnCheckAssoc].Checked);
    ini.ValueBoolean('CreateBak',
      mmMain.Items[mnCreateBak].Checked);
    ini.ValueInteger('BackColor', sbImage.Color);
    ini.ValueInteger('RandomCells', cbbRandPalNum.Count);

  end
  else
  begin
    chkTransparency.Checked := ini.ValueBoolean('BlackTransp', false);
    mmMain.Items[mnAutoExtract].Checked :=
      ini.ValueBoolean('ExtractTims', false);
    mmMain.Items[mnCheckAssoc].Checked :=
      ini.ValueBoolean('CheckAssoc', true);
    mmMain.Items[mnCreateBak].Checked :=
      ini.ValueBoolean('CreateBak', true);
    sbImage.Color := ini.ValueInteger('BackColor', clBtnFace);
    cbbZoom.CurIndex := ini.ValueInteger('ZoomState', 8) - 1;
    cbbZoomChange(@self);
    i := ini.ValueInteger('RandomCells', 16);
    cbbRandPalNum.Clear;

    if i = 0 then
    i := 1;

    while i > 0 do
    begin
    cbbRandPalNum.Add(Int2Digs(i, 2));
    Dec(i);
    end;
    cbbRandPalNum.CurIndex := 0;

    if (mmMain.Items[mnCheckAssoc].Checked) and
      (not AssociatedTIM) then
    begin
      BringWindowToTop(form.Handle);
      if MessageBox(Form.Handle,
        'TIM associations was changed by other program.' +
        #13#10 + 'Do you want to associate TimView with *.TIM files?',
        'Information',
        MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES then
        AssocTim;
    end;

  end;
  Free_And_Nil(ini);
  //ini.free;
end;

//Clearing all Global Variables

procedure TfrmMain.ClearAll;
begin
  FillChar(pal, SizeOf(pal), 0);
  FillChar(img, SizeOf(img), 0);
  FillChar(head, SizeOf(head), 0);
  ImgRealWidth := 0;
  bpp := 0;
  try
    setlength(ClutMas, 0, 0);
    setlength(clutdat, 0);
    setlength(imgdat_4_8_16, 0);
    setlength(imgdat_24, 0);
    Free_And_Nil(bmpImage);
    Free_And_Nil(ClutBMP);
    Free_And_Nil(pngImage);
  except
    //
  end;
end;

//Operations after scan

procedure TfrmMain.AfterScan;
var
  list: PControl;
begin
  ClearAll;
  pbScan.Progress := 0;
  lvListG.Enabled := true;
  lvListB.Enabled := true;

  btnStop.Enabled := false;
  lblFiles.Caption := Format('%d (G)/%d (B)',
  [lvListG.LVCount, lvListB.LVCount]);

  lblPos.Caption := '0000000000';
  mmMain.Items[mnFile].Enabled := true;
  mmMain.Items[mnClose].Enabled := true;
  ListForScan.clear;

  if CurGBPage = 0 then
    list := lvListG
  else
    list := lvListB;

  if (lvListG.LVCount = 0) and (lvListB.LVCount = 0) then
    mmMainmnCloseMenu(mmMain, mnClose)
  else
  begin
    if list.LVCount <= list.LVPerPage then
      list.LVCurItem := list.count - 1;
    //else
    //  list.LVCurItem := 0;
    list.LVMakeVisible(list.LVCurItem, true);
    lvListGClick(@self);
  end;
end;

//Converts Head.bpp to Global Bpp

procedure TfrmMain.HeadBpp2Bpp;
begin
  case head.Bpp of
    $00: bpp := 41;
    $08: bpp := 4;
    $01: bpp := 81;
    $09: bpp := 8;
    $02: bpp := 16;
    $0A: bpp := 161;
    $03: bpp := 24;
    $0B: bpp := 241;
    $04: bpp := 48;
    $0C: bpp := 64;
  end;
end;

//Rereading head.BPP

procedure TfrmMain.ReadBpp;
var
  tmp: PStream;
begin
  try
    if CurGBPage = 0 then
    begin
      tmp := NewReadFileStream(FileNamesG.Items[CurNum]);
      tmp.Seek(FilePosesG[CurNum] + 4, spBegin);
    end
    else
    begin
      tmp := NewReadFileStream(FileNamesB.Items[CurNum]);
      tmp.Seek(FilePosesB[CurNum] + 4, spBegin)
    end;
    tmp.Read(head.bpp, 1);
    Free_And_Nil(tmp);
   // tmp.free;
  except
    Free_And_Nil(tmp);
    //tmp.free;
  end;
end;

//Converts TIM's two bytes (15bpp) to Delphi's Color

function TfrmMain.TwoBytesToColor(A: word): cardinal;
var
  t, b, g, r: byte;
begin
  r := GetBits(a, 0, 4) * 8;
  g := GetBits(a, 5, 9) * 8;
  b := GetBits(a, 10, 14) * 8;

  t := GetBits(a, 15, 15);
  r := r + t;

  result := RGB(r, g, b);
end;

//Converts TIM's three bytes to Delphi's Color

function TfrmMain.ThreeBytesToColor(A: cardinal): cardinal;
var
  b, g, r: byte;
begin
  r := GetBits(a, 0, 7);
  g := GetBits(a, 8, 15);
  b := GetBits(a, 16, 23);
  result := RGB(r, g, b);
end;

//Divides One byte to two 4bits parts

function TfrmMain.OneByte2Bits(A: byte): Two4bits;
begin
  result.fhalf := GetBits(a, 0, 3);
  result.shalf := GetBits(a, 4, 7);
end;

//Reading and Painting CLUT

procedure TfrmMain.PaintClut(Show: Boolean; FastClut: boolean);
var
  x, y, z: cardinal;
  wd, hg: word;
  bmp, bmpc: PBitmap;
begin
  try
    if ((lvListG.Count = 0) and (CurGBPage = 0)) or
      (lvListB.Count = 0) and (CurGBPage = 1) then
      Exit;

    if Head.Bpp in [$04, $0C] then
      Exit;

    if bpp in [4, 8, 41, 81, 161, 241] then
    begin

      z := 0;
      if not fastclut then
      begin
        case bpp of
          4, 8:
            begin
              wd := pal.ClutColors;
              hg := pal.ClutNum;
              SetLength(Clutmas, hg, wd);

              for x := 1 to hg do
                for y := 1 to wd do
                begin
                  Clutmas[x - 1, y - 1] :=
                  cardinal(TwoBytesToColor(clutdat[z]));
                  Inc(z);
                end;
              {chkRandom.Enabled := true;
              btnGenPal.Enabled := true;
              btnSaveAsRandom.Enabled := true;    }
            end;
          41, 81:
            begin
              bmp := NewDIBBitmap(0, 0, pf24bit);

              CreateDirectory(PAnsiChar(ExtractFilePath(MainPath) +
                sPalettes), nil);

              if tcPages.TC_Items[2] = 'CLUT' then
              begin
              if not FileExists(ExtractFilePath(MainPath) + sPalettes + '\' +
                Int2Digs(cbbRandPalNum.CurIndex + 1, 2) + '.bmp') then
                btnGenPalClick(@self);

              bmp.LoadFromFile(ExtractFilePath(MainPath) + sPalettes + '\' +
                Int2Digs(cbbRandPalNum.CurIndex + 1, 2) + '.bmp');
              end
              else
              bmp.LoadFromFile(ExtractFilePath(MainPath) + sPalettes + '\' +
                Int2Digs(16 +
                         Str2Int(Copy(tcPages.TC_Items[2],
                         Pos('[', tcPages.TC_Items[2]) + 1,
                         Pos(']', tcPages.TC_Items[2]) -
                         Pos('[', tcPages.TC_Items[2]))), 2) + '.bmp');

              wd := bmp.Width;
              hg := 1;
              bmp.RotateRightTrueColor;
              SetLength(Clutmas, hg, wd);

              for x := 1 to hg do
                for y := 1 to wd do
                  Clutmas[x - 1, y - 1] := bmp.DIBPixels[x - 1, y - 1];

            {  chkRandom.Enabled := true;
              btnGenPal.Enabled := true;
              btnSaveAsRandom.Enabled := true;  }
              Free_And_Nil(bmp);
              //bmp.Free;
              //pbClut.clear;
              pbClut.Canvas.Brush.Color := pnlClut.Color;
              pbClut.Canvas.FillRect(pbClut.ClientRect);
              Exit;
            end;
          161, 241:
            begin
              wd := pal.ClutColors;
              hg := pal.ClutNum;
              SetLength(Clutmas, hg, wd);

              for x := 1 to hg do
                for y := 1 to wd do
                begin
                  Clutmas[x - 1, y - 1] :=
                    cardinal(TwoBytesToColor(clutdat[z]));
                  Inc(z);
                end;
            end;
        end;

        if show then
        begin
          //pbClut.Clear;
          pbClut.Canvas.Brush.Color := pnlClut.Color;
          pbClut.Canvas.FillRect(pbClut.ClientRect);

          pbClut.Width := 16 * 25;

          if (pal.ClutColors mod 16)=0 then
          pbClut.Height := (pal.ClutColors div 16) * 25
          else
          pbClut.Height := ((pal.ClutColors div 16)+1) * 25;

          bmpc := NewDIBBitmap(pal.ClutNum, pal.ClutColors, pf24bit);

          if (pal.ClutColors mod 16)=0 then
          clutbmp := NewDIBBitmap(16, pal.ClutColors div 16, pf24bit)
          else
          clutbmp := NewDIBBitmap(16, (pal.ClutColors div 16)+1, pf24bit);

          for x := 1 to pal.ClutNum do
            for y := 1 to pal.ClutColors do
              bmpc.DIBPixels[x - 1, y - 1] := Clutmas[x - 1, y - 1];

          bmpc.RotateLeftTrueColor;
          bmpc.FlipVertical;
          z := 0;
          x := 0;
          y := 0;

          while y < pal.ClutColors do
          begin
            case bpp of
              4, 8: Clutbmp.DIBPixels[x, z] :=
                    bmpc.DIBPixels[y, cbbpalette.CurIndex];
              161, 241: Clutbmp.DIBPixels[x, z] := bmpc.DIBPixels[y, 0];
            end;

            if x = 15 then
            begin
              x := 0;
              Inc(z);
            end
            else
              Inc(x);
            Inc(y);
          end;
          Free_And_Nil(bmpc);
          //bmpc.Free;
        end;
      end;

      if show and (Clutbmp<>nil) then
      begin
        Clutbmp.StretchDraw(GetDC(pbClut.Handle), pbClut.ClientRect);
        pbClut.visible := true;
        Exit;
      end;
    end;

    pbClut.visible := false;
  except
    pbClut.visible := false;
  end;
end;

//Image Painting

procedure TfrmMain.PaintImage(Show: boolean = true);
var
  x, y, z: cardinal;
  wd, hg: cardinal;
  t: byte;
  col: cardinal;
  TranspCnt: Cardinal;
  offset, tOffset: integer;
begin
  try
    TranspCnt := 0;
    if ((lvListG.Count = 0) and (CurGBPage = 0)) or
      ((lvListB.Count = 0) and (CurGBPage = 1)) then
      Exit;

    if Head.Bpp in [$04, $0C] then
      Exit;

    z := 0;

    if not FastPaint then
    begin
      pbImage.Canvas.Brush.Color := sbImage.Color;
      pbImage.Canvas.FillRect(pbImage.ClientRect);
      cls := false;
    end;

    wd := ImgRealWidth;
    hg := img.ImgHeight;

    pbImage.Visible := show;

    if not FastPaint then
    begin
      bmpImage := NewDibBitmap(wd, hg, pf32bit);
      pngImage := TPNGObject.CreateBlank(COLOR_RGBALPHA, 16, wd, hg);
      pngImage.CompressionLevel := 9;
      pngImage.Filters := [];
    end;

    case ZoomValue of
      10:
        begin
          pbImage.Width := wd;
          pbImage.Height := hg;
          cbbZoom.CurIndex := 0;
        end;
      15:
        begin
          pbImage.Width := wd * 3 div 2;
          pbImage.Height := hg * 3 div 2;
          cbbZoom.CurIndex := 1;
        end;
      20:
        begin
          pbImage.Width := wd * 2;
          pbImage.Height := hg * 2;
          cbbZoom.CurIndex := 2;
        end;
      25:
        begin
          pbImage.Width := wd * 5 div 2;
          pbImage.Height := hg * 5 div 2;
          cbbZoom.CurIndex := 3;
        end;
      30:
        begin
          pbImage.Width := wd * 3;
          pbImage.Height := hg * 3;
          cbbZoom.CurIndex := 4;
        end;
      35:
        begin
          pbImage.Width := wd * 7 div 2;
          pbImage.Height := hg * 7 div 2;
          cbbZoom.CurIndex := 5;
        end;
      40:
        begin
          pbImage.Width := wd * 4;
          pbImage.Height := hg * 4;
          cbbZoom.CurIndex := 6;
        end;
      100:
        begin
          if (cardinal(sbimage.Width) / wd)<(cardinal(sbimage.Height) / hg) then
          begin
            pbImage.Width := wd * (cardinal(sbimage.Width) - 15) div wd;
            pbImage.Height := hg * (cardinal(sbimage.Width) - 15) div wd;
          end
          else
          begin
            pbImage.Width := wd * (cardinal(sbimage.Height) - 15) div hg;
            pbImage.Height := hg * (cardinal(sbimage.Height) - 15) div hg;
          end;
          cbbZoom.CurIndex := 7;
        end;
    end;
    if not FastPaint then
    begin
      col := clBlack;
      tOffset := Str2Int(edtOffset.Text);
      for y := 1 to hg do
        for x := 1 to wd do
          case bpp of
            4, 8, 41, 81, 16, 161:
              begin
                if bpp in [4,8,41,81] then
                begin
                offset := imgdat_4_8_16[z] + tOffset;
                if offset > 0 then
                begin
                  if not (bpp in [41,81]) then
                  if (offset>Length(Clutmas[cbbPalette.CurIndex])) then
                  offset := offset mod Length(Clutmas[cbbPalette.CurIndex]);
                end
                else
                if (offset < 0) then
                begin
                if not (bpp in [41,81]) then
                  offset := Length(Clutmas[cbbPalette.CurIndex]) -
                  Abs(offset)
                else
                  offset := Length(Clutmas[0]) - Abs(offset);
                end
                else
                  offset:=imgdat_4_8_16[z];

                if (bpp in [4, 8]) then
                  col := Clutmas[cbbPalette.CurIndex,
                         offset mod pal.ClutColors]
                else
                if (bpp in [41, 81]) then
                  col := Clutmas[0, offset mod 256];

                end
                else
                col := TwoBytesToColor(imgdat_4_8_16[z]);

                pngImage.Pixels[x - 1, y - 1] := col;

                if chkTransparency.Checked then
                begin
                  t := GetRValue(col) - (GetRValue(col) div 8) * 8;

                  if t = 0 then
                  begin
                    if (GetRValue(col) = 0) and (GetGValue(col) = 0) and
                       (GetBValue(col) = 0) then
                    begin
                      pngImage.AlphaScanline[y - 1]^[x - 1] := 0;
                      bmpImage.DIBPixels[x - 1, y - 1] := sbImage.Color;
                      Inc(TranspCnt);
                    end
                    else
                    begin
                      pngImage.AlphaScanline[y - 1]^[x - 1] := 255;
                      bmpImage.DIBPixels[x - 1, y - 1] := col;
                    end;
                  end
                  else
                  begin
                    if (GetRValue(col) = 1) and (GetGValue(col) = 0) and
                       (GetBValue(col) = 0) then
                    begin
                      pngImage.Pixels[x - 1, y - 1] := clBlack;
                      pngImage.AlphaScanline[y - 1]^[x - 1] := 255;
                      bmpImage.DibPixels[x - 1, y - 1] := clBlack;
                    end
                    else
                    begin
                      pngImage.Pixels[x - 1, y - 1] := col;
                      pngImage.AlphaScanline[y - 1]^[x - 1] := 255;
                      bmpImage.DibPixels[x - 1, y - 1] := col;
                    end;
                  end;
                end
                else
                begin
                  pngImage.Pixels[x - 1, y - 1] := col;
                  pngImage.AlphaScanline[y - 1]^[x - 1] := 255;
                  bmpImage.DibPixels[x - 1, y - 1] := col;
                end;
                Inc(z);
              end;
            24, 241:
              begin
                pngImage.Pixels[x - 1, y - 1] :=
                  ThreeBytesToColor(imgdat_24[z]);
                bmpImage.DIBPixels[x - 1, y - 1] :=
                  ThreeBytesToColor(imgdat_24[z]);
                pngImage.AlphaScanline[y - 1]^[x - 1] := 255;
                Inc(z);
              end;
          end;
    end;

    if show and (bmpImage<>nil) then
    begin
      if TranspCnt <> wd * hg then
      begin
        bmpImage.StretchDraw(GetDC(pbImage.Handle), pbImage.ClientRect);
        chkTransparency.Caption := 'Transparency';
      end
      else
      begin
        chkTransparency.Caption := 'Transparency (!!!)';
        pbImage.Canvas.Brush.Color := sbImage.Color;
        pbImage.Canvas.FillRect(pbImage.ClientRect);
        cls := true;
        Exit;
      end;
    end;

    FastPaint := true;
    cls := true;
  except
    FastPaint := False;
  end;
end;

procedure TfrmMain.cbbPaletteChange(Sender: PObj);
begin
  if cls then
  begin
    FastPaint := False;
    PaintClut(true, false);
    PaintImage;
  end;
end;

//MainFunction - Reading TIM information

function TfrmMain.ReadTIM(const FileName: string; Pos: integer; FlSize:
  cardinal; SkipHead: Boolean = false): boolean;
var
  i: integer;
  ind: byte;
  z: integer;
  pFile, pFileStart: PByte;
  hFile, hMap: THandle;
  bps: string;
  ImageScan: Boolean;
  filesz: Cardinal;
begin
  result := false;
  if not SkipHead then
    ClearAll;
  cls := True;
  lvInfo.Clear;
  //pbImage.Clear;
  pbImage.Canvas.Brush.Color := sbImage.Color;
  pbImage.Canvas.FillRect(pbImage.ClientRect);
  cbbPalette.Clear;
  lblIndex.Caption := 'Index (0):';
  bps := '';

  ImageScan := GetImageScan(FileName);
  filesz := FileSize(FileName);

  if filesz > cMaxSize then
  begin
    BringWindowToTop(form.Handle);
    if MessageBox(Form.Handle, sTooBig, sConfirmation, MB_YESNO +
      MB_ICONQUESTION + MB_TOPMOST + MB_DEFBUTTON2) = IDNO then
      Exit;
  end;

  pFile := MapFileRead(FileName, hFile, hMap);
  if pFile = nil then Exit;

  pFileStart := pFile;

  CheckCurrentPos(ImageScan, pFileStart, pFile, ccPlus, true);
  inc(pFile, pos);
  CheckCurrentPos(ImageScan, pFileStart, pFile, ccPlus, true);

  if not SkipHead then
  begin
    ReadFromMem(ImageScan, filesz, rtHead, pFileStart, pFile);
    if (head.Sign <> $10) or ((head.Version <> $00) and
      (head.Version <> $01)) or (not (head.Bpp in
      [$08, $09, $0A, $0B, $02, $03, $00, $01, $04, $0C])) then
    begin
      UnmapFile(pFileStart, hFile, hMap);
        pFileStart := nil;
        hFile := 0;
        hMap := 0;
      ClearAll;
      Exit;
    end;
  end
  else
  begin
    Inc(pFile);
    for i := 1 to SizeOf(head) - 1 do
    begin
      CheckCurrentPos(ImageScan, pFileStart, pFile, ccPlus);
      Inc(pFile);
    end;
  end;

  if (head.Bpp in [$08, $09, $0A, $0B, $0C]) then
  begin
    ReadFromMem(ImageScan, filesz, rtPal, pFileStart, pFile);

    for i := 1 to pal.ClutNum do
      cbbPalette.Add(Int2Str(i));

    lblIndex.Caption := 'Index (' + int2str(pal.ClutNum) + '):';

    SetLength(clutdat, pal.ClutColors * pal.ClutNum);

    for i := 1 to (pal.ClutColors * pal.ClutNum) do
      clutdat[i - 1] := InvertWord(ImageScan, filesz, pFileStart, pFile);
  end;

  ReadFromMem(ImageScan, filesz, rtImage, pFileStart, pFile);

  if (img.ImgWidth = 0) or (img.ImgHeight = 0) then
  begin
    UnmapFile(pFileStart, hFile, hMap);
        pFileStart := nil;
        hFile := 0;
        hMap := 0;
    ClearAll;
    Exit;
  end;

  if (pal.ClutColors * pal.ClutNum) > 0 then
  begin
  if (pal.ClutColors * pal.ClutNum * 2 + $0C + img.ImgWidth *
      img.ImgHeight * 2 + SizeOf(Head) + $0C) > FlSize then
  begin
    UnmapFile(pFileStart, hFile, hMap);
        pFileStart := nil;
        hFile := 0;
        hMap := 0;
    ClearAll;
    Exit;
  end;
  end
  else
  if (img.ImgWidth * img.ImgHeight * 2 + SizeOf(Head) + $0C) > FlSize then
  begin
    UnmapFile(pFileStart, hFile, hMap);
        pFileStart := nil;
        hFile := 0;
        hMap := 0;
    ClearAll;
    Exit;
  end;

  HeadBpp2Bpp;

  case head.Bpp of
    $08, $00: ImgRealWidth := word(img.ImgWidth * 4);
    $09, $01: ImgRealWidth := word(img.ImgWidth * 2);
    $0A, $02, $0C, $04: ImgRealWidth := word(img.ImgWidth * 1);
    $0B, $03: ImgRealWidth := word(Round(img.ImgWidth * 2 / 3));
  end;

  if (ImgRealWidth = 0) then
  begin
    UnmapFile(pFileStart, hFile, hMap);
        pFileStart := nil;
        hFile := 0;
        hMap := 0;
    ClearAll;
    Exit;
  end;

  if not (head.Bpp in [$0C, $04]) then
  begin
    z := 0;

    case bpp of
      4, 41: SetLength(imgdat_4_8_16, img.ImgWidth * img.ImgHeight * 4);
      8, 81,
    16, 161,
     48, 64: SetLength(imgdat_4_8_16, img.ImgWidth * img.ImgHeight * 2);
    24, 241:
             if Odd(ImgRealWidth) then
              SetLength(imgdat_24, img.ImgWidth * img.ImgHeight * 2 -
              img.ImgHeight)
             else
              SetLength(imgdat_24, img.ImgWidth * img.ImgHeight * 2);
    end;

    i := 1;
    while i<=(img.ImgWidth * img.ImgHeight * 2) do
    begin
      if (Cardinal(pFile) - Cardinal(pFileStart)) >= filesz then Break;
      case bpp of
        4, 41:
          begin
            CheckCurrentPos(ImageScan, pFileStart, pFile, ccPlus);
            imgdat_4_8_16[z] := OneByte2Bits(pFile^).fhalf;
            Inc(z);
            CheckCurrentPos(ImageScan, pFileStart, pFile, ccPlus);
            imgdat_4_8_16[z] := OneByte2Bits(pFile^).shalf;
            Inc(z);
            Inc(pFile);
            Inc(i);
          end;
        8, 81:
          begin
            CheckCurrentPos(ImageScan, pFileStart, pFile, ccPlus);
            imgdat_4_8_16[z] := pFile^;
            Inc(pFile);
            Inc(i);
            Inc(z);
          end;
        16, 161:
          begin
            imgdat_4_8_16[z] :=
            InvertWord(ImageScan, filesz, pFileStart, pFile);
            Inc(i, 2);
            Inc(z);
          end;
        24, 241:
          begin
            imgdat_24[z] := InvertThree(ImageScan, filesz, pFileStart, pFile);
            Inc(i, 3);
            if Odd(ImgRealWidth) then
              if ((z + 1) mod ImgRealWidth) = 0 then
              begin
                CheckCurrentPos(ImageScan, pFileStart, pFile, ccPlus);
                Inc(pFile);
              end;
            Inc(z);
          end;

      end;
    end;
  end;

  UnmapFile(pFileStart, hFile, hMap);
        pFileStart := nil;
        hFile := 0;
        hMap := 0;

  ind := 1;
  lvInfo.LVAdd('Header:', 0, [], 0, 0, 0);

  lvInfo.LVAdd('Signature', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(head.Sign, 2);

  Inc(ind);
  lvInfo.LVAdd('Version', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(head.Version, 2);

  Inc(ind);
  lvInfo.LVAdd('Reserved1', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(head.Reserved1, 2);

  Inc(ind);
  lvInfo.LVAdd('Reserved2', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(head.Reserved2, 2);

  Inc(ind);
  lvInfo.LVAdd('BPP', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(head.bpp, 2);

  case Bpp of
    41: lvInfo.LVItems[ind, 2] := '4-bit (without CLUT)';
     4: lvInfo.LVItems[ind, 2] := '4-bit (with CLUT)';
    81: lvInfo.LVItems[ind, 2] := '8-bit (without CLUT)';
     8: lvInfo.LVItems[ind, 2] := '8-bit (with CLUT)';
    48: lvInfo.LVItems[ind, 2] := 'Mixed (without CLUT)';
    16: lvInfo.LVItems[ind, 2] := '16-bit (without CLUT)';
   161: lvInfo.LVItems[ind, 2] := '16-bit (with CLUT)';
    24: lvInfo.LVItems[ind, 2] := '24-bit (without CLUT)';
   241: lvInfo.LVItems[ind, 2] := '24-bit (with CLUT)';
    64: lvInfo.LVItems[ind, 2] := 'Mixed (with CLUT)';
  end;

  Inc(ind);
  lvInfo.LVAdd('Reserved3', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(head.Reserved3, 2);

  Inc(ind);
  lvInfo.LVAdd('Reserved4', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(head.Reserved4, 2);

  Inc(ind);
  lvInfo.LVAdd('Reserved5', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(head.Reserved5, 2);

  if (pal.ClutLen + pal.PalX + pal.PalY + pal.ClutColors + pal.ClutNum) > 0
  then
  begin
    lvInfo.LVAdd('', 0, [], 0, 0, 0);
    lvInfo.LVAdd('Palette:', 0, [], 0, 0, 0);

    Inc(ind, 3);
    lvInfo.LVAdd('Length of the CLUT Data', 0, [], 0, 0, 0);
    lvInfo.LVItems[ind, 1] := Int2Hex(pal.ClutLen, 8);
    lvInfo.LVItems[ind, 2] :=
      Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

    Inc(ind);
    lvInfo.LVAdd('Palette Org X', 0, [], 0, 0, 0);
    lvInfo.LVItems[ind, 1] := Int2Hex(pal.PalX, 4);
    lvInfo.LVItems[ind, 2] :=
      Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

    Inc(ind);
    lvInfo.LVAdd('Palette Org Y', 0, [], 0, 0, 0);
    lvInfo.LVItems[ind, 1] := Int2Hex(pal.PalY, 4);
    lvInfo.LVItems[ind, 2] :=
      Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

    Inc(ind);
    lvInfo.LVAdd('Number of Colors in CLUT', 0, [], 0, 0, 0);
    lvInfo.LVItems[ind, 1] := Int2Hex(pal.ClutColors, 4);
    lvInfo.LVItems[ind, 2] :=
      Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

    Inc(ind);
    lvInfo.LVAdd('Number of CLUTs', 0, [], 0, 0, 0);
    lvInfo.LVItems[ind, 1] := Int2Hex(pal.ClutNum, 4);
    lvInfo.LVItems[ind, 2] :=
      Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

    Inc(ind);
    lvInfo.LVAdd('CLUT Data', 0, [], 0, 0, 0);
    lvInfo.LVItems[ind, 2] := Int2Str(pal.ClutColors * pal.ClutNum * 2);
  end;

  lvInfo.LVAdd('', 0, [], 0, 0, 0);

  lvInfo.LVAdd('Image:', 0, [], 0, 0, 0);

  Inc(ind, 3);
  lvInfo.LVAdd('Length of the Image Data', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(img.ImgLen, 8);
  lvInfo.LVItems[ind, 2] :=
    Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

  Inc(ind);
  lvInfo.LVAdd('Image Org X', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(img.ImgX, 4);
  lvInfo.LVItems[ind, 2] :=
    Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

  Inc(ind);
  lvInfo.LVAdd('Image Org Y', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(img.ImgY, 4);
  lvInfo.LVItems[ind, 2] :=
    Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

  Inc(ind);
  lvInfo.LVAdd('Image Width', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(img.ImgWidth, 4);
  lvInfo.LVItems[ind, 2] :=
    Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

  Inc(ind);
  lvInfo.LVAdd('Image Width (Real)', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(ImgRealWidth, 4);
  lvInfo.LVItems[ind, 2] :=
    Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

  Inc(ind);
  lvInfo.LVAdd('Image Height', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 1] := Int2Hex(img.ImgHeight, 4);
  lvInfo.LVItems[ind, 2] :=
    Int2Str(Hex2Int(lvInfo.LVItems[ind, 1]));

  Inc(ind);
  lvInfo.LVAdd('Image Data', 0, [], 0, 0, 0);
  lvInfo.LVItems[ind, 2] := Int2Str(img.ImgWidth * img.ImgHeight * 2);

  lblPos.Caption := Int2Hex(pos, 10);

  mmMain.Items[mnSaveImage].Enabled := True;
  mmMain.Items[mnSaveAllImages].Enabled := True;
  mmMain.Items[mnSaveAllwPals].Enabled := True;
  mmMain.Items[mnSaveAllPals].Enabled := True;
  mmMain.Items[mnBMPextract].Enabled := True;

  ppList.Items[ppSaveImage].Enabled := True;
  ppList.Items[ppSaveAllImages].Enabled := True;
  ppList.Items[ppSaveAllwPals].Enabled := True;
  ppList.Items[ppSaveAllPals].Enabled := True;
  ppList.Items[ppBMPextract].Enabled := True;

 { case bpp of
  4, 8, 161, 241: pbClut.Visible := true;
          41, 81: pbClut.Visible := false;
  end; }

  mmMain.Items[mnClose].Enabled := True;
  Result := True;
end;

//Replacing TIM in File or Image

function TfrmMain.bin2bcd(P: Integer): Byte;
begin
  Result := ((p div 10) shl 4) or (p mod 10);
end;

procedure TfrmMain.BuildAdress(LBA: Integer; var Dest);
var
  P: PByte;
begin
  Inc(LBA, 75 * 2); // 2 seconds
  P := @Dest;
  P^ := bin2bcd(LBA div (60 * 75));
  Inc(P);
  P^ := bin2bcd((LBA div 75) mod 60);
  Inc(P);
  P^ := bin2bcd(LBA mod 75);
  Inc(P);
  P^ := 2;
end;

function TfrmMain.ReplaceInImage(const FileName: string): boolean;
type
  TMode2Sector = array[0..2352 - 1] of Byte;

var
  tmp, tmp2, tmp3: PStream;
  TimOffsetInSector, i, First, last: Word;
  sectorNumber, PosRaw: cardinal;
  SectorMem: TMode2Sector;
  edc: cardinal;
  sect4: array[0..3] of byte;
  secpos, FlSize, FlSizeGB: cardinal;
  palsel: byte;
  ImageScan: Boolean;
begin
  result := false;
  FlSize := FileSize(FileName);

  if pal.ClutNum > 0 then
    palsel := cbbpalette.CurIndex
  else
    palsel := 0;

  if ReadTIM(FileName, 0, FlSize) then
  begin
    if CurGBPage = 0 then
      FlSizeGB := cardinal(Hex2Int(lvListG.LVItems[lvlistG.curindex, 1]))
    else
      FlSizeGB := cardinal(Hex2Int(lvListB.LVItems[lvlistB.curindex, 1]));

    if FlSize = FlSizeGB then
    begin
      if CurGBPage = 0 then
      begin
        if mmMain.Items[mnCreateBak].Checked then
          CopyFile(PAnsiChar(FileNamesG.Items[CurNum]),
            PAnsiChar(ExtractFilePath(FileNamesG.Items[CurNum]) +
            ExtractFileName(FileNamesG.Items[CurNum]) + '.bak'), false);

        ImageScan := GetImageScan(FileNamesG.Items[CurNum]);
      end
      else
      begin
        if mmMain.Items[mnCreateBak].Checked then
          CopyFile(PAnsiChar(FileNamesB.Items[CurNum]),
            PAnsiChar(ExtractFilePath(FileNamesB.Items[CurNum]) +
            ExtractFileName(FileNamesB.Items[CurNum]) + '.bak'), false);

        ImageScan := GetImageScan(FileNamesB.Items[CurNum]);
      end;

      if FlSize > cMaxSize then
      begin
        BringWindowToTop(form.Handle);
        if MessageBox(Form.Handle,sTooBig,sConfirmation, MB_YESNO +
          MB_ICONQUESTION + MB_TOPMOST + MB_DEFBUTTON2) = IDNO then
          Exit;
      end;

      tmp2 := NewMemoryStream;
      tmp3 := NewReadFileStream(FileName);

      Stream2Stream(tmp2, tmp3, tmp3.Size);
      Free_And_Nil(tmp3);
      //tmp3.Free;
      if CurGBPage = 0 then
        tmp := NewReadWriteFileStream(FileNamesG.Items[CurNum])
      else
        tmp := NewReadWriteFileStream(FileNamesB.Items[CurNum]);
      tmp2.Position := 0; //Memory for input tim

      if not ImageScan then
      begin
        if CurGBPage = 0 then
          tmp.Seek(fileposesG[CurNum], spBegin)
        else
          tmp.Seek(fileposesB[CurNum], spBegin);
        Stream2Stream(tmp, tmp2, FlSize);
      end
      else
      begin
        if CurGBPage = 0 then
        begin
          sectorNumber := fileposesG[CurNum] div sector + 1;
          TimOffsetInSector := fileposesG[CurNum] mod Sector - info1;
        end
        else
        begin
          sectorNumber := fileposesB[CurNum] div sector + 1;
          TimOffsetInSector := fileposesB[CurNum] mod Sector - info1;
        end;
        posRaw := (sectorNumber - 1) * Sector;
        First := sectdata - TimOffsetInSector;

        secpos := posRaw;
        tmp.Seek(secpos, spBegin);

        for i := 0 to sector - 1 do
          tmp.read(SectorMem[i], 1);

        tmp.Seek(secpos, spBegin);

        tmp.Seek(12, spCurrent);
        for i := 0 to 3 do
          tmp.Read(Sect4[i], 1);
        tmp.Seek(-16, spCurrent);

        for i := 12 to 15 do
          SectorMem[i] := 0;

        for i := 0 to First - 1 do
          tmp2.Read(SectorMem[i + info1 + TimOffsetInSector], 1);

        edc := build_edc(@SectorMem[16], sectdata + 8);
        Move(edc, SectorMem[info1 + sectdata], 4);
        encode_L2_P(@SectorMem[12]);
        encode_L2_Q(@SectorMem[12]);
        BuildAdress(sectorNumber, SectorMem[12]);

        tmp.Seek(secpos, spBegin);
        for i := 0 to sector - 1 do
          tmp.write(SectorMem[i], 1);

        tmp.Seek(secpos + 12, spBegin);
        for i := 12 to 15 do
          tmp.write(Sect4[i - 12], 1);

        Inc(secpos, sector);
        tmp.Seek(secpos, spBegin);

        while abs(flsize - tmp2.position) >= sectdata do
        begin
          Inc(sectorNumber);

          for i := 0 to sector - 1 do
            tmp.read(SectorMem[i], 1);

          tmp.Seek(secpos, spBegin);

          tmp.Seek(12, spCurrent);
          for i := 0 to 3 do
            tmp.Read(Sect4[i], 1);
          tmp.Seek(-16, spCurrent);

          for i := 12 to 15 do
            SectorMem[i] := 0;

          for i := 0 to sectdata - 1 do
            tmp2.Read(SectorMem[i + info1], 1);

          edc := build_edc(@SectorMem[16], sectdata + 8);
          Move(edc, SectorMem[info1 + sectdata], 4);
          encode_L2_P(@SectorMem[12]);
          encode_L2_Q(@SectorMem[12]);
          BuildAdress(sectorNumber, SectorMem[12]);

          tmp.Seek(secpos, spBegin);
          for i := 0 to sector - 1 do
            tmp.write(SectorMem[i], 1);

          tmp.Seek(secpos + 12, spBegin);
          for i := 12 to 15 do
            tmp.write(Sect4[i - 12], 1);

          Inc(secpos, sector);
          tmp.Seek(secpos, spBegin);
        end;

        Inc(sectorNumber);

        for i := 0 to sector - 1 do
          tmp.read(SectorMem[i], 1);

        tmp.Seek(secpos, spBegin);

        tmp.Seek(12, spCurrent);
        for i := 0 to 3 do
          tmp.Read(Sect4[i], 1);
        tmp.Seek(-16, spCurrent);

        for i := 12 to 15 do
          SectorMem[i] := 0;

        last := flsize - tmp2.position;

        for i := 0 to last - 1 do
          tmp2.Read(SectorMem[i + info1], 1);

        edc := build_edc(@SectorMem[16], sectdata + 8);
        Move(edc, SectorMem[info1 + sectdata], 4);
        encode_L2_P(@SectorMem[12]);
        encode_L2_Q(@SectorMem[12]);
        BuildAdress(sectorNumber, SectorMem[12]);

        tmp.Seek(secpos, spBegin);
        for i := 0 to sector - 1 do
          tmp.write(SectorMem[i], 1);

        tmp.Seek(secpos + 12, spBegin);
        for i := 12 to 15 do
          tmp.write(Sect4[i - 12], 1);
      end;
      Free_And_Nil(tmp2);
      //tmp2.free;
      Free_And_Nil(tmp);
      //tmp.free;
      result := True;
      cbbpalette.CurIndex := palsel;
      cbbPaletteChange(@self);
    end
    else
    begin
      BringWindowToTop(form.Handle);
      MessageBox(Form.Handle, 'TIM sizes must be equal!', 'Error',
      MB_OK + MB_ICONSTOP + MB_TOPMOST);
    end;

  end
  else
  begin
    BringWindowToTop(form.Handle);
    MessageBox(Form.Handle, 'Please, select good TIM file!', 'Error',
    MB_OK + MB_ICONSTOP + MB_TOPMOST);
  end;
end;

//Converting BMP to TIM

function TfrmMain.ConvertBMP2Tim(const BMP: string): Boolean;
var
  NewTim, InTim, InBMPm: PStream;
  InBMP: PBitmap;
  wd, hg: word;
  x, y: cardinal;
  s: string;
  buf, i: cardinal;
  a, c, b, g, r, buf4: Byte;
begin
  ClearAll;
  if not FileExists(ExtractFileName(BMP)) then
  begin
    result := False;
    BringWindowToTop(form.Handle);
    MessageBox(Form.Handle, 'TIM File must be in the same directory as the BMP File!',
      'Error', MB_OK + MB_ICONWARNING + MB_TOPMOST);

    exit;
  end;
  if ReadTIM(ChangeFileExt(BMP, sTimExt), 0,
     FileSize(ChangeFileExt(BMP, sTimExt))) and
    (KOLLowerCase(ExtractFileExt(BMP)) = '.bmp') then
  begin
    buf := 0;
    NewTim := NewMemoryStream;
    InBmp := NewDibBitmap(imgRealWidth, img.ImgHeight, pf32bit);
    InBMP.LoadFromFile(BMP);

    wd := imgRealWidth;
    hg := img.ImgHeight;

    if (bpp in [4, 41, 8, 81, 16, 161, 24, 241]) then
    begin

      case bpp of
        24, 241: InBMP.PixelFormat := pf24bit;
      end;

      inbmp.PixelFormat := pf32bit;
      InTim := NewReadFileStream(ChangeFileExt(BMP, sTimExt));

      if (pal.ClutColors * pal.ClutNum) > 0 then
         Stream2Stream(NewTim, InTim, pal.ClutColors * pal.ClutNum * 2 +
         $0C + SizeOf(Head) + $0C)
      else
        Stream2Stream(NewTim, InTim, SizeOf(Head) + $0C);

      PaintClut(false, false);
      PaintImage(false);

      case bpp of
        4, 41, 8, 81, 16, 161:
          begin
            s := '';
            inbmpm := NewMemoryStream;
            InBMP.FlipVertical;
            InBMP.SaveToStream(inbmpm);
            InBMPm.Seek($36, spBegin);

            case bpp of
              4, 41:
                for i := 1 to (wd * hg div 2) do
                begin
                  inbmpm.Read(b, 1);
                  b := b - (b div 8) * 8;
                  inbmpm.Read(g, 1);
                  g := g - (g div 8) * 8;
                  inbmpm.Read(r, 1);
                  r := r - (r div 8) * 8;
                  inbmpm.seek(1, spcurrent);
                  a := ((b shl 6) + (g shl 3) + r) shr 1;

                  inbmpm.Read(b, 1);
                  b := b - (b div 8) * 8;
                  inbmpm.Read(g, 1);
                  g := g - (g div 8) * 8;
                  inbmpm.Read(r, 1);
                  r := r - (r div 8) * 8;
                  inbmpm.seek(1, spcurrent);
                  c := ((b shl 6) + (g shl 3) + r) shr 1;

                  buf4 := ByteFrom4Bits(a, c);
                  NewTim.Write(buf4, 1);
                end;
              8, 81:
                for i := 1 to Length(imgdat_4_8_16) do
                begin
                  inbmpm.Read(b, 1);
                  b := b - (b div 8) * 8;
                  inbmpm.Read(g, 1);
                  g := g - (g div 8) * 8;
                  inbmpm.Read(r, 1);
                  r := r - (r div 8) * 8;
                  inbmpm.seek(1, spcurrent);
                  buf4 := ((b shl 6) + (g shl 3) + r) shr 1;
                  NewTim.Write(buf4, 1);
                end;
              16, 161:
                begin
                  for i := 1 to (Length(imgdat_4_8_16) div 2) do
                  begin
                    inbmpm.Read(b, 1);
                    inbmpm.Read(g, 1);
                    inbmpm.Read(r, 1);
                    inbmpm.seek(1, spcurrent);
                    buf := ColorTo2Bytes(RGB(r, g, b));
                    NewTim.Write(buf, 2);
                  end;
                end;
            end;
            Free_And_Nil(InBMPm);
            //InBMPm.Free;
          end;
        24, 241:
          begin
            for y := 1 to hg do
              for x := 1 to wd do
              begin
                buf := ColorTo3Bytes(inbmp.DibPixels[x - 1, y - 1]);
                NewTim.Write(buf, 3);
                if Odd(ImgRealWidth) then
                  if (ImgRealWidth - x) = 0 then
                  begin
                    buf := 0;
                    NewTim.Write(buf, 1);
                  end;
              end;
          end;
      end;
      Free_And_Nil(InBMP);
      //InBmp.free;
      NewTim.SaveToFile(ChangeFileExt(BMP, '_new.tim'), 0, NewTim.Size);
      Free_And_Nil(NewTim);
      //NewTim.free;
      ClearAll;
      BringWindowToTop(form.Handle);
      MessageBox(Form.Handle, 'Operation is OK!', 'Information',
      MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
      result := true;
      fastpaint := false;
    end
    else
      result := false;

    sbImage.Visible := true;
  end
  else
    result := false;
end;

//Converts TIM to BMP

procedure TfrmMain.ConvertTIM2BMP(const SourceFile: string);
var
  bmpm: PStream;
  i: cardinal;
  r, g, b, a: byte;
  col: TColor;
  path: string;
begin
  bmpm := NewMemoryStream;
  case bpp of
    4, 41, 8, 81, 16, 161: bmpImage.FlipVertical;
  end;
  bmpImage.SaveToStream(bmpm);

  bmpm.Seek($36, spBegin);

  case bpp of
    4, 41, 8, 81:
      for i := 1 to Length(imgdat_4_8_16) do
      begin
        bmpm.Read(b, 1);
        bmpm.Read(g, 1);
        bmpm.Read(r, 1);
        a := imgdat_4_8_16[i - 1];
        b := b + GetBits(a, 5, 7);
        g := g + GetBits(a, 2, 4);
        r := r + (GetBits(a, 0, 1) shl 1);
        bmpm.Seek(-3, spCurrent);
        bmpm.Write(b, 1);
        bmpm.Write(g, 1);
        bmpm.Write(r, 1);
        bmpm.Seek(1, spCurrent);
        Form.ProcessPendingMessages;
      end;
    16, 161:
      for i := 1 to Length(imgdat_4_8_16) do
      begin
        bmpm.Seek(2, spCurrent);
        col := TwoBytesToColor(imgdat_4_8_16[i - 1]);
        r := GetRValue(col);
        bmpm.Write(r, 1);
        bmpm.Seek(1, spCurrent);
        Form.ProcessPendingMessages;
      end;
  end;
  CreateDirectory(PAnsiChar(ExtractFilePath(MainPath) + sForEdit), nil);
  path := ChangeFileExt(SourceFile, '.bmp');
  case bpp of
    4, 41, 8, 81, 16, 161:
      begin
        bmpm.SaveToFile(path, 0, bmpm.size);
        bmpImage.LoadFromFile(path);
        bmpImage.FlipVertical;
        bmpImage.SaveToFile(path);
      end;
    24, 241: bmpm.SaveToFile(path, 0, bmpm.size);
  end;
  BringWindowToTop(form.Handle);
  MessageBox(Form.Handle, PAnsiChar('File "' + path + '" succesfully saved!' +
    #13#10 + 'Now you can open this file in any graphics editor.'),
    'Information', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
  Free_And_Nil(bmpm);
  //bmpm.free;
end;

procedure TfrmMain.mmMainmnExitMenu(Sender: PMenu; Item: Integer);
begin
  mmMainmnCloseMenu(mmMain, mnClose);
  stop := true;
  form.close;
end;

procedure TfrmMain.mmMainmnCloseMenu(Sender: PMenu; Item: Integer);
begin
  lvInfo.Clear;
  cbbPalette.Clear;
  lblIndex.Caption := 'Index (0):';
  mmMain.Items[mnClose].Enabled := False;
  pbImage.Width := 0;
  pbImage.Height := 0;
  pbImage.Canvas.Brush.Color := sbImage.Color;
  pbImage.Canvas.FillRect(pbImage.ClientRect);
  cls := false;
  edtOffset.Text := '0';
  mmMain.Items[mnSaveImage].Enabled := False;
  mmMain.Items[mnSaveAllImages].Enabled := False;
  mmMain.Items[mnSaveAllwPals].Enabled := false;
  mmMain.Items[mnSaveAllPals].Enabled := false;
  mmMain.Items[mnBMPextract].Enabled := false;
  mmMain.Items[mnSaveTIM].Enabled := False;

  ppList.Items[ppSaveImage].Enabled := False;
  ppList.Items[ppSaveAllImages].Enabled := False;
  ppList.Items[ppSaveAllwPals].Enabled := false;
  ppList.Items[ppSaveAllPals].Enabled := false;
  ppList.Items[ppBMPextract].Enabled := false;
  ppList.Items[ppSaveTIM].Enabled := False;

  pbClut.Visible := false;
  mmMain.Items[mnInsertAtPos].Enabled := False;
  ppList.Items[ppInsertAtPos].Enabled := False;
  chkRandom.Enabled := False;
  chkRandom.checked := False;
  btnGenPal.Enabled := false;
  btnMinus.Enabled := False;
  edtOffset.Enabled := False;
  btnPlus.Enabled := false;
  btnSaveAsRandom.Enabled := false;
  cbbRandPalNum.Enabled := false;
  cbbMode.Enabled := false;
  cbbPalette.Enabled := false;
  lvlistG.LVOptions := [lvoGridLines, lvoRowSelect,
  lvoRegional, lvoInfoTip, lvoUnderlineHot];
  lvListG.Enabled := true;
  lvlistB.LVOptions := [lvoGridLines, lvoRowSelect,
  lvoRegional, lvoInfoTip, lvoUnderlineHot];
  lvListB.Enabled := true;
  ClearAll;
  stop := false;
  btnStop.Enabled := false;
  lblPos.Caption := '0000000000';
  lvListG.Clear;
  lvListB.Clear;
  FileNamesG.Clear;
  FileNamesB.Clear;
  FilePosesB := nil;
  FilePosesG := nil;
  lblFiles.Caption := '0 (G)/0 (B)';
  tcPages.TC_Items[1] := 'Image';
  FastPaint := false;
  //pbClut.Clear;
  pbClut.Canvas.Brush.Color := pbClut.Color;
  pbClut.Canvas.FillRect(pbClut.ClientRect);
  pnlRGBClut.caption := '';
  form.SimpleStatusText := 'No File Opened...';
  tcPages.TC_Items[2] := 'CLUT';
  btnSaveEdit.Enabled := false;
  edtValue.Enabled := false;
  chkTransparency.Caption := 'Transparency';
end;

//Files drag-n-droping

procedure TfrmMain.frmKOL1DropFiles(Sender: PControl;
  const FileList: KOL_String; const Pt: TPoint);
var
  tmp: PStrList;
begin
  tmp := NewStrList;
  tmp.Text := FileList;
  if FileExists(tmp.Items[0]) then
  begin
    ListForScan.Text := tmp.text;
    mmMainmmScanRAWMenu(mmMain, mmScanRaw);
  end
  else
  begin
    GetFilesList({ExtractFilePath(}tmp.Items[0]{)}, ListForScan);
    //ListForScan := GetFilesList(IncludeTrailingPathDelimiter(tmp.Items[0]));
    mmMainmmScanRAWMenu(mmMain, mnScanFolder);
  end;
  Free_And_Nil(tmp);
 //tmp.free;
end;

procedure TfrmMain.frmKOL1Close(Sender: PObj; var Accept: Boolean);
begin
  Config(true);
end;

//Files scanner

procedure TfrmMain.mmMainmmScanRAWMenu(Sender: PMenu; Item: Integer);
var
  thread: PThread;
begin
  thread := NewThreadAutoFree(thScanThread);
  thread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
  thread.Resume;
end;

//Files List clicks

procedure TfrmMain.mmMainmnSaveImageMenu(Sender: PMenu; Item: Integer);
var
  pngThread: PThread;
begin
  CreateDirectory(PAnsiChar(ExtractFilePath(MainPath) + 'images'), nil);

  pngThread := NewThreadAutoFree(thPngSaving);
  pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
  pngThread.Resume;

  while not pngThread.Terminated do
      Form.ProcessPendingMessages;

  BringWindowToTop(form.Handle);    
  if CurGBPage = 0 then
    MessageBox(Form.Handle, PAnsiChar('File succesfully saved as:' + #13#10 +
      '"' + ExtractFilePath(MainPath) + 'images\' +
      ExtractFileName(FileNamesG.Items[CurNum]) + '_' +
      lvlistG.LVItems[CurNum, 0] +
      '_image' + Int2Str(cbbpalette.CurIndex + 1) + '.png' + '"'), 'Good',
      MB_OK + MB_ICONINFORMATION + MB_TOPMOST)
  else
    MessageBox(Form.Handle, PAnsiChar('File succesfully saved as:' + #13#10 +
      '"' + ExtractFilePath(MainPath) + 'images\' +
      ExtractFileName(FileNamesB.Items[CurNum]) + '_' +
      lvlistB.LVItems[CurNum, 0] +
      '_image' + Int2Str(cbbpalette.CurIndex + 1) + '.png' + '"'), 'Good',
      MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
end;

procedure TfrmMain.pbImagePaint(Sender: PControl; DC: HDC);
begin
  if cls then
    PaintImage;
end;

//Opening when another instance of program is running

procedure OnNoOne.GG(const cmd: string);
  function UnQuotedStr(const aSrc: string): string;
  var
    tLen: Integer;
  begin
    Result := aSrc;
    tLen := Length(Result);
    if tLen < 2 then Exit;

    if (Result[1] = '"') and (Result[tLen] = '"') then
    begin
      Delete(Result, tLen, 1);
      Delete(Result, 1, 1);
    end;
  end;
var
  str: PStrList;
  s: string;
begin
  try
    frmMain.ListForScan.Clear;
    str := NewStrList;
    str.Text := cmd;
    s := str.Text;
    StrReplace(s, '"' + frmMain.MainPath + '" ', '');
    s := UnQuotedStr(s);
    StrReplace(s, #13#10, '');
    s := UnQuotedStr(s);
    if WinVer <> wvSeven then
      StrReplace(s, ' ', '');
    s := UnQuotedStr(s);

    if FileExists(s) then
    begin
      frmMain.ListForScan.Add(s);
      frmMain.mmMainmmScanRAWMenu(frmMain.mmMain, mmScanRaw);
    end;
  except
    Exit;
  end;
end;

procedure TfrmMain.frmKOL1FormCreate(Sender: PObj);
var
  reg: HKEY;
begin
  FileNamesG := NewStrList;
  FileNamesB := NewStrList;
  Add2AutoFree(FileNamesG);
  Add2AutoFree(FileNamesB);
  ListForScan := NewStrList;
  Add2AutoFree(ListForScan);
  bpp := 0;
  cls := false;
  stop := false;
  imgRealWidth := 0;
  ZoomValue := 100;
  FastPaint := false;
  CurNum := 0;
  CurGBPage := 0;
  ToChange := 0;
  

  if GetDriveType(PAnsiChar(ExtractFileDrive(ParamStr(0)))) <>
    DRIVE_CDROM then
  MainPath := ParamStr(0)
  else
  begin
    reg := RegKeyOpenRead(HKEY_CURRENT_USER,
    'Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders');
    MainPath := IncludeTrailingPathDelimiter(RegKeyGetStrEx(reg,
    'Personal')) + 'TimViewPlus';

    if not (CreateDirectory(PAnsiChar(MainPath), nil) or
    DirectoryExists(MainPath)) then
    begin
      BringWindowToTop(form.Handle);
      MessageBox(Form.Handle, PAnsiChar('Can not create directory:' + #13#10 +
      '"' + MainPath + '"' + #13#10 + 'The program will be closed.'), 'Error',
      MB_OK + MB_ICONSTOP + MB_TOPMOST);

      AppletTerminated := true;
    end;

    MainPath := MainPath + '\timviewp.exe';
  end;

  if ParamCount >= 1 then
    if FileExists(ParamStr(1)) then
    begin
      ListForScan.Add(ParamStr(1));
      mmMainmmScanRAWMenu(mmMain, mmScanRaw);
    end;
end;

procedure TfrmMain.btnGenPalClick(Sender: PObj);
var
  bmp: PBitmap;
  x: word;
  r, g, b: byte;
begin
  bmp := NewDIBBitmap(512, 1, pf24bit);

  Randomize;

  for x := 0 to 511 do
  begin
    r := random(32) * 8;
    g := random(32) * 8;
    b := random(32) * 8;
    bmp.DIBPixels[x, 0] := rgb(r, g, b);
  end;

  bmp.SaveToFile(ExtractFilePath(MainPath) + sPalettes + '\' +
                 Int2Digs(cbbRandPalNum.CurIndex + 1, 2) + '.bmp');

  Free_And_Nil(bmp);
  //bmp.free;
  FastPaint := False;
  PaintClut(true, false);
  PaintImage;
end;

procedure TfrmMain.btnStopClick(Sender: PObj);
begin
  stop := true;
end;

procedure TfrmMain.lvListGKeyUp(Sender: PControl; var Key: Integer;
  Shift: cardinal);
begin
  if (Key in [VK_UP, VK_DOWN]) then
    lvListGClick(@self);
end;

procedure TfrmMain.mmMainmmAssocMenu(Sender: PMenu; Item: Integer);
begin
  AssocTim;
  mmMain.Items[mmAssoc].Enabled := not AssociatedTIM;
end;

procedure TfrmMain.mmMainmmAboutMenu(Sender: PMenu; Item: Integer);
begin
  BringWindowToTop(form.Handle);
  MessageBox(Form.Handle, PAnsiChar('TIM Files Viewer - "TimView+"' + #13#10 +
    'Version: v0.6.2 Final (03.07.2012)'
    + #13#10#13#10 + 'Authors (Lab 313):' + #13#10 +
    '[ Dr. MefistO (Programming) ]' + #13#10 +
    '| E-mail: meffi@lab313.ru |' + #13#10 +
    '| ICQ: 313-62-01 |' + #13#10#13#10 +
    '[ AID_X (Analysis) ]' + #13#10 +
    '[ E-mail: aid_x@lab313.ru ]' + #13#10 +
    '| ICQ: 313-36-75 |' + #13#10#13#10 +
    '[ Oregu (Testing) ]' + #13#10 +
    '[ E-mail: oregu@lab313.ru ]' + #13#10 +
    '| ICQ: 327-302-443 |' + #13#10#13#10 +
    '[ Mark Zart (Testing, Translating) ]' + #13#10 +
    '| E-mail: romsstar@lab313.ru |' + #13#10 +
    '| ICQ: 174-097-192 |' + #13#10#13#10 +
    '[ Brill (Consulting, Testing) ]' + #13#10 +
    '| E-mail: brill@lab313.ru |' + #13#10 +
    '| ICQ: 230-270-183 |' + #13#10#13#10 +
    'Other Regards to:' + #13#10 +
    '[ HoRRoR, Dinmaite, edgbla ]' + #13#10#13#10 +
    'Program Path:' + #13#10 +
    '"' + ExtractFilePath(MainPath) + '"'),
    'About TimView+', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
end;

//Copies TIM to another Place

procedure TfrmMain.CopyTIM(const NewTim: string; Pos, Size: cardinal;
  CurPage: byte);
var
  msvtim: PStream;
  i: cardinal;
  ImageScan: Boolean;
  pFile, pFileStart: PByte;
  hMap, hFile: THandle;
  flsize: cardinal;
begin
  if CurPage = 0 then
  begin
    ImageScan := GetImageScan(FileNamesG.Items[CurNum]);
    flsize := FileSize(FileNamesG.Items[CurNum]);
  end
  else
  begin
    ImageScan := GetImageScan(FileNamesB.Items[CurNum]);
    flsize := FileSize(FileNamesB.Items[CurNum]);
  end;

  if flsize > cMaxSize then
  begin
    BringWindowToTop(form.Handle);
    if MessageBox(Form.Handle, sTooBig, 'Confirmation', MB_YESNO +
      MB_ICONQUESTION + MB_TOPMOST + MB_DEFBUTTON2) = IDNO then
      Exit;
  end;

  msvtim := NewMemoryStream;
  if CurPage = 0 then
    pFile := MapFileRead(FileNamesG.Items[CurNum], hFile, hMap)
  else
    pFile := MapFileRead(FileNamesB.Items[CurNum], hFile, hMap);

  if pFile = nil then
  begin
    AfterScan;
    Free_And_Nil(msvtim);
    //msvtim.free;
    Exit;
  end;
  pFileStart := pFile;
  Inc(pFile, Pos);

  if not ImageScan then
    for i := 1 to Size do
    begin
      msvtim.Write(pFile^, 1);
      Inc(pFile);
    end
  else
    for i := 1 to Size do
    begin
      msvtim.Write(pFile^, 1);
      Inc(pFile);
      CheckCurrentPos(ImageScan, pFileStart, pFile, ccPlus);
    end;
  msvtim.SaveToFile(NewTim, 0, Size);
  Free_And_Nil(msvtim);
  //msvtim.free;
  UnmapFile(pFileStart, hFile, hMap);
        pFileStart := nil;
        hFile := 0;
        hMap := 0;
end;

procedure TfrmMain.mmMainmnSaveTIMMenu(Sender: PMenu; Item: Integer);
var
  bps: string;
begin
  if CurGBPage = 0 then
    case bpp of
      4: bps := 'G_4c';
      41: bps := 'G_4nc';
      8: bps := 'G_8c';
      81: bps := 'G_8nc';
      16: bps := 'G_16nc';
      161: bps := 'G_16c';
      24: bps := 'G_24nc';
      241: bps := 'G_24c';
      48: bps := 'G_Mix04';
      64: bps := 'G_Mix0C';
    end
  else
    case bpp of
      4: bps := 'B_4c';
      41: bps := 'B_4nc';
      8: bps := 'B_8c';
      81: bps := 'B_8nc';
      16: bps := 'B_16nc';
      161: bps := 'B_16c';
      24: bps := 'B_24nc';
      241: bps := 'B_24c';
      48: bps := 'B_Mix04';
      64: bps := 'B_Mix0C';
    end;

  dlgOpen.OpenDialog := false;

  if CurGBPage = 0 then
  begin
  dlgOpen.Filename := ExtractFileName(FileNamesG.Items[CurNum]) + '_' +
    Int2Str(CurNum + 1) + '_' + bps + sTimExt;
    if dlgOpen.Execute then
      CopyTIM(dlgOpen.Filename, FilePosesG[CurNum],
        Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1]), 0);
  end
  else
  begin
  dlgOpen.Filename := ExtractFileName(FileNamesB.Items[CurNum]) + '_' +
    Int2Str(CurNum + 1) + '_' + bps + sTimExt;
    if dlgOpen.Execute then
      CopyTIM(dlgOpen.Filename, FilePosesB[CurNum],
        Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1]), 1);
  end;
end;

procedure TfrmMain.frmKOL1Show(Sender: PObj);
begin
  Config(false);
  mmMain.Items[mmAssoc].Enabled := not AssociatedTIM;
end;

procedure TfrmMain.mmMainmnBMP2TIMMenu(Sender: PMenu; Item: Integer);
var
  bs: string;
begin
  dlgOpen.OpenDialog := true;

  if dlgOpenBMP.Execute then
  begin
    if ConvertBMP2Tim(dlgopenbmp.Filename) then
      if ReadTIM(ChangeFileExt(dlgopenbmp.Filename, '_new.tim'), 0,
        FileSize(ChangeFileExt(dlgopenbmp.Filename, '_new.tim'))) then
      begin
        case bpp of
          4: bs := '_4c';
          8: bs := '_8c';
          41: bs := '_4nc';
          81: bs := '_8nc';
          161: bs := '_16c';
          16: bs := '_16nc';
          241: bs := '_24c';
          24: bs := '_24nc';
        end;
        if CurGBPage = 0 then
        begin
          lvListG.LVAdd(Int2Digs(lvListG.count + 1,6) + '_G' + bs, 0, [], 0, 0, 0);

          if (pal.ClutColors * pal.ClutNum) > 0 then
            lvListG.LVItems[lvListG.Count - 1, 1] :=
              Int2Hex(pal.ClutColors * pal.ClutNum * 2 + $0C +
              img.ImgWidth * img.ImgHeight * 2 +
              SizeOf(Head) + $0C, 6)
          else
            lvListG.LVItems[lvListG.Count - 1, 1] :=
              Int2Hex(img.ImgWidth * img.ImgHeight * 2 + SizeOf(Head) + $0C,
              6);

          lvListG.LVItems[lvListG.Count - 1, 2] :=
            Int2Str(imgRealWidth) + 'x' + Int2Str(img.ImgHeight);

          SetLength(FilePosesG, Length(FilePosesG) + 1);
          FilePosesG[Length(FilePosesG) - 1] := 0;
          FileNamesG.Add(ChangeFileExt(dlgopenbmp.Filename, '_new.tim'));
          lvListG.LVCurItem := lvListG.count - 1;
          lvListGClick(@Self);
        end
        else
        begin
          lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B' + bs, 0, [], 0,
            0, 0);

          if (pal.ClutColors * pal.ClutNum) > 0 then
            lvListB.LVItems[lvListB.Count - 1, 1] :=
              Int2Hex(pal.ClutColors * pal.ClutNum * 2 + $0C +
              img.ImgWidth * img.ImgHeight * 2 +
              SizeOf(Head) + $0C, 6)
          else
            lvListB.LVItems[lvListB.Count - 1, 1] :=
              Int2Hex(img.ImgWidth * img.ImgHeight * 2 + SizeOf(Head) + $0C,
              6);

          lvListB.LVItems[lvListB.Count - 1, 2] :=
            Int2Str(imgRealWidth) + 'x' + Int2Str(img.ImgHeight);

          SetLength(FilePosesB, Length(FilePosesB) + 1);
          FilePosesB[Length(FilePosesB) - 1] := 0;
          FileNamesB.Add(ChangeFileExt(dlgopenbmp.Filename, '_new.tim'));
          lvListB.LVCurItem := lvListB.count - 1;
          lvListGClick(@Self);
        end;
        AfterScan;
      end
      else
        Exit;

  end;
end;

procedure TfrmMain.mmMainmnCheckAssocMenu(Sender: PMenu; Item: Integer);
begin
  mmMain.Items[mnCheckAssoc].Checked := not mmMain.Items[mnCheckAssoc].Checked;
end;

procedure TfrmMain.mmMainmnBMPextractMenu(Sender: PMenu; Item: Integer);
var
  wd, hg, y, x: cardinal;
  z: integer;
  col: cardinal;
  t: Byte;
begin
  z := 0;
  wd := ImgRealWidth;
  hg := img.ImgHeight;

  for y := 1 to hg do
    for x := 1 to wd do
    begin
      case bpp of
        4, 8:
          begin
            bmpImage.DibPixels[x - 1, y - 1] :=
              Clutmas[cbbPalette.CurIndex, Imgdat_4_8_16[z]];
            Inc(z);
          end;
        16, 161:
          begin
            bmpImage.DibPixels[x - 1, y - 1] :=
              TwoBytesToColor(imgdat_4_8_16[z]);
            Inc(z);
          end;
      end;
    end;

  if CurGBPage = 0 then
    ConvertTIM2BMP(ExtractFilePath(MainPath) + sForEdit + '\' +
      ExtractFileName(FileNamesG.Items[CurNum]) + '_' +
      lvlistG.LVItems[CurNum, 0] +
      '_edt' + Int2str(cbbPalette.CurIndex + 1) + sTimExt)
  else
    ConvertTIM2BMP(ExtractFilePath(MainPath) + sForEdit + '\' +
      ExtractFileName(FileNamesB.Items[CurNum]) + '_' +
      lvlistB.LVItems[CurNum, 0] +
      '_edt' + Int2str(cbbPalette.CurIndex + 1) + sTimExt);

  CreateDirectory(PAnsiChar(ExtractFilePath(MainPath) + sForEdit), nil);
  if DirectoryExists(ExtractFilePath(MainPath) + sForEdit + '\') then
    if CurGBPage = 0 then
      CopyTIM(ExtractFilePath(MainPath) + sForEdit + '\' +
        ExtractFileName(FileNamesG.Items[CurNum]) + '_' +
        lvlistG.LVItems[CurNum, 0] +
        '_edt' + Int2str(cbbPalette.CurIndex + 1) + sTimExt,
        FilePosesG[CurNum], Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1]), 0)
    else
      CopyTIM(ExtractFilePath(MainPath) + sForEdit + '\' +
        ExtractFileName(FileNamesB.Items[CurNum]) + '_' +
        lvlistB.LVItems[CurNum, 0] +
        '_edt' + Int2str(cbbPalette.CurIndex + 1) + sTimExt,
        FilePosesB[CurNum], Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1]), 1);

  z := 0;

  for y := 1 to hg do
    for x := 1 to wd do
      case bpp of
        4, 8, 41, 81, 16, 161:
          begin

            if (bpp in [4, 8]) then
              col := Clutmas[cbbPalette.CurIndex,
                imgdat_4_8_16[z] mod pal.ClutColors]
            else if (bpp in [41, 81]) then
              col := Clutmas[0, imgdat_4_8_16[z]]
            else
              col := TwoBytesToColor(imgdat_4_8_16[z]);

            if chkTransparency.Checked then
            begin
              t := GetRValue(col) - (GetRValue(col) div 8) * 8;

              if t = 0 then
              begin
                if (GetRValue(col) = 0) and (GetGValue(col) = 0) and
                  (GetBValue(col) = 0) then
                  bmpImage.DibPixels[x - 1, y - 1] := sbImage.Color
                else
                  bmpImage.DibPixels[x - 1, y - 1] := col;
              end
              else
              begin
                if (GetRValue(col) = 1) and (GetGValue(col) = 0) and
                  (GetBValue(col) = 0) then
                  bmpImage.DibPixels[x - 1, y - 1] := clBlack
                else
                  bmpImage.DibPixels[x - 1, y - 1] := col;
              end;
            end
            else
              bmpImage.DibPixels[x - 1, y - 1] := col;
            Inc(z);
          end;
        24, 241:
          begin
            bmpImage.DibPixels[x - 1, y - 1] := ThreeBytesToColor(imgdat_24[z]);
            Inc(z);
          end;
      end;
end;

procedure TfrmMain.mmMainmnInsertAtPosMenu(Sender: PMenu; Item: Integer);
begin
  dlgOpen.OpenDialog := true;

  if dlgOpen.Execute then
    if ReplaceInImage(dlgOpen.Filename) then
    begin
      lvListGClick(@Self);
      BringWindowToTop(form.Handle);
      MessageBox(Form.Handle, 'TIM entry was replaced succefully!',
       'Information', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
    end;

end;

procedure TfrmMain.mnScanFolderMenu(Sender: PMenu; Item: Integer);
begin
  if dlgOpenDir.Execute then
  begin
    GetFilesList(dlgOpenDir.Path, ListForScan);
    mmMainmmScanRAWMenu(mmMain, mnScanFolder);
  end;
end;

procedure TfrmMain.pbClutPaint(Sender: PControl; DC: HDC);
begin
  if cls then
    PaintClut(True, true);
end;

procedure TfrmMain.pbClutMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
var
  r, g, b: byte;
  i: integer;
  TimWrite, TimMem, TimRead: PStream;
  buf: word;
  TimOffsetInSector, First: Word;
  flsize: cardinal;
  ImageScan: Boolean;
  CurIndex: word;
begin
  if (16 * ((Mouse.Y - 1) div 25) + ((Mouse.X - 1) div 25)) < pal.ClutColors
    then
  begin
    dlgcColor.color :=
      ClutBMP.DIBPixels[(Mouse.X - 1) div 25, (Mouse.Y - 1) div 25];

    for i := 1 to 16 do
      dlgcColor.CustomColors[i] :=
        ClutBMP.DIBPixels[i - 1, (Mouse.Y - 1) div 25];
    if dlgcColor.Execute then
    begin

      r := GetRValue(dlgcColor.Color) div 8;
      g := GetGValue(dlgcColor.Color) div 8;
      b := GetBValue(dlgcColor.Color) div 8;

      r := GetBitsL(r, 0, 5) * 8;
      g := GetBitsL(g, 0, 5) * 8;
      b := GetBitsL(b, 0, 5) * 8;

      ClutBMP.DIBPixels[(Mouse.X - 1) div 25, (Mouse.Y - 1) div 25] := RGB(r, g,
        b);
      PaintClut(True, true);

      TimMem := NewMemoryStream;
      if CurGBPage = 0 then
      begin
        TimRead := NewReadFileStream(FileNamesG.Items[CurNum]);
        ImageScan := GetImageScan(FileNamesG.Items[CurNum]);
      end
      else
      begin
        TimRead := NewReadFileStream(FileNamesB.Items[CurNum]);
        ImageScan := GetImageScan(FileNamesB.Items[CurNum]);
      end;

      if CurGBPage = 0 then
        flsize := FileSize(FileNamesG.Items[CurNum])
      else
        flsize := FileSize(FileNamesB.Items[CurNum]);

      if flsize > cMaxSize then
      begin
        BringWindowToTop(form.Handle);
        if MessageBox(Form.Handle, sTooBig, 'Confirmation', MB_YESNO +
          MB_ICONQUESTION + MB_TOPMOST + MB_DEFBUTTON2) = IDNO then
        begin
          Free_And_Nil(TimRead);
          //TimRead.free;
          Free_And_Nil(TimMem);
          //TimMem.free;
          Exit;
        end;
      end;

      if CurGBPage = 0 then
        flsize := Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1])
      else
        flsize := Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1]);

      if not ImageScan then
      begin
        if CurGBPage = 0 then
          TimRead.Seek(filePosesG[CurNum], spBegin)
        else
          TimRead.Seek(filePosesB[CurNum], spBegin);
        Stream2Stream(TimMem, TimRead, flsize);
      end
      else
      begin
        if CurGBPage = 0 then
          TimOffsetInSector := fileposesG[CurNum] mod Sector - info1
        else
          TimOffsetInSector := fileposesB[CurNum] mod Sector - info1;

        First := sectdata - TimOffsetInSector;

        if CurGBPage = 0 then
          TimRead.Seek(fileposesG[CurNum], spBegin)
        else
          TimRead.Seek(fileposesB[CurNum], spBegin);

        Stream2Stream(TimMem, TimRead, First);
        TimRead.seek(eccedc, spCurrent);

        while abs(flsize - TimMem.position) >= sectdata do
        begin
          TimRead.seek(info1, spCurrent);
          Stream2Stream(TimMem, TimRead, sectdata);
          TimRead.seek(eccedc, spCurrent);
        end;
        TimRead.seek(info1, spCurrent);
        Stream2Stream(TimMem, TimRead, flsize - TimMem.position);
      end;
      Free_And_Nil(TimRead);
      //TimRead.Free;
      TimMem.SaveToFile(ExtractFilePath(MainPath) + 'presave.tmp', 0,
        TimMem.Size);
      Free_And_Nil(TimMem);
      //TimMem.free;

      CurIndex := cbbpalette.CurIndex;

      ReadTIM(ExtractFilePath(MainPath) + 'presave.tmp', 0,
        FileSize(ExtractFilePath(MainPath) + 'presave.tmp'));

      TimWrite := NewReadWriteFileStream(ExtractFilePath(MainPath) +
        'presave.tmp');
      TimWrite.Seek(0, spBegin);
      TimWrite.Seek(SizeOf(head), spcurrent);
      TimWrite.Seek(SizeOf(pal), spcurrent);
      TimWrite.Seek(pal.ClutColors * CurIndex * 2, spcurrent);
      TimWrite.Seek((16 * ((Mouse.Y - 1) div 25) + ((Mouse.X - 1) div 25)) * 2,
        spcurrent);

      buf := ColorTo2Bytes(RGB(r, g, b));
      TimWrite.Write(buf, 2);

      Free_And_Nil(TimWrite);
      //TimWrite.Free;
      ReplaceInImage(ExtractFilePath(MainPath) + 'presave.tmp');
      DeleteFile(PAnsiChar(ExtractFilePath(MainPath) + 'presave.tmp'));
    end;

  end;
end;

procedure TfrmMain.pbClutMouseMove(Sender: PControl;
  var Mouse: TMouseEventData);
var
  col: cardinal;
begin
  if (16 * ((Mouse.Y - 1) div 25) + ((Mouse.X - 1) div 25)) < pal.ClutColors
    then
  begin
    col := ClutBMP.DIBPixels[(Mouse.X - 1) div 25, (Mouse.Y - 1) div 25];
    pnlRGBClut.caption := Format('R: %s; G: %s; B: %s', [
      Int2Hex(GetRValue(col), 2),
        Int2Hex(GetGValue(col), 2),
        Int2Hex(GetBValue(col), 2)
        ]);
  end;
end;

procedure TfrmMain.mmMainmnCreateBakMenu(Sender: PMenu; Item: Integer);
begin
  mmMain.Items[mnCreateBak].Checked := not mmMain.Items[mnCreateBak].Checked;
end;

procedure TfrmMain.chkRandomClick(Sender: PObj);
var
  origbit: byte;
begin
  origbit := 0;
  if head.Sign = $10 then
    ReadBpp
  else
    Exit;

  case head.Bpp of
    $00: origbit := 41;
    $08: origbit := 4;
    $01: origbit := 81;
    $09: origbit := 8;
    $02: origbit := 16;
    $0A: origbit := 161;
    $03: origbit := 24;
    $0B: origbit := 241;
  end;

  if (origbit = 16) or (origbit = 24) or (origbit = 41) or (origbit = 81) or
    (origbit = 48) then
    chkRandom.Checked := True;

  btnSaveAsRandom.Enabled := not chkRandom.Checked;
  btnGenPal.Enabled := chkRandom.Checked;
  cbbRandPalNum.Enabled := chkRandom.Enabled or chkRandom.Checked;

  FastPaint := False;
  if chkRandom.Checked then
  tcPages.TC_Items[2] := 'CLUT'
  else
  if origbit = 4 then
  tcPages.TC_Items[2] := 'CLUT [1]';

  if chkRandom.Checked then
  begin
    case bpp of
      4: bpp := 41;
      8: bpp := 81;
    end;
    PaintClut(false, false);
    PaintImage;
  end
  else
  begin
    case head.bpp of
      $08, $0A: bpp := 4;
      $09, $0B: bpp := 8;
    end;
    PaintClut(True, false);
    PaintImage;
  end;
end;

procedure TfrmMain.pbClutMouseUp(Sender: PControl;
  var Mouse: TMouseEventData);
var
  curRow: byte;
  bmp: PBitmap;
  x: byte;
  curbpp: byte;
begin
  case cbbMode.CurIndex of
    1: curbpp := 4;
    2: curbpp := 8;
  else
    curbpp := bpp;
  end;

  if ((16 * ((Mouse.Y - 1) div 25) + ((Mouse.X - 1) div 25)) < pal.ClutColors)
    and (curbpp = 4) then
  begin
    curRow := (Mouse.Y - 1) div 25 + 1;
    tcPages.TC_Items[2] := Format('CLUT [%d]', [curRow]);

    bmp := NewDIBBitmap(512, 1, pf24bit);

    for x := 0 to 15 do
      bmp.DIBPixels[x, 0] := ClutBMP.DIBPixels[x, curRow - 1];

    bmp.SaveToFile(ExtractFilePath(MainPath) + sPalettes + '\' +
                   Int2Digs(16 + curRow, 2) + '.bmp');
                   
    Free_And_Nil(bmp);
    //bmp.free;

    case bpp of
      4, 8: bpp := 41;
    end;
    FastPaint := false;
    PaintClut(false, false);
    PaintImage;

    case head.bpp of
      $08: bpp := 4;
      $09: bpp := 8;
    end;
    PaintClut(true, true);
  end;
end;

procedure TfrmMain.tpImageClick(Sender: PObj);
begin
  FastPaint := false;
  PaintImage;
end;

procedure TfrmMain.cbbModeChange(Sender: PObj);
var
  origbit: byte;
begin
  origbit := 0;
  if head.Sign = $10 then
    ReadBpp
  else
    Exit;

  if Head.Bpp in [$04, $0C] then
    Exit;

  case head.Bpp of
    $00: origbit := 41;
    $08: origbit := 4;
    $01: origbit := 81;
    $09: origbit := 8;
    $02: origbit := 16;
    $0A: origbit := 161;
    $03: origbit := 24;
    $0B: origbit := 241;
  end;

  case cbbMode.CurIndex of
    0:
      begin
        if CurGBPage = 0 then
        begin
          if ReadTIM(FileNamesG.Items[CurNum], fileposesG[CurNum],
            Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1])) then
            PaintClut(True, false)
          else
            Exit;
        end
        else
        begin
          if ReadTIM(FileNamesB.Items[CurNum], fileposesB[CurNum],
            Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1])) then
            PaintClut(True, false)
          else
            Exit;
        end;

        FastPaint := False;
        PaintImage;
        chkRandom.Checked := (origbit = 41) or (origbit = 81);
        chkRandom.Enabled := not (origbit in [16, 24, 241, 161]);
        cbbRandPalNum.Enabled := chkRandom.Enabled or chkRandom.Checked;
        btnSaveAsRandom.Enabled := not chkRandom.Checked;

        if origbit = 4 then
          tcPages.TC_Items[2] := 'CLUT [1]'
        else
          tcPages.TC_Items[2] := 'CLUT';
      end;
    1:
      begin
        case head.bpp of
          $08..$0B:
            begin
              head.bpp := $08;
              chkRandom.Checked := false;
            end;
          $00..$03:
            begin
              head.bpp := $00;
              chkRandom.Checked := true;
              chkRandom.Enabled := false;
            end;
        end;

        if CurGBPage = 0 then
        begin
          if ReadTIM(FileNamesG.Items[CurNum], fileposesG[CurNum],
            Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1]), true) then
            case origbit of
              4, 8, 81: bpp := 41;
              161, 241: bpp := 4;
            end
          else
            Exit;
        end
        else
        begin
          if ReadTIM(FileNamesB.Items[CurNum], fileposesB[CurNum],
            Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1]), true) then
            case origbit of
              4, 8, 81: bpp := 41;
              161, 241: bpp := 4;
            end
          else
            Exit;
        end;

        //  PaintClut(false, false);
         // FastPaint := False;
        //  PaintImage;

        chkRandomClick(@self);

        if not chkRandom.Checked then
          tcPages.TC_Items[2] := 'CLUT [1]';
      end;
    2:
      begin
        case head.bpp of
          $08..$0B:
            begin
              head.bpp := $09;
              chkRandom.Enabled := true;
            end;
          $00..$03:
            begin
              head.bpp := $01;
              chkRandom.Enabled := false;
            end;
        end;

        if CurGBPage = 0 then
        begin
          if ReadTIM(FileNamesG.Items[CurNum], fileposesG[CurNum],
            Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1]), true) then
            case origbit of
              4, 8, 41: bpp := 81;
              161, 241: bpp := 8;
            end
          else
            Exit;
        end
        else
        begin
          if ReadTIM(FileNamesB.Items[CurNum], fileposesB[CurNum],
            Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1]), true) then
            case origbit of
              4, 8, 41: bpp := 81;
              161, 241: bpp := 8;
            end
          else
            Exit;
        end;

        //  PaintClut(false, false);
        //  PaintImage;

        chkRandomClick(@self);
        tcPages.TC_Items[2] := 'CLUT';
      end;
    3:
      begin
        case head.bpp of
          $08..$0B: head.bpp := $0A;
          $00..$03: head.bpp := $02;
        end;

        FastPaint := False;

        if CurGBPage = 0 then
        begin
          if ReadTIM(FileNamesG.Items[CurNum], fileposesG[CurNum],
            Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1]), true) then
            bpp := 16
          else
            Exit;
        end
        else
        begin
          if ReadTIM(FileNamesB.Items[CurNum], fileposesB[CurNum],
            Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1]), true) then
            bpp := 16
          else
            Exit;
        end;

        PaintImage;
        chkRandom.Enabled := False;
        chkRandom.Checked := false;
        btnGenPal.Enabled := false;
        btnSaveAsRandom.Enabled := false;
        cbbRandPalNum.Enabled := false;
        tcPages.TC_Items[2] := 'CLUT';
      end;
    4:
      begin
        case head.bpp of
          $08..$0B: head.bpp := $0B;
          $00..$03: head.bpp := $03;
        end;

        FastPaint := False;

        if CurGBPage = 0 then
        begin
          if ReadTIM(FileNamesG.Items[CurNum], fileposesG[CurNum],
            Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1]), true) then
            bpp := 24
          else
            Exit;
        end
        else
        begin
          if ReadTIM(FileNamesB.Items[CurNum], fileposesB[CurNum],
            Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1]), true) then
            bpp := 24
          else
            Exit;
        end;

        PaintImage;
        chkRandom.Enabled := False;
        chkRandom.Checked := false;
        btnGenPal.Enabled := false;
        btnSaveAsRandom.Enabled := false;
        cbbRandPalNum.Enabled := false;
        tcPages.TC_Items[2] := 'CLUT';
      end;
  end;
end;

procedure TfrmMain.mmMainmnForumMenu(Sender: PMenu; Item: Integer);
var
 exec : function(hWnd: HWnd; Operation, FileName, Parameters,
                 Directory: PAnsiChar; ShowCmd: Integer): HINST; stdcall;
begin
exec := GetProcAddress(LoadLibrary('shell32.dll'),'ShellExecuteA');
exec(0,'open','http://lab313.ru',nil,nil,SW_SHOWMAXIMIZED);
end;

procedure TfrmMain.mmMainmnSaveAllPalsMenu(Sender: PMenu; Item: Integer);
var
  i, a: word;
  pngThread: PThread;
begin
  CreateDirectory(PAnsiChar(ExtractFilePath(MainPath) + 'images'), nil);

  if cbbPalette.Count>0 then
  begin
  a := cbbpalette.CurIndex;
  for i := 1 to cbbpalette.Count do
  begin
    cbbPalette.CurIndex := i - 1;
    FastPaint := False;
    PaintClut(false, false);
    PaintImage(False);

  pngThread := NewThreadAutoFree(thPngSaving);
  pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
  pngThread.Resume;

        while not pngThread.Terminated do
          Form.ProcessPendingMessages;

  end;

  cbbPalette.CurIndex := a;
  cbbPaletteChange(@self);
  end
  else
  begin
  pngThread := NewThreadAutoFree(thPngSaving);
  pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
  pngThread.Resume;

  while not pngThread.Terminated do
      Form.ProcessPendingMessages;  
  end;

  BringWindowToTop(form.Handle);
  MessageBox(Form.Handle, PAnsiChar('File(s) succesfully saved at "' +
    ExtractFilePath(MainPath) + 'images\" directory!'), 'Good',
    MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
end;

function TfrmMain.thPngSaving(Sender: PThread): Integer;
var
  name : string;
begin
  result := 0;
  cls := false;
  if CurGBPage = 0 then
    name := ExtractFilePath(MainPath) + 'images\' +
      ExtractFileName(FileNamesG.Items[CurNum]) + '_' +
      lvlistG.LVItems[CurNum, 0] +
      '_image' + Int2Str(cbbpalette.CurIndex + 1) + '.png'
  else
    name := ExtractFilePath(MainPath) + 'images\' +
      ExtractFileName(FileNamesB.Items[CurNum]) + '_' +
      lvlistB.LVItems[CurNum, 0] +
      '_image' + Int2Str(cbbpalette.CurIndex + 1) + '.png';
    pngImage.SaveToFile(name);
  cls := true;
end;

function TfrmMain.thScanThread(Sender: PThread): Integer;
var
  i: integer;
  j: Cardinal;
  // fsm, fsr: PStream;
  bps: string;
  k: cardinal;
  flsz: cardinal;
  ScanResults: PStream;
  FileMem, StartPos: PByte;
  hFile, hMap: THandle;
  ImageScan: Boolean;
  posit, FileCRC: cardinal;
  //extr: Boolean;
  goodbad, CurScanName, fromfile: string;
  goods, bads: Cardinal;
  //cddvd: Boolean;
const
  vers = '062f';
begin
  dlgOpen.OpenDialog := true;
  result := 0;

  if Pos(#$0D#$0A, ListForScan.Text) = 0 then
    if dlgOpen.Execute then
      ListForScan.Add(dlgopen.Filename)
    else
      Exit;

  ClearAll;

  mmMain.Items[mnFile].Enabled := false;

  lvlistG.Enabled := False;
  lvlistB.Enabled := False;

  for j := 1 to ListForScan.Count do
  begin
    CurScanName := ListForScan.Items[j - 1];
    Form.SimpleStatusText := Format('Current File: "%s"', [CurScanName]);

    flsz := FileSize(CurScanName);

    if flsz > cMaxSize then
    begin
      BringWindowToTop(form.Handle);
      if MessageBox(Form.Handle, sTooBig, sConfirmation, MB_YESNO +
        MB_ICONQUESTION + MB_TOPMOST + MB_DEFBUTTON2) = IDNO then
        Continue;
    end;

    ImageScan := GetImageScan(CurScanName);

    lblPos.Caption := 'Calculating CRC32';
    FileCRC := FileCRC32(CurScanName);
    lblPos.Caption := '0000000000';

    if DirectoryExists(ExtractFilePath(MainPath) + sResults) then
    begin
      if FileExists(ExtractFilePath(MainPath) + 'results\' +
        ExtractFileName(CurScanName) + '.fsr') then
      begin
        ScanResults := NewReadFileStream(ExtractFilePath(MainPath) +
          'results\' + ExtractFileName(CurScanName) + '.fsr');

        if (ScanResults.ReadStr = vers) and
           (cardinal(Hex2Int(ScanResults.ReadStr)) = FileCRC) then
        begin
          goodbad := ScanResults.ReadStr;
          while (goodbad = 'good') or (goodbad = 'bad') do
          begin
            fromfile := ScanResults.ReadStr;
            fromfile := Copy(fromfile, Pos('_', fromfile),
              Length(fromfile) - Pos('_', fromfile) + 1);
            if goodbad = 'good' then
            begin
              lvListG.LVAdd(Int2Digs(lvListG.Count + 1,6) + fromfile, 0, [], 0,
                0, 0);
              lvListG.LVItems[lvListG.Count - 1, 1] := ScanResults.ReadStr;
              lvListG.LVItems[lvListG.Count - 1, 2] := ScanResults.ReadStr;
              SetLength(FilePosesG, Length(FilePosesG) + 1);
              FilePosesG[High(FilePosesG)] := Str2Int(ScanResults.ReadStr);
              FileNamesG.Add(CurScanName);
            end
            else
            begin
              lvListB.LVAdd(Int2Digs(lvListB.Count + 1,6) + fromfile, 0, [], 0,
                0, 0);
              lvListB.LVItems[lvListB.Count - 1, 1] := ScanResults.ReadStr;
              lvListB.LVItems[lvListB.Count - 1, 2] := ScanResults.ReadStr;
              SetLength(FilePosesB, Length(FilePosesB) + 1);
              FilePosesB[High(FilePosesB)] := Str2Int(ScanResults.ReadStr);
              FileNamesB.Add(CurScanName);
            end;
            goodbad := ScanResults.ReadStr;
          end;
          Free_And_Nil(ScanResults);
          Continue;
        end
        else
        begin
          Free_And_Nil(ScanResults);
          ScanResults := NewMemoryStream;
          ScanResults.WriteStr(vers + #13#10);
          ScanResults.WriteStr(Int2Hex(FileCRC, 8) + #13#10);
        end;
      end
      else
      begin
        Free_And_Nil(ScanResults);
        ScanResults := NewMemoryStream;
        ScanResults.WriteStr(vers + #13#10);
        ScanResults.WriteStr(Int2Hex(FileCRC, 8) + #13#10);
      end;
    end
    else
    begin
      Free_And_Nil(ScanResults);
      ScanResults := NewMemoryStream;
      ScanResults.WriteStr(vers + #13#10);
      ScanResults.WriteStr(Int2Hex(FileCRC, 8) + #13#10);
    end;

    btnStop.Enabled := true;
    FileMem := MapFileRead(CurScanName, hFile, hMap);
    StartPos := FileMem;

    if FileMem = nil then
    begin
      if ((lvlistG.count = 0) and (CurGBPage = 0)) or
        ((lvlistB.count = 0) and (CurGBPage = 1)) then
      begin
        BringWindowToTop(form.Handle);
        MessageBox(Form.Handle,
          PChar(Format('Unable to open this file for scanning!' +
          #13#10 + 'If it is image-file, try to unmount it in this programs:' +
          #13#10 + '[Daemon Tools], [Alcohol 120%] and etc.', [])), 'Error',
          MB_OK + MB_ICONSTOP + MB_TOPMOST);
      end;
      UnmapFile(StartPos, hFile, hMap);
        StartPos := nil;
        hFile := 0;
        hMap := 0;
      Continue;
    end;

    pbScan.MaxProgress := flsz;
    pbScan.Progress := 0;

    lblPos.Caption := 'Scanning file...';

    goods := 0;
    bads := 0;

    i := -1;
    while i < integer(flsz) do
    begin
      ClearAll;
      Inc(i);
      if (i mod (15 * 1024 * 1024)) = 0 then
        pbScan.Progress := i;
      if stop then
      begin
        UnmapFile(StartPos, hFile, hMap);
        StartPos := nil;
        hFile := 0;
        hMap := 0;
        Break;
      end;
      FileMem := StartPos;
      //CheckCurrentPos(ImageScan, StartPos, FileMem, ccPlus);
      Inc(FileMem, i);
      CheckCurrentPos(ImageScan, StartPos, FileMem, ccPlus);

      posit := Cardinal(FileMem) - Cardinal(StartPos);

      ReadFromMem(ImageScan, flsz, rtHead, StartPos, FileMem);

      if ((head.Sign <> $10) or ((head.Version <> $00) and
        (head.Version <> $01)) or
        (not (head.Bpp in
        [$08, $09, $0A, $0B, $02, $03, $00, $01, $04, $0C]))) then
        Continue;

      if (head.Bpp in [$08, $09, $0A, $0B, $0C]) then
      begin
        ReadFromMem(ImageScan, flsz, rtPal, StartPos, FileMem);

        if (pal.ClutColors > 512) or (pal.ClutNum > 1024) or
          (pal.ClutColors = 0) or (pal.ClutNum = 0) then
          continue;

        for k := 1 to (pal.ClutColors * pal.ClutNum * 2) do
        begin
          CheckCurrentPos(ImageScan, StartPos, FileMem, ccPlus);
          Inc(FileMem);
        end;
      end;

      ReadFromMem(ImageScan, flsz, rtImage, StartPos, FileMem);

      if (img.ImgWidth = 0) or (img.ImgHeight = 0) then
        Continue;

      case head.Bpp of
        $08, $00: ImgRealWidth := word(img.ImgWidth * 4);
        $09, $01: ImgRealWidth := word(img.ImgWidth * 2);
        $0A, $02, $04, $0C: ImgRealWidth := word(img.ImgWidth * 1);
        $0B, $03: ImgRealWidth := word(Round(img.ImgWidth * 2 / 3));
      end;

      if (ImgRealWidth = 0) or (Img.ImgWidth > $400) or
        (img.ImgHeight > $400) then
        Continue;

      if (pal.ClutColors * pal.ClutNum)>0 then
      begin
      if ((pal.ClutColors * pal.ClutNum * 2 + $0C + img.ImgWidth *
           img.ImgHeight * 2 + SizeOf(Head) + $0C) > flsz) then
        Continue;
      end
      else
      begin
      if ((img.ImgWidth * img.ImgHeight * 2 + SizeOf(Head) + $0C) > flsz)
      then Continue;
      end;

      if ((head.Reserved1 <> 0) or (head.Reserved2 <> 0) or
        (head.Reserved3 <> 0) or (head.Reserved4 <> 0) or
        (head.Reserved5 <> 0)) or ((head.Bpp in [$00, $01, $04, $0C]) and
        (img.ImgLen<>(img.ImgWidth * img.ImgHeight * 2 + $0C))) then
        Continue;

      bpp := 0;
      HeadBpp2Bpp;

      CreateDirectory(PAnsiChar(ExtractFilePath(MainPath) + sResults), nil);

      if (img.ImgLen<>(img.ImgWidth * img.ImgHeight * 2 + $0C)) then
      begin
        case bpp of
          4: lvListB.LVAdd(int2Digs(lvListB.count + 1,6) + '_B_4c', 0, [], 0,
              0, 0);
          8: lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B_8c', 0, [], 0,
              0, 0);
          41: lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B_4nc', 0, [], 0,
              0, 0);
          81: lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B_8nc', 0, [], 0,
              0, 0);
          16: lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B_16nc', 0, [], 0,
              0, 0);
          161: lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B_16c', 0, [], 0,
              0, 0);
          24: lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B_24nc', 0, [], 0,
              0, 0);
          241: lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B_24c', 0, [], 0,
              0, 0);
          48: lvListB.LVAdd(Int2Digs(lvListB.count + 1,6) + '_B_Mix04', 0, [], 0,
              0, 0);
          64: lvListB.LVAdd(int2Digs(lvListB.count + 1,6) + '_B_Mix0C', 0, [], 0,
          0, 0);
        end;
        Inc(bads);
        ScanResults.WriteStr('bad' + #13#10);
        goodbad := lvListB.LVItems[lvListB.count - 1, 0];
        ScanResults.WriteStr(Int2Digs(bads,6) + Copy(goodbad, Pos('_', goodbad),
          Length(goodbad) - Pos('_', goodbad) + 1) + #13#10);

        if (pal.ClutColors * pal.ClutNum) > 0 then
          lvListB.LVItems[lvListB.Count - 1, 1] :=
            Int2Hex(pal.ClutColors * pal.ClutNum * 2 + $0C +
            img.ImgWidth * img.ImgHeight * 2 +
            SizeOf(Head) + $0C, 6)
        else
          lvListB.LVItems[lvListB.Count - 1, 1] :=
            Int2Hex(img.ImgWidth * img.ImgHeight * 2 +
            SizeOf(Head) + $0C, 6);

        ScanResults.WriteStr(lvListB.LVItems[lvListB.count - 1, 1] + #13#10);

        lvListB.LVItems[lvListB.Count - 1, 2] :=
          Int2Str(imgRealWidth) + 'x' + Int2Str(img.ImgHeight);

        ScanResults.WriteStr(lvListB.LVItems[lvListB.count - 1, 2] + #13#10);

        SetLength(FilePosesB, Length(FilePosesB) + 1);
        FilePosesB[Length(FilePosesB) - 1] := posit;

        ScanResults.WriteStr(Int2Str(posit) + #13#10);

        FileNamesB.Add(CurScanName);
      end
      else
      begin
        case bpp of
          4: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_4c', 0, [], 0,
              0, 0);
          8: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_8c', 0, [], 0,
              0, 0);
          41: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_4nc', 0, [], 0,
              0, 0);
          81: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_8nc', 0, [], 0,
              0, 0);
          16: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_16nc', 0, [], 0,
              0, 0);
          161: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_16c', 0, [], 0,
              0, 0);
          24: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_24nc', 0, [], 0,
              0, 0);
          241: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_24c', 0, [], 0,
              0, 0);
          48: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_Mix04', 0, [], 0,
              0, 0);
          64: lvListG.LVAdd(int2Digs(lvListG.count + 1,6) + '_G_Mix0C', 0, [], 0,
          0, 0);
        end;
        Inc(goods);
        ScanResults.WriteStr('good' + #13#10);
        goodbad := lvListG.LVItems[lvListG.count - 1, 0];
        ScanResults.WriteStr(Int2Str(goods) + Copy(goodbad, Pos('_', goodbad),
          Length(goodbad) - Pos('_', goodbad) + 1) + #13#10);

        if (pal.ClutColors * pal.ClutNum) > 0 then
          lvListG.LVItems[lvListG.Count - 1, 1] :=
            Int2Hex(pal.ClutColors * pal.ClutNum * 2 + $0C +
            img.ImgWidth * img.ImgHeight * 2 +
            SizeOf(Head) + $0C, 6)
        else
          lvListG.LVItems[lvListG.Count - 1, 1] :=
            Int2Hex(img.ImgWidth * img.ImgHeight * 2 +
            SizeOf(Head) + $0C, 6);

        ScanResults.WriteStr(lvListG.LVItems[lvListG.count - 1, 1] + #13#10);

        lvListG.LVItems[lvListG.Count - 1, 2] :=
          Int2Str(imgRealWidth) + 'x' + Int2Str(img.ImgHeight);

        ScanResults.WriteStr(lvListG.LVItems[lvListG.count - 1, 2] + #13#10);

        SetLength(FilePosesG, Length(FilePosesG) + 1);
        FilePosesG[Length(FilePosesG) - 1] := posit;

        ScanResults.WriteStr(Int2Str(posit));
        ScanResults.WriteStr(#13#10);

        FileNamesG.Add(CurScanName);
      end;

      if mmMain.Items[mnAutoExtract].Checked then
      begin
        bps := goodbad;
        CreateDirectory(PAnsiChar(ExtractFilePath(MainPath) + sExtracted),
        nil);
        if DirectoryExists(ExtractFilePath(MainPath) + sExtracted) and
          (ExtractFilePath(CurScanName) <>
          ExtractFilePath(MainPath) + sExtracted + '\') then
          if Pos('G', bps) > 0 then
          begin
            CurNum := lvlistG.count - 1;
            CopyTIM(ExtractFilePath(MainPath) + sExtracted + '\' +
              ExtractFileName(CurScanName) + '_' + bps + sTimExt, posit,
              Hex2Int(lvlistG.LVItems[lvlistG.count - 1, 1]), 0)
          end
          else
          begin
            CurNum := lvlistB.count - 1;
            CopyTIM(ExtractFilePath(MainPath) + sExtracted + '\' +
              ExtractFileName(CurScanName) + '_' + bps + sTimExt, posit,
              Hex2Int(lvlistB.LVItems[lvlistB.count - 1, 1]), 1);
          end;
      end;

      FileMem := PByte(Cardinal(StartPos) + posit);

      i := cardinal(FileMem) - cardinal(StartPos);
      lblFiles.Caption := Format('%d (G)/%d (B)',
        [lvListG.LVCount, lvListB.LVCount]);
    end;
    if StartPos<>nil then
    begin
    UnmapFile(StartPos, hFile, hMap);
    StartPos := nil;
    hFile := 0;
    hMap := 0;
    end;
    if not stop then
    ScanResults.SaveToFile(ExtractFilePath(MainPath) + 'results\' +
      ExtractFileName(CurScanName) + '.fsr', 0,
      ScanResults.Size);
    Free_And_Nil(ScanResults);
  end;
  AfterScan;

  MessageBox(0, PAnsiChar('Scan complete!'),
    'Information', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
end;

procedure TfrmMain.lvListGColumnClick(Sender: PControl; Idx: Integer);
begin
  if Idx = 1 then
  begin
    if CurGBPage = 0 then
    begin
      if lvlistG.LVOptions <> [lvoGridLines, lvoRowSelect, lvoRegional,
         lvoInfoTip, lvoUnderlineHot, lvoSortAscending]
          then
        lvlistG.LVOptions := [lvoGridLines, lvoRowSelect, lvoRegional,
        lvoInfoTip, lvoUnderlineHot, lvoSortAscending]
      else
        lvlistG.LVOptions := [lvoGridLines, lvoRowSelect, lvoRegional,
        lvoInfoTip, lvoUnderlineHot, lvoSortDescending];
      lvlistG.LVSortColumn(idx);
      Exit;
    end
    else
    begin
      if lvlistB.LVOptions <> [lvoGridLines, lvoRowSelect, lvoRegional,
         lvoInfoTip, lvoUnderlineHot, lvoSortAscending]
          then
        lvlistB.LVOptions := [lvoGridLines, lvoRowSelect, lvoRegional,
        lvoInfoTip, lvoUnderlineHot, lvoSortAscending]
      else
        lvlistB.LVOptions := [lvoGridLines, lvoRowSelect, lvoRegional,
        lvoInfoTip, lvoUnderlineHot, lvoSortDescending];
      lvlistB.LVSortColumn(idx);
      Exit;
    end;
  end;
  if Idx = 0 then
  begin
    if CurGBPage = 0 then
    begin
      lvListG.OnCompareLVItems := lvListSortBG;
      lvListG.LVSort;
    end
    else
    begin
      lvListB.OnCompareLVItems := lvListSortBG;
      lvListB.LVSort;
    end;
    Exit;
  end;
  if Idx = 2 then
  begin
    if CurGBPage = 0 then
    begin
      lvListG.OnCompareLVItems := lvListCompareWH;
      lvListG.LVSort;
    end
    else
    begin
      lvListB.OnCompareLVItems := lvListCompareWH;
      lvListB.LVSort;
    end;
    Exit;
  end;
end;

function TfrmMain.lvListCompareWH(Sender: PControl; Idx1,
  Idx2: Integer): Integer;
var
  w1, h1, w2, h2, _s1, _s2: integer;
  s1, s2: string;
begin
  with Sender^ do
  begin
    w1 := Str2Int(Copy(LVItems[Idx1, 2], 1, Pos('x', LVItems[Idx1, 2])));
    h1 := Str2Int(Copy(LVItems[Idx1, 2], Pos('x', LVItems[Idx1, 2]) + 1,
      Length(LVItems[Idx1, 2]) - Pos('b', LVItems[Idx1, 2])));
    w2 := Str2Int(Copy(LVItems[Idx2, 2], 1, Pos('x', LVItems[Idx2, 2])));
    h2 := Str2Int(Copy(LVItems[Idx2, 2], Pos('x', LVItems[Idx2, 2]) + 1,
      Length(LVItems[Idx2, 2]) - Pos('b', LVItems[Idx2, 2])));
    s1 := Int2Hex(w1, 4) + Int2Hex(h1, 4);
    s2 := Int2Hex(w2, 4) + Int2Hex(h2, 4);
    _s1 := hex2int(s1);
    _s2 := hex2int(s2);
  end;
  result := _s1 - _s2;
  form.ProcessPendingMessages;
end;

procedure TfrmMain.cbbZoomChange(Sender: PObj);
begin
  case cbbZoom.CurIndex of
    0:
      begin
        ZoomValue := 10;
        FastPaint := false;
        PaintImage;
      end;
    1:
      begin
        ZoomValue := 15;
        FastPaint := false;
        PaintImage;
      end;
    2:
      begin
        ZoomValue := 20;
        FastPaint := false;
        PaintImage;
      end;
    3:
      begin
        ZoomValue := 25;
        FastPaint := false;
        PaintImage;
      end;
    4:
      begin
        ZoomValue := 30;
        FastPaint := false;
        PaintImage;
      end;
    5:
      begin
        ZoomValue := 35;
        FastPaint := false;
        PaintImage;
      end;
    6:
      begin
        ZoomValue := 40;
        FastPaint := false;
        PaintImage;
      end;
    7:
      begin
        ZoomValue := 100;
        FastPaint := false;
        PaintImage;
      end;
  end;
end;

function TfrmMain.lvListSortBG(Sender: PControl; Idx1,
  Idx2: Integer): Integer;
var
  id1, id2: integer;
begin
  with Sender^ do
  begin
    id1 := Str2Int(Copy(LVItems[Idx1, 0], 1, Pos('_', LVItems[Idx1, 0]) - 1));

    id2 := Str2Int(Copy(LVItems[Idx2, 0], 1, Pos('_', LVItems[Idx2, 0]) - 1));
  end;
  result := id1 - id2;
  form.ProcessPendingMessages;
end;

procedure TfrmMain.chkTransparencyClick(Sender: PObj);
begin
  FastPaint := False;
  PaintImage;
end;

procedure TfrmMain.mmMainmnAutoExtractMenu(Sender: PMenu; Item: Integer);
begin
  mmMain.Items[mnAutoExtract].Checked := not
    mmMain.Items[mnAutoExtract].Checked;
end;

procedure TfrmMain.tcGBClick(Sender: PObj);
begin
  CurGBPage := tcGB.CurIndex;
end;

procedure TfrmMain.lvListBClick(Sender: PObj);
begin
  CurGBPage := 1;
  lvListGClick(@Self);
end;

procedure TfrmMain.lvInfoClick(Sender: PObj);
begin
  if (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Version') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Reserved1') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Reserved2') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Reserved3') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Reserved4') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Reserved5') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'BPP') then
  begin
    edtValue.Enabled := true;
    edtValue.Text := int2str(hex2int(lvInfo.LVItems[lvInfo.CurIndex, 1]));
    btnSaveEdit.Enabled := true;
    ToChange := lvinfo.LVCurItem;
    Exit;
  end;
  if (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Palette Org X') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Palette Org Y') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Number of Colors in CLUT') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Number of CLUTs') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Palette Org X') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Palette Org Y') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Image Org X') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Image Org Y') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Image Width') or
    (lvInfo.LVItems[lvInfo.CurIndex, 0] = 'Image Height') then
  begin
    edtValue.Enabled := true;
    edtValue.Text := int2str(hex2int(lvInfo.LVItems[lvInfo.CurIndex, 1]));
    btnSaveEdit.Enabled := true;
    ToChange := lvinfo.LVCurItem;
    Exit;
  end;
  edtValue.Enabled := False;
  btnSaveEdit.Enabled := False;
  ToChange := 0;
end;

procedure TfrmMain.btnSaveEditClick(Sender: PObj);
var
  TimWrite, TimMem, TimRead: PStream;
  TimOffsetInSector, First: Word;
  flsize: cardinal;
  ImageScan: Boolean;
  orbit: byte;
begin
  TimMem := NewMemoryStream;
  if CurGBPage = 0 then
  begin
    TimRead := NewReadFileStream(FileNamesG.Items[CurNum]);
    ImageScan := GetImageScan(FileNamesG.Items[CurNum]);
  end
  else
  begin
    TimRead := NewReadFileStream(FileNamesB.Items[CurNum]);
    ImageScan := GetImageScan(FileNamesB.Items[CurNum]);
  end;

  if CurGBPage = 0 then
    flsize := FileSize(FileNamesG.Items[CurNum])
  else
    flsize := FileSize(FileNamesB.Items[CurNum]);

  if flsize > cMaxSize then
  begin
    BringWindowToTop(form.Handle);
    if MessageBox(Form.Handle, sTooBig, sConfirmation, MB_YESNO +
      MB_ICONQUESTION + MB_TOPMOST + MB_DEFBUTTON2) = IDNO then
    begin
      Free_And_Nil(TimRead);
      //TimRead.free;
      Free_And_Nil(TimMem);
      //TimMem.free;
      Exit;
    end;
  end;

  if CurGBPage = 0 then
    flsize := Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1])
  else
    flsize := Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1]);

  if not ImageScan then
  begin
    if CurGBPage = 0 then
      TimRead.Seek(filePosesG[CurNum], spBegin)
    else
      TimRead.Seek(filePosesB[CurNum], spBegin);
    Stream2Stream(TimMem, TimRead, flsize);
  end
  else
  begin
    if CurGBPage = 0 then
      TimOffsetInSector := fileposesG[CurNum] mod Sector - info1
    else
      TimOffsetInSector := fileposesB[CurNum] mod Sector - info1;
    First := sectdata - TimOffsetInSector;

    if CurGBPage = 0 then
      TimRead.Seek(fileposesG[CurNum], spBegin)
    else
      TimRead.Seek(fileposesB[CurNum], spBegin);

    Stream2Stream(TimMem, TimRead, First);
    TimRead.seek(eccedc, spCurrent);

    while abs(flsize - TimMem.position) >= sectdata do
    begin
      TimRead.seek(info1, spCurrent);
      Stream2Stream(TimMem, TimRead, sectdata);
      TimRead.seek(eccedc, spCurrent);
    end;
    TimRead.seek(info1, spCurrent);
    Stream2Stream(TimMem, TimRead, flsize - TimMem.position);
  end;
  Free_And_Nil(TimRead);
  //TimRead.Free;
  TimMem.SaveToFile(ExtractFilePath(MainPath) + 'presave.tmp', 0,
    TimMem.Size);
  Free_And_Nil(TimMem);
  //TimMem.free;

  ReadTIM(ExtractFilePath(MainPath) + 'presave.tmp', 0,
    FileSize(ExtractFilePath(MainPath) + 'presave.tmp'));

  TimWrite := NewReadWriteFileStream(ExtractFilePath(MainPath) +
    'presave.tmp');
  TimWrite.Seek(0, spBegin);

  if (lvInfo.LVItems[ToChange, 0] = 'Version') then
    head.Version := Byte(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Reserved1') then
    head.Reserved1 := Byte(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Reserved2') then
    head.Reserved2 := Byte(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Reserved3') then
    head.Reserved3 := Byte(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Reserved4') then
    head.Reserved4 := Byte(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Reserved5') then
    head.Reserved5 := Byte(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'BPP') then
  begin
    orbit := head.BPP;
    head.BPP := Byte(Str2Int(edtValue.Text));
    case head.BPP of
      $00..$04: if orbit in [$08..$0C] then
          head.Bpp := head.Bpp + $08;
      $08..$0C: if orbit in [$00..$04] then
          head.Bpp := head.Bpp - $08;
    end;
  end;

  if (lvInfo.LVItems[ToChange, 0] = 'Palette Org X') then
    pal.PalX := word(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Palette Org Y') then
    pal.PalY := word(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Number of Colors in CLUT') then
    pal.ClutColors := word(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Number of CLUTs') then
    pal.ClutNum := word(Str2Int(edtValue.Text));

  if (lvInfo.LVItems[ToChange, 0] = 'Image Org X') then
    img.ImgX := word(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Image Org Y') then
    img.ImgY := word(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Image Width') then
    img.ImgWidth := word(Str2Int(edtValue.Text));
  if (lvInfo.LVItems[ToChange, 0] = 'Image Height') then
    img.ImgHeight := word(Str2Int(edtValue.Text));

  TimWrite.Write(Head, SizeOf(Head));
  if pal.ClutColors * pal.ClutNum * 2 > 0 then
  begin
    TimWrite.Write(pal, SizeOf(pal));
    TimWrite.Seek(pal.ClutColors * pal.ClutNum * 2, spcurrent);
  end;
  TimWrite.Write(img, SizeOf(img));

  Free_And_Nil(TimWrite);
  //TimWrite.Free;
  if not ReplaceInImage(ExtractFilePath(MainPath) + 'presave.tmp') then
  begin
    edtValue.Clear;
    edtValue.Enabled := False;
    btnSaveEdit.Enabled := false;
    ClearAll;
  end;
  DeleteFile(PAnsiChar(ExtractFilePath(MainPath) + 'presave.tmp'));
end;

procedure TfrmMain.lvListGClick(Sender: PObj);
begin
  if ((lvListG.Count > 0) and (lvlistG.SelLength >= 1) and (CurGBPage = 0)) or
    ((lvListB.Count > 0) and (lvlistB.SelLength >= 1) and (CurGBPage = 1)) then
  begin
    if CurGBPage = 0 then
      CurNum := Str2Int(Copy(lvlistG.LVItems[lvlistG.curindex, 0], 1,
        Pos('_', lvlistG.LVItems[lvlistG.curindex, 0]) - 1)) - 1
    else
      CurNum := Str2Int(Copy(lvlistB.LVItems[lvlistB.curindex, 0], 1,
        Pos('_', lvlistB.LVItems[lvlistB.curindex, 0]) - 1)) - 1;

    cbbMode.Enabled := true;
    edtOffset.Text := '0';

    if CurGBPage = 0 then
    begin
      if ReadTIM(FileNamesG.Items[CurNum], filePosesG[CurNum],
        Hex2Int(lvlistG.LVItems[lvlistG.curindex, 1])) then
      begin
        mmMain.Items[mnsavetim].Enabled := True;
        mmMain.Items[mnInsertAtPos].Enabled := true;

        ppList.Items[ppsavetim].Enabled := True;
        ppList.Items[ppInsertAtPos].Enabled := true;
      end
      else
        Exit;
    end
    else
    begin
      if ReadTIM(FileNamesB.Items[CurNum], filePosesB[CurNum],
        Hex2Int(lvlistB.LVItems[lvlistB.curindex, 1])) then
      begin
        mmMain.Items[mnsavetim].Enabled := True;
        mmMain.Items[mnInsertAtPos].Enabled := true;

        ppList.Items[ppsavetim].Enabled := True;
        ppList.Items[ppInsertAtPos].Enabled := true;        
      end
      else
        Exit;
    end;

    if Head.Bpp in [$04, $0C] then
      Exit;

    chkRandom.Checked := bpp in [41, 81];
    chkRandom.Enabled := bpp in [4, 8];
    btnSaveAsRandom.Enabled := not chkRandom.Checked;
    cbbPalette.Enabled := chkRandom.Enabled;
    btnGenPal.Enabled := chkRandom.Checked;
    cbbRandPalNum.Enabled := chkRandom.Enabled or chkRandom.Checked;
    btnMinus.Enabled := btnSaveAsRandom.Enabled;
    btnPlus.Enabled := btnSaveAsRandom.Enabled;
    edtOffset.Enabled := btnSaveAsRandom.Enabled;

    if chkRandom.Checked then
    begin
      case bpp of
        4: bpp := 41;
        8: bpp := 81;
      end;
    end
    else
    begin
      case head.bpp of
        $08: bpp := 4;
        $09: bpp := 8;
      end;
      end;

    PaintClut(True, false);

    FastPaint := false;
    PaintImage;

    cbbMode.CurIndex := 0;
    if CurGBPage = 0 then
      tcPages.TC_Items[1] := Format('#%d: %s', [CurNum + 1,
        ExtractFileName(FileNamesG.Items[CurNum])])
    else
      tcPages.TC_Items[1] := Format('#%d: %s', [CurNum + 1,
        ExtractFileName(FileNamesB.Items[CurNum])]);
    pbImage.Left := 1;
    pbImage.Top := 1;
    pbClut.Left := 1;
    pbClut.Top := 1;
    if CurGBPage = 0 then
      Form.SimpleStatusText := Format('Current File: "%s"',
        [FileNamesG.Items[CurNum]])
    else
      Form.SimpleStatusText := Format('Current File: "%s"',
        [FileNamesB.Items[CurNum]]);

    case bpp of
      4: tcPages.TC_Items[2] := 'CLUT [1]';
    else
      tcPages.TC_Items[2] := 'CLUT';
    end;
  end;
end;

procedure TfrmMain.mmMainmnChangeBackMenu(Sender: PMenu; Item: Integer);
begin
  if dlgcColor.Execute then
  begin
    sbImage.Color := dlgcColor.Color;
    if cls then
    begin
    FastPaint := false;
    PaintImage;
    end;
  end;
end;

procedure TfrmMain.lvInfoKeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if (Key in [VK_UP, VK_DOWN]) then
    lvInfoClick(@self);
end;

procedure TfrmMain.edtListFilterChange(Sender: PObj);
var
  n: integer;
begin
  if CurGBPage = 0 then
  begin
    n := lvListG.LVSearchFor(edtListFilter.Text,0, true);
    lvListG.LVMakeVisible(n, false);
  end
  else
  begin
    n := lvListB.LVSearchFor(edtListFilter.Text,0, true);
    lvListB.LVMakeVisible(n, false);
  end
end;

procedure TfrmMain.mmMainmnClearFSRsMenu(Sender: PMenu; Item: Integer);
begin
  DeleteFiles(ExtractFilePath(MainPath) + sResults + '\*.fsr');
  RemoveDirectory(PAnsiChar(ExtractFilePath(MainPath) + sResults));
end;

procedure TfrmMain.mmMainmnSaveAllImagesMenu(Sender: PMenu; Item: Integer);
var
  i,j: cardinal;
  a: word;
  pngThread: PThread;
begin
  CreateDirectory(PAnsiChar(ExtractFilePath(MainPath) + 'images'), nil);
  mmMain.Items[mnFile].Enabled := false;
  lvlistG.Enabled := False;
  lvlistB.Enabled := False;

  pbScan.Progress := 0;
  btnStop.Enabled := true;
  if cbbpalette.Count>0 then
  a := cbbpalette.CurIndex
  else
  a:=0;

  if CurGBPage = 0 then
  begin
  pbScan.MaxProgress := lvlistG.lvCount;
  lvListG.LVSortColumn(0);
  for i := 1 to lvlistG.lvCount do
  begin
    if stop then Break;
    ClearAll;
    CurNum := i-1;
    lvListG.LVCurItem := i-1;
    if ReadTIM(FileNamesG.Items[CurNum], filePosesG[CurNum],
       Hex2Int(lvlistG.LVItems[lvlistG.LVCurItem, 1])) then
    begin
    if Item = mnSaveAllwPals then
    begin
    if cbbPalette.Count>0 then
    for j:= 1 to cbbPalette.Count do
    begin
    cbbPalette.CurIndex := j-1;
    FastPaint := False;
    PaintClut(false, false);
    PaintImage(False);

    pngThread := NewThreadAutoFree(thPngSaving);
    pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
    pngThread.Resume;

        while not pngThread.Terminated do
          Form.ProcessPendingMessages;
    end
    else
    begin
    FastPaint := False;
    PaintImage(False);
    pngThread := NewThreadAutoFree(thPngSaving);
    pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
    pngThread.Resume;

        while not pngThread.Terminated do
          Form.ProcessPendingMessages;
    end
    end else
    begin
    FastPaint := False;
    if cbbPalette.Count > 0 then
    begin
    cbbpalette.CurIndex := 0;
    PaintClut(false, false);
    end;
    PaintImage(False);

    pngThread := NewThreadAutoFree(thPngSaving);
    pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
    pngThread.Resume;

        while not pngThread.Terminated do
          Form.ProcessPendingMessages;
    end;
    pbScan.Progress := i;
    end;
  end;
  end
  else
  begin
  pbScan.MaxProgress := lvlistB.lvCount;
  lvListB.LVSortColumn(0);
  for i := 1 to lvlistB.lvCount do
  begin
    if stop then Break;
    ClearAll;
    CurNum := i-1;
    lvListB.LVCurItem := i-1;
    if ReadTIM(FileNamesB.Items[CurNum], filePosesB[CurNum],
       Hex2Int(lvlistB.LVItems[lvlistB.LVCurItem, 1])) then
    begin
    if Item = mnSaveAllwPals then
    begin
    if cbbPalette.Count>0 then
    for j:= 1 to cbbPalette.Count do
    begin
    cbbPalette.CurIndex := j-1;
    FastPaint := False;
    PaintClut(false, false);
    PaintImage(False);

    pngThread := NewThreadAutoFree(thPngSaving);
    pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
    pngThread.Resume;

        while not pngThread.Terminated do
          Form.ProcessPendingMessages;
    end
    else
    begin
    FastPaint := False;
    PaintImage(False);
    pngThread := NewThreadAutoFree(thPngSaving);
    pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
    pngThread.Resume;

        while not pngThread.Terminated do
          Form.ProcessPendingMessages;
    end
    end else
    begin
    FastPaint := False;
    if cbbPalette.Count > 0 then
    begin
    cbbpalette.CurIndex := 0;
    PaintClut(false, false);
    end;
    PaintImage(False);

    pngThread := NewThreadAutoFree(thPngSaving);
    pngThread.ThreadPriority := THREAD_PRIORITY_HIGHEST;
    pngThread.Resume;

        while not pngThread.Terminated do
          Form.ProcessPendingMessages;
    end;
    pbScan.Progress := i;
    end;
  end;
  end;
  if cbbpalette.Count>0 then
  begin
  cbbpalette.CurIndex := a;
  cbbPaletteChange(@self);
  end;
  AfterScan;

  pbScan.Progress := 0;
  BringWindowToTop(form.Handle);
  MessageBox(Form.Handle, PAnsiChar('File(s) succesfully saved at "' +
    ExtractFilePath(MainPath) + 'images\" directory!'), 'Good',
    MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

end;

procedure TfrmMain.btnMinusClick(Sender: PObj);
begin
  if cls then
  begin
  if pal.ClutColors=0 then Exit;
  if abs(Str2Int(edtOffset.Text)-1)=pal.ClutColors then
  edtOffset.Text := '0'
  else
  edtOffset.Text := Int2Str(Str2Int(edtOffset.Text) mod (pal.ClutColors) - 1);
  FastPaint := false;
  PaintImage;
  end;
end;

procedure TfrmMain.btnPlusClick(Sender: PObj);
begin
  if cls then
  begin
  if pal.ClutColors=0 then Exit;
  if Str2Int(edtOffset.Text)+1=pal.ClutColors then
  edtOffset.Text := '0'
  else
  edtOffset.Text := Int2Str(Str2Int(edtOffset.Text) mod (pal.ClutColors) + 1);
  FastPaint := false;
  PaintImage;
  end;
end;

procedure TfrmMain.edtOffsetKeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
if cls then
begin
if (abs(Str2Int(edtOffset.Text))>=pal.ClutColors) then
   Key := Ord('0');
   FastPaint := False;
   PaintImage;
end
else
Key := ord(#0);
end;

procedure TfrmMain.edtOffsetKeyChar(Sender: PControl; var Key: KOLChar;
  Shift: Cardinal);
begin
if (not (Key in ['0'..'9', '-', chr(VK_BACK),chr(VK_DELETE)])) then
Key := #0;
end;

procedure TfrmMain.frmKOL1BeforeCreateWindow(Sender: PObj);
var
    a: OnNoOne;
begin
  if not JustOneNotify(form, 'TimView+', a.GG) then
    TerminateProcess(GetCurrentProcess,0);
end;

procedure TfrmMain.frmKOL1KeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
if (Key = VK_DELETE) then
if CurGBPage=0 then
lvListG.Delete(CurNum)
else
lvListB.Delete(CurNum);
end;

procedure TfrmMain.btnSaveAsRandomClick(Sender: PObj);
var
  palette: PBitmap;
  i: integer;
begin
  palette := NewDIBBitmap(512, 1, pf24bit);

  for i:= 1 to pal.ClutColors do
  palette.DIBPixels[i - 1, 0] := clutmas[cbbPalette.CurIndex, i - 1];

  palette.SaveToFile(ExtractFilePath(MainPath) + sPalettes + '\' +
                     Int2Digs(cbbRandPalNum.CurIndex + 1, 2) + '.bmp');
  Free_And_Nil(palette);
end;

procedure TfrmMain.cbbRandPalNumChange(Sender: PObj);
begin
  if not chkRandom.Checked then Exit;

  if cls then
  begin
    FastPaint := False;
    PaintClut(true, false);
    PaintImage;
  end;
end;

end.

