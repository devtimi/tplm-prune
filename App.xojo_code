#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  var bDryRun as Boolean
		  var sBackupsPath as String
		  
		  // Parse flags
		  for each sArg as String in args
		    if sArg = "--dry-run" then
		      bDryRun = true
		      
		    elseif sArg.Left(1) = "/" then
		      // maybe? a path
		      sBackupsPath = args(1)
		      
		    end
		    
		  next sArg
		  
		  SetupBackupsLocation(sBackupsPath)
		  
		  if mfTarget = nil or (not mfTarget.Exists) then
		    Print("Backups location is missing")
		    return -9001
		    
		  end
		  
		  // Retain everything in the last 4 weeks
		  var dti4Wk as new DateInterval(0, 0, 28)
		  var dtmPurge as DateTime = DateTime.Now - dti4Wk
		  var sPurgeBefore as String = dtmPurge.SQLDate
		  
		  // We'll need to sort in-framework because not every filesystem guarantees order
		  var arsBackups() as String
		  var arfBackups() as FolderItem
		  
		  for each fTarget as FolderItem in mfTarget.Children
		    // SQLDate string comparison is much faster than DateTime comparison
		    // Fast, easy way to filter out things we don't even need to evaluate (retain)
		    var sTargetDate as String = fTarget.Name
		    if sTargetDate < sPurgeBefore then
		      // Backup is older than 28 days
		      arsBackups.Add(sTargetDate) // (skip asking for the name again)
		      arfBackups.Add(fTarget)
		      
		    end
		    
		  next fTarget
		  
		  arsBackups.SortWith(arfBackups)
		  
		  // Both are now sorted by date ASC
		  // Reverse that
		  var ariReverse() as Integer
		  for i as Integer = arsBackups.LastIndex downto 0
		    ariReverse.Add(i)
		    
		  next i
		  
		  ariReverse.SortWith(arfBackups, arsBackups)
		  
		  // Arrays sorted by date text stamp DESC
		  ariReverse.ResizeTo(-1)
		  
		  // This is memory for items we will be purging
		  var arfPurge() as FolderItem
		  
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub SetupBackupsLocation(sCustomPath as String)
		  // To customize the data location use Lifeboat and set a path for TPLM_Path
		  if sCustomPath.Trim <> "" then
		    try
		      mfTarget = new FolderItem(sCustomPath, FolderItem.PathModes.Shell)
		      
		    catch ex as UnsupportedFormatException
		      // Is not occurring on macOS and Linux
		      // https://xojo.com/issue/79365
		      Print("Bad input path: " + sCustomPath)
		      Print("Reverting to default path")
		      
		    end try
		    
		  end
		  
		  // Default to application support
		  if mfTarget = nil then
		    mfTarget = SpecialFolder.ApplicationData.Child(kDataFolderName)
		    
		  end
		  
		  // Are we looking at the container folder?
		  var fBackupsChild as FolderItem = mfTarget.Child("backups")
		  if mfTarget.Name <> "backups" and fBackupsChild <> nil and fBackupsChild.Exists then
		    mfTarget = fBackupsChild
		    
		  end
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mfTarget As FolderItem
	#tag EndProperty


	#tag Constant, Name = kDataFolderName, Type = String, Dynamic = False, Default = \"", Scope = Private
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"com.strawberrysw.licensemanager"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \".com.strawberrysw.licensemanager"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"TPLM"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
