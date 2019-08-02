# Developer Setup

Um gemeinsam an einem Software oder Web-Projekt arbeiten zu können, braucht es ein paar Entwicklerwerkzeuge und Systemeinstellungen. Diese Anleitung zeigt, wie du auf deinem Computer Git, SSH, Node.js, Python und Visual Studio Code installieren und konfigurieren kannst. Ziel soll es sein, dass alle Kollegen eine ähnliche Entwicklungsumgebung haben und sich voll und ganz auf großartige Investigativ- und  Datengeschichten konzentrieren können.

Die Anleitung richtig sich sowohl an Windows- als auch MacOS-Benutzer. Dabei gilt es zu beachten, dass sich hier in einigen Fällen die einzelnen Installationsschritte unterscheiden.  

## Kommandozeile und Git-Installation

### MacOS

Die Kommandozeile wir über die vorinstallierte App *Terminal* unter *Programme > Dienstprogramme* aufgerufen. Es öffnet sich ein Fenster mit der Standard-Shell *bash*. Das Versionsverwaltungssystem *git* (und eine paar andere Werkzeuge) müssen jedoch erst noch installiert werden. Am einfachsten geht das über das vorinstallierte Xcode-Kommandozeilen-Werkzeug *xcode-select*:

```shell
sudo xcode-select --install
```

Der Befehl `sudo` wird benötigt, um die Installation als Administrator auszuführen. Ist der Benutzer kein Administrator wird der Befehl mit einer Fehlermeldung abgebrochen:

```console
User is not in the sudoers file. This incident will be reported.
```

Um einen Benutzer Adminrechte zu erteilen, muss man in *Systemeinstellungen > Benutzer & Gruppen* einen Haken bei *Der Benutzer darf diesen Computer verwalten* setzen.

### Windows

Die Windows-Eingabeaufforderung ist etwas gewöhnungsbedürftig und verwendet andere Befehle als Bash. Glücklicherweise wird bei der Installation von Git gleichzeitig die sogenannte Git-Bash mitinstalliert, welche die wichtigsten Bash-Befehle unterstützt.

Git kann von dieser Seite heruntergeladen werden: <https://git-scm.com/download/win>

Nach dem Herunterladen kann das Installationsprogramm ausgeführt werden. Dies erfordert Administratorrechte *Rechtsklick -> Als Administrator ausführen*. Bei BR-Computer muss dazu einmalig ein Adminstrator-Account *ADM-NachnameV* eingerichtet werden. Ansprechpartner dafür ist die HA IT (-40000).

Beim Installationsprozess kann man alle Standardoptionen unverändert lassen und sich einfach mit *Weiter* durchklicken. Nach der Installation kann man **Git Bash** im Startmenü aufrufen, um einen „normale“ Bash-Kommandozeile zu öffnen.

## Git einrichten

Die Einrichtung von Git auf der Kommandozeile ist unter Mac und Windows vergleichbar. MacOS-Benutzer öffnen dazu das *Terminal*, Windows-Benutzer *Git Bash*.

Namen angeben:

```shell
git config --global user.name "Vorname Nachname"
```

E-Mail-Adresse angeben:

```shell
git config --global user.email "vorname.nachname@br.de"
```

Standard-Editor festlegen, um zum Beispiel die Commit-Message bei einem Merge einfach verändern zu können:

```shell
git config --global core.editor nano
```

Git speichert die Git-Konfiguration unter `~/.gitconfig`. `~` steht für das Home-Verzeichnis, welche in Windows meistens unter `C:\Users\benutzername` liegt, in MacOS unter `/Users/benutzername`.

In der `.gitconfig` können außerdem noch bestimmte Abkürzungen für Git-Befehle und weitere Einstellungen vorgenommen werden. Eine Muster `.gitignore` findet sich hier.

## SSH-Schlüssel erstellen

Das Erstellen einen neues SSH-Schlüsselpaars auf der Kommandozeile ist unter Mac und Windows vergleichbar. MacOS-Benutzer öffnen dazu das *Terminal*, Windows-Benutzer *Git Bash*.

Einen neuen Schlüssel erstellen:

```shell
ssh-keygen -t rsa -b 4096 -C "vorname.nachname@br.de"
```

