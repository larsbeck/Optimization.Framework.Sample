Dear Optimization.Framework user,

before you look at the samples, please note the following:

We included a file called ProblemRunner.cs in your project. This file is meant to be the entry point for your application. In case you just created a new Console application, the fastest and easiest way to use this entry point is by removing the file 'Program.cs' and hitting F5 (which starts your project in Debug mode).

Have fun with our samples!

The DS&OR Team

Optional steps: Note that we changed your app.config file. It now includes a path to the GLPK native dlls, which you also downloaded by installing these samples. These native dlls are located in your project but for now are not deployed when you build your project. That means that you can run and debug the samples, but if you want to deploy them, you should do the following:

In your solution explorer find the GLPK native dlls. They are located in your project in 'Reference Assemblies\GLPK\x64' and 'Reference Assemblies\GLPK\x86' respectively. Right click and choose 'Properties'. Change the 'Copy to output directory' to 'Always copy'. Now you can go to the app.config file and find the following line:
<solver name="GLPK" path="..\..\Reference Assemblies\GLPK\x86" />
Change this line to
<solver name="GLPK" path="Reference Assemblies\GLPK\x86" />
if you want to use the 32 bit version of GLPK or to
<solver name="GLPK" path="Reference Assemblies\GLPK\x64" />
if you want to use the 64 bit version of GLPK.

Note that in both cases you have to make sure that your build configuration (from the menu choose: Build->Configuration Manager) has to be set to the appropriate target platform.