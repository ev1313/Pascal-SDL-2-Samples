program rwops_sample_1;

{
  RWops Sample 1
  --------------

  This simple Example demonstrates how using rwops with SDL 2.
}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SDL,
  SysUtils;

var
  rwops: PSDL_RWops;
  i: Integer;

begin
  try
    rwops := SDL_RWFromFile(PAnsiChar('C:\Test.txt'),PAnsiChar('rb'));

    if rwops = nil then
    begin
      WriteLn(SDL_GetError);
      ReadLn;
      Exit;
    end;

    SDL_RWRead(rwops, @i, 4, 1);
    SDL_RWClose(rwops);

    WriteLn(i);

    WriteLn(SDL_GetError);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  ReadLn;
end.
