program sample_1;

{$APPTYPE CONSOLE}

{$R *.res}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses
  dglOpenGL in 'c:/externals/delphi/dglOpenGL.pas',
  SDL in 'c:/externals/delphi/sdl.pas',
  SysUtils;

var
  window: PSDL_Window;
  context: TSDL_GLContext;
  running: Boolean;

procedure OpenGL;
begin
  InitOpenGL;
  ReadExtensions;
  ReadImplementationProperties;

  glClearColor(0.0, 0.0, 0.0, 1.0);
  glClearDepth(1.0);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
end;

procedure SetViewport(w,h: Integer);
begin
  if w <= 0 then w := 1;
  if h <= 0 then h := 1;

  glViewport( 0, 0, w, h );
 
  glMatrixMode( GL_PROJECTION );
    glLoadIdentity;
    gluPerspective( 45.0, w / h, 0.1, 100.0 );
  glMatrixMode( GL_MODELVIEW );

  glLoadIdentity;
end;

procedure HandleEvents;
var
  event: TSDL_Event;
begin
  while SDL_PollEvent(@event) > 0 do
  begin
    case event.type_ of
      //only works with one window!
      //see sample_2 how to catch this event correct.
      SDL_QUITEV:
        running := false;
    end;
  end;
end;

procedure Render;
begin
  glClear( GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT );

  glLoadIdentity();
  glTranslatef( -1.5, 0.0, -6.0 );

  glColor3f(1,0,0);
  glBegin( GL_TRIANGLES );
    glVertex3f( 0.0, 1.0, 0.0 );
    glVertex3f( -1.0, -1.0, 0.0 );
    glVertex3f( 1.0, -1.0, 0.0 );
  glEnd;

  glTranslatef( 3.0, 0.0, 0.0 );

  glColor3f(0,1,0);
  glBegin( GL_QUADS );
    glVertex3f( -1.0, 1.0, 0.0 );
    glVertex3f( 1.0, 1.0, 0.0 );
    glVertex3f( 1.0, -1.0, 0.0 );
    glVertex3f( -1.0, -1.0, 0.0 );
  glEnd;
  SDL_GL_SwapWindow(window);
end;

begin
  try
    if SDL_Init(SDL_INIT_VIDEO) > 0 then
    begin
      raise Exception.Create('Error at initializing SDL_VIDEO: ' + SDL_GetError);
    end;

    window := SDL_CreateWindow('Sample 1', 200, 200, 640, 400, SDL_WINDOW_OPENGL);

    if window = nil then
    begin
      raise Exception.Create('Error while creating Window: ' + SDL_GetError);
    end;

    context := SDL_GL_CreateContext(window);

    OpenGL;
    SetViewport(640,400);

    running := true;
    while running do
    begin
      HandleEvents;
      Render;
    end;

    SDL_DestroyWindow(window);
    SDL_GL_DeleteContext(context);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
