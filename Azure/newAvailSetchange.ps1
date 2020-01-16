## [주석 = #] 별 내용 확인하시고 순서대로 모두 진행하시기 바랍니다. 

# 변수 설정 (가용성 집합을 변경할 가상머신의 리소스 그룹, 가상머신 이름, 사용할 가상머신 이름을 입력합니다.)
    $resourceGroup = "myResourceGroup"
    $vmName = "myVM"
    $newAvailSetName = "myAvailabilitySet"

################아래 명령어부터 복사 + 붙여넣기만 하시면 됩니다. ################

# 가용성 집합으로 이동할 VM의 세부 정보를 가져옵니다.
    $originalVM = Get-AzVM `
       -ResourceGroupName $resourceGroup `
       -Name $vmName

# 변수로 설정한 가용성 집합이 있으면 가져오고 없으면 새로 생성 (위 변수 선언중$newAvailSetName = "myAvailabilitySet"으로 설정된 가용성 집합이 있으면 정보를 가져오고 없으면 새로 생성하게 됩니다.)

    $availSet = Get-AzAvailabilitySet `
       -ResourceGroupName $resourceGroup `
       -Name $newAvailSetName `
       -ErrorAction Ignore
    if (-Not $availSet) {
    $availSet = New-AzAvailabilitySet `
       -Location $originalVM.Location `
       -Name $newAvailSetName `
       -ResourceGroupName $resourceGroup `
       -PlatformFaultDomainCount 2 `
       -PlatformUpdateDomainCount 2 `
       -Sku Aligned
    }

# 위 단계를 모두 마치면 가상머신을 삭제합니다. (가상머신만 삭제될 뿐 네트워크 인터페이스, 디스크는 그대로 남습니다.)
    Remove-AzVM -ResourceGroupName $resourceGroup -Name $vmName

# 가용성 집합에 넣을 가상머신의 기본 구성을 만듭니다.

    $newVM = New-AzVMConfig `
       -VMName $originalVM.Name `
       -VMSize $originalVM.HardwareProfile.VmSize `
       -AvailabilitySetId $availSet.Id

    Set-AzVMOSDisk `
       -VM $newVM -CreateOption Attach `
       -ManagedDiskId $originalVM.StorageProfile.OsDisk.ManagedDisk.Id `
       -Name $originalVM.StorageProfile.OsDisk.Name `
       -Linux  OS가 윈도우일 경우 Windows로 변경해 줍니다.

# 데이터 디스크 추가

    foreach ($disk in $originalVM.StorageProfile.DataDisks) {
    Add-AzVMDataDisk -VM $newVM `
       -Name $disk.Name `
       -ManagedDiskId $disk.ManagedDisk.Id `
       -Caching $disk.Caching `
       -Lun $disk.Lun `
       -DiskSizeInGB $disk.DiskSizeGB `
       -CreateOption Attach
    }

# 네트워크 인터페이스 추가

    foreach ($nic in $originalVM.NetworkProfile.NetworkInterfaces) {
    if ($nic.Primary -eq "True")
        {
            Add-AzVMNetworkInterface `
            -VM $newVM `
            -Id $nic.Id -Primary
            }
        else
            {
              Add-AzVMNetworkInterface `
              -VM $newVM `
              -Id $nic.Id
                }
    }

# 가용성 집합에 들어간 가상머신 생성

    New-AzVM `
       -ResourceGroupName $resourceGroup `
       -Location $originalVM.Location `
       -VM $newVM `
       -DisableBginfoExtension
