%miraSeries(Persona, Series).
miraSeries(juan, himym).
miraSeries(nico, starWars).
miraSeries(maiu, starWars).
miraSeries(gaston, hoc).
miraSeries(juan, futurama).
miraSeries(nico, got).
miraSeries(maiu, got).
miraSeries(juan, got).
miraSeries(maiu, onePiece).


personas(Persona):-
  miraSeries(Persona, _).
personas(Persona):-
  quiereVer(Persona, _).
 
:- encoding(utf8). 
:- begin_tests(miraSeries).

test(juanMiraSeries, nondet) :-
    miraSeries(juan, Serie), Serie == himym.
	
test(juanMiraSeries, nondet) :-
    miraSeries(juan, Serie), Serie == futurama.	
test(juanMiraSeries, nondet) :-
    miraSeries(juan, Serie), Serie == got.

test(nicoMiraSeries, nondet) :-
    miraSeries(nico, Serie), Serie == starWars.
test(nicoMiraSeries, nondet) :-
    miraSeries(nico, Serie), Serie == got.
	
test(maiuMiraSeries) :-
    miraSeries(maiu, Serie), Serie == starWars.
test(maiuMiraSeries) :-
    miraSeries(maiu, Serie), Serie == got.
test(maiuMiraSeries) :-
    miraSeries(maiu, Serie), Serie == onePiece.

test(gastonMiraSeries) :-
    miraSeries(gaston, Serie), Serie == hoc.
	
test(alfNoMiraSeries) :-
    not(miraSeries(alf, Serie)).
	
:- end_tests(miraSeries). 
 

%Alf no ve ninguna serie porque el doctorado le consume toda la vida
%Alf no se define por no pertenecer a los que miran series. No hace falta negarlo

%himym, starWars, got, futurama, hoc, onePiece, drHouse, madMen.
%quiereVer(Persona, Series).
quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gaston, himym).


:- begin_tests(quiereVer).
test(juanQuiereVer):-
	quiereVer(juan, Serie), Serie == hoc.
test(ayeQuiereVer):-
	quiereVer(aye, Serie), Serie == got.
test(gastonQuiereVer):-
	quiereVer(gaston, Serie), Serie == himym.

:- end_tests(quiereVer).

:- begin_tests(sonPopulares).

test(seriesPopulares):-
	sonPopulares(Serie), Serie == got.
test(seriesPopulares):-
	sonPopulares(Serie), Serie == hoc.
test(seriesPopulares):-
	sonPopulares(Serie), Serie == starWars.
	
:- end_tests(sonPopulares).


%sonPopulares(Series).
sonPopulares(hoc).
sonPopulares(got).
sonPopulares(starWars).

%episodios(Serie, Temporada, Episodios).
episodios(got, 3, 12).
episodios(got, 2, 10).
episodios(himym, 1, 23).
episodios(drHouse, 8, 16).
episodios(madMen, 2).


:- begin_tests(episodios).

test(cuantosEpidodiosTieneGOT):-
	episodios(got, 3, Episodio), Episodio == 12.
test(cuantosEpidodiosTieneGOT):-
	episodios(got, 2, Episodio), Episodio == 10.

test(cuantosEpidodiosTieneHimym):-
	episodios(himym, 1, Episodio), Episodio == 23.

test(cuantosEpidodiosTieneDrHouse):-
	episodios(drHouse, 8, Episodio), Episodio == 16.

test(noSabemosCuantosEpidodiosTieneMadMen):-
	not(episodios(madMen, 2, Episodio)).

:- end_tests(episodios).


%paso(Serie, Temporada, Episodio, Lo que paso)
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

%leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

esSpoiler(Serie, Spoiler):-   %es consulta existencial
  paso(Serie,_,_,Spoiler).


  
:- begin_tests(esSpoiler).
test(muereEmperorEnStartWars):-
	esSpoiler(starWars, muerte(emperor)).

test(noMuerePedroEnStartWars):-
	not(esSpoiler(starWars, muerte(pedro))).

test(parentescoDeAnakinYelReyEnStartWars):-
	esSpoiler(starWars, relacion(parentesco, anakin, rey)).

test(noHayparentescoDeAnakinYLavezziEnStartWars):-
	not(esSpoiler(starWars, relacion(parentesco, anakin, lavezzi))).

:- end_tests(esSpoiler). 



%miraOPlaneaVer que nos diga si una persona mira o planea ver una serie
miraOPlaneaVer(Persona, Serie):-
  miraSeries(Persona, Serie).
miraOPlaneaVer(Persona, Serie):-
  quiereVer(Persona, Serie).

leSpoileo(Sabe, NoLaVio, Serie):-
  miraOPlaneaVer(NoLaVio, Serie),
  leDijo(Sabe, NoLaVio, Serie, Spoiler),
  esSpoiler(Serie, Spoiler).



:- begin_tests(leSpoileo).
  
test(gastonLeSpoileoGOTAMaiu):-
	leSpoileo(gaston, maiu, got).
  
test(nicoLeSpoileoStartWarsAMaiu):-
	leSpoileo(nico, maiu, starWars).
	
:- end_tests(leSpoileo).  



noLeSpoileo(Sabe, NoLoVio, Serie):-
  not(leSpoileo(Sabe, NoLoVio, Serie)).

televidenteResponsable(Persona):-
  personas(Persona),
    noLeSpoileo(Persona, _, _).


:- begin_tests(televidenteResponsable).
test(juanEsTelevieteResponsable):-
	televidenteResponsable(juan).

test(ayeEsTelevidenteResponsable):-
	televidenteResponsable(aye).

test(maiuEsTelevidenteResponsable):-
	televidenteResponsable(maiu).

test(nicoNoEsTelevidenteResponsable):-
	not(televidenteResponsable(nico)).

test(gastonNoEsTelevidenteResponsable):-
	not(televidenteResponsable(gaston)).

:- end_tests(televidenteResponsable).


cosasFuertes(Serie):-
	paso(Serie, _, _, muerte(_)).
cosasFuertes(Serie):-
	paso(Serie, _, _, relacion(parentesco, _,_)).
cosasFuertes(Serie):-
	paso(Serie, _, _, relacion(amorosa, _,_)).

seriesDeInterés(Serie):-
  cosasFuertes(Serie).

seriesDeInterés(Serie):-
  sonPopulares(Serie).
  
vieneZafando(Persona, Series):-
    seriesDeInterés(Series),
    miraOPlaneaVer(Persona, Series),
    noLeSpoileo(_, Persona, Series).

 % vieneZafando(Persona, Series):-
   % seriesDeInterés(Series),
   % miraSeries(Persona, Series),
   % not(leSpoileo(Sabe, Persona, Series)).
