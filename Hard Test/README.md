# For Windows System

Cross-Compiling R packages from source for Windows Machines, which requires the creation of Window Binaries.

**Approach Followed** - Cross-build on an intel-based linux or mac system. Here, we are following with Windows System.
For, automating the task a Makefile is been created to get all the requirements and dependencies. And it creats following subdirectories
in the directory RCrossBuild.

- downloads
- cross-tools
- WinR
- LinuxR
- pkgsrc
- WinRlibs
