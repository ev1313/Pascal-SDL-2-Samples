program thread_sample_1;

{
  Thread Sample 1
  ---------------

  This simple Example demonstrates how using threads with SDL 2.
}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SDL,
  SysUtils;

var
  thread: PSDL_Thread;
  i: Integer;

function MyThread1(data: Pointer): Integer; cdecl;
begin
  SDL_Delay(1000);
  WriteLn('Hallo 1');
  Result := 1;
end;

begin
  try
    thread := SDL_CreateThread(MyThread1,PAnsiChar('Thread 1'), nil);
    ReadLn;
    i := 0;
    SDL_WaitThread(thread,@i);
    WriteLn(IntToStr(i));
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
