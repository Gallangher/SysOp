<#
        Control Panel [FR-UK(US)]

#>
Clear-host

 # DEFINE ASSEMBLY#
 #================#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$code = @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;

namespace System
{
	public class IconExtractor
	{

	 public static Icon Extract(string file, int number, bool largeIcon)
	 {
	  IntPtr large;
	  IntPtr small;
	  ExtractIconEx(file, number, out large, out small, 1);
	  try
	  {
	   return Icon.FromHandle(largeIcon ? large : small);
	  }
	  catch
	  {
	   return null;
	  }

	 }
	 [DllImport("Shell32.dll", EntryPoint = "ExtractIconExW", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
	 private static extern int ExtractIconEx(string sFile, int iIndex, out IntPtr piLargeVersion, out IntPtr piSmallVersion, int amountIcons);

	}
}
"@
Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing                 


# DEFINE LOCAL   #
#================#
[long]$global:width             = 1400
[long]$global:Height            = 740

# DEFINE Language  
# -----------------
enum language{
    Fr = 0
    Us = 1
}

[int]$defaultlang              = [language]::us               # [language]::Us



# Helpder Console

function IsConsole{
    return ($host.Name -match "consolehost")
}

if(IsConsole) {$global:width+=10; $global:height+=10}

# DEFINE ARRAY   @( @{ },@{ },... )  
# hashtable array (Label : Text Affiché. Path = path  )

$global:aHT = @()

$global:aHT += [PSCustomObject]@{  Label = @("Activation de Windows L’assistant", "Windows Activation"); Path= "slui.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Ajout Fonctionnalité Windows", "Windows Features"); Path= "optionalfeatures.Exe"; IconIndex = 0; IconFile =""}
$global:aHT += [PSCustomObject]@{  Label = @("Ajout / Suppression de programmes", "Programs And Features"); Path= "appwiz.cpl"; IconIndex = 82; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Centre de sauvegarde et de restauration","Backup And Restore"); Path= "control.exe /name microsoft.backupandrestorecenter"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Centre de sécurité", "Security And Maintenance"); Path= "wscui.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Centre de synchronisation", "Sync Center"); Path= "mobsync.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Certificats pour l’utilisateur actuel", "certmgr"); Path= "certmgr.msc"; IconIndex = 4; IconFile = "mstscax.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Clavier visuel", "On-Screen Keyboard"); Path= "osk.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Comptes utilisateurs","User Accounts"); Path= "control.exe userpasswords"; IconIndex = 1; IconFile = "sysdm.cpl" }
$global:aHT += [PSCustomObject]@{  Label = @("Configuration du système", "System Configuration"); Path= "msconfig.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Date Et Heure","Date And Time"); Path= "timedate.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Diagnostic DirectX", "DirectX Diagnostic Tool"); Path= "dxdiag.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Console vide", "Microsoft Mangment Console"); Path= "mmc.exe"; IconIndex = 0; IconFile =""}#298; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Contrôle les utilisateurs et leurs accès", "User Accounts(Other)"); Path= "netplwiz"; IconIndex = 290; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Contacts", "Contacts"); Path= "wab"; IconIndex = 117; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Dossiers partagés", "Shared Folders"); Path= "fsmgmt.msc"; IconIndex = 275; IconFile = "shell32.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Éditeur de registre", "Registry Editor"); Path= "regedit.exe"; IconIndex = 1; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Firewall (avancé)", "Firewall (Advanced") ; Path= "wf.msc"; IconIndex = 73; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Fonts", "Fonts"); Path= "control.exe fonts"; IconIndex = 72; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Gestionnaire d'autorisations", "Authorization Manager"); Path= "azman.msc"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Gestionnaire de périphériques", "Device Manager"); Path= "hdwwiz.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Gestionnaire des tâches", "Task Manager"); Path= "taskmgr.exe"; IconIndex = 144; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Gestion des disques", "Disk Managment"); Path= "diskmgmt.msc"; IconIndex = 27; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Gestion de l'ordinateur", "Computer Managment"); Path= "compmgmt.msc"; IconIndex = 313; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Initiateur iSCSI", "iSCSI Initiator"); Path= "iscsicpl.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Imprimantes et fax", "Devices And Fax"); Path= "control.exe printers"; IconIndex = 302; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Informations système", "System Information"); Path= "msinfo32.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Langues d’affichage", "Install or Uninstall Display Language"); Path= "lpksetup"; IconIndex = 256; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Media", "Media"); Path= "$env:windir\media\"; IconIndex = 128; IconFile = "Shell32.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Moniteur de ressources", "Resource Monitor"); Path= "resmon.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Nettoyage de disque", "Disk Cleanup"); Path= "cleanmgr.exe"; IconIndex = 0; IconFile = "cleanmgr.exe" }
$global:aHT += [PSCustomObject]@{  Label = @("Observateur d’évènements", "Event Viewer"); Path= "eventvwr.msc"; IconIndex = 0; IconFile = "eventvwr.exe" }
$global:aHT += [PSCustomObject]@{  Label = @("Options d’ergonomie", "Utilman"); Path= "utilman.exe"; IconIndex = 81; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Options de Démarrage", "System Configuration"); Path= "msconfig.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Option des dossiers", "File Explorer Options"); Path= "control.exe folders"; IconIndex = 157; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Options l’alimentation", "Power Options"); Path= "powercfg.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Option régionaux et linguistiques", "Region"); Path= "intl.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Outils d'administrations", "Administrative Tools"); Path= "control.exe admintools"; IconIndex = 64; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Outil Diagnostics de la mémoire", "Windows Memory Diagnostic"); Path= "mdsched"; IconIndex = 12; IconFile = "shell32.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Bitdefender Firewall","Windows Defender Firewall"); Path= "firewall.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Panneau de configuration", "Control Panel"); Path= "Control"; IconIndex = 21; IconFile = "shell32.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Planificateur de tâches", "Task Scheduler"); Path= "taskschd.msc /s"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Paramètre de compte Utilisateurs","User Accounts Control Settings"); Path= "UserAccountControlSettings.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Programmes par défaut", "Default Apps"); Path= "computerdefaults"; IconIndex = 19; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Propriétés de l’affichage","Display"); Path= "desk.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Propriété de l’apparence", "Background"); Path= "control.exe color"; IconIndex = 186; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Propriété clavier", "Keyboard"); Path= "control.exe keyboard"; IconIndex = 173; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Propriétés internet (IE)", "Internet Properties"); Path= "inetcpl.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Propriété Réseaux (ncpa.cpl)", "Network Connections"); Path= "ncpa.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Propriété Son", "Sound"); Path= "mmsys.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Propriété Souris", "Mouse Proprities"); Path= "main.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Propriété Système", "System Properties"); Path= "sysdm.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Restauration du système", "System Restore"); Path= "rstrui.exe"; IconIndex = 0 ; IconFile =""}#IconIndex = 202; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Sauvegarde et restauration des mots de passe des utilisateurs","Stored User Names And Passwords"); Path= "credwiz.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Services des composants Windows", "Component Services"); Path= "dcomcnfg"; IconIndex = 147; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Sources de données (ODBC)", "ODBC Data Source Administrator"); Path= "odbcad32.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("SQL Client Utility","SQL Client Utility"); Path= "cliconfg.exe"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Téléphonie", "Location Information") ; Path= "telephon.cpl"; IconIndex = 0; IconFile = "" }
$global:aHT += [PSCustomObject]@{  Label = @("Utilisateurs et groupes locaux", "Local Users And Groups"); Path= "lusrmgr.msc"; IconIndex = 169; IconFile = "imageres.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Windows Update", "Windows Update"); Path= "control.exe update"; IconIndex = 238; IconFile = "shell32.dll" }
$global:aHT += [PSCustomObject]@{  Label = @("Numérisation", "New Scan"); Path= "wiaacmgr.exe"; IconIndex = 0; IconFile = "" }


