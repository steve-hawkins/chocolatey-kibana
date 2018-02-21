ifdef SystemRoot
	RM = del /Q /F
else
   ifeq ($(shell uname), Linux)
      RM = rm -f
   endif
endif

package:
	cpack package/kibana.nuspec

install:
	cinst -y kibana -source '.;chocolatey'

uninstall:
	cuninst kibana

clean:
	$(RM) *.nupkg

.PHONY: package install uninstall clean
