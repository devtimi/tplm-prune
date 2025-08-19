#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  var sBackupsPath as String
		  
		  if args.LastIndex > 0 then
		    sBackupsPath = args(1)
		    
		  end
		  
		  SetupBackupsLocation(sBackupsPath)
		  
		  if mfTarget = nil or (not mfTarget.Exists) then
		    Print("Backups location is missing")
		    return -9001
		    
		  end
		  
		  
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
