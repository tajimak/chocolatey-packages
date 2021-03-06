import-module au

$releases = 'https://www.iobit.com/en/advanceduninstaller.php'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $content = $download_page.Content

    $pattern = '(?<=button\ btn-jadegreen\ large)[\S\s]*"ver_size"><span>V (?<Version>[\d\.]+)'
    $url   = 'http://update.iobit.com/dl/iobituninstaller.exe'
    $version = [regex]::Match($content, $pattern).groups['Version'].value

    return @{ 
        URL32 = $url
        Version = $version 
    }
}

update -ChecksumFor 32