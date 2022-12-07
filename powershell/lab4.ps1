"This is a system report with a bunch of cool stuff. Enjoy!"


#grabbing system hardware information
function hardware {
	gwmi win32_computersystem | fl Description
} 

#grabbing OS name and version number
function operatingsystem {
	gwmi win32_operatingsystem | fl Name,Version 
}

#grabbing processor description
function processor {
	$L1cache = (gwmi win32_processor).L1CacheSize
	$L2cache = (gwmi win32_processor).L2CacheSize
	$L3cache = (gwmi win32_processor).L3CacheSize
	gwmi win32_processor | fl CurrentClockSpeed,NumberOfCores,L1cache,L2cache,L3cache
	if ($L1cache -eq $null) {
		$L1cache = "data unavailable"
	}
	if ($L2cache -eq $null) {
		$L2cache = "data unavailable"
	}
	if ($L3cache -eq $null) {
		$L3cache = "data unavailable"
	}
}

#grabbing summary of RAM
function memory {
	$totalcapacity = 0
	get-wmiobject -class win32_physicalmemory |
	foreach {
		new-object -TypeName psobject -Property @{
		Manufacturer = $_.manufacturer
		"Speed(MHz)" = $_.speed
		"Size(MB)" = $_.capacity/1mb
		Bank = $_.banklabel
		Slot = $_.devicelocator
		}
	$totalcapacity += $_.capacity/1mb
	} |
	ft -auto Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot
	"Total RAM: ${totalcapacity}MB "
}

#grabbing info for physical disk drives
function physicaldisk {
  $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }
}

#grabbing info on the video card
$videocontroller = 
function videocard { 
	gwmi win32_videocontroller | fl Name,Description,CurrentHorizontalResolution, CurrentVerticalResolution
}


"~~~System Hardware:~~~"
hardware

"~~~Operating System Name & Version:~~~"
operatingsystem

"~~~Processor:~~~"
processor

"~~~RAM:~~~"
memory

"~~~Physical Disk Drives:~~~"
physicaldisk

"~~~Video Card Information:~~~"
videocard

"~~~Network Adapter Configuration:~~~"
ipconfigreport.ps1