function run ($idx){
    if ($global:aHT[$idx].path.Contains(" ")) {
        $cmd, $arguments = ([string]$global:aHT[$idx].path).split(" ")

        try{
            Start-Process -FilePath $cmd -ArgumentList @($arguments) -Wait
        }catch{}

    }else{

        try{
            start-process $global:aHT[$idx].path
        }catch{}

    }


}


# ===========
# Main Form 
# ----------

$MainForm                                      = New-Object System.Windows.Forms.Form
$MainForm.Text                                 = "Control Panel"
$MainForm.Icon                                 = [System.IconExtractor]::Extract("control.exe", 0, $false)
$MainForm.Size                                 = New-Object System.Drawing.Size($width, $height)
$MainForm.StartPosition                        = "CenterScreen"
$MainForm.FormBorderStyle                      = 'Fixed3D'
$MainForm.MaximizeBox                          = $false

$MainForm.Add_Closing({param($sender,$e)
    $e.Cancel= $false
})


# ================
# DEFINE CONTROLS
# ---------------

$grpLinkLabel = @()
$grpPictureBox = @()
for([int]$i = 0; $i -lt $global:aHT.count; $i++){
        $grpLinkLabel                          += New-Object System.Windows.Forms.LinkLabel
        $grpPictureBox                         += New-Object System.Windows.Forms.PictureBox
        $grpLinkLabel[$i].TabIndex             = $i
        $grpLinkLabel[$i].text                 = $global:aHT[$i].label[$defaultlang]
        $grpLinkLabel[$i].add_Click({
                       run $this.tabindex
        })
        
        $grpLinkLabel[$i].Size                = New-Object System.Drawing.Size(318, 20)
        $grpPictureBox[$i].Size               = New-Object System.Drawing.Size(34 , 34)
        $grpLinkLabel[$i].Location            = New-Object System.Drawing.Point((48 + (360 * ($i%4))), (25 + (40 * [Math]::floor($i/4))))
        $grpPictureBox[$i].Location           = New-Object System.Drawing.Point((6  + (360 * ($i%4))), (16 + (40 * [Math]::floor($i/4))))

        if ($global:aHT[$i].IconFile -eq ""){
                $grpPictureBox[$i].Image      =  [System.IconExtractor]::Extract($global:aHT[$i].path, $global:aHT[$i].IconIndex, $true)
        }else{
                $grpPictureBox[$i].Image      = [System.IconExtractor]::Extract($global:aHT[$i].IconFile, $global:aHT[$i].IconIndex, $true)
        }
                     
}
$MainForm.controls.addrange($grpLinkLabel)
$MainForm.controls.addrange($grpPictureBox)



[void]$MainForm.ShowDialog()
[void]$MainForm.close()
# unload
for([int]$i = 0; $i -lt $global:aHT.count; $i++){
        $grpPictureBox[$i].Dispose()
}
$null = $MainForm.Disposed
