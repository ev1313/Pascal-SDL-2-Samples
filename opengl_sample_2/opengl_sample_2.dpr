program opengl_sample_2;

{
  OpenGL Sample 2
  ---------------

  This simple Example demonstrates how using two windows with opengl-support with SDL 2.

  It also demonstrates correct eventhandling with more than one window.
}

{$APPTYPE CONSOLE}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses
  dglOpenGL,
  SDL,
  SysUtils;

var
  window: PSDL_Window;
  window2: PSDL_Window;
  context: TSDL_GLContext;
  running: Boolean;

procedure OpenGL;
begin
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
      SDL_WINDOWEVENT:
      begin
        case event.window.event of
          SDL_WINDOWEVENT_CLOSE:
          begin
            if event.window.windowID = SDL_GetWindowID(window) then
            begin
              SDL_DestroyWindow(window);
              window := nil;
            end;
            if event.window.windowID = SDL_GetWindowID(window2) then
            begin
              SDL_DestroyWindow(window2);
              window2 := nil;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure Render(r,g,b: Integer);
begin
  glClear( GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT );

  glLoadIdentity;
  glTranslatef( -1.5, 0.0, -6.0 );

  glColor3f(r,g,b);
  glBegin( GL_TRIANGLES );
    glVertex3f( 0.0, 1.0, 0.0 );
    glVertex3f( -1.0, -1.0, 0.0 );
    glVertex3f( 1.0, -1.0, 0.0 );
  glEnd;

  glTranslatef( 3.0, 0.0, 0.0 );

  glColor3f(r,g,b);
  glBegin( GL_QUADS );
    glVertex3f( -1.0, 1.0, 0.0 );
    glVertex3f( 1.0, 1.0, 0.0 );
    glVertex3f( 1.0, -1.0, 0.0 );
    glVertex3f( -1.0, -1.0, 0.0 );
  glEnd;
end;

begin
  try
    if SDL_Init(SDL_INIT_VIDEO) > 0 then
    begin
      raise Exception.Create('Error at initializing SDL_VIDEO: ' + SDL_GetError);
    end;

    window := SDL_CreateWindow('Sample 2 - Window 1', 200, 200, 640, 400, SDL_WINDOW_OPENGL);

    if window = nil then
    begin
      raise Exception.Create('Error while creating Window: ' + SDL_GetError);
    end;

    window2 := SDL_CreateWindow('Sample 2 - Window 2', 400, 400, 640, 400, SDL_WINDOW_OPENGL);

    if window2 = nil then
    begin
      raise Exception.Create('Error while creating Window: ' + SDL_GetError);
    end;

    InitOpenGL;
    ReadExtensions;
    ReadImplementationProperties;

    //Creates a context supporting opengl 1.0 and up.
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 1);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);

    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

    context := SDL_GL_CreateContext(window);

    if context = nil then
    begin
      raise Exception.Create('Error while creating Context: ' + SDL_GetError);
    end;

    OpenGL;
    SetViewport(640,400);

    running := true;
    while running do
    begin
      HandleEvents;
      if window <> nil then
      begin
        SDL_GL_MakeCurrent(window, context);
        Render(1,0,0);
        SDL_GL_SwapWindow(window);
      end;
      if window2 <> nil then
      begin
        SDL_GL_MakeCurrent(window2, context);
        Render(0,0,1);
        SDL_GL_SwapWindow(window2);
      end;
      if (window = nil) and (window2 = nil) then
        running := false;
    end;

    SDL_GL_DeleteContext(context);
    SDL_DestroyWindow(window);
    SDL_DestroyWindow(window2);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
