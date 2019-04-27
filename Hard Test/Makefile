
MAKE =  /usr/local/bin/gmake
SHELL = /bin/sh
WGET = wget --passive-ftp
BINS = \*.so \*.dll \*.RData \*.rda \*.zip \*.rds \*.pdf \*.ps


RCB := $(shell pwd)
## the directory where the downloaded sources are stored
DOWNDIR = $(RCB)/downloads
## the directory where the cross-tools are installed
CROSSDIR = $(RCB)/cross-tools

WINR = $(RCB)/WinR

LINUXR = $(RCB)/LinuxR

## the directory where package sources are stored
PKGDIR = $(RCB)/pkgsrc

WINRLIBS = $(RCB)/WinRlibs

## current versions
R = R-2.0.0
## snapshot R is only available at 
ftp://ftp.stat.math.ethz.ch/Software/R
ifeq ($(findstring devel, $(R)), devel)
RURL = ftp://ftp.stat.math.ethz.ch/Software/R
REXT = tar.gz
else
RURL = http://cran.us.r-project.org/src/base/R-2
REXT = tar.gz
endif

R_TCL_URL = https://prdownloads.sourceforge.net/tcl/tcl8.6.9-src.tar.gz

#MINGW_CROSS = mingw-cross2 now:
MINGW_CROSS = mingw-cross4

## R_EXE
LinuxFresh = YES
ifeq ($(strip $(LinuxFresh)),YES)
R_EXE = $(LINUXR)/R/bin/R
else
R_EXE = R
endif

default: 
	@echo "syntax:"
	@echo "make <target>"
	@echo "No <Target> Specified.  Should be one of:"
	@echo " "
	@echo "-------------------"
	@echo "down     : downloads files"
	@echo "xtools   : unpack cross compilers"
	@echo "prepsrc  : unpack and prepare source code"
	@echo "mkrules  : patch source code for cross-compile"
	@echo "R        : cross-compile R"
	@echo " "
	@echo "(or to run all at once (trusting, aren't you?))"

	@echo " "
	@echo "CrossCompileBuild"
	@echo " "
	@echo "(To build packages or bundles, steps above have to be run"

	@echo " first to get a working build of R, which is required!)"

	@echo " "
	@echo "pkg-NAME_VER    : cross-build package NAME_VER"
	@echo "bundle-NAME_VER : cross-build packages in bundle NAME_VER"

	@echo " "
	@echo "(For example, put geepack_0.2-7.tar.gz and VR_7.1-10.tar.gz"

	@echo " in subdirectory pkgsrc, then do"
	@echo " "
	@echo " make pkg-geepack_0.2-7"
	@echo " make bundle-VR_7.1-10)"
	@echo "-------------------"
	@echo " "

buildR: clean prepsrc mkrules R

#### steps described in the document

down:
	mkdir -p $(DOWNDIR); \
	cd $(DOWNDIR); \
	$(WGET) $(RURL)/$(R).$(REXT) -O $(R).tgz; \
	$(WGET) $(R_TCL_URL); \
	$(WGET) http://www.stats.ox.ac.uk/pub/Rtools/
	$(MINGW_CROSS).tar.bz2; \

downR:
	mkdir -p $(DOWNDIR); \
	cd $(DOWNDIR); \
	$(WGET) $(RURL)/$(R).$(REXT) -O $(R).tgz; \

downRTcl:
	mkdir -p $(DOWNDIR); \
	cd $(DOWNDIR); \
	$(WGET) $(R_TCL_URL);\

downXtools:
	mkdir -p $(DOWNDIR); \
	cd $(DOWNDIR); \
	$(WGET) http://www.stats.ox.ac.uk/pub/Rtools/
	$(MINGW_CROSS).tar.bz2; \

linuxR:
	mkdir -p $(LINUXR); \
	cd $(LINUXR); \
	tar zxf $(DOWNDIR)/$(R).tgz; \
	cd $(LINUXR)/$(R); \
	./configure; \
	$(MAKE); \
	$(MAKE) prefix=$(LINUXR)/R install; \

xtools:
	mkdir -p $(RCB)/cross-tools; \
	cd $(CROSSDIR); \
	tar jxf $(DOWNDIR)/$(MINGW_CROSS).tar.bz2; \

prepsrc:
	mkdir -p $(WINR); \
	cd $(WINR); \
	rm -rf $(R); \
	tar zxf $(DOWNDIR)/$(R).tgz; \
	cd $(WINR)/$(R); \
	unzip $(DOWNDIR)/R_Tcl.zip

