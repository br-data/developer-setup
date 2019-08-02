# Developer Setup
Um gemeinsam an einem Software oder Web-Projekt arbeiten zu können, braucht es ein paar Entwicklerwerkzeuge und Systemeinstellungen. Diese Anleitung zeigt, wie du auf deinem Computer Git, SSH, Node.js, Python und Visual Studio Code installieren und konfigurieren kannst. Ziel soll es sein, dass alle Kollegen eine ähnliche Entwicklungsumgebung haben und sich voll und ganz auf großartige Investigativ- und  Datengeschichten konzentrieren können.

Die Anleitung richtig sich sowohl an Windows- als auch MacOS-Benutzer. Dabei gilt es zu beachten, dass sich hier in einigen Fällen die einzelnen Installationsschritte unterscheiden.  

## Command Line und Git
### MacOS
Die Kommandozeile wir über die vorinstallierte App *Terminal* unter *Programme > Dienstprogramme* aufgerufen. Es öffnet sich ein Fenster mit der Standard-Shell *bash*. Das Versionsverwaltungssystem *git* (und eine paar andere Werkzeuge) müssen jedoch erst noch installiert werden. Am einfachsten geht das über das vorinstallierte Xcode-Kommandozeilen-Werkzeug *xcode-select*:

```
$ sudo xcode-select --install
```

Der Befehl `sudo` wird benötigt, um die Installation als Administrator auszuführen. Ist der Benutzer kein Administrator wird der Befehl mit einer Fehlermeldung abgebrochen:

```
> User is not in the sudoers file. This incident will be reported.
```

Um einen Benutzer Adminrechte zu erteilen, muss man in *Systemeinstellungen > Benutzer & Gruppen* einen Haken bei *Der Benutzer darf diesen Computer verwalten* setzen.

### Windows
Die Windows-Eingabeaufforderung ist etwas gewöhnungsbedürftig und verwendet andere Befehle als Bash. Glücklicherweise wird bei der Installation von Git gleichzeitig die sogenannte Git-Bash mitinstalliert, welche die wichtigsten Bash-Befehle unterstützt.

Git kann von dieser Seite heruntergeladen werden: https://git-scm.com/download/win

Nach dem Herunterladen kann das Installationsprogramm ausgeführt werden. Dies erfordert Administratorrechte *Rechtsklick -> Als Administrator ausführen*. Bei BR-Computer muss dazu einmalig ein Adminstrator-Account *ADM-NachnameV* eingerichtet werden. Ansprechpartner dafür ist die HA IT (-40000).

Beim Installationsprozess kann man alle Standardoptionen unverändert lassen und sich einfach mit *Weiter* durchklicken.

Nach der Installation kann man **Git Bash** im Startmenü aufrufen, um einen „normale“ Bash-Kommandozeile zu öffnen.
