program timer_sample_1;

{
  Timer Sample 1
  --------------

  This sample demonstrates how using SDL_Timer and SDL_Delay.
}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SDL,
  SysUtils;

var
  id1: TSDL_TimerID;

function MyTimerCallback1(interval: UInt32; param: Pointer): UInt32;
begin
  WriteLn('Timer 1 - ' + IntToStr(id1));
  //writes the actual tick-count
  WriteLn(IntToStr(SDL_GetTicks));

  Result := 1;
end;

begin
  try
    id1 := SDL_AddTimer(1000,@MyTimerCallback1,nil);
    ReadLn;
    WriteLn('start delay');
    SDL_Delay(1000);
    WriteLn('end delay');
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
