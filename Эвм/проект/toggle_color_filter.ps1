# Проверка текущего состояния цветного фильтра
$current = Get-ItemProperty -Path "HKCU:\Software\Microsoft\ColorFiltering" -Name "ColorFilter" -ErrorAction SilentlyContinue
if ($null -eq $current) {
    # Если ключ не существует, создадим его
    New-Item -Path "HKCU:\Software\Microsoft\ColorFiltering" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\ColorFiltering" -Name "ColorFilter" -Value 0
    $current.ColorFilter = 0
}

if ($current.ColorFilter -eq 0) {
    # Включить цветной фильтр
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\ColorFiltering" -Name "ColorFilter" -Value 1
    Write-Host "Цветной фильтр включен."
} else {
    # Выключить цветной фильтр
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\ColorFiltering" -Name "ColorFilter" -Value 0
    Write-Host "Цветной фильтр выключен."
}
