PYUIC = pyuic4
PYRCC = pyrcc4

UIFILES := $(wildcard ggpo/gui/ui/*.ui)
UIPYFILES := $(UIFILES:.ui=_ui.py)
QRCFILES := $(wildcard ggpo/resources/*.qrc)
QRCPYFILES := $(QRCFILES:.qrc=_rc.py)

%_ui.py: %.ui
	$(PYUIC) $< --output $@

%_rc.py : %.qrc
	$(PYRCC) $< -o $@

.PHONY: all ui qrc clean
all: ui qrc
ui: $(UIPYFILES)
qrc: $(QRCPYFILES)

clean:
	rm -f $(UIPYFILES) $(UIPYFILES:.py=.pyc) $(QRCPYFILES:.py=.pyc) 

linux: cleanbuild
	rm -rf /tmp/FightCade/
	mkdir /tmp/FightCade/
	cp -R * /tmp/FightCade/
	rm -rf /tmp/FightCade/ggpo/resources/assets/ /tmp/FightCade/Makefile /tmp/FightCade/savestates/.git
	cd /tmp ; tar cvfz fightcade-linux-v0`cat FightCade/VERSION`.tar.gz FightCade
	rm -rf /tmp/FightCade
	rm -rf cheats flyers previews recordings ROMs screenshots titles
	ls -laht /tmp/fightcade-linux-v0* |head -n 1

win: cleanbuild
	../python-windows-packager/package.sh ./ggpofba.py ggpofba
	cp dist/ggpofba.exe .
	../python-windows-packager/package.sh ./main.py fightcade
	cp dist/fightcade.exe ./FightCade.exe
	rm -rf build dist
	rm -rf /tmp/FightCade/
	mkdir /tmp/FightCade/
	cp -R assets config FightCade.exe ggpofba.exe ggpofba-ng.exe ggponet.dll kailleraclient.dll LICENSE VERSION cheats flyers previews recordings ROMs savestates screenshots titles /tmp/FightCade/
	rm -rf /tmp/FightCade/savestates/.git
	cd /tmp ; zip -r fightcade-win32-v0`cat FightCade/VERSION`.zip FightCade
	rm -rf /tmp/FightCade FightCade.exe fightcade.spec ggpofba.exe ggpofba.spec
	rm -rf cheats flyers previews recordings ROMs screenshots titles
	ls -laht /tmp/fightcade-win32-v0* |head -n 1

osx: cleanbuild
	rm -rf /tmp/FightCade.app/
	tar zxvfp ../Fightcade-app-skeleton-osx.tgz -C /tmp/
	mkdir -p /tmp/FightCade.app/Contents/MacOS/
	cp -R * /tmp/FightCade.app/Contents/MacOS/
	cp ggpo/resources/img/icon.icns /tmp/FightCade.app/Contents/Resources/
	cp ggpo/scripts/Info.plist /tmp/FightCade.app/Contents/
	rm -rf /tmp/FightCade.app/Contents/MacOS/ggpo/resources/assets/ /tmp/FightCade.app/Contents/MacOS/linux-install.sh /tmp/FightCade.app/Contents/MacOS/Makefile /tmp/FightCade.app/savestates/.git
	sed -i '' -e 's/nVidSelect 1/nVidSelect 3/' /tmp/FightCade.app/Contents/MacOS/config/ggpofba-ng.default.ini
	clang ggpo/scripts/fightcade-launcher.c -arch i386 -arch x86_64 -march=core2 -mmacosx-version-min=10.7 -o /tmp/FightCade.app/Contents/MacOS/fightcade.bin
	#pyinstaller --onefile -w -i ggpo/resources/img/icon.icns -n fightcade.bin --runtime-hook ggpo/scripts/runtimehook.py main.py
	#cp dist/fightcade.bin /tmp/FightCade.app/Contents/MacOS/
	cd /tmp ; /Users/pau/Development/yoursway-create-dmg/create-dmg --icon FightCade.app 160 205 --volname 'FightCade Installer' --background /Users/pau/Development/pyqtggpo/ggpo/resources/img/osx-installer-bg.png --icon-size 128 --app-drop-link 380 205 --window-size 600 450 fightcade-osx64-v0`cat /Users/pau/Development/pyqtggpo/VERSION`.dmg FightCade.app
	rm -rf /tmp/FightCade.app
	rm -rf cheats flyers previews recordings ROMs screenshots titles build dist fightcade.bin.spec
	ls -laht /tmp/fightcade-osx64-v0* |head -n 1

cleanbuild:
	rm -rf build dist fightcade.bin.spec
	rm -rf cheats flyers previews recordings ROMs screenshots titles
	mkdir cheats flyers previews recordings ROMs screenshots titles
	touch ggpo/__init__.pyc
	find . -iname "*.pyc" |xargs -n 1 rm
	git submodule foreach git pull
