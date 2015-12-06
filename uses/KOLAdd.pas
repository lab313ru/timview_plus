unit KOLadd;

interface

uses Windows, KOL, Messages;

function MapFileRead( const Filename: AnsiString; var hFile, hMap: THandle ): Pointer;
procedure UnmapFile( BasePtr: Pointer; hFile, hMap: THandle );

implementation

function MapFileRead( const Filename: AnsiString; var hFile, hMap: THandle ): Pointer;
begin
  Result := nil;
  hFile := FileCreate( KOLString(Filename), ofOpenRead or ofOpenExisting or ofShareDenyNone );
  hMap := 0;
  if hFile = INVALID_HANDLE_VALUE then Exit;
  hMap := CreateFileMapping( hFile, nil, PAGE_READONLY, 0, 0, nil );
  if hMap = 0 then Exit;
  //if (Hi <> 0) or (Sz > $0FFFFFFF) then Sz := $0FFFFFFF;
  //????? ? ????? ?????????? ?? 256 ?? ?????? ????????????? ?? ?????? ?????
  Result := MapViewOfFile( hMap, FILE_MAP_READ, 0, 0, 0 );
end;

procedure UnmapFile( BasePtr: Pointer; hFile, hMap: THandle );
begin
  if BasePtr <> nil then
    UnmapViewOfFile( BasePtr );
  if hMap <> 0 then
    CloseHandle( hMap );
  if hFile <> INVALID_HANDLE_VALUE then
    CloseHandle( hFile );
end;

end.
