
********************************************************************************
Reziprok oder postmateriell? 
Präferenzen in der Gestaltung nationaler Klimapolitik 
Eine Analyse am Beispiel der Schweiz mit Daten aus dem Schweizer Umweltpanel

Do-File zum Referat von Isabella Stürzer am 28.07.2022      

Umfragen und Umfrageexperimente in der Politikwissenschaft (Dr. Lukas Rudolph)
Veranstaltungsnummer: 15029                               
********************************************************************************



********************************************************************************
*Datensatz bearbeiten*                                      
********************************************************************************
Datenset laden
*use "\\nas.ads.mwn.de\ru68pez\Desktop\Datasets in use\w2_data_SEP.dta" 

Installation Add-on zur Darstellung gestapelter Säulen- & Balkendiagramme
*ssc inst catplot

Merging Dataset Welle 1 & Welle 2 SEP
Master-Datenset w2_data_SEP, using-Datenset w1_data_SEP (beide nicht öffentlich zugänglich; für nicht-kommerzielle Zwecke Zugang bentragbar über SwissUbase https://www.swissubase.ch/de/catalogue/studies/13913/17169/overview)
Key-Variable "PubID"
*merge 1:1 PubId using "\\nas.ads.mwn.de\ru68pez\Desktop\SEP Daten\w1_data_SEP.dta"

*drop if w2_flag == 1 (eliminieren der Beobachtungnen, bei denen Angaben zu Geschlecht und Geburtsjahr der Befragten von den Angaben der
Personen aus der ursprünglichen Stichprobe lt. Daten des Bevölkerungsregisters des Schweizer Bundesamtes für Statistik um mehr als +/- ein Jahr bzw. in Angaben des Geschlechts abweichen)


Verwendete Variablen aus dem gemergeten Datensatz
**w2_q0x1 birthyeaer
**w2_q0x2 gender
**w2_q9 Wirtschaft nutzen/schaden
**w2_treat3
**w2_q13 other_countries
**w2_treat5 
**w1_q4 Bildungsstand/Berufsabschluss
**w1_q20 Interesse am politischen Geschehen
**w1_q21 Ideologie verortet auf links-mitte-rechts-Spektrum
**w1_q33x1 Nettoeinkommen/Monat

fehlende/fehlerhafte Responses coden
*recode w1_q4 w1_q20 w1_q21 w1_q33x1 w2_q0x1 w2_q9 w2_q13 (-8 -77 -99 = .)

*generate Verhalten_CH=.
*replace Verhalten_CH = w2_q13 if w2_q13==1
*replace Verhalten_CH = w2_q13 if w2_q13==2
*replace Verhalten_CH = w2_q13 if w2_q13==3
*replace Verhalten_CH = w2_q13 if w2_q13==4
*replace Verhalten_CH = w2_q13 if w2_q13==5
*tabulate Verhalten_CH


*tabulate w2_treat5
*label define ene 0 "Erreichen" 1 "Nicht erreichen" (ene ist labelcontainer)
*label values w2_treat5 ene
*tabulate w2_treat5


*tabulate w2_q13
*generate treated = w2_q13 if w2_treat5==1
*tabulate treated
*label define treat 1 "Verstärken" 2 "Umsetzen" 3 "Abschwächen" 4 "Stoppen" 5 "Aussteigen" (treat ist labelcontainer)
*label values treated treat
*tabulate treated

*generate no_treatment = w2_q13 if w2_treat5==0
*tabulate no_treatment
*label define no_treat 1 "Verstärken" 2 "Umsetzen" 3 "Abschwächen" 4 "Stoppen" 5 "Aussteigen" (no_treat ist labelcontainer)
*label values no_treatment no_treat
*tabulate no_treatment

Neue Variable Alterskohorte "agecohort" generieren
7 Altersgruppen festlegen mittels Variable w2_q0x1 (label: "birthyear")
1 = 18-29 Jahre (Teilnahme am SEP ab 18 Jahren), Jahrgänge 1990-2002
2 = 30-39 Jahre, Jahrgänge 1989-1980
3 = 40-49 Jahre, Jahrgänge 1979-1970
4 = 50-59 Jahre, Jahrgänge 1969-1960
5 = 60-69 Jahre, Jahrgänge 1959-1950
6 = 70-79 Jahre, Jahrgänge 1949-1940
7 = 80-99 Jahre, Jahrgänge 1939-1924 (älteste [realistische] Teilnehmende *1924; älteste lebende Schweizerin *1912)


*tabulate w2_q0x1 
*egen agecohort = cut(w2_q0x1), at( 1924 1940 1950 1960 1970 1980 1990 2003 )
*tabulate agecohort
*label define agescohort  1924 "80-99 Jahre" 1940 "70-79 Jahre" 1950 "60-69 Jahre" 1960 "50-59 Jahre" 1970 "40-49 Jahre" 1980 "30-39 Jahre" 1990 "18-29 Jahre" (agescohort ist labelcontainer)
*label values agecohort agescohort
*tabulate agecohort

Neue Variable Einkommensgruppe "income_m" generieren
4 Gruppen festlegen mittels Variable w1_q33x1
1 = unter 2.000 CHF/Monat (Value Label 1) -> Armutsgrenze CH bei 2.279 CHF/M
2 = bis 4.000 CHF/Monat (Value Label 2) -> 50% leben von weniger als ca. 4.177 CHF/M
3 = 4.001 - 8.000 CHF/Monat (Value Labels 3,4)
4 = 8.001 - 14.000+ CHF/Monat (Value Labels 5 mit 8) -> obere 10% mehr als 7.884 CHF/M zur Verfügung

*tabulate w1_q33x1
*generate income_m = .
*replace income_m = 1 if w1_q33x1 == 1
*replace income_m = 2 if w1_q33x1 == 2
*replace income_m = 3 if (w1_q33x1 >= 3) & (w1_q33x1 <= 4)
*replace income_m = 4 if (w1_q33x1 >= 5) & (w1_q33x1 <= 8)
*drop if income_m == .

*tabulate w1_q33x1 income_m

*tabulate w2_treat3
*label define unu 0 "Umsetzt" 1 "Nicht umsetzt" (unu ist labelcontainer)
*label values w2_treat3 unu

*generate eco_nottreated = w2_q9 if w2_treat3==0
*generate eco_treated = w2_q9 if w2_treat3==1
*tabulate eco_nottreated, eco_treated

********************************************************************************
		*INDEXBILDUNG*                                   
********************************************************************************
INDEX Internationale Konsequenzen

3 Variablen (w2_q12x1 - w2_q12x3) - Welche internationalen Folgen würden Sie erwarten oder nicht erwarten, wenn
die Schweiz das Ziel einer Reduktion ihrer Treibhausgas-Emissionen bis 2030
um 50% und bis 2050 um mindestens 70% nicht erreicht? --- Bezogen auf internationale Institutionen
Zustimmung von 1 "Dies würde sicher nicht eintreten" bis 5 "Dies würde sicher eintreten"
Bildung Durchschnitts-Index 
*generate Index_IntCons = (w2_q12x1 + w2_q12x2 + w2_q12x3)/3 (oder *egen Index_IntCons = rowmean (w2_q12x1 w2_q12x2 w2_q12x3))

Test 
*alpha w2_q12x1 w2_q12x2 w2_q12x3 
Scale reliability coefficient:  0,7771    
3 Items auf der Skala, Cronbach's Alpha > 0,7 -- ist in Ordnung

*xtile Q_IntCons = Index_IntCons, nquantiles(5)
*tabulate Q_IntCons
*label define quantsInt 1 "Keine Konsequenzen" 2 "Kaum Konsequenzen" 3 "Teilweise Konsequenzen" 4 "Eher Konsequenzen" 5 "Sicher Konsequenzen" (quantsInt ist labelcontainer)
*label values Q_IntCons quantsInt
*tabulate Q_IntCons


INDEX Umweltbewusstsein via w1_q9x1 bis w1_q9x10
Achtung: Frage w1_q9x6 und w1_q9x10 sind anders gepolt als w1_q9x1 mit w1_q9x5 sowie w1_q9x7 mit w1_q9x9

*tabulate w1_q9x6 
*generate w1_q9x6mod= .
*replace w1_q9x6mod=1 if w1_q9x6==5
*replace w1_q9x6mod=2 if w1_q9x6==4
*replace w1_q9x6mod=3 if w1_q9x6==3
*replace w1_q9x6mod=4 if w1_q9x6==2
*replace w1_q9x6mod=5 if w1_q9x6==1
*tabulate w1_q9x6mod
*label define mod6 1 "Stimme überhaupt nicht zu" 2 "Stimme eher nicht zu" 3 "Stimme teils, teils zu" 4 "Stimme eher zu" 5 "Stimme voll zu" (mod6 ist labelcontainer)
*label values w1_q9x6mod mod6
*tabulate w1_q9x6mod

*tabulate w1_q9x10 
*generate w1_q9x10mod= .
*replace w1_q9x10mod=1 if w1_q9x10==5
*replace w1_q9x10mod=2 if w1_q9x10==4
*replace w1_q9x10mod=3 if w1_q9x10==3
*replace w1_q9x10mod=4 if w1_q9x10==2
*replace w1_q9x10mod=5 if w1_q9x10==1
*tabulate w1_q9x10mod
*label define mod10 1 "Stimme überhaupt nicht zu" 2 "Stimme eher nicht zu" 3 "Stimme teils, teils zu" 4 "Stimme eher zu" 5 "Stimme voll zu" (mod10 ist labelcontainer)
*label values w1_q9x10mod mod10
*tabulate w1_q9x10mod

*egen missing_variables = rowmiss(w1_q9x1 w1_q9x2 w1_q9x3 w1_q9x4 w1_q9x5 w1_q9x6mod w1_q9x7 w1_q9x8 w1_q9x9 w1_q9x10mod)
*egen Ind_ProblemRelevance = rowmean (w1_q9x1 w1_q9x2 w1_q9x3 w1_q9x4 w1_q9x5 w1_q9x6mod w1_q9x7 w1_q9x8 w1_q9x9 w1_q9x10mod) if missing_variables <=1

Test 
*alpha w1_q9x1 w1_q9x2 w1_q9x3 w1_q9x4 w1_q9x5 w1_q9x6mod w1_q9x7 w1_q9x8 w1_q9x9 w1_q9x10mod
Scale reliability coefficient:   0,8688  
10 Items auf der Skala, Cronbach's Alpha > 0,7 -- in Ordnung

*xtile Q_ProblemRelevance = Ind_ProblemRelevance, nquantiles(5)
*tabulate Q_ProblemRelevance
*label define quants 1 "Nicht erkannt" 2 "Kaum erkannt" 3 "Teils erkannt" 4 "Eher erkannt" 5 "Voll erkannt" (quants ist labelcontainer)
*label values Q_ProblemRelevance




********************************************************************************
		*Balance-Chek; Deskriptive Analyse & Visualisierung*                                   
********************************************************************************

(signifikanter) Unterschied erkennbar Gruppe & Kontrollgruppe
Varianz berechnen Treatment/No-Treatment
*tabstat w2_treat5, s(var) by(w2_q13)
Schiefe und Wölbung der Verteilung Treatment/No-Treatment berechnen
*tabstat w2_treat5, s(skewness kurtosis) by(w2_q13)


Kontingenztabelle erstellen
*tabulate w2_q13 w2_treat5

Catplot erstellen 
*catplot w2_q13, over (w2_treat5) percent (w2_treat5) asyvar recast (bar)

Säulendiagramm erstellen: Anzahl der Respondents nach Meinung zu Aktion nach Treatment
*graph bar (count) w2_q0x1, over (w2_q13) by(w2_treat5)
 kategoriale hier sind nach Geburtsjahr


********************************************************************************
		*Subgruppen-Analyse & Visualisierung*                                   
********************************************************************************
Add-on zur Visualisierung installieren
*ssc install coefplot

Boxplot erstellen
*graph box treated no_treatment, by(agecohort)

*regress Verhalten_CH i.w2_treat5##i.income_m
*margins w2_treat5, at(income_m=(1 2 3 4))
*marginsplot

*regress Verhalten_CH i.w2_treat5##i.Q_ProblemRelevance
*margins w2_treat5, at(Q_ProblemRelevance=(1 2 3 4 5))
*marginsplot


*regress Verhalten_CH i.w2_treat5##i.Q_IntCons
*margins w2_treat5, at(Q_IntCons=(1 2 3 4 5))
*marginsplot


*regress Verhalten_CH i.w2_treat5##i.w1_q20
*margins w2_treat5, at(w1_q20=(1 2 3 4 5))
*marginsplot


*regress Verhalten_CH i.w2_treat5##i.w1_q21
*margins w2_treat5, at(w1_q21=(1 2 3 4 5))
*marginsplot


*regress Verhalten_CH i.w2_treat5##i.w1_q4
*margins w2_treat5, at(w1_q4=(1 2 3 4 5 6))
*marginsplot


*regress Verhalten_CH i.w2_treat5##i.eco_treated
*margins w2_treat5, at(eco_treated=(1 2 3 4 5))
*marginsplot

*regress Verhalten_CH i.w2_treat5##i.eco_nottreated
*margins w2_treat5, at(eco_nottreated=(1 2 3 4 5))
*marginsplot