Die folgende Abfrage einfach mit Eingabe bestätigen, es sei denn man hat schon ein Schlüsselpaar erstellt und möchte dem neuen Schlüsselpaar einen neuen Namen zuweisen.

```console
Enter a file in which to save the key (/Users/benutzername/.ssh/id_rsa):
```

Passwort für den neuen Schlüssel festlegen und bestätigen.

```console
Enter passphrase (empty for no passphrase): [Type a passphrase]
Enter same passphrase again: [Type passphrase again]
```

Diese Passwort sollte man sich auf jeden Fall merken, aufschreiben oder am besten in einem Passwort-Tresor (1Password) speichern.

Die neu erstellten Schlüsselpaare sollte nun im Homeverzeichnis im Ordner `~/.ssh` liegen. `id_rsa` enthält den privaten Schlüssel, den man niemals teilen sollten, `id_rsa.pub` enthält den öffentlichen Schlüssel, den wir später auf Github hochladen werden.

Genauso wie das Passwort sollte man auch das Schlüsselpaar irgendwo noch einmal sichern (ausdrucken, USB-Stick, Passwort-Tresor).

Als letzten Schritt muss der SSH-Schlüssel noch dem sogenannten *ssh-agent* hinzugefügt werden. Das Hinzufügen funktioniert unter Windows und MacOS jeweils leicht anders:

### MacOS

SSH-Agent im Hintergrund starten:

```shell
eval "$(ssh-agent -s)"
```

Damit der Schlüssel zukünftig automatisch geladen und das Passwort im MacOS-Schlüsselbund (Keychain) gespeichert wird, muss die SSH-Konfiguration unter `~/.ssh/config` angepasst werden. Außerdem geben wir einen alternativen SSH-Port für Github an, da der Standard-Port 22 in Unternehmensnetzwerken oftmals geblockt wird. Gibt es die Konfigurationsdatei noch nicht, sollte sie neu angelegen werden.

```shell
nano ~/.ssh/config
```

Folgende Zeilen einfügen oder ändern:

```ssh-config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa

Host github.com
  Hostname ssh.github.com
  Port 443
```

Datei schließen (Ctrl + X) und speichern (Y).

Jetzt kann der SSH-Schlüssel hinzugefügt werden:

```shell
ssh-add -K ~/.ssh/id_rsa
```

### Windows

SSH-Agent im Hintergrund starten:

```shell
eval "$(ssh-agent -s)"
```

SSH-Schlüssel hinzugefügen:

```shell
ssh-add ~/.ssh/id_rsa
```

In vielen Unternehmensnetzwerken wird der Standard-SSH-Port (22) blockiert. Um einen alternativen Port für Github (443) anzugeben, muss die SSH-Konfiguration unter `~/.ssh/config` angepasst werden. Gibt es die Konfigurationsdatei noch nicht, sollte sie neu angelegen werden.

```shell
nano ~/.ssh/config
```

Folgende Zeilen einfügen oder ändern:

```
Host github.com
  Hostname ssh.github.com
  Port 443
```

Datei schließen (Strg + X) und speichern (Y).

## Github & SSH

Um auf Repository von Github zugreifen (klonen, pushen, ...) zu können, muss der öffentliche SSH-Schlüssel dort hinterlegt werden. Dazu muss zuerst der Inhalt des Schlüssels kopiert werden:

```shell
cat ~/.ssh/id_rsa.pub
```

Diese Ausgabe dieses Befehls von `ssh-rsa ...` bis `... vorname.name@br.de` kopieren. Unter Windows geht das in Git Bash mit *Strg + Einf*, unter MacOS im Terminal mit *Cmd + C*.

Auf Github kann der Key auf folgender Seite hinterlegt werden: <https://github.com/settings/keys>

Der Link funktioniert natürlich nur, wenn man sich vorher bei Github angemeldet hat.

## Code Editor

## Node.js

## Python

### Homebrew

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### ZSH

### PATH-Variable

### Inspiration

- New York Times: [Set Up Your Mac Like an Interactive News Developer](https://open.nytimes.com/set-up-your-mac-like-an-interactive-news-developer-bb8d2c4097e5)
- NPR: [How to Setup Your Mac to Develop News Applications Like We Do](https://blog.apps.npr.org/2013/06/06/how-to-setup-a-developers-environment.html)
