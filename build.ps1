# Fix Example section markup from PlatyPS
$files = dir "$PSSCriptRoot\PSDiff\docs"
$replacements = foreach ($file in $files) {
    $exampleText = [RegEx]::Match(($file | Get-Content -Raw), '(?ms)## EXAMPLES(.*)?## PARAMETERS').Groups[1].Value
    $examples = ($exampleText -split '###.*EXAMPLE \d\s*[-]*') | select -Skip 1
    foreach ($example in $examples) {
        [PSCustomObject][ordered]@{
            Old  = $example
            New  = "`r`n" + '```' + "`r`n$($example.Replace('```','').Trim())`r`n" + '```' + "`r`n"
            Path = $file.FullName
        }
    }
}

foreach ($replacement in $replacements) {
    (Get-Content $replacement.Path -Raw).Replace($replacement.Old, $replacement.New) | Set-Content $replacement.Path
}
