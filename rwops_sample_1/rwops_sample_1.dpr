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
  SDL2 in 'c:\repository\git\pascal-sdl-2-headers\sdl2.pas',
  SysUtils;

var
  rwops: PSDL_RWops;
  c: array[0..100] of AnsiChar;

begin
  try
    rwops := SDL_RWFromFile(PAnsiChar('C:\Test.txt'),PAnsiChar('rb'));

    if rwops = nil then
    begin
      WriteLn(SDL_GetError);
      ReadLn;
      Exit;
    end;

    SDL_RWRead(rwops, @c, SizeOf(AnsiChar), SDL_RWSize(rwops));
    SDL_RWClose(rwops);

    WriteLn(c);

    WriteLn(SDL_GetError);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  ReadLn;
end.
