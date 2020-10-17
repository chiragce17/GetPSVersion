Function Get-PSVersion{
    param(
       [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
       [String[]]$ComputerName
    )
  
    Begin{
       Write-Verbose "Starting script to get the PowerShell version from the remote computers"
       $output = @()   
       $comment = ""
    }
 
    process{
       foreach($computer in $ComputerName){
        try {
             if(Test-Connection $computer -Count 1 -Quiet -ErrorAction Ignore){
                $psout = Invoke-Command -ComputerName $Computer -ScriptBlock{$PSVersionTable.PSVersion} -ErrorAction Stop
                $psver = "$($psout.Major)" + ".$($psout.minor)"
                $comment = 'Connection successful'         
             }  

             else{
                $comment = 'Connection failed'
             }
        }
        catch {
            $comment = $_.Exception.Message
        }   

                $output += [PSCustomObject]@{
                Server = $computer
                PSVersion = $psver
                Comment = $comment 
            }

            $psver = ""
            $comment = ""
       } 
    }
 
    End{
       Write-Verbose 'Generating Output' 
       $output | ft -AutoSize
    }
   
 }