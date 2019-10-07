# Import the functions
$srcPath = "$(Split-Path $PSScriptRoot -Parent)\Source\DiffMatchPatch.cs"
if (!(Test-Path $srcPath)) {
    Write-Warning "$srcPath not found. `nPlease download DiffMatchPatch.cs from https://github.com/google/diff-match-patch`nand put it into the folder $(Split-Path $PSScriptRoot -Parent)\Source"
    exit
}
$assemblies = @'
System
System.Core
System.Linq
System.Web
'@ -split "`r`n"
if ("DiffMatchPatch.diff_match_patch" -as [type]) { } else {
    $code = (Get-Content -Raw -Path $srcPath) -replace 'protected', 'public'
    Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $code -Language CSharp
}
$dmp = New-Object DiffMatchPatch.diff_match_patch

function Get-CommonPrefixLength {
    <#    
        .SYNOPSIS
            Get the length of a common prefix for two strings
        .DESCRIPTION
            Function from https://github.com/google/diff-match-patch
        .PARAMETER Text1
            The first string
        .PARAMETER Text2
            The second string
        .EXAMPLE
            # returns 4
            Get-CommonPrefixLength "1234abcdef" "1234xyz"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] 
        $Text1,
        [Parameter(Mandatory, Position = 1)] 
        $Text2
    )
    $dmp.diff_commonPrefix($Text1, $Text2)
}

function Get-CommonSuffixLength {
    <#    
        .SYNOPSIS
            Get the length of a common suffix for two strings
        .DESCRIPTION
            Function from https://github.com/google/diff-match-patch
        .PARAMETER Text1
            The first string
        .PARAMETER Text2
            The second string
        .EXAMPLE
            # returns 4
            Get-CommonSuffixLength "abcdef1234"  "xyz1234"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] 
        $Text1,
        [Parameter(Mandatory, Position = 1)] 
        $Text2
    )
    $dmp.diff_commonSuffix($Text1, $Text2)
}

function Get-CommonOverlapLength {
    <#    
        .SYNOPSIS
            Get the length of a common suffix or prefix overlap for two strings
        .DESCRIPTION
            Function from https://github.com/google/diff-match-patch
        .PARAMETER Text1
            The first string
        .PARAMETER Text2
            The second string
        .EXAMPLE
            # returns 3
            Get-CommonOverlapLength "123456xxx" "xxxabcd")
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] 
        $Text1,
        [Parameter(Mandatory, Position = 1)] 
        $Text2
    )
    $dmp.diff_commonOverlap($Text1, $Text2)
}

