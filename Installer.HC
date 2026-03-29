U0 Install()
{
  if (!FileFind("KMisc.HC")) {
    "KMisc.HC not found. Exiting.\n"; return;
  }

  Move("::/Kernel/KMisc.HC.Z", "::/Kernel/KMisc.BAK.Z");
  Copy("KMisc.HC", "::/Kernel/KMisc.HC.Z");
  BootHDIns(':');

  "\nYou need to reboot your PC for changes to apply.\n";
  "Reboot now ";

  if (YorN)
    Reboot;
}

U0 Uninstall()
{
  if (!FileFind("::/Kernel/KMisc.BAK.Z")) {
    "KMisc.BAK.Z not found. Exiting.\n"; return;
  }

  Move("::/Kernel/KMisc.BAK.Z", "::/Kernel/KMisc.HC.Z");
  BootHDIns(':');

  "\nYou need to reboot your PC for changes to apply.\n";
  "Reboot now ";

  if (YorN)
    Reboot;
}