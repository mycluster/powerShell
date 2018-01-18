################################################################################
#             Texas State University VM Image Push                             #
#==============================================================================#
# Author: Mason Egger                                                          #
# Edited by: Mike Luster (2018)                                                #
#------------------------------------------------------------------------------#
################################################################################



Function Greeting()
{
   Clear_Screen
   Write-Host `n
   Write-Host "|==============================================================================|"
   Write-Host "| Welcome to the TxSt CS Department Test Setup/Execution Script                |"
   Write-Host "| This environment can be run in two modes, guided and shell.                  |"
   Write-Host "|                                                                              |"
   Write-Host "| The guided environment will guide you through an entire testing process from |"
   Write-Host "| beginning to end. The shell environment can be used to complete any of the   |"
   Write-Host "| commands that are run in this process. Only a Lab Administrator should run in|"
   Write-Host "| shell mode.                                                                  |"
   Write-Host "|                                                                              |"
   Write-Host "|   *Enter '?' to view Shell Options*                                          |"
   Write-Host "|   *Enter 'x' to Exit*                                                        |"
   Write-Host "|==============================================================================|"
   Write-Host `n
}


################################################################################
# Shell Options                                                                #
################################################################################
Function Shell_Options()
{
   Write-Host `n
   Write-Host "The current commands for this shell are:"
   Write-Host "Clear_Screen"
   Write-Host "Push_Items Rooms\rooms.txt"
   Write-Host ""
   Write-Host `n
}


#==============================================================================#
# Clear Screen                                                                 #
#------------------------------------------------------------------------------#
# Clears the screen                                                            #
#==============================================================================#
Function Clear_Screen()
{
   cmd /c "cls"
}


#==============================================================================#
# Restart Room                                                                 #
#------------------------------------------------------------------------------#
# @Param - $room_choice (A fully qualified path to a file with computer names) #
#------------------------------------------------------------------------------#
# This function restarts all computers listed in the file $room_choice.        #
#==============================================================================#
Function Restart_Room($room_choice)
{
   $file = get-content $room_choice

   foreach($computer in $file)
   {
      cmd /c "start shutdown /m \\$computer /r /f /t 0"
   }   
  
   TIMEOUT 120
   Clear_Screen
}

#==============================================================================#
# Push_Items                                                                   #
#------------------------------------------------------------------------------#
# @Param - $room_choice (A fully qualified path to a file with computer names) #
#------------------------------------------------------------------------------#
# This function creates a directory in the C dir in every computer in the file #
#==============================================================================#
Function Push_Items($room_choice)
{
   do
   {
      $NewDir = Read-Host 'Enter the name of the directory to be created'  
   }
   until($student_dir -ne "")
   
   $file = get-content $room_choice

   foreach($computer in $file)
   {

      New-Item \\$computer\c$\$NewDir -type directory
      Copy-Item -Recurse -Path \\planetexpress\software$\VirtualBox_VMs\Mint_Clone -Destination \\$computer\c$\$NewDir -Force
      
   }

   
   
}

################################################################################
# Main                                                                         #
################################################################################

Greeting

$loop_control = 'true'
   do
   {
      $cmd = Read-Host 'Enter Command'
      If($cmd -eq 'quit')
      {
         $loop_control = 'false'
         Clear_Screen
      }
      ElseIf($cmd -eq '?' -or $cmd -eq 'help')
      {
         Shell_Options
      }
      ElseIf($cmd -eq 'info')
      {
         Greeting
      }
      ElseIf($cmd -eq 'x')
      {
         $loop_control = 'false'
      }
      Else
      {
         Invoke-Expression $cmd
      }
   }
   until($loop_control -eq 'false')