function Get-LineDiff {
    <#    
        .SYNOPSIS
            Get a diff of two texts based on lines rather than chars or words
        .DESCRIPTION
            Function from https://github.com/google/diff-match-patch
        .PARAMETER Text1
            The first text
        .PARAMETER Text2
            The second text
        .PARAMETER Delimiter
            The line delimiter for the text elements. Defaults to "`r`n"
        .EXAMPLE
            Get-lineDiff (get-content .\txt1.txt -raw) (get-content .\txt2.txt -raw)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] 
        $Text1,
        [Parameter(Mandatory, Position = 1)] 
        $Text2,
        [Parameter(Position = 2)] 
        $Delimiter = '`r`n'
    )
    $dmp.diff_lineWordDiff($Text1, $Text2, $Delimiter.Replace('`','\'))
}

function Get-WordDiff {
    <#    
       .SYNOPSIS
           Get a diff of two texts based on words rather than chars
       .DESCRIPTION
           Function from https://github.com/google/diff-match-patch
       .PARAMETER Text1
           The first text
       .PARAMETER Text2
           The second text
       .PARAMETER Delimiter
           The delimter that separate the words in the text. Defaults to " "
       .EXAMPLE
           Get-WordDiff "this is a test" "this is not a test"
   #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] 
        $Text1,
        [Parameter(Mandatory, Position = 1)] 
        $Text2,
        [Parameter(Position = 2)] 
        $Delimiter = ' '
    )
    $dmp.diff_lineWordDiff($Text1, $Text2, $Delimiter.Replace('`', '\'))
}

function Get-CharDiff {
    <#    
       .SYNOPSIS
           Get a diff of two strings character by character
       .DESCRIPTION
           Function from https://github.com/google/diff-match-patch
       .PARAMETER Text1
           The first string
       .PARAMETER Text2
           The second string
       .EXAMPLE
           Get-CharDiff 'this and that' 'tit and tat'
   #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] 
        $Text1,
        [Parameter(Mandatory, Position = 1)] 
        $Text2
    )
    $diff = $dmp.diff_main($Text1, $Text2)
    $dmp.diff_cleanupSemantic($diff)
    $diff
}

function ConvertFrom-DiffToHtml {
    <#    
        .SYNOPSIS
            Convert a diff to hmtl, output to file and open in browser (unless specified)
        .DESCRIPTION
            Function from https://github.com/google/diff-match-patch
        .PARAMETER Diff
            The diffs (output from Get-*Diff command) to be converted to html
        .PARAMETER NoFile
            Switch parameter if specified, the command will only return the html output
        .PARAMETER NoOpen
            Switch parameter if specified, the command will put the html into a file and only return the path to the file.
        .EXAMPLE
            Get-CharDiff 'this and that' 'tit and tat' | ConvertFrom-DiffToHtml
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)] 
        $Diff,
        [Switch]$NoFile,
        [Switch]$NoOpen
    )
    BEGIN {
        $diffs = New-Object System.Collections.Generic.List[DiffMatchPatch.Diff]
    }
    PROCESS { 
        $Null = $diffs.Add($Diff)
    }
    END {
        $html = $dmp.diff_prettyHtml($diffs)
        if ($NoFile) {
            return $html
        }
        $path = [IO.Path]::ChangeExtension([IO.Path]::GetTempFileName(), 'html')
        ConvertTo-Html -Body $html -Title 'Diff by https://github.com/google/diff-match-patch' | 
            Set-Content -Path $path
        if ($NoOpen) {
            return $path
        }
        ii $path
    }
}

function ConvertFrom-DiffToText {
    <#    
        .SYNOPSIS
            Converts a diff (output of one of the Get-*Diff commands) to a source (text1) and destination (text2)
        .DESCRIPTION
            Function from https://github.com/google/diff-match-patch
        .PARAMETER Diff
            The diffs (output from Get-*Diff command) to be converted to text1 and text2
        .EXAMPLE
            $srcText = "jumps over the lazy"
            $destText = "jumped over a lazy"
            $res = Get-CharDiff $srcText $destText | ConvertFrom-DiffToText
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)] 
        $Diff
    )
    
    BEGIN {
        $diffs = New-Object System.Collections.Generic.List[DiffMatchPatch.Diff]
    }
    PROCESS { 
        $Null = $diffs.Add($Diff)
    }
    END {
        $dmp.diff_text1($diffs)
        $dmp.diff_text2($diffs)
    }
}