mkrules:
	cd $(WINR)/$(R)/src/gnuwin32/; \
	cp MkRules MkRules.orig; \
	sed 's|^BUILD=MINGW|BUILD=CROSS|; s|^HEADER=.*$$|HEADER=$(CROSSDIR)/i586-mingw32/include|; s|^R_EXE=.*$$|R_EXE=$(R_EXE)|; s|# R_EXE=R|R_EXE=$(R_EXE)|' MkRules.orig > MkRules

R:
	export PATH=$(CROSSDIR)/bin:$(CROSSDIR)/mingw32/bin:$(PATH); \
	cd $(WINR)/$(R)/src/gnuwin32/; \
	$(MAKE); \
	cd $(RCB)/WinR; \
	tar zcf Win-$(R).tgz $(R)

pkg-%:
	export PATH=$(CROSSDIR)/bin:$(CROSSDIR)/mingw32/bin:$(PATH); \
	export mypkg=`echo $* | cut -d'_' -f1,1`; \
	cd $(PKGDIR); \
	rm -rf $$mypkg; \
	tar zxf $*.tar.gz; \
	echo -------$$mypkg------; \
	cd $(WINR)/$(R)/src/gnuwin32/; \
	$(MAKE) PKGDIR=$(PKGDIR) RLIB=$(WINRLIBS) STAMP=no pkg-$$mypkg; \
	mkdir -p $(WINRLIBS); \
	cd $(WINRLIBS); \
	rm -rf $$mypkg.zip; \
	zip -rl $$mypkg.zip $$mypkg -x $(BINS);\
	zip -r9 $$mypkg.zip $$mypkg -i $(BINS);\
	rm -rf $$mypkg


bundle-%:
	export PATH=$(CROSSDIR)/bin:$(CROSSDIR)/mingw32/bin:$(PATH); \
	cd $(WINR)/$(R)/src/library;\
	tar zxf $(PKGDIR)/$*.tar.gz; \
	export mybundle=`echo $* | cut -d'_' -f1,1`; \
	echo -------$$mybundle------; \
	cd $(WINR)/$(R)/src/gnuwin32/; \
	$(R_EXE) CMD perl XINSTALL --unsafe --docs=normal ../library/$${mybundle} || exit 1; \
	mkdir -p $(WINRLIBS); \
	ls $(WINR)/$(R)/src/library/$$mybundle/; \
	echo $(PKGDIR)/$$mybundle/DESCRIPTION; \
	grep "^Contains:" $(WINR)/$(R)/src/library/$$mybundle/DESCRIPTION | sed -e 's/Contains: //'; \
	export incl=`grep "^Contains:" $(WINR)/$(R)/src/library/$$mybundle/DESCRIPTION | sed -e 's/Contains: //'`; \
	echo ------$$incl------; \
	cd $(WINR)/$(R)/library; \
	for pkg in $$incl; do \
	(rm -rf $$pkg.zip; \
	 zip -rl $(WINRLIBS)/$$pkg.zip $$pkg -x $(BINS); \
	 zip -r9 $(WINRLIBS)/$$pkg.zip $$pkg -i $(BINS); \
	 rm -rf $$pkg); \
	done; \
	rm -rf $(WINR)/$(R)/src/library/$${mybundle}; \


#### other targets that may be useful

pkgclean-%:
	cd $(PKGDIR); \
	rm -rf $*


recommended:
	export PATH=$(CROSSDIR)/bin:$(CROSSDIR)/mingw32/bin:$(PATH); \
	cd $(WINR)/$(R)/src/gnuwin32/; \
	$(MAKE) recommended

# dist-recommended:
# 	mkdir -p $(WINRLIBS); \
# 	cd $(WINR)/$(R)/src/gnuwin32/; \
# 	$(MAKE) dist-recommended; \
# 	mv Recommended.zip $(WINRLIBS)/

clean:
	rm -rf $(WINR)

#### not tested
# rinstaller:
# 	export PATH=$(CROSSDIR)/bin:$(CROSSDIR)/mingw32/bin:$(PATH); \
# 	cd $(WINR)/$(R)/src/gnuwin32/; \
# 	$(MAKE) rinstaller


CrossCompileBuild :
	$(MAKE) down
	$(MAKE) xtools 
	$(MAKE) prepsrc
	$(MAKE) mkrules
	$(MAKE) R
