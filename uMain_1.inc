{ KOL MCK } // Do not remove this line!
resourcestring frmKOL1_Caption = 'TimView+';
resourcestring frmKOL1_SimpleStatusText = 'No File Opened...';
resourcestring frmKOL1_mmMain_mnFile = '&File';
resourcestring frmKOL1_mmMain_mmScanRAW = '&Scan File...'+#9+'Ctrl+S';
resourcestring frmKOL1_mmMain_mnScanFolder = 'Scan Directory...'+#9+'Ctrl+D';
resourcestring frmKOL1_mmMain_mnClose = '&Close All'+#9+'Ctrl+N';
resourcestring frmKOL1_mmMain_mnExit = '&Exit'+#9+'Alt+F4';
resourcestring frmKOL1_mmMain_mmImage = '&Operations';
resourcestring frmKOL1_mmMain_mnSaveImage = 'Save &Image to PNG (First Palette)'+#9+'Ctrl+I';
resourcestring frmKOL1_mmMain_mnSaveAllPals = 'Save Image to PNGs (&All Palettes)'+#9+'Ctrl+P';
resourcestring frmKOL1_mmMain_mnSaveAllImages = '&Save All Images (First Palette)'+#9+'Ctrl+Shift+I';
resourcestring frmKOL1_mmMain_mnSaveAllwPals = 'Save All Images (All &Palettes)'+#9+'Ctrl+Alt+P';
resourcestring frmKOL1_mmMain_mnBMPextract = 'E&xtract BMP for Edit...'+#9+'Ctrl+B';
resourcestring frmKOL1_mmMain_mnBMP2TIM = 'Convert &BMP to TIM...'+#9+'Ctrl+K';
resourcestring frmKOL1_mmMain_mnSaveTIM = '&Extract TIM...'+#9+'Ctrl+E';
resourcestring frmKOL1_mmMain_mnInsertAtPos = '&Replace TIM...'+#9+'Ctrl+R';
resourcestring frmKOL1_mmMain_mmConfig = '&Config';
resourcestring frmKOL1_mmMain_mnCheckAssoc = '&Check TIM Association at Start';
resourcestring frmKOL1_mmMain_mmAssoc = '&Associate program with TIM';
resourcestring frmKOL1_mmMain_mnCreateBak = 'Create &Backup when Replace';
resourcestring frmKOL1_mmMain_mnAutoExtract = 'Auto TIM &Extraction ("Extracted" folder)';
resourcestring frmKOL1_mmMain_mnChangeBack = 'Change Bac&kground Color';
resourcestring frmKOL1_mmMain_mnClearFSRs = 'Clear Previous Scan &Results';
resourcestring frmKOL1_mmMain_mmHelp = '&Help';
resourcestring frmKOL1_mmMain_mnForum = '[Lab 313] Forum...';
resourcestring frmKOL1_mmMain_mmAbout = '&About TimView+...'+#9+'F1';
resourcestring frmKOL1_ppList_ppSaveImage = 'Save &Image to PNG (First Palette)';
resourcestring frmKOL1_ppList_ppSaveAllPals = 'Save Image to PNGs (&All Palettes)';
resourcestring frmKOL1_ppList_ppSaveAllImages = '&Save All Images (First Palette)';
resourcestring frmKOL1_ppList_ppSaveAllwPals = 'Save All Images (All &Palettes)';
resourcestring frmKOL1_ppList_ppBMPextract = 'E&xtract BMP for Edit...';
resourcestring frmKOL1_ppList_ppBMP2TIM = 'Convert &BMP to TIM...';
resourcestring frmKOL1_ppList_ppSaveTIM = '&Extract TIM...';
resourcestring frmKOL1_ppList_ppInsertAtPos = '&Replace TIM...';
resourcestring frmKOL1_btnStop_Caption = 'Stop';
resourcestring frmKOL1_lvListG_Column0Caption = 'Name';
resourcestring frmKOL1_lvListG_Column1Caption = 'Size';
resourcestring frmKOL1_lvListG_Column2Caption = 'Resolution';
resourcestring frmKOL1_lvListB_Column0Caption = 'Name';
resourcestring frmKOL1_lvListB_Column1Caption = 'Size';
resourcestring frmKOL1_lvListB_Column2Caption = 'Resolution';
resourcestring frmKOL1_lblListFilter_Caption = 'Search #:';
resourcestring frmKOL1_lblValue_Caption = 'Value (DEC):';
resourcestring frmKOL1_btnSaveEdit_Caption = 'Save Changes';
resourcestring frmKOL1_lvInfo_Column0Caption = 'Block';
resourcestring frmKOL1_lvInfo_Column1Caption = 'Value (HEX)';
resourcestring frmKOL1_lvInfo_Column2Caption = 'Value (or Size)';
resourcestring frmKOL1_lblBitDepth_Caption = 'Bitdepth:';
resourcestring frmKOL1_lblIndex_Caption = 'Index (0):';
resourcestring frmKOL1_lblZoom_Caption = 'Zoom:';
resourcestring frmKOL1_lblPalOffset_Caption = 'Palette Offset:';
resourcestring frmKOL1_btnMinus_Caption = '-1';
resourcestring frmKOL1_btnPlus_Caption = '+1';
resourcestring frmKOL1_cbbMode_Item0 = 'Real';
resourcestring frmKOL1_cbbMode_Item1 = '4-bit';
resourcestring frmKOL1_cbbMode_Item2 = '8-bit';
resourcestring frmKOL1_cbbMode_Item3 = '16-bit';
resourcestring frmKOL1_cbbMode_Item4 = '24-bit';
resourcestring frmKOL1_cbbZoom_Item0 = '100%';
resourcestring frmKOL1_cbbZoom_Item1 = '150%';
resourcestring frmKOL1_cbbZoom_Item2 = '200%';
resourcestring frmKOL1_cbbZoom_Item3 = '250%';
resourcestring frmKOL1_cbbZoom_Item4 = '300%';
resourcestring frmKOL1_cbbZoom_Item5 = '350%';
resourcestring frmKOL1_cbbZoom_Item6 = '400%';
resourcestring frmKOL1_cbbZoom_Item7 = 'Stretch';
resourcestring frmKOL1_chkRandom_Caption = 'Rand PAL #:';
resourcestring frmKOL1_btnSaveAsRandom_Caption = '<- Current PAL';
resourcestring frmKOL1_chkTransparency_Caption = 'Transparency';
resourcestring frmKOL1_btnGenPal_Caption = 'Gen random PAL';
const clFileB = 0;
const clSizeB = 1;
const clResB = 2;
const clFileG = 0;
const clSizeG = 1;
const clResG = 2;
const _tpMain = 0;
const _tpImage = 1;
const _tpClut = 2;
const Col1 = 0;
const Col3 = 1;
const Col4 = 2;
const _tpGood = 0;
const _tpBad = 1;
const mnFile = 0;
const mmScanRAW = 1;
const mnScanFolder = 2;
const mnClose = 4;
const mnExit = 5;
const mmImage = 6;
const mnSaveImage = 7;
const mnSaveAllPals = 8;
const mnSaveAllImages = 9;
const mnSaveAllwPals = 10;
const mnBMPextract = 12;
const mnBMP2TIM = 13;
const mnSaveTIM = 15;
const mnInsertAtPos = 16;
const mmConfig = 17;
const mnCheckAssoc = 18;
const mmAssoc = 19;
const mnCreateBak = 21;
const mnAutoExtract = 23;
const mnChangeBack = 25;
const mnClearFSRs = 26;
const mmHelp = 27;
const mnForum = 28;
const mmAbout = 30;

