# Medianfilter (Assembler)

## Beschreibung
Ein Medianfilter teilt ein Array in Blöcke fester (ungerader) Länge und erzeugt aus den Medianwerten der Blöcke ein neues, gefiltertes Signal.
Dies ist eine x86-Assembler Implementierung des Medianfilters, der von einem C-Programm aufgerufen wird.

## Voraussetzungen

Getestet mit:
* Ubuntu 16.04 (64-bit)
* Assembler: nasm 2.11.08
* gcc 5.4.0
* gnuplot 5.0

## Kompilieren

Zum Assemblieren des Filters und Kompilieren des Rahmenprogramms kann das Makefile verwendet werden.
```bash
$ make
```
Für die Testumgebung gibt es ebenfalls ein Makefile.
```bash
$ cd tests
$ make
```
Die erzeugten Dateien können mit
```bash
$ make clean
```
wieder entfernt werden.

## Testen
Das Rahmenprogramm kann mit 
```bash
$ ./main
```
ausgeführt werden. Die Parameter sind jedoch in`main.c` festgelegt. Für flexibleres Testen bietet sich die Testumgebung an.
```bash
$ cd tests
$ ./test_filter
```
Es kann aus den folgenden Testmodi gewählt werden.

#### 1. Randomly generated signals
Eingabe: <*Anzahl Testläufe*> <*Wertebereich*> <*Signallänge*> <*Blocklänge*>
In jedem Testlauf wird ein zufälliges Signal erzeugt und gefiltert. Das Ergebnis wird auf Richtigkeit geprüft. Die Ausgabe steht in `debug.txt`.
#### 2. Custom input
Eingabe: <*Blocklänge*>
In `custom_signal.dat` können benutzerdefinierte Signale abgelegt werden (Leerzeichen zwischen Werten, ein Signal pro Zeile).
Diese werden gefiltert und geprüft, die Ausgabe steht in `debug.txt`.
#### 3. Plot function
Zum Visualisieren des Filters kann aus mehreren Funktionen ausgewählt werden (Sinus, Kosinus, Exponentialfunktion, Logarithmus, Wurzel), die mit einem Rauschen versehen und gefiltert werden. Beide Signale werden mit gnuplot dargestellt.
Die Funktionen können mit
```bash
$ cd plots
$ ./generate_plots
```
neu erzeugt werden. Es kann auch ein eigenes Signal in `custom.dat` definiert werden, das Format kann den Beispielfunktionen entnommen werden.

## Autoren

* Ruben Bachmann
* Franziska Steinle
* Roland Würsching


