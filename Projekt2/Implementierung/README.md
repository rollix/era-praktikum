# ALU des Am2901 (VHDL)

## Beschreibung
Die Arithmetisch-Logische Einheit (ALU) ist der Teil des mikroprogrammierbaren Rechenwerks, der für die eigentlichen Rechenoperationen zuständig ist. Als Eingabe erhält die ALU zwei 16-Bit Wörter sowie den Opcode der Rechenoperation. Der Baustein ist mit 50 MHz getaktet und kann durch ein CE-Signal ein- und ausgeschaltet werden.

## Voraussetzungen

Getestet mit:
* Ubuntu 16.04 (64-bit)
* GHDL 0.33
* GTWave Analyzer v3.3.66

## Kompilieren
Mit
```bash
$ make alu
```
wird die Testbench kompiliert und ausgeführt; das Ergebnis wird als `ALU.vcd` gespeichert. Diese Datei kann mit 
```bash
$ make gtk
```
in GTKWave dargestellt werden.
Um alle erzeugten Dateien zu entfernen, kann
```bash
$ make clean
```
verwendet werden.

## Testen
#### Testbench
Zum Testen kann die bereitgestellte Testbench mittels `./alu_tb` verwendet werden. Eine fehlerhafte Operation wird durch einen *assertion error* angezeigt, Undefinierte Werte (z.B. X, U) können *assertion warnings* erzeugen. Eine korrekte Implementierung sollte keine *errors* aufweisen.
#### GTKWave
Die Signalverläufe sind im Fenster *Waves* dargestellt. Mit der Maus können Signale vom linken Fenster nach *Signals* gezogen und per Rechtsklick wieder gelöscht werden.
Mit *Zoom Fit* (links oben) kann der gesamte verwendete Zeitbereich betrachtet werden.
Über `File > Write Save File As` kann die aktuelle Konfiguration als `ALU_config.gtkw`gespeichert werden. Sie wird beim nächsten Aufruf von `gtkwave` wieder geladen. 

## Autoren

* Ruben Bachmann
* Franziska Steinle
* Roland Würsching


