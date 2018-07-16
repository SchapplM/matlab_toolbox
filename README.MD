# Matlab-Toolbox

Dieses Repo enthält eine Sammlung von allgemeinen Matlab-Funktionen, die die Benutzung von Matlab/Simulink erleichtern sollen und mit den mitgelieferten Funktionen von Matlab unzureichend abgedeckt sind.

Moritz Schappler, schappler@imes.uni-hannover.de, 2018-03  
(C) Institut für mechatronische Systeme, Universität Hannover

## Benutzung

Für die Benutzung des Repos muss die Pfadinitialisierung durchgeführt werden mit dem Skript `matlab_tools_path_init.m` aus dem Hauptordner.

### Modultests

Die einzelnen Funktionen des Repos können über die Modultests aus dem Ordner `examples_tests` gestartet werden. Die Funktionsfähigkeit des Gesamt-Repos kann mit dem Gesamt-Testskript `matlab_tools_test_repo.m` aus dem Hauptordner geprüft werden.

## Inhalt

Hier erfolgt eine kurze Übersicht der im Repo enthaltenen Funktionen. Die Funktionsweise ist in den jeweiligen Funktionsdateien und Modultests erklärt.

* Kompilierung (Ordner `coder`)
  * Automatische Kompilierung einer Matlab-Funktion als .mex-Datei: `matlabfcn2mex.m`
  * Automatische Kompilierung aller mex-Abhängigkeiten eines Matlab-Skriptes: `mex_script_dependencies.m`
  * Kompilierung aller Matlab-Funktionen in einem Verzeichnis: `mex_all_matlabfcn_in_dir.m`
* Datenverarbeitung (Ordner `data_handling`)
  * Umwandlung der Ausgabe von über Matlab-Skripte gestarteten Simulink-Modellen in andere Datenformate: `simulink_signal2struct.m`
  * Verarbeitung von Datenstrukturen, die Zeitreihen von Daten enthalten. Dies ist vorteilhaft bei der Handhabung von Trajektorien und Simulations- und Messdaten: `timestruct_append.m`, `timestruct_merge.m`, `timestruct_repeat.m`, ...
  * Ausgabe eines Arrays als String mit Formatierung für Matlab-Eingabe: `disp_array.m`
* Signalverarbeitung (Ordner `signal_processing`)
  * Tiefpassfilterung von Daten: `filtfilt_lowpass_order1_discr.m`
* Plot-bezogene Funktionen (Ordner `plot`)
  * FFT-Plot mit Online FFT aus einem anderen subplot: `plot_fft.m`
  * Figure auf publikationsgeeignetes Format bringen: `figure_format_publication.m`
  * Linienformate aus publikationsgeeignetes Format bringen: `line_format_publication.m`
  * Größe einer Figure anpassen (für Publikation): `set_size_plot_subplot.m`
  * Redundante Achsbeschriftungen entfernen: `remove_inner_labels.m`
  * Achseneinteilung verbinden: `linkxaxes.m`
  * Subplot-Nummer aus Zeilen-/Spaltennummer erzeugen: `sprc2no.m`
  * Alle Figures andocken: `dockall.m`
* Dateisystembezogene Funktionen:
  * Pfad säubern: `clean_absolute_path.m`
  * Verzeichnis robust erstellen: `mkdirs.m`
  * Temporäres Verzeichnis erstellen: `tmpDirFcn.m`
* Simulink-bezogene Funktionen und -Modelle
  * Hilfsblöcke für Simulink (insbesondere Echtzeit-Block): `lib_utility.mdl`
  * Simulation im Fehlerfall nochmal bis kurz vor Auftreten des Fehlers durchführen: `sim_repeatonerror.m`

## Erweiterung

Weitere allgemeine Funktionen sollen unter Verwendung des Benennungsschemas und grundsätzlicher Programmierkonventionen ergänzt werden und damit allen Institutsangehörigen zur Verfügung gestellt werden.

