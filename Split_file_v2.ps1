<#
Inspired from GitHub gist

awayken/Split-File.ps1
https://gist.github.com/awayken/5861923

#>

# Modified from: http://stackoverflow.com/a/11010158/215200

Param(
    [Parameter(Mandatory=$true)]
    [ValidateScript(
        {Test-Path $_}
    )]
    [string]$inFile
    ,
    [string]$outFile
    ,
    [int]$outputFileSize = 1MB # the unit MB is calculated by Powershell
)

$inputFile = Get-ChildItem -Path $inFile
if ( Test-Path -Path $inputFile -PathType Leaf )
{
    Write-Host "Found inFile '${infile}'. Continuing."
} else {
    <# Action when all if and elseif conditions are false #>
    Write-Error "ERROR: Unable to find 'inFile' '${inFile}'. Aborting script."
    exit 1
}

$fileBuffer                     = New-Object byte[] $outputFileSize
[int]$inputFileBytesRead        = 0
[string]$inputFileFolder        = $inputFile.DirectoryName
[string]$inputFileBaseName      = $inputFile.BaseName
[string]$inputFileExtension     = $inputFile.Extension.Replace( "." , "")
[string]$inputFileFullName      = "{0}{1}.{2}" -f ($inputFileFolder, $inputFileBaseName, $inputFileExtension)
$inputFileIo                    = [io.file]::OpenRead($inputFile.FullName)

if ( $outFile -and $outFile.Length -gt 0)
{
    if ( Split-Path -Path $outFile -IsAbsolute )
    {
        [string]$outputFileFolder        = $inputFile.DirectoryName

    } else {
        # https://superuser.com/questions/1660757/how-to-get-current-path-in-powershell-into-a-variable
        [string]$outputFileFolder        = $PWD.Path
    }
    # https://stackoverflow.com/a/9788998
    [string]$outputFileBaseName      = [System.IO.Path]::GetFileName( $outFile )
    [string]$outputFileExtension     = [System.IO.Path]::GetExtension( $outFile ).Replace( "." , "" )
} else {
    Write-Information "`$outFile is either null nor empty. Using 'inFile' name for 'outFile'. Continuing."
    # https://stackoverflow.com/a/9788998
    [string]$outputFileFolder        = $inputFile.DirectoryName
    [string]$outputFileBaseName      = $inputFile.BaseName
    [string]$outputFileExtension     = $inputFile.Extension.Replace( "." , "" )
}

[int]$outputFileCount           = 1
[string]$outputFileCountMax     = [Math]::Ceiling( $inputFile.Length / $outputFileSize )
[int]$outputFileCountFieldWidth = $outputFileCountMax.Length + 1

Write-Host "Splitting file '$inputFileFullName' using $outputFileSize bytes ($( ${outputFileSize}/1MB ) MiB) per file.`n"
try {
    do {
        $inputFileBytesRead = $inputFileIo.Read($fileBuffer, 0, $fileBuffer.Length)
        if ($inputFileBytesRead -gt 0)
        {
            $outputFileFullName = "{0}\{1}.{2:d${outputFileCountFieldWidth}}.{3}" -f ($outputFileFolder, $outputFileBaseName, $outputFileCount, $outputFileExtension)
            $outputFileIo = [io.file]::OpenWrite($outputFileFullName)
            try {
                $outputFileIo.Write( $fileBuffer, 0, $inputFileBytesRead )
                Write-Host "Wrote file  : '$outputFileFullName'."
            } finally {
                $outputFileIo.Close()
            }
        }
        $outputFileCount ++
    } while ($inputFileBytesRead -gt 0)
}
finally {
    $inputFileIo.Close()
}