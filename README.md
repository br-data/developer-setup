# Developer Setup

Um gemeinsam an Software- oder Webprojekten arbeiten zu können, braucht es ein paar Entwicklerwerkzeuge, Systemeinstellungen und Konventionen. Diese Anleitung hilft dabei Git, SSH, Node.js, Python und Visual Studio Code auf einem neuen Computer (Windows oder Mac) zu installieren und konfigurieren.

## Inhaltsverzeichnis

- [Kommandozeile und Git-Installation](#kommandozeile-und-git-installation)
- [Git einrichten](#git-einrichten)
- [SSH-Schlüssel erstellen](#ssh-schlüssel-erstellen)
- [Github und SSH](#github-und-ssh)
- [Visual Studio Code](#visual-studio-code)
- [Webserver](#webserver)
- [Node.js](#nodejs)
- [Python](#python)
- [Homebrew](#homebrew)
- [ZSH](#zsh)
- [Skripte](#skripte)

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

### Windows 7

Die Windows-Eingabeaufforderung *cmd* ist für die meisten Benutzer etwas gewöhnungsbedürftig. Glücklicherweise wird bei der Installation von Git gleichzeitig Git-Bash mitinstalliert, welche die wichtigsten Bash-Befehle unterstützt und so funktioniert wie auf einem MacOS- oder Linux-System.

Git kann von dieser Seite heruntergeladen werden: <https://git-scm.com/download/win>

Nach dem Herunterladen kann das Installationsprogramm ausgeführt werden. Dies erfordert Administratorrechte (*Rechtsklick -> Als Administrator ausführen*). Beim Installationsprozess kann man alle Standardoptionen unverändert lassen und sich einfach mit *Weiter* durchklicken. Nach der Installation kann man **Git Bash** im Startmenü aufrufen, um einen „normale“ Bash-Kommandozeile zu öffnen.

### Windows 10

Die neueste Version von Windows unterstützt das sogenannte *Windows-Subsystems für Linux (WSL)*. Dadurch kann innerhalb von Windows eine virtualisierte Installation von Linux hinzugefügt werden. Diese läuft in einem Terminal-Fenster und bringt die Linux-Shell *bash* mit.

Zum Aktivieren des WSL muss die *PowerShell* mit Administratorrechten gestartet (*Rechtsklick -> Als Administrator ausführen*) und folgender Befehl ausgeführt werden:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

Die Installation einer Linux-Distribution erfolgt über den Windows Store. Empfehlenswert ist zum Beispiel die Linux-Distribution [Ubuntu](https://www.microsoft.com/de-de/p/ubuntu/9nblggh4msv6).

## Git einrichten

Die Einrichtung von Git auf der Kommandozeile ist unter Mac und Windows vergleichbar. MacOS-Benutzer öffnen dazu das *Terminal*, Windows-Benutzer *Git Bash*.

Namen angeben:

```shell
git config --global user.name "Vorname Nachname"
```

E-Mail-Adresse angeben:

```shell
git config --global user.email "vorname.nachname@example.com"
```

Standard-Editor festlegen, um zum Beispiel die Commit-Message bei einem Merge einfach verändern zu können:

```shell
git config --global core.editor nano
```

Git speichert die Git-Konfiguration unter `~/.gitconfig`. `~` steht für das Home-Verzeichnis, welche in Windows meistens unter `C:\Users\benutzername` liegt, in MacOS unter `/Users/benutzername`.

In der `.gitconfig` können außerdem noch bestimmte Abkürzungen für Git-Befehle und weitere Einstellungen vorgenommen werden.

💡 Ein Vorlage für die `.gitignore` gibt es [hier](./.gitconfig).

## SSH-Schlüssel erstellen

Das Erstellen einen neues SSH-Schlüsselpaars auf der Kommandozeile ist unter Mac und Windows vergleichbar. MacOS-Benutzer öffnen dazu das *Terminal*, Windows-Benutzer *Git Bash*.

Einen neuen Schlüssel erstellen:

```shell
ssh-keygen -t rsa -b 4096 -C "vorname.nachname@example.com"
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

Damit der Schlüssel zukünftig automatisch geladen und das Passwort im MacOS-Schlüsselbund (Keychain) gespeichert wird, muss die SSH-Konfiguration `~/.ssh/config` angepasst werden. Außerdem geben wir einen alternativen SSH-Port für Github an, da der Standard-Port 22 in Unternehmensnetzwerken oftmals geblockt wird. Gibt es die Konfigurationsdatei noch nicht, sollte sie neu angelegen werden.

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

Datei schließen (`Ctrl` + `X`) und speichern (`Y`).

Jetzt kann der SSH-Schlüssel hinzugefügt werden:

```shell
ssh-add --apple-use-keychain ~/.ssh/id_rsa
```

Lässt sich der SSH-Schlüssel nicht hinzufügen, kann das daran liegen, dass die Berechtigungen falsch gesetzt sind. So setzt man die richtigen Berechtigungen für die Dateien im SSH-Ordner:

```shell
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub
sudo chmod 644 ~/.ssh/config
```

💡 Ein Beispiel für eine `.ssh/config` findet sich [hier](./.ssh/config).

### Windows

SSH-Agent im Hintergrund starten:

```shell
eval "$(ssh-agent -s)"
```

SSH-Schlüssel hinzugefügen:

```shell
ssh-add ~/.ssh/id_rsa
```

In vielen Unternehmensnetzwerken wird der Standard-SSH-Port (22) blockiert. Um einen alternativen Port für Github (443) anzugeben, muss die SSH-Konfiguration `~/.ssh/config` angepasst werden. Gibt es die Konfigurationsdatei noch nicht, sollte sie neu angelegen werden.

```shell
nano ~/.ssh/config
```

Folgende Zeilen einfügen oder ändern:

```ssh-config
Host github.com
  Hostname ssh.github.com
  Port 443
```

Datei schließen (`Strg` + `X`) und speichern (`Y`).

## Github und SSH

Um auf Repository von Github zugreifen (klonen, pushen, ...) zu können, muss der öffentliche SSH-Schlüssel dort hinterlegt werden. Dazu muss zuerst der Inhalt des Schlüssels kopiert werden:

```shell
cat ~/.ssh/id_rsa.pub
```

Diese Ausgabe dieses Befehls von `ssh-rsa ...` bis `... vorname.name@example.com` kopieren. Unter Windows geht das in Git Bash mit `Strg` + `Einf`, unter MacOS mit `Cmd` + `C`.

Auf Github kann der Key auf unter *Settings > SSH and GPG keys* hinterlegt werden: <https://github.com/settings/keys>. Der Link funktioniert nur, wenn man sich vorher bei Github angemeldet hat.

### Signierte Commits

Signierte Commits ermöglichen es, den Autor eines Commits anhand eines kryptographischen Schlüssels (GPG/SSH) zu verifizieren. Das ist sinnvoll, da Commits sehr einfach gefälscht werden können.

Eine hundertprozentige Sicherheit bietet aber auch diese Methode nicht, da ein böswilliger Akteur ebenfalls Commits mit seinem eigenen Schlüssel signieren kann. Trotzdem helfen signierte Commits, echte von falschen Commits zu unterscheiden.

Diese Anleitung geht davon aus, dass du bereits einen [SSH-Key](#ssh-schlüssel-erstellen) hast, um auf [Github](#github-und-ssh) zuzugreifen. Zudem wird davon ausgegangen, dass du auf einem Mac- oder Linux-System arbeitest.

Zuerst musst du dich bei Github anmelden und in den Benutzereinstellungen unter "SSH and GPG keys" einen neuen SSH-Schlüssel hinzufügen: https://github.com/settings/ssh/new

Der *Key type* muss *Signing key* sein. Im Feld *Key* muss der Inhalt des öffentlichen Schlüssels  (`cat ~/.ssh/id_rsa.pub`) eingefügt werden.

Damit Git weiß, dass Commits signiert werden sollen, musst du noch deine Git-Konfiguration anpassen (`code ~/.gitconfig`). Folgende Zeilen müssen hinzugefügt oder geändert werden:

```text
[user]
 name = Vorname Name
 email = vorname.name@example.com
 signingkey = ~/.ssh/id_rsa.pub 

[commit]
 gpgsign = true
 
[gpg]
 format = ssh

[tag]
 gpgsign = true
```

Wenn alles geklappt hatte, sollten deine neuen Commits in Github mit einem *Verified*-Tag dargestellt werden.

## Visual Studio Code

Visual Studio Code ist ein kostenloser Quelltext-Editor, der viele Programmiersprachen unterstützt und mit Plugins erweitert werden kann.

Der Editor für Windows, MacOS oder Linux kann hier heruntergeladen werden: <https://code.visualstudio.com/download>

Visual Studio Code kann auch auf Windows-Computern ohne Administratorrechte verwendet werden ([Portable-Modus](https://code.visualstudio.com/docs/editor/portable)):

1. Visual Studio Code als Zip-Datei herunterladen
2. Zip-Datei in einen Ordner `VSCode` entpacken
3. Im Ordner `VSCode` einen neuen Ordner `data` erstellen
4. `Code.exe` ausführen, um den Editor zu starten

### Plugins

Um den Visual Studio Code optimal nutzen zu können, sollten man noch ein paar Plugins (*extensions*) installieren. Sogenannten Linter helfen dabei, Fehler im Code frühzeitig zu erkennen. Das erspart viel Ärger und Arbeit bei der Fehlersuche.

- **ESLint**: Linter für JavaScript-Code
- **HTMLHint**: Linter für HTML
- **markdownlint**: Linter für Markdown
- **Python**: Support/Linter für Python
- **R**: Support/Linter für R

Linter sind für alle gängige Programmiersprachen verfügbar. Öffnet man eine Datei in einer Programmier- oder Skriptsprache, für die noch kein Linter installiert ist, bietet VS Code automatisch an, den passenden Linter zu installieren.

Folgende Plugins sind ebenfalls nützlich:

- **EditorConfig**: Editor-Einstellungen aus `.editorconfig` laden
- **Code Spell Checker**: Rechtschreibkorrektur für Code und Dokumentation
- **Prettier**: Code richtig formatieren und einrücken (HTML, CSS, JavaScript)
- **Visual Studio IntelliCode**: Intelligente Autovervollständigung für Code
- **Live Server**: Einfachen Entwicklungsserver starten
- **Sublime Text Keymap**: Tastenkombinationen wie in Sublime Text
- **Rainbow CSV**: Spalten in CSV-Tabellen farblich voneinander abheben
- **Edit csv**: Mini-Excel, um CSV-Dateien in VS Code zu bearbeiten

### Kommandozeilenintegration

Damit Visual Studio Code von der Kommandozeile mit dem Befehl `code` gestartet werden kann, muss zuerst die Kommandozeilenerweiterung installiert werden. Die geht in Visual Studio Code über das Befehlsmenü `Shift` + `Shift` + `P`. Dort einfach nach *Shell Command: Install 'code' command in PATH* suchen und mit Eingabe bestätigen.

Alternativ können Mac-Benutzer auch die `$PATH`-Variable in ihrer Shell-Konfiguration unter `~/.bash_profile` (bash) oder `~/.zshrc` (ZSH) anpassen:

```shell
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
```

### Einsteiger-Tipps

Es gibt in Visual Studio Code vor allem eine wichtige Tastenkombination: `Shift` + `Shift` + `P` öffnet das Befehlsmenü, über das man schnell häufig genutzte Funktionen aufrufen kann. So muss man sich keine hundert Tastenkombinationen merken, sondern kann einfach eingeben, was man gerne tun möchte. Mit  `Strg` + `P` kann man schnell nach Dateien innerhalb eines Projekts suchen.

Weitere gute Code-Editoren sind [Sublime Text](https://www.sublimetext.com/), [Notepad++](https://notepad-plus-plus.org/), [Atom](https://atom.io/), [Coda](https://panic.com/coda/) und [Brackets](http://brackets.io/).

## Webserver

Um statische Seiten über einen Webserver abzurufen, war es früher oft notwendig Apache oder das darauf aufbauende XAMPP zu installieren. Die Konfiguration dieser Software ist aufwendig und zudem stellt ein ständig laufender Webserver auf dem eigenen Rechner ein nicht unerhebliches Sicherheitsrisiko dar. Mittlerweile gibt verschiedene Lösungen für kleine Entwicklungsserver, die sich bei Bedarf schnell starten und stoppen lassen:

- **Visual Studio Code**: Extension [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) installieren und aus der Statusleiste (unten) starten
- **Node.js**: Modul http-server global installieren `npm install -g http-server` und mit `http-server` im gewünschten Verzeichnis starten
- **Python**: Eingebauten Webserver in Python 3 mit `python3 -m http.server` oder in Python 2 mit `python -m SimpleHTTPServer` im gewünschten Verzeichnis starten

Die meisten Webprojekte bringen mittlerweile einen eigenen Entwicklungsserver mit. Wir verwenden dafür [webpack-dev-server](https://webpack.js.org/configuration/dev-server/). Nach Installation der notwendigen Pakete mit `npm install` kann der Webserver mit `npm start` gestartet werden.

## Node.js

Node.js ist eine JavaScript-Runtime für die Kommandozeile. Die einfachste Möglichkeit Node.js zu installieren besteht darin, das offizielle Installationsprogramm zu verwenden. Mac-Benutzer können Node.js auch über [Homebrew](#homebrew) installieren.

Es empfiehlt sich die LTS-Version (*Long Term Support*) von Node.js herunterzuladen: <https://nodejs.org/en/download/>

Nach der Installation sollte `node` und der Node.js-Paketmanager `npm` auf der Kommandozeile verfügbar sein:

```shell
node --version
v16.18.0
```

```shell
npm --version
8.19.2
```

Typischerweise haben Node.js-Projekte ein Manifest `package.json`, in dem alle in einem Projekt verwendeten Abhängigkeiten und einige Metadaten angegeben sind. Über Konflikte bei installierten Paketen muss man sich mit Node.js eigentlich keine Sorgen machen. Pakete werden mit `npm install` immer im aktuellen Verzeichnis unter `node_modules` abgelegt. Möchte man ein Paket, wie den Webserver `http-server`, global installieren, tut man dies mit `npm install -g http-server`.

## Python

Python ist ein einfach zu erlernende und universell einsetzbare Programmiersprache. Ein gute Anleitung, wie man Python auf verschieden Betriebssystemen installieren kann, findet sich hier: <https://cloud.google.com/python/setup?hl=de>

Da die Verwaltung von Abhängigkeiten und Bibliotheken in Python [eher schwierig](https://xkcd.com/1987/) ist, und gerade bei Anfänger oft zu Problemen führt, empfiehlt es sich für jedes Python-Projekt eine virtuelle Umgebung [venv](https://docs.python.org/3/library/venv.html) einzurichten. Dadurch werden die Abhängigkeiten für jedes Projekt einzeln installiert und Versionskonflikte vermieden.

Projekt-Ordner `project` anlegen:

```shell
mkdir project && cd project
```

Neue virtuelle Umgebung mit dem Namen `env` erstellen:

```shell
python3 -m venv env
```

In Python 2 müsste man zuerst [virtualenv](https://virtualenv.pypa.io/en/stable/) installieren, um eine neue virtuelle Umgebung mit `virtualenv env` anzulegen.

Virtuelle Umgebung unter **Windows** aktivieren:

```powershell
env\Scripts\activate.bat
```

Virtuelle Umgebung unter **MacOS** aktivieren:

```shell
source ./env/bin/activate
```

Neue Pakete und Bibliotheken können nun wie gewohnt mit dem Python-Paketmanager *pip* installiert werden:

```shell
pip install beautifulsoup4
```

Anstatt Pakete einzeln zu installieren, kann man alle Abhängigkeiten auch in einer Art Manifest `requirements.txt` deklarieren. Hier ein einfaches Beispiel:

```plaintext
requests==2.18.4
google-auth==1.1.0
```

Nun kann man alle in der `requirements.txt` angegebenen Abhängigkeiten nacheinander installieren:

```shell
pip install -r requirements.txt
```

Braucht man die die virtuelle Umgebung nicht mehr, kann man sie einfach deaktivieren:

```shell
deactivate
```

## R

R ist eine Programmiersprache mit dem Fokus auf Daten. Typischerweise wird R im Zusammenspiel mit RStudio verwendet, eine Installationsanleitung dafür findet sich [hier](https://rstudio-education.github.io/hopr/starting.html). Aber auch VS Code eigent sich als Entwicklungsumgebung gut, braucht aber ein bisschen [mehr Konfiguration](https://github.com/REditorSupport/vscode-R).

Das Paketmanagement ist zentralisiert auf den sogenannten CRAN-Servern mit strengen Tests. Ein CRAN-Paket wird installiert mit:

```R
install.packages("tidyverse")
```

Allerdings lassen sich auch Pakete aus anderen Quellen installieren, meist von Github. Dafür braucht man erst das Paket `devtools` und danach den Pfad zum Paket auf Github. Ein Beispiel:

```R
install.packages("devtools")
devtools::install_github("cutterkom/kabrutils")
```

Bei komplexeren Projekten lohnt es sich, ähnlich zu [Pythons virtuellen Umgebungen](https://github.com/br-data/developer-setup#python), `rvenv` zu nutzen, um eine robustes Management von Softwareabhängigkeiten zu implementieren. Mehr dazu [hier](https://rstudio.github.io/renv/articles/renv.html).

## Homebrew

Homebrew ist ein praktischer Paketmanager für MacOS, der einen ähnlichen Funktionsumfang bietet wie die von Linux-Systemen bekannten Paketmanager YUM, RPM oder APT.

Homebrew wird über eine Ruby-Skript installiert:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Um zu testen, ob die eigene Homebrew-Installation (noch) funktioniert, gibt es ein eingebautes Werkzeug zur Selbstdiagnose:

```shell
brew doctor
```

Neue Pakete können einfach mit dem Befehl `install` installiert werden:

```shell
brew install postgresql
```

Homebrew hat eine Funktion, um Dienste, wie Datenbanken, zu starten:

```shell
brew services start postgresql
```

Eine grafische Lösung, um mit Hombrew installierte Dienste zu starten oder stoppen ist [launchrocket](https://github.com/jimbojsb/launchrocket), welches in als PrefPane in den Systemeinstellungen installiert wird.

## ZSH

ZSH ist eine alternative Shell für Mac- und Linux-Systeme. Gerade in der Verbindungen mit [Oh my ZSH!](https://ohmyz.sh/) ist ZSH sehr mächtig und gut mit Plugins erweiterbar.

Eine aktuelle Version von ZSH kann unter MacOS mit [Homebrew](#homebrew) installiert werden:

```bash
brew install zsh zsh-completions
```

Danach kann man ZSH als Standard-Shell festlegen:

```bash
chsh -s /bin/zsh
```

Die Erweiterung Oh my ZSH! lässt sich mit einem Befehl installieren:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

Eine ausführliche Installationsanleitung für verschiedene Systeme findet sich hier: <https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH>

Um Oh my ZSH! zu konfigurieren, muss man einen `.zshrc`-Konfigurationsdatei im Homeverzeichnis des Benutzers anlegen oder die bereits bestehende Konfigurationsdatei bearbeiten:

```shell
# Set name of the theme from ~/.oh-my-zsh/themes/
ZSH_THEME="ys"

# Load oh-my-zsh plugins from ~/.oh-my-zsh/plugins/
plugins=(osx vscode git git-extras brew node npm pip)

# Initialize oh-my-zsh
source $HOME/.oh-my-zsh/oh-my-zsh.sh
```

Im Oh my ZSH!-Repo auf Github gibt es eine Übersicht über die verfügbaren [Themes](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes) und [Plugins](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins).

💡 Ein Beispiel für eine `.zshrc`-Datei gibt es [hier](./.zshrc).

## Skripte

Unter Mac OS X lässt sich die Installation von Werkzeugen und Apps, so wie die Erstkonfiguration des Betriebssystems relativ einfach mit Bash-Skripten automatisieren. Hier zwei Skripte, die als Grundlage für eine eigenes Setup-Skript dienen können

- Werkzeuge und Apps installieren: [install-all.sh](./install-all.sh)
- Konfiguration anpassen: [configure-all.sh](./configure-all.sh)

Um ein Skript auszuführen, muss man es erst mit den entsprechenden Rechten ausstatten:

```shell
chmod +x install-all.sh
```

Das Skript wird dann mit folgendem Befehl gestartet:

```shell
./install-all.sh
```

**Wichtig:** Man sollte sich die Skripte auf jeden Fall vor den Ausführen noch mal anschauen und anpassen, welche Software und Einstellungen man wirklich braucht.

💡 Läuft eines der Skripte wegen eines Fehlers nicht bis zu Ende, kann man es einfach erneut starten. Bereits installierte Software wird nicht noch mal installiert.

## Weitere Links

- [Open Source Guidelines](https://github.com/br-data/open-source-guidelines)
- [Dokumenten-Workflow mit Tika und Tesseract](https://github.com/br-data/elasticsearch-document-workshop)
- [Einführung in die Webentwicklung mit HTML, CSS und JavaScript](https://github.com/stekhn/programming-workshop)
- [Interaktive Grafiken mit D3](https://github.com/stekhn/d3-workshop)
- [Karten für's Web mit Leaflet](https://github.com/stekhn/leaflet-workshop)

## Inspiration

- New York Times: [Set Up Your Mac Like an Interactive News Developer](https://open.nytimes.com/set-up-your-mac-like-an-interactive-news-developer-bb8d2c4097e5)
- NPR: [How to Setup Your Mac to Develop News Applications Like We Do](https://blog.apps.npr.org/2013/06/06/how-to-setup-a-developers-environment.html)

## Todo

- Ordnerstruktur für Entwicklung erklären
- Hilfe für PATH-Variablen
- Anleitung für das Google Cloud SDK
