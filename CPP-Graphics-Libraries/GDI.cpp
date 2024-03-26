/******************************************************************
 Grafika komputerowa, środowisko MS Windows - program  przykładowy
 *****************************************************************/

#include <windows.h>
#include <gdiplus.h>
using namespace Gdiplus;


struct move {
	int X = 0;
	int Y = 0;
}moveXY;
//deklaracja funkcji obslugi okna
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

//funkcja Main - dla Windows
 int WINAPI WinMain(HINSTANCE hInstance,
               HINSTANCE hPrevInstance,
               LPSTR     lpCmdLine,
               int       nCmdShow)
{
	MSG meldunek;		  //innymi slowy "komunikat"
	WNDCLASS nasza_klasa; //klasa głównego okna aplikacji
	HWND okno;
	static char nazwa_klasy[] = "Podstawowa";
	
	GdiplusStartupInput gdiplusParametry;// parametry GDI+; domyślny konstruktor wypełnia strukturę odpowiednimi wartościami
	ULONG_PTR	gdiplusToken;			// tzw. token GDI+; wartość uzyskiwana przy inicjowaniu i przekazywana do funkcji GdiplusShutdown
   
	// Inicjujemy GDI+.
	GdiplusStartup(&gdiplusToken, &gdiplusParametry, NULL);

	//Definiujemy klase głównego okna aplikacji
	//Okreslamy tu wlasciwosci okna, szczegoly wygladu oraz
	//adres funkcji przetwarzajacej komunikaty
	nasza_klasa.style         = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
	nasza_klasa.lpfnWndProc   = WndProc; //adres funkcji realizującej przetwarzanie meldunków 
 	nasza_klasa.cbClsExtra    = 0 ;
	nasza_klasa.cbWndExtra    = 0 ;
	nasza_klasa.hInstance     = hInstance; //identyfikator procesu przekazany przez MS Windows podczas uruchamiania programu
	nasza_klasa.hIcon         = 0;
	nasza_klasa.hCursor       = LoadCursor(0, IDC_ARROW);
	nasza_klasa.hbrBackground = (HBRUSH) GetStockObject(GRAY_BRUSH);
	nasza_klasa.lpszMenuName  = "Menu" ;
	nasza_klasa.lpszClassName = nazwa_klasy;

    //teraz rejestrujemy klasę okna głównego
    RegisterClass (&nasza_klasa);
	
	/*tworzymy okno główne
	okno będzie miało zmienne rozmiary, listwę z tytułem, menu systemowym
	i przyciskami do zwijania do ikony i rozwijania na cały ekran, po utworzeniu
	będzie widoczne na ekranie */
 	okno = CreateWindow(nazwa_klasy, "Grafika komputerowa", WS_OVERLAPPEDWINDOW | WS_VISIBLE,
						CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL);
	
	
	/* wybór rozmiaru i usytuowania okna pozostawiamy systemowi MS Windows */
   	ShowWindow (okno, nCmdShow) ;
    
	//odswiezamy zawartosc okna
	UpdateWindow (okno) ;

	// GŁÓWNA PĘTLA PROGRAMU
	while (GetMessage(&meldunek, NULL, 0, 0))
     /* pobranie komunikatu z kolejki; funkcja GetMessage zwraca FALSE tylko dla
	 komunikatu WM_QUIT; dla wszystkich pozostałych komunikatów zwraca wartość TRUE */
	{
		TranslateMessage(&meldunek); // wstępna obróbka komunikatu
		DispatchMessage(&meldunek);  // przekazanie komunikatu właściwemu adresatowi (czyli funkcji obslugujacej odpowiednie okno)
	}

	GdiplusShutdown(gdiplusToken);
	
	return (int)meldunek.wParam;
}

