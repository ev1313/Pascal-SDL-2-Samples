program opengl_sample_1;

{
  OpenGL Sample 1
  ---------------

  This simple Example demonstrates how using opengl with one window with SDL 2.
}

{$APPTYPE CONSOLE}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses
  dglOpenGL,
  SDL,
  SysUtils;

type
  TVertex = record
    x,y,z: Float;
  end;

var
  window: PSDL_Window;
  context: TSDL_GLContext;
  running: Boolean;
  triangle,
  quad: array of TVertex;

procedure OpenGL;
begin
  //Initialize OpenGL
  InitOpenGL;
  ReadExtensions;
  ReadImplementationProperties;

  //some good presettings
  glClearColor(0.0, 0.0, 0.0, 1.0);  //background: black
  glClearDepth(1.0);                 //depth-test
  glEnable(GL_DEPTH_TEST);           //depth-test
  glDepthFunc(GL_LEQUAL);            //depth-test
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST); //nice perspective correction
end;

procedure SetViewport(w,h: Integer);
begin
  //reset the opengl viewport
  if w <= 0 then w := 1;
  if h <= 0 then h := 1;

  glViewport( 0, 0, w, h );

  //perspective projection, with fov of 45
  //and clipping plane from 0,1 to 100
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
          SDL_WINDOWEVENT_SIZE_CHANGED:
          begin
            if event.window.windowID = SDL_GetWindowID(window) then
            begin
              SetViewport(window.w,window.h);
            end;
          end;
          SDL_WINDOWEVENT_CLOSE:
          begin
            if event.window.windowID = SDL_GetWindowID(window) then
            begin
              SDL_DestroyWindow(window);
              window := nil;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure Render;
begin
  //render a triangle and a quad
  glClear( GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT );

  glLoadIdentity();
  glTranslatef( -1.5, 0.0, -3.0 );

  glEnableClientState(GL_VERTEX_ARRAY);

  glColor3f(0,0,1);
  glVertexPointer(3, GL_FLOAT, 0, triangle);
  glDrawArrays(GL_TRIANGLE_FAN, 0, 3);

  glTranslatef(2,0,0);

  glColor3f(1,0,0);
  glVertexPointer(3, GL_FLOAT, 0, quad);
  glDrawArrays(GL_TRIANGLE_FAN, 0, 4);

  glDisableClientState(GL_VERTEX_ARRAY);

  SDL_GL_SwapWindow(window);
end;

begin
  try
    //store data of triangle/quad:
    SetLength(triangle,3);
    triangle[0].x := 0.0;
    triangle[0].y := 0.0;
    triangle[0].z := 0.0;
    triangle[1].x := 1.0;
    triangle[1].y := 0.0;
    triangle[1].z := 0.0;
    triangle[2].x := 0.5;
    triangle[2].y := 1.0;
    triangle[2].z := 0.0;
    SetLength(quad,4);
    quad[0].x := 0.0;
    quad[0].y := 0.0;
    quad[0].z := 0.0;
    quad[1].x := 1.0;
    quad[1].y := 0.0;
    quad[1].z := 0.0;
    quad[2].x := 1.0;
    quad[2].y := 1.0;
    quad[2].z := 0.0;
    quad[3].x := 0.0;
    quad[3].y := 1.0;
    quad[3].z := 0.0;

    //initialize SDL
    if SDL_Init(SDL_INIT_VIDEO) > 0 then
    begin
      raise Exception.Create('Error at initializing SDL_VIDEO: ' + SDL_GetError);
    end;

    //create a window at 200 x and 200 y, 640 wide, 400 high and with opengl-support
    window := SDL_CreateWindow('Sample 1', 200, 200, 640, 400, SDL_WINDOW_OPENGL or
                                                               SDL_WINDOW_RESIZABLE);

    //check if window is created correctly
    if window = nil then
    begin
      raise Exception.Create('Error while creating Window: ' + SDL_GetError);
    end;

    //Set Contextversion
    //ALWAYS use the MINIMUM supported OpenGL-Version there!
    //all functions from older versions are not avaiable!
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);

    //create opengl context for the window
    context := SDL_GL_CreateContext(window);

    //initialize opengl
    OpenGL;
    //set the viewport
    SetViewport(640,400);

    //mainloop
    running := true;
    while running and (window <> nil) do
    begin
      HandleEvents;
      Render;
    end;

    //finally free requested resources.
    SDL_DestroyWindow(window);
    SDL_GL_DeleteContext(context);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
