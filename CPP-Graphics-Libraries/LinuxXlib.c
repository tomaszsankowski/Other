
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define TRUE 1
#define FALSE 0

int red, green, blue, yellow;
unsigned long foreground, background;


//*************************************************************************************************************************
//funkcja przydzielania kolorow

int AllocNamedColor(char *name, Display* display, Colormap colormap)
  {
    XColor col;
    XParseColor(display, colormap, name, &col);
    XAllocColor(display, colormap, &col);
    return col.pixel;
  } 

//*************************************************************************************************************************
// inicjalizacja zmiennych globalnych okreslajacych kolory

int init_colors(Display* display, int screen_no, Colormap colormap)
{
  background = WhitePixel(display, screen_no);  //niech tlo bedzie biale
  foreground = BlackPixel(display, screen_no);  //niech ekran bedzie czarny
  red=AllocNamedColor("red", display, colormap);
  green=AllocNamedColor("green", display, colormap);
  blue=AllocNamedColor("blue", display, colormap);
  yellow=AllocNamedColor("yellow", display, colormap);
}

//*************************************************************************************************************************
// Glowna funkcja zawierajaca petle obslugujaca zdarzenia */

int main(int argc, char *argv[])
{
  char            icon_name[] = "Grafika";
  char            title[]     = "Grafika komputerowa";
  Display*        display;    //gdzie bedziemy wysylac dane (do jakiego X servera)
  Window          window;     //nasze okno, gdzie bedziemy dokonywac roznych operacji
  GC              gc;         //tu znajduja sie informacje o parametrach graficznych
  XEvent          event;      //gdzie bedziemy zapisywac pojawiajace sie zdarzenia
  KeySym          key;        //informacja o stanie klawiatury 
  Colormap        colormap;
  int             screen_no;
  XSizeHints      info;       //informacje typu rozmiar i polozenie ok
  
  char            buffer[8];  //gdzie bedziemy zapamietywac znaki z klawiatury
  int             hm_keys;    //licznik klawiszy
  int             to_end;

  display    = XOpenDisplay("");                //otworz polaczenie z X serverem pobierz dane od zmiennej srodowiskowej DISPLAY ("")
  screen_no  = DefaultScreen(display);          //pobierz domyslny ekran dla tego wyswietlacza (0)
  colormap = XDefaultColormap(display, screen_no);
  init_colors(display, screen_no, colormap);

  //okresl rozmiar i polozenie okna
  info.x = 100;
  info.y = 150;
  info.width = 500;
  info.height = 300;
  info.flags = PPosition | PSize;

  //majac wyswietlacz, stworz okno - domyslny uchwyt okna
  window = XCreateSimpleWindow(display, DefaultRootWindow(display),info.x, info.y, info.width, info.height, 7/* grubosc ramki */, foreground, background);
  XSetStandardProperties(display, window, title, icon_name, None, argv, argc, &info);
  //utworz kontekst graficzny do zarzadzania parametrami graficznymi (0,0) domyslne wartosci
  gc = XCreateGC(display, window, 0, 0);
  XSetBackground(display, gc, background);
  XSetForeground(display, gc, foreground);

  //okresl zdarzenia jakie nas interesuja, np. nacisniecie klawisza
  XSelectInput(display, window, (KeyPressMask | ExposureMask | ButtonPressMask| ButtonReleaseMask | Button1MotionMask));
  XMapRaised(display, window);  //wyswietl nasze okno na samym wierzchu wszystkich okien
      
  to_end = FALSE;

  XPoint points1[] = { 
            {50,40},
            {150,40},
            {150,60},
            {70,60},
            {70,100},
            {150,100},
            {150,150},
            {130,170},
            {60,170},
            {50,140},
            {70,140},
            {80,155},
            {120,155},
            {130,140},
            {130,120},
            {50,120},
            {50,40}
          };
    int sizeX = 120;
    int sizeY = 130;
    int numberOfFives = 1;
    typedef struct{
      int x,y,isset;
    }Obiekt;
    Obiekt fives[20];
    fives[0].x = 30;
    fives[0].y = 40;
    fives[0].isset = TRUE;
 /* petla najpierw sprawdza, czy warunek jest spelniony
     i jesli tak, to nastepuje przetwarzanie petli
     a jesli nie, to wyjscie z petli, bez jej przetwarzania */

  while (to_end == FALSE)
  {
    XNextEvent(display, &event);  // czekaj na zdarzenia okreslone wczesniej przez funkcje XSelectInput

    switch(event.type)
    {
      case Expose:
        if (event.xexpose.count == 0)
        {
         
          XSetForeground(display, gc, foreground);
          XClearWindow(display, window);
          XFillPolygon(display,window,gc,points1,16,Nonconvex,CoordModeOrigin);
          XFillArc(display,window,gc,30,40,40,80,90*64,180*64);
          XFlush(display);
        }
        break;

      case MappingNotify:
        XRefreshKeyboardMapping(&event.xmapping); // zmiana ukladu klawiatury - w celu zabezpieczenia sie przed taka zmiana trzeba to wykonac
        break;

      case ButtonPress:
        if (event.xbutton.button == Button1)  // sprawdzenie czy wcisnieto lewy przycisk		
        {
          int isEmpty = TRUE;
          for(int i=0;i<numberOfFives;i++){
            if(fives[i].x <= event.xbutton.x && fives[i].x + sizeX >= event.xbutton.x && fives[i].y <= event.xbutton.y && fives[i].y + sizeY >= event.xbutton.y){
              fives[i].isset = FALSE;
              isEmpty = FALSE;
            }
          }
          if(isEmpty == TRUE){
            fives[numberOfFives].x = event.xbutton.x;
              fives[numberOfFives].y = event.xbutton.y;
              fives[numberOfFives].isset = TRUE;
              numberOfFives++;
          }
          XSetForeground(display, gc, foreground);
          XClearWindow(display, window);
          for(int i=0;i<numberOfFives;i++){
            if(fives[i].isset == TRUE){
              int dx = fives[i].x;
              int dy = fives[i].y;
              XPoint points1[] = { 
              {dx + 20,dy},
              {dx + 120,dy},
              {dx + 120,dy + 20},
              {dx + 40,dy + 20},
              {dx + 40,dy + 60},
              {dx + 120,dy + 60},
              {dx + 120,dy + 110},
              {dx + 100,dy + 130},
              {dx + 30,dy + 130},
              {dx + 20,dy + 100},
              {dx + 40,dy + 100},
              {dx + 50,dy + 115},
              {dx + 90,dy + 115},
              {dx + 100,dy + 100},
              {dx + 100,dy + 80},
              {dx + 20,dy + 80},
              {dx + 20,dy}
              };
              XFillPolygon(display,window,gc,points1,16,Nonconvex,CoordModeOrigin);
              XFillArc(display,window,gc,dx,dy,40,80,90*64,180*64);
            }
          }
          XFlush(display);
    
        }
        break;


      case KeyPress:
        hm_keys = XLookupString(&event.xkey, buffer, 8, &key, 0);
        if (hm_keys == 1)
        {
          if (buffer[0] == 'q') to_end = TRUE;        // koniec programu
          
        }

      default:
        break;
    }
  }

  XFreeGC(display, gc);
  XDestroyWindow(display, window);
  XCloseDisplay(display);

  return 0;
}