const ppSaveImage = 0;
const ppSaveAllPals = 1;
const ppSaveAllImages = 2;
const ppSaveAllwPals = 3;
const ppBMPextract = 5;
const ppBMP2TIM = 6;
const ppSaveTIM = 8;
const ppInsertAtPos = 9;


procedure NewfrmMain( var Result: PfrmMain; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PfrmMain.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, frmKOL1_Caption ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.frmKOL1BeforeCreateWindow( Result );
    Result.Form.SetClientSize( 881, 653 );
    Result.Form.Border := 1;
    Result.Form.SimpleStatusText := PKOLChar( frmKOL1_SimpleStatusText );
    Result.Form.KeyPreview := TRUE;
      Result.Form.OnClose := Result.frmKOL1Close;
      Result.Form.OnKeyUp := Result.frmKOL1KeyUp;
      Result.Form.OnShow := Result.frmKOL1Show;
      Result.Form.OnDropFiles := Result.frmKOL1DropFiles;

    Result.mmMain := NewMenu( Result.Form, 0, [ 
      PKOLChar( frmKOL1_mmMain_mnFile ), '('
      , PKOLChar( frmKOL1_mmMain_mmScanRAW )
      , PKOLChar( frmKOL1_mmMain_mnScanFolder ), '-' + ''
      , PKOLChar( frmKOL1_mmMain_mnClose )
      , PKOLChar( frmKOL1_mmMain_mnExit ), ')'
      , PKOLChar( frmKOL1_mmMain_mmImage ), '('
      , PKOLChar( frmKOL1_mmMain_mnSaveImage )
      , PKOLChar( frmKOL1_mmMain_mnSaveAllPals )
      , PKOLChar( frmKOL1_mmMain_mnSaveAllImages )
      , PKOLChar( frmKOL1_mmMain_mnSaveAllwPals ), '-' + ''
      , PKOLChar( frmKOL1_mmMain_mnBMPextract )
      , PKOLChar( frmKOL1_mmMain_mnBMP2TIM ), '-' + ''
      , PKOLChar( frmKOL1_mmMain_mnSaveTIM )
      , PKOLChar( frmKOL1_mmMain_mnInsertAtPos ), ')'
      , PKOLChar( frmKOL1_mmMain_mmConfig ), '('
      , PKOLChar( frmKOL1_mmMain_mnCheckAssoc )
      , PKOLChar( frmKOL1_mmMain_mmAssoc ), '-' + ''
      , PKOLChar( frmKOL1_mmMain_mnCreateBak ), '-' + ''
      , PKOLChar( frmKOL1_mmMain_mnAutoExtract ), '-' + ''
      , PKOLChar( frmKOL1_mmMain_mnChangeBack )
      , PKOLChar( frmKOL1_mmMain_mnClearFSRs ), ')'
      , PKOLChar( frmKOL1_mmMain_mmHelp ), '('
      , PKOLChar( frmKOL1_mmMain_mnForum ), '-' + ''
      , PKOLChar( frmKOL1_mmMain_mmAbout ), ')', '' ], nil );
    Result.mmMain.AssignEvents( 1, [ Result.mmMainmmScanRAWMenu ] );
    Result.mmMain.ItemAccelerator[ 1 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $53 );
    Result.mmMain.AssignEvents( 2, [ Result.mnScanFolderMenu ] );
    Result.mmMain.ItemAccelerator[ 2 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $44 );
    Result.mmMain.ItemEnabled[ 4 ] := False;
    Result.mmMain.AssignEvents( 4, [ Result.mmMainmnCloseMenu ] );
    Result.mmMain.ItemAccelerator[ 4 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $4E );
    Result.mmMain.AssignEvents( 5, [ Result.mmMainmnExitMenu ] );
    Result.mmMain.ItemAccelerator[ 5 ] := MakeAccelerator( FVIRTKEY or FALT, VK_F4 );
    Result.mmMain.ItemEnabled[ 7 ] := False;
    Result.mmMain.AssignEvents( 7, [ Result.mmMainmnSaveImageMenu ] );
    Result.mmMain.ItemAccelerator[ 7 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $49 );
    Result.mmMain.ItemEnabled[ 8 ] := False;
    Result.mmMain.AssignEvents( 8, [ Result.mmMainmnSaveAllPalsMenu ] );
    Result.mmMain.ItemAccelerator[ 8 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $50 );
    Result.mmMain.ItemEnabled[ 9 ] := False;
    Result.mmMain.AssignEvents( 9, [ Result.mmMainmnSaveAllImagesMenu ] );
    Result.mmMain.ItemAccelerator[ 9 ] := MakeAccelerator( FVIRTKEY or FSHIFT or FCONTROL, $49 );
    Result.mmMain.ItemEnabled[ 10 ] := False;
    Result.mmMain.AssignEvents( 10, [ Result.mmMainmnSaveAllImagesMenu ] );
    Result.mmMain.ItemAccelerator[ 10 ] := MakeAccelerator( FVIRTKEY or FCONTROL or FALT, $50 );
    Result.mmMain.ItemEnabled[ 12 ] := False;
    Result.mmMain.AssignEvents( 12, [ Result.mmMainmnBMPextractMenu ] );
    Result.mmMain.ItemAccelerator[ 12 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $42 );
    Result.mmMain.AssignEvents( 13, [ Result.mmMainmnBMP2TIMMenu ] );
    Result.mmMain.ItemAccelerator[ 13 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $4B );
    Result.mmMain.ItemEnabled[ 15 ] := False;
    Result.mmMain.AssignEvents( 15, [ Result.mmMainmnSaveTIMMenu ] );
    Result.mmMain.ItemAccelerator[ 15 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $45 );
    Result.mmMain.ItemEnabled[ 16 ] := False;
    Result.mmMain.AssignEvents( 16, [ Result.mmMainmnInsertAtPosMenu ] );
    Result.mmMain.ItemAccelerator[ 16 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $52 );
    Result.mmMain.AssignEvents( 18, [ Result.mmMainmnCheckAssocMenu ] );
    Result.mmMain.AssignEvents( 19, [ Result.mmMainmmAssocMenu ] );
    Result.mmMain.AssignEvents( 21, [ Result.mmMainmnCreateBakMenu ] );
    Result.mmMain.AssignEvents( 23, [ Result.mmMainmnAutoExtractMenu ] );
    Result.mmMain.AssignEvents( 25, [ Result.mmMainmnChangeBackMenu ] );
    Result.mmMain.AssignEvents( 26, [ Result.mmMainmnClearFSRsMenu ] );
    Result.mmMain.AssignEvents( 28, [ Result.mmMainmnForumMenu ] );
    Result.mmMain.AssignEvents( 30, [ Result.mmMainmmAboutMenu ] );
    Result.mmMain.ItemAccelerator[ 30 ] := MakeAccelerator( FVIRTKEY, VK_F1 );

    Result.dlgcColor := NewColorDialog( ccoFullOpen );
  Result.Form.Add2AutoFree( Result.dlgcColor );

    Result.dlgOpenDir := NewOpenDirDialogEx;
    Result.dlgOpenDir.Title := 'Please, select Directory for Scan...';
  Result.Form.Add2AutoFree( Result.dlgOpenDir );

    Result.dlgOpenBMP := NewOpenSaveDialog( 'Please, select Bitmap for import...', '', [  ] );
      Result.dlgOpenBMP.Filter := 'Windows Bitmaps (*.bmp)|*.bmp';
      Result.dlgOpenBMP.DefExtension := 'bmp';
  Result.Form.Add2AutoFree( Result.dlgOpenBMP );

    Result.dlgOpen := NewOpenSaveDialog( 'Please, select PSX Image File...', '', [ OSFileMustExist, OSHideReadonly, OSNoChangedir, OSPathMustExist ] );
      Result.dlgOpen.Filter := 'All Files (*.*)|*.*';
      Result.dlgOpen.DefExtension := 'tim';
  Result.Form.Add2AutoFree( Result.dlgOpen );

    Result.ppList := NewMenu( Result.Form, 0, [ 
      PKOLChar( frmKOL1_ppList_ppSaveImage )
      , PKOLChar( frmKOL1_ppList_ppSaveAllPals )
      , PKOLChar( frmKOL1_ppList_ppSaveAllImages )
      , PKOLChar( frmKOL1_ppList_ppSaveAllwPals ), '-' + ''
      , PKOLChar( frmKOL1_ppList_ppBMPextract )
      , PKOLChar( frmKOL1_ppList_ppBMP2TIM ), '-' + ''
      , PKOLChar( frmKOL1_ppList_ppSaveTIM )
      , PKOLChar( frmKOL1_ppList_ppInsertAtPos ), '' ], nil );
    Result.ppList.ItemEnabled[ 0 ] := False;
    Result.ppList.AssignEvents( 0, [ Result.mmMainmnSaveImageMenu ] );
    Result.ppList.ItemEnabled[ 1 ] := False;
    Result.ppList.AssignEvents( 1, [ Result.mmMainmnSaveAllPalsMenu ] );
    Result.ppList.ItemEnabled[ 2 ] := False;
    Result.ppList.AssignEvents( 2, [ Result.mmMainmnSaveAllImagesMenu ] );
    Result.ppList.ItemEnabled[ 3 ] := False;
    Result.ppList.AssignEvents( 3, [ Result.mmMainmnSaveAllImagesMenu ] );
    Result.ppList.ItemEnabled[ 5 ] := False;
    Result.ppList.AssignEvents( 5, [ Result.mmMainmnBMPextractMenu ] );
    Result.ppList.AssignEvents( 6, [ Result.mmMainmnBMP2TIMMenu ] );
    Result.ppList.ItemEnabled[ 8 ] := False;
    Result.ppList.AssignEvents( 8, [ Result.mmMainmnSaveTIMMenu ] );
    Result.ppList.ItemEnabled[ 9 ] := False;
    Result.ppList.AssignEvents( 9, [ Result.mmMainmnInsertAtPosMenu ] );
    Result.ppList.Flags := TPM_VERTICAL or TPM_HORPOSANIMATION or TPM_HORNEGANIMATION or TPM_VERPOSANIMATION or TPM_VERNEGANIMATION;
    Result.pnlList := NewPanel( Result.Form, esNone ).SetAlign ( caLeft ).SetSize( 312, 0 ).SetBorder( 2);
    Result.pnlList.Font.FontHeight := 16;
    Result.pnlList.Font.FontName := 'Calibri';
    Result.pnlList.Font.FontPitch := fpVariable;
      Result.pnlCount := NewPanel( Result.pnlList, esNone ).SetAlign ( caBottom ).SetSize( 0, 28 );
        Result.lblFiles := NewLabel( Result.pnlCount, '0 (G)/0 (B)' ).SetAlign ( caLeft ).AutoSize( TRUE );
    Result.lblFiles.VerticalAlign := KOL.vaCenter;
        Result.lblPos := NewLabel( Result.pnlCount, '0000000000' ).SetAlign ( caClient ).AutoSize( TRUE );
    Result.lblPos.TextAlign := KOL.taRight;
    Result.lblPos.VerticalAlign := KOL.vaCenter;
        Result.btnStop := NewButton( Result.pnlCount, frmKOL1_btnStop_Caption ).SetAlign ( caRight ).SetSize( 90, 0 );
        Result.btnStop.Enabled := False;
      Result.tcGB := NewTabControl( Result.pnlList, [ 'Good TIMs', 'Bad TIMs' ], [ tcoMultiline ], nil, 0 ).SetAlign ( caClient );
    Result.tcGB.TabStop := FALSE;
    Result.tcGB.Pages[ 0 ].VerticalAlign := KOL.vaCenter;
          Result.lvListG := NewListView( Result.tcGB.Pages[ 0 ], lvsDetail, [ lvoGridLines, lvoRowSelect, lvoRegional, lvoInfoTip, lvoUnderlineHot ], nil, nil, nil ).SetAlign ( caClient );
    Result.lvListG.Color := TColor(clWindow);
          Result.lvListG.LVColAdd( frmKOL1_lvListG_Column0Caption, taRight, 115);
          Result.lvListG.LVColAdd( frmKOL1_lvListG_Column1Caption, taLeft, 75);
          Result.lvListG.LVColAdd( frmKOL1_lvListG_Column2Caption, taCenter, 80);
          Result.lvListB := NewListView( Result.tcGB.Pages[ 1 ], lvsDetail, [ lvoGridLines, lvoRowSelect, lvoRegional, lvoInfoTip, lvoUnderlineHot ], nil, nil, nil ).SetAlign ( caClient );
    Result.lvListB.Color := TColor(clWindow);
          Result.lvListB.LVColAdd( frmKOL1_lvListB_Column0Caption, taRight, 115);
          Result.lvListB.LVColAdd( frmKOL1_lvListB_Column1Caption, taLeft, 75);
          Result.lvListB.LVColAdd( frmKOL1_lvListB_Column2Caption, taCenter, 80);
      Result.pnlFilter := NewPanel( Result.pnlList, esLowered ).SetAlign ( caBottom ).SetSize( 0, 28 );
        Result.lblListFilter := NewLabel( Result.pnlFilter, frmKOL1_lblListFilter_Caption ).SetAlign ( caClient ).AutoSize( TRUE );
    Result.lblListFilter.TextAlign := KOL.taRight;
    Result.lblListFilter.VerticalAlign := KOL.vaCenter;
        Result.edtListFilter := NewEditBox( Result.pnlFilter, [ eoNoHideSel ] ).SetAlign ( caRight ).SetSize( 129, 0 );
    Result.edtListFilter.TextAlign := KOL.taCenter;
    Result.pnlButtons := NewPanel( Result.Form, esNone ).SetAlign ( caClient ).SetBorder( 2);
    Result.pnlButtons.Font.FontHeight := 16;
    Result.pnlButtons.Font.FontName := 'Calibri';
    Result.pnlButtons.Font.FontPitch := fpVariable;
      Result.tcPages := NewTabControl( Result.pnlButtons, [ 'Info', 'Image', 'CLUT' ], [ tcoFitRows ], nil, 0 ).SetAlign ( caClient );
    Result.tcPages.TabStop := FALSE;
    Result.tcPages.Pages[ 0 ].TextAlign := KOL.taCenter;
          Result.pnlEdit := NewPanel( Result.tcPages.Pages[ 0 ], esLowered ).SetAlign ( caBottom ).SetSize( 0, 31 ).SetBorder( 0);
            Result.lblValue := NewLabel( Result.pnlEdit, frmKOL1_lblValue_Caption ).SetPosition( 10, 5 ).AutoSize( TRUE ).SetBorder( 2);
    Result.lblValue.TextAlign := KOL.taRight;
    Result.lblValue.VerticalAlign := KOL.vaCenter;
            Result.edtValue := NewEditBox( Result.pnlEdit, [ eoLowercase, eoNoHideSel, eoNumber ] ).SetPosition( 99, 4 ).SetBorder( 2);
            Result.edtValue.Enabled := False;
            Result.btnSaveEdit := NewButton( Result.pnlEdit, frmKOL1_btnSaveEdit_Caption ).SetPosition( 207, 5 ).AutoSize( TRUE ).SetBorder( 2);
            Result.btnSaveEdit.Enabled := False;
          Result.lvInfo := NewListView( Result.tcPages.Pages[ 0 ], lvsDetail, [ lvoGridLines, lvoRowSelect ], nil, nil, nil ).SetAlign ( caClient );
    Result.lvInfo.Color := TColor(clBtnFace);
          Result.lvInfo.LVBkColor := clBtnFace;
          Result.lvInfo.LVColAdd( frmKOL1_lvInfo_Column0Caption, taLeft, 200);
          Result.lvInfo.LVColAdd( frmKOL1_lvInfo_Column1Caption, taLeft, 90);
          Result.lvInfo.LVColAdd( frmKOL1_lvInfo_Column2Caption, taLeft, 170);
    Result.tcPages.Pages[ 1 ].TextAlign := KOL.taCenter;
          Result.pnlTools := NewPanel( Result.tcPages.Pages[ 1 ], esSolid ).SetAlign ( caTop ).SetSize( 0, 83 );
            Result.pnlZoom := NewPanel( Result.pnlTools, esNone ).SetAlign ( caLeft ).SetSize( 275, 0 ).SetBorder( 0);
              Result.lblBitDepth := NewLabel( Result.pnlZoom, frmKOL1_lblBitDepth_Caption ).SetPosition( 185, 1 ).AutoSize( TRUE ).SetBorder( 2);
    Result.lblBitDepth.TextAlign := KOL.taRight;
    Result.lblBitDepth.VerticalAlign := KOL.vaCenter;
              Result.lblIndex := NewLabel( Result.pnlZoom, frmKOL1_lblIndex_Caption ).SetPosition( 90, 1 ).AutoSize( TRUE ).SetBorder( 2);
    Result.lblIndex.TextAlign := KOL.taRight;
    Result.lblIndex.VerticalAlign := KOL.vaCenter;
              Result.lblZoom := NewLabel( Result.pnlZoom, frmKOL1_lblZoom_Caption ).SetPosition( 9, 1 ).AutoSize( TRUE ).SetBorder( 2);
    Result.lblZoom.TextAlign := KOL.taRight;
    Result.lblZoom.VerticalAlign := KOL.vaCenter;
              Result.pnlOffset := NewPanel( Result.pnlZoom, esNone ).SetAlign ( caBottom ).SetSize( 0, 25 ).SetBorder( 2);
                Result.lblPalOffset := NewLabel( Result.pnlOffset, frmKOL1_lblPalOffset_Caption ).SetPosition( 10, 5 ).AutoSize( TRUE );
    Result.lblPalOffset.TextAlign := KOL.taRight;
    Result.lblPalOffset.VerticalAlign := KOL.vaCenter;
                Result.edtOffset := NewEditBox( Result.pnlOffset, [  ] ).SetPosition( 165, 2 ).SetSize( 61, 0 );
    Result.edtOffset.TextAlign := KOL.taCenter;
                Result.edtOffset.Enabled := False;
                Result.edtOffset.Text := '0';
                Result.btnMinus := NewButton( Result.pnlOffset, frmKOL1_btnMinus_Caption ).SetPosition( 124, 2 ).SetSize( 36, 23 );
                Result.btnMinus.Enabled := False;
                Result.btnPlus := NewButton( Result.pnlOffset, frmKOL1_btnPlus_Caption ).SetPosition( 233, 2 ).SetSize( 36, 23 );
                Result.btnPlus.Enabled := False;
              Result.cbbMode := NewComboBox( Result.pnlZoom, [ coReadOnly, coNoHScroll, coNoIntegralHeight ] ).SetPosition( 185, 25 ).SetSize( 84, 0 ).SetBorder( 2);
              Result.cbbMode.Enabled := False;
              Result.cbbMode.EraseBackground := TRUE;
    Result.cbbMode.Color := TColor(clWindow);
              Result.cbbMode.Items[ 0 ] := frmKOL1_cbbMode_Item0;
              Result.cbbMode.Items[ 1 ] := frmKOL1_cbbMode_Item1;
              Result.cbbMode.Items[ 2 ] := frmKOL1_cbbMode_Item2;
              Result.cbbMode.Items[ 3 ] := frmKOL1_cbbMode_Item3;
              Result.cbbMode.Items[ 4 ] := frmKOL1_cbbMode_Item4;
              Result.cbbMode.CurIndex := 0;
              Result.cbbPalette := NewComboBox( Result.pnlZoom, [ coReadOnly, coNoHScroll, coNoIntegralHeight ] ).SetPosition( 90, 25 ).SetSize( 91, 0 ).SetBorder( 2);
              Result.cbbPalette.Enabled := False;
              Result.cbbPalette.EraseBackground := TRUE;
    Result.cbbPalette.Color := TColor(clWindow);
              Result.cbbZoom := NewComboBox( Result.pnlZoom, [ coReadOnly, coNoHScroll, coNoIntegralHeight ] ).SetPosition( 9, 25 ).SetSize( 77, 0 ).SetBorder( 2);
              Result.cbbZoom.EraseBackground := TRUE;
    Result.cbbZoom.Color := TColor(clWindow);
              Result.cbbZoom.Items[ 0 ] := frmKOL1_cbbZoom_Item0;
              Result.cbbZoom.Items[ 1 ] := frmKOL1_cbbZoom_Item1;
              Result.cbbZoom.Items[ 2 ] := frmKOL1_cbbZoom_Item2;
              Result.cbbZoom.Items[ 3 ] := frmKOL1_cbbZoom_Item3;
              Result.cbbZoom.Items[ 4 ] := frmKOL1_cbbZoom_Item4;
              Result.cbbZoom.Items[ 5 ] := frmKOL1_cbbZoom_Item5;
              Result.cbbZoom.Items[ 6 ] := frmKOL1_cbbZoom_Item6;
              Result.cbbZoom.Items[ 7 ] := frmKOL1_cbbZoom_Item7;
              Result.cbbZoom.CurIndex := 7;
            Result.pnlRandom := NewPanel( Result.pnlTools, esNone ).SetAlign ( caRight ).SetSize( 260, 0 ).SetBorder( 0);
              Result.chkRandom := NewCheckBox( Result.pnlRandom, frmKOL1_chkRandom_Caption ).SetPosition( 8, 28 ).AutoSize( TRUE ).SetBorder( 2);
              Result.chkRandom.Enabled := False;
              Result.btnSaveAsRandom := NewButton( Result.pnlRandom, frmKOL1_btnSaveAsRandom_Caption ).SetPosition( 168, 28 ).AutoSize( TRUE ).SetBorder( 2);
              Result.btnSaveAsRandom.Enabled := False;
              Result.chkTransparency := NewCheckBox( Result.pnlRandom, frmKOL1_chkTransparency_Caption ).SetPosition( 8, 5 ).AutoSize( TRUE ).SetBorder( 2);
              Result.btnGenPal := NewButton( Result.pnlRandom, frmKOL1_btnGenPal_Caption ).SetPosition( 8, 57 ).AutoSize( TRUE ).SetBorder( 2);
              Result.btnGenPal.Enabled := False;
              Result.cbbRandPalNum := NewComboBox( Result.pnlRandom, [ coReadOnly, coNoHScroll, coNoIntegralHeight, coSort ] ).SetPosition( 111, 27 ).SetSize( 47, 0 ).SetBorder( 2);
              Result.cbbRandPalNum.Enabled := False;
              Result.cbbRandPalNum.EraseBackground := TRUE;
    Result.cbbRandPalNum.Color := TColor(clWindow);
          Result.sbImage := NewScrollBoxEx( Result.tcPages.Pages[ 1 ], esLowered ).SetAlign ( caClient );
          Result.sbImage.EraseBackground := TRUE;
    Result.sbImage.Color := TColor(clBtnFace);
            Result.pbImage := NewPaintBox( Result.sbImage ).SetSize( 627, 496 ).CenterOnParent.SetBorder( 3);
            Result.pbImage.Visible := False;
    Result.pbImage.Color := TColor(clBtnFace);
    Result.tcPages.Pages[ 2 ].TextAlign := KOL.taCenter;
          Result.pnlClut := NewPanel( Result.tcPages.Pages[ 2 ], esLowered ).SetAlign ( caClient );
          Result.pnlClut.EraseBackground := TRUE;
            Result.pnlRGBClut := NewPanel( Result.pnlClut, esLowered ).SetAlign ( caBottom ).SetSize( 0, 24 );
    Result.pnlRGBClut.TextAlign := KOL.taCenter;
            Result.pbClut := NewPaintBox( Result.pnlClut ).SetPosition( 1, 1 ).SetSize( 255, 800 ).SetBorder( 1);
            Result.pbClut.Visible := False;
            Result.pbClut.EraseBackground := TRUE;
    Result.pbClut.Color := TColor(clBlack);
    Result.pnlScan := NewPanel( Result.Form, esNone ).SetAlign ( caBottom ).SetSize( 0, 22 ).SetBorder( 2);
    Result.pnlScan.Font.FontStyle := [ fsBold ];
    Result.pnlScan.Font.FontHeight := 16;
    Result.pnlScan.Font.FontName := 'Calibri';
    Result.pnlScan.Font.FontPitch := fpVariable;
      Result.pbScan := NewProgressBar( Result.pnlScan ).SetAlign ( caBottom ).SetSize( 0, 18 );
      Result.chkRandom.OnClick := Result.chkRandomClick;
    Result.edtOffset.Color := TColor(clWindow);
      Result.edtOffset.OnKeyUp := Result.edtOffsetKeyUp;
      Result.edtOffset.OnKeyChar := Result.edtOffsetKeyChar;
    Result.edtValue.Color := TColor(clWindow);
    Result.lvListB.SetAutoPopupMenu( Result.ppList );
      Result.lvListB.OnClick := Result.lvListBClick;
      Result.lvListB.OnKeyUp := Result.lvListGKeyUp;
      Result.lvListB.OnColumnClick := Result.lvListGColumnClick;
    Result.lvListG.SetAutoPopupMenu( Result.ppList );
      Result.lvListG.OnClick := Result.lvListGClick;
      Result.lvListG.OnKeyUp := Result.lvListGKeyUp;
      Result.lvListG.OnColumnClick := Result.lvListGColumnClick;
      Result.btnStop.OnClick := Result.btnStopClick;
      Result.tcPages.CurIndex := 1;
      Result.tcPages.Pages[ 1 ].BringToFront;
      Result.btnMinus.OnClick := Result.btnMinusClick;
      Result.btnPlus.OnClick := Result.btnPlusClick;
      Result.btnSaveAsRandom.OnClick := Result.btnSaveAsRandomClick;
      Result.btnSaveEdit.OnClick := Result.btnSaveEditClick;
      Result.chkTransparency.OnClick := Result.chkTransparencyClick;
    Result.edtListFilter.Color := TColor(clWindow);
      Result.edtListFilter.OnChange := Result.edtListFilterChange;
      Result.lvInfo.OnClick := Result.lvInfoClick;
      Result.lvInfo.OnKeyUp := Result.lvInfoKeyUp;
      Result.tcPages.Pages[ 1 ].OnClick := Result.tpImageClick;
      Result.btnGenPal.OnClick := Result.btnGenPalClick;
      Result.tcGB.OnClick := Result.tcGBClick;
      Result.cbbMode.OnChange := Result.cbbModeChange;
      Result.cbbRandPalNum.OnChange := Result.cbbRandPalNumChange;
      Result.pbClut.OnMouseDblClk := Result.pbClutMouseDblClk;
      Result.pbClut.OnMouseMove := Result.pbClutMouseMove;
      Result.pbClut.OnMouseUp := Result.pbClutMouseUp;
      Result.pbClut.OnPaint := Result.pbClutPaint;
      Result.pbImage.OnPaint := Result.pbImagePaint;
      Result.dlgOpenBMP.WndOwner := Result.Form.GetWindowHandle;
      Result.dlgOpen.WndOwner := Result.Form.GetWindowHandle;
      Result.cbbPalette.OnChange := Result.cbbPaletteChange;
      Result.cbbZoom.OnChange := Result.cbbZoomChange;
    Result.Form.CenterOnParent;
    Result.frmKOL1FormCreate( Result );

end;


