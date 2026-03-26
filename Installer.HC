U0 Install()
{
  U8 *kmisc_path = DirNameAbs("KMisc.HC");

  Drv(':');
  Move("/Kernel/KMisc.HC.Z", "/Kernel/KMisc.BAK.Z");
  Copy(kmisc_path, "/Kernel/KMisc.HC.Z");

  BootHDIns;

  "\nYou need to reboot your PC for changes to apply.\n";
  "Reboot now ";

  if (YorN)
    Reboot;
}

U0 Uninstall()
{
  Drv(':');

  if (FileFind("/Kernel/KMisc.BAK.Z"))
    Move("/Kernel/KMisc.BAK.Z", "/Kernel/KMisc.HC.Z");
  else
    "/Kernel/KMisc.BAK.Z not found. You'll need to copy KMisc.HC.Z to /Kernel/ manually.\n"; throw;

  BootHDIns;

  "\nYou need to reboot your PC for changes to apply.\n";
  "Reboot now ";

  if (YorN)
    Reboot;
}