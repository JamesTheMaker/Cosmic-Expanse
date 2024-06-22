Param(
    [Parameter(Mandatory, HelpMessage = "Please provide a valid path")]
    $Path
)

$modPath = Join-Path -Path (Get-Location) -ChildPath "\*"
Write-Host "Current path is: $($modPath)"

Try {
    if (Test-Path -Path $Path) {
        Remove-Item -Path $Path -Recurse
    }
} Catch {
    Write-Error "Something went wrong: $($_.exception.message)"
} Finally {
    Try {
        New-Item -Path $Path -ItemType Directory -Force
    } Catch {
        Write-Error "Something went wrong: $($_.exception.message)"
    }
}

Try {
    Copy-Item -Path $modPath -Destination $Path -Recurse

    Remove-Item -Path (Join-Path -Path $Path -ChildPath "\.git\") -Recurse
    Remove-Item -Path (Join-Path -Path $Path -ChildPath "\_export.ps1")
} Catch {
    Write-Error "Something went wrong: $($_.exception.message)"

    if (Test-Path -Path $Path) {
        Remove-Item -Path $Path -Recurse
    }
}