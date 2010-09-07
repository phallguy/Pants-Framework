iPhone framework for some common tasks shared by [Apps In Your Pants][3] applications.

[![Creative Commons License][1]][2]



#Adding to your Project#

See [Easy, Modular Code Sharing Across iPhone Apps: Static Libraries and Cross-Project References][4] for details on adding the Pants-Framework to your project.

One additional step not mentioned in the guide is required to support class categories included in the project. In your _main project's_ build settings, add **`-ObjC -all_load`** to the **Other Linker Flags** property.




[1]: http://i.creativecommons.org/l/by-sa/3.0/88x31.png
[2]: http://creativecommons.org/licenses/by-sa/3.0/
[3]: http://appsinyourpants.com
[4]: http://www.clintharris.net/2009/iphone-app-shared-libraries/