/********************************************************************
FUNKCJA OKNA realizujaca przetwarzanie meldunków kierowanych do okna aplikacji*/
LRESULT CALLBACK WndProc (HWND okno, UINT kod_meldunku, WPARAM wParam, LPARAM lParam)
{
	HMENU mPlik, mInfo, mGlowne;
/* PONIŻSZA INSTRUKCJA DEFINIUJE REAKCJE APLIKACJI NA POSZCZEGÓLNE MELDUNKI */
	switch (kod_meldunku) 
	{
	case WM_CREATE:  //meldunek wysyłany w momencie tworzenia okna
		mPlik = CreateMenu();
		AppendMenu(mPlik, MF_STRING, 100, "&Zapiszcz...");
		AppendMenu(mPlik, MF_SEPARATOR, 0, "");
		AppendMenu(mPlik, MF_STRING, 101, "&Koniec");
		mInfo = CreateMenu();
		AppendMenu(mInfo, MF_STRING, 200, "&Autor...");
		mGlowne = CreateMenu();
		AppendMenu(mGlowne, MF_POPUP, (UINT_PTR) mPlik, "&Plik");
		AppendMenu(mGlowne, MF_POPUP, (UINT_PTR) mInfo, "&Informacja");
		SetMenu(okno, mGlowne);
		DrawMenuBar(okno);

	case WM_COMMAND: //reakcje na wybór opcji z menu
		switch (wParam)
		{
		case 100: if(MessageBox(okno, "Zapiszczeć?", "Pisk", MB_YESNO) == IDYES)
					MessageBeep(0);
                  break;
		case 101: DestroyWindow(okno); //wysylamy meldunek WM_DESTROY
        		  break;
		case 200: MessageBox(okno, "Imię i nazwisko: Tomasz Sankowski\nNumer indeksu: s193363", "Autor", MB_OK);
		}
		return 0;
	
	case WM_LBUTTONDOWN: //reakcja na lewy przycisk myszki
		{
			int x = LOWORD(lParam);
			int y = HIWORD(lParam);

			return 0;
		}
	case WM_KEYDOWN:
	{
		if (wParam==VK_UP) {
			moveXY.Y -= 5;
		}
		else if (wParam ==VK_DOWN) {
			moveXY.Y += 5;
		}
		InvalidateRect(okno, 0, TRUE);
		return 0;
	}
	case WM_PAINT:
		{
			PAINTSTRUCT paint;
			HDC kontekst;

			kontekst = BeginPaint(okno, &paint);
		
			// MIEJSCE NA KOD GDI

			/*HPEN pioro = CreatePen(PS_SOLID, 10, RGB(255,0,0));
			SelectObject(kontekst, pioro);

			MoveToEx(kontekst, 100, 300, NULL);
			LineTo(kontekst, 800, 300);
			
			DeleteObject(pioro);*/

			// utworzenie obiektu umożliwiającego rysowanie przy użyciu GDI+
			// (od tego momentu nie można używać funkcji GDI
			
			// MIEJSCE NA KOD GDI+


			Graphics grafika(kontekst);
			Pen czarnePioro(Color::Color(255, 0, 0, 0));
			SolidBrush szary(Color::Color(255, 180, 180, 180));
			SolidBrush bialy(Color::Color(255, 255, 255, 255));
			SolidBrush czerwony(Color::Color(255, 255, 0, 0));

			GraphicsPath* myGraphicsPath = new GraphicsPath();
			Point point1(100, 100 + moveXY.Y);
			Point point2(200, 100 + moveXY.Y);
			Point point3(200, 300 + moveXY.Y);
			Point point4(100, 300 + moveXY.Y);
			Point point5(100, 100 + moveXY.Y);
			Point rocket[5] = { point1, point2, point3, point4, point5 };
			//grafika.DrawPolygon(&czarnePioro, rocket, 5);
			grafika.FillPolygon(&szary, rocket, 5);

			point1 = Point(200, 300 + moveXY.Y);
			point2 = Point(250, 350 + moveXY.Y);
			point3 = Point(250, 300 + moveXY.Y);
			point4 = Point(200, 250 + moveXY.Y);
			Point rocket2[4] = { point1, point2, point3, point4 };
			//grafika.DrawPolygon(&czarnePioro, rocket2, 4);
			grafika.FillPolygon(&czerwony, rocket2, 4);

			point1 = Point(100, 300 + moveXY.Y);
			point2 = Point(50, 350 + moveXY.Y);
			point3 = Point(50, 300 + moveXY.Y);
			point4 = Point(100, 250 + moveXY.Y);
			Point rocket3[4] = { point1, point2, point3, point4 };
			//grafika.DrawPolygon(&czarnePioro, rocket3, 4);
			grafika.FillPolygon(&czerwony, rocket3, 4);

			point1 = Point(125, 300 + moveXY.Y);
			point2 = Point(100, 350 + moveXY.Y);
			point3 = Point(200, 350 + moveXY.Y);
			point4 = Point(175, 300 + moveXY.Y);
			Point rocket4[4] = { point1, point2, point3, point4 };
			//grafika.DrawPolygon(&czarnePioro, rocket4, 4);
			grafika.FillPolygon(&czerwony, rocket4, 4);

			//grafika.DrawArc(&czarnePioro, 100, 50, 100, 100,180,180);
			grafika.FillPie(&szary, 100, 50 + moveXY.Y, 100, 100, 180, 180);
			//grafika.DrawEllipse(&czarnePioro, 125, 150, 50, 50);
			grafika.FillEllipse(&bialy, 125, 150 + moveXY.Y, 50, 50);

			//grafika.FillPolygon(szary,)
			EndPaint(okno, &paint);

			// utworzenie czcionki i wypisanie tekstu na ekranie
			/*FontFamily  fontFamily(L"Times New Roman");
			Font        font(&fontFamily, 24, FontStyleRegular, UnitPixel);
			PointF      pointF(100.0f, 400.0f);
			SolidBrush  solidBrush(Color(255, 0, 0, 255));


			grafika.DrawString(L"To jest tekst napisany za pomocą GDI+.", -1, &font, pointF, &solidBrush);*/

			EndPaint(okno, &paint);

			return 0;
		}
  	
	case WM_DESTROY: //obowiązkowa obsługa meldunku o zamknięciu okna
		PostQuitMessage (0) ;
		return 0;
    
	default: //standardowa obsługa pozostałych meldunków
		return DefWindowProc(okno, kod_meldunku, wParam, lParam);
	}
}
