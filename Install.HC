U8 *kmisc_path = DirNameAbs("KMisc.HC");

Drv(':');
Move("/Kernel/KMisc.HC.Z", "/Kernel/KMisc.BAK.Z");
Copy(kmisc_path, "/Kernel/KMisc.HC.Z");

BootHDIns;

"\nYou need to reboot your PC for changes to apply.\n";
"Reboot now ";

if (YorN)
  Reboot;