function Out-ConsoleDiff {
    <#    
        .SYNOPSIS
            Diffs two strings and outputs the results side by side in the console color coded and with line numbers.
        .DESCRIPTION
            Uses Get-CharDiff but adds handing of array input (strings with multiple lines need to be split by new line) 
            by inserting a replacementchar to mark new lines. The color coding is done using ansi escape sequences. White on
            red for deletions and white on green for insertions.
        .PARAMETER Text
            The base string
        .PARAMETER Text 1
            The difference string
        .PARAMETER ReplacementDelimiter
            The string used to replace newline characters internally, Defaults to 'ÜÜÜ'
        .EXAMPLE
            # Using file content as input
            $txt1 = (get-content "c:\txt1.txt")
            $txt2 = (get-content "c:\txt2.txt")
            Out-ConsoleDiff $txt1 $txt2
        .EXAMPLE
            # Using string input split by newline
            $txt1 = @'
will stay
this will be changed
this will be deleted
'@ -split '\r?\n'
            $txt2 = @'
will stay
this is now changed to something new
replaced with new line
here is a totally new line
'@ -split '\r?\n'
            Out-ConsoleDiff $txt1 $txt2


    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Text1,
        [Parameter(Mandatory, Position = 1)]
        $Text2,
        [Parameter(Position = 2)]
        $ReplacementDelimiter = 'ÜÜÜ'
    )
    #put the replacementdelimiter at the end of every line of the texts (lines remain array items)
    $regex = '(?<=' + $ReplacementDelimiter + ')'
    $txt1 = $Text1 -join $ReplacementDelimiter -split $regex
    $txt2 = $Text2 -join $ReplacementDelimiter -split $regex
    #handle txts of different lengths substituting the empty line/array item with ''
    $len1 = $txt1.Length
    $len2 = $txt2.Length
    $maxLength = [Math]::Max($len1, $len2)
    $diffs = for ($i = 0; $i -lt $maxLength; $i++) {
        $t1 = $t2 = ''
        if ($i -lt $len1) { $t1 = $txt1[$i] }
        if ($i -lt $len2) { $t2 = $txt2[$i] }
        #get the character based diff based on a line by line comparison
        Get-CharDiff $t1 $t2
    }
   
    $diffText1 = [System.Text.StringBuilder]::new()
    $diffText2 = [System.Text.StringBuilder]::new()
    #ansi escape 
    $esc=$([char]27)
    #run through the diffs and rebuild text1 and text2 color coding the diff text with white on green for insertions and with on red for deletions
    #esnure end ansi escape sequence '[0m' are preceding the replacementchars to remain on the same line
    foreach ($currDiff in $diffs) {
        switch ($currDiff.Operation) {
            'Equal' { 
                [void]$diffText1.Append($currDiff.text)
                [void]$diffText2.Append($currDiff.text)
                break 
            }
            'Delete' { 
                [void]$diffText1.Append($currDiff.text)
                if ($currDiff.text.EndsWith($ReplacementDelimiter)) {
                    [void]$diffText2.Append("$esc[48;5;9m$($currDiff.text.Replace($ReplacementDelimiter,"$esc[0m$ReplacementDelimiter"))")
                }
                else{
                    [void]$diffText2.Append("$esc[48;5;9m$($currDiff.text)$esc[0m")
                }
                break 
            }
            'Insert' { 
                if ($currDiff.text.EndsWith($ReplacementDelimiter)) {
                    [void]$diffText2.Append("$esc[48;5;10m$($currDiff.text.Replace($ReplacementDelimiter,"$esc[0m$ReplacementDelimiter"))")
                }
                else{
                    [void]$diffText2.Append("$esc[48;5;10m$($currDiff.text)$esc[0m")
                }
            }
        }
    }
    #split the now color coded diffs again at the original new lines (marked by the replacement char)
    $diffText1 = $diffText1 -Split $ReplacementDelimiter
    $diffText2 = $diffText2 -Split $ReplacementDelimiter
    #handle texts of different lengths and substitute missing lines by 'n/a' 
    #also add the linenumbers
    $max = $diffText1
    $minCount, $maxName, $minName = $diffText2.Count, 't1', 't2'
    if ($diffText1.Count -ne $diffText2.Count -and $diffText1.Count -lt $diffText2.Count){
        $max = $diffText2
        $minCount, $maxName, $minName = $diffText1.Count, 't2', 't1'
    }
    $t1 = $t2 = ''
    for ($i = 0; $i -lt $max.Count;$i++){
        if ($i+1 -gt $minCount){
            Set-Variable $minName 'n/a'
            Set-Variable $maxName ($max[$i])
        }
        else{
            $t1 = $diffText1[$i]
            $t2 = $diffText2[$i]
                
        }
        [PSCustomObject][ordered]@{
                Line =  $i+1
                Text1 = $t1
                Text2 = $t2
        }
    }
        
}