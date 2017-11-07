function Save-ClipboardImage {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,Position=0)]
        [string]$Path,
        [validateset('BMP', 'PNG', 'JPG', 'GIF')]$ImageFormat = 'BMP',
        [switch]$Force = $false
    )

    Process {
        $preCurrentDirectory = [System.Environment]::CurrentDirectory
        try {    
            [System.Environment]::CurrentDirectory = (Get-Location).Path
            [void](Add-Type -AssemblyName PresentationCore)
            if ([System.Windows.Clipboard]::ContainsImage()) {
                [System.Windows.Media.Imaging.BitmapSource]$image = [System.Windows.Clipboard]::GetImage();
                [System.Windows.Media.Imaging.BitmapEncoder]$encoder = $null
                if ($ImageFormat -like 'BMP') {
                    $encoder = New-Object System.Windows.Media.Imaging.BmpBitmapEncoder
                } elseif ($ImageFormat -like 'PNG') {
                    $encoder = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
                } elseif ($ImageFormat -like 'JPG') {
                    $encoder = New-Object System.Windows.Media.Imaging.JpegBitmapEncoder
                } elseif ($ImageFormat -like 'GIF') {
                    $encoder = New-Object System.Windows.Media.Imaging.GifBitmapEncoder
                }
                [void]$encoder.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($image))
                if ([System.IO.Path]::GetExtension($Path) -notlike ('.' + $ImageFormat)) {
                    $Path += ('.' + $ImageFormat.ToLower())
                }
                if ($Force) {
                    $stream = New-Object System.IO.FileStream -ArgumentList $Path, 'Create', 'Write'
                } else {
                    $stream = New-Object System.IO.FileStream -ArgumentList $Path, 'CreateNew', 'Write'
                }
                [void]$encoder.Save($stream)
                [void]$stream.Close();
                New-Object System.IO.FileInfo -ArgumentList $Path
            } else {
                Write-Error 'クリップボードに画像がありません。'
            }
        } finally {
            [System.Environment]::CurrentDirectory = $preCurrentDirectory
        }
    }
}