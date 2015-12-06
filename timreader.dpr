{ KOL MCK } // Do not remove this line!
program timreader;

uses
KOL,
//FastMM4,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IF Defined(KOL_MCK)} {$I timreader_0.inc} {$ELSE}

  Application.Initialize;
  Application.Title := 'TimView+';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

{$IFEND}

end.

