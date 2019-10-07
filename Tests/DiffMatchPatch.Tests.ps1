$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace('.Tests', '').Replace('ps1', 'psm1')
Import-Module "$here\DiffMatchPatch\$sut" -force
  
Describe "Get-CommonPrefixLength" {
    It "Returns 0 if there is no common prefix" {
        Get-CommonPrefixLength "abc" "xyz" | Should -Be 0
    }
    It "It returns the number of common prefix chars" {
        Get-CommonPrefixLength "1234abcdef" "1234xyz" | Should -Be 4
    }
    It "It also works if one string begins with the other" {
        Get-CommonPrefixLength "1234" "1234xyz" | Should -Be 4
    }
}

Describe "Get-CommonSuffixLength" {
    It "Returns 0 if there is no common suffix" {
        Get-CommonSuffixLength "abc" "xyz" | Should -Be 0
    }
    It "It returns the number of common suffix chars" {
        Get-CommonSuffixLength "abcdef1234" "xyz1234" | Should -Be 4
    }
    It "It also works if one string ends with the other" {
        Get-CommonSuffixLength "1234" "xyz1234" | Should -Be 4
    }
}

Describe "Get-CommonOverlapLength" {
    It "Returns 0 if there is no common overlap" {
        Get-CommonOverlapLength "" "abcd" | Should -Be 0
    }
    It "It returns the number of common overlap chars if one string contains the other" {
        Get-CommonOverlapLength "abc" "abcd" | Should -Be 3
    }
    It "It returns 0 if there is no overlap" {
        Get-CommonOverlapLength "123456" "abcd" | Should -Be 0
    }
    It "It returns the number of common overlap chars" {
        Get-CommonOverlapLength "123456xxx" "xxxabcd" | Should -Be 3
    }
}

Describe "ConvertFrom-DiffToHtml" {
    It "Outputs diff converted to hmlt if -NoFile switch is used" {
        $res = Get-CharDiff 'this and that' 'tit and tat' | ConvertFrom-DiffToHtml -NoFile
        $res.Trim() | Should -Be '<span>t</span><del style="background:#ffe6e6;">his</del><ins style="background:#e6ffe6;">it</ins><span> and t</span><del style="background:#ffe6e6;">h</del><span>at</span>'
    }
    It "It returns a file path if -NoOpen switch is used" {
        Get-CharDiff 'this and that' 'tit and tat' | ConvertFrom-DiffToHtml -NoOpen | 
        Test-Path | Should -Be $true
}
}

Describe "ConvertFrom-DiffToText" {
    $srcText = "jumps over the lazy"
    $destText = "jumped over a lazy"
    $res = Get-CharDiff $srcText $destText | ConvertFrom-DiffToText
    It "It converts a list of diffs back to the source (text1)" {
        $res[0] | Should -Be $srcText
    }
    It "It converts a list of diffs back to the destination (text2)" {
        $res[1] | Should -Be $destText
    }
}


Describe "Get-CharDiff" {
    It "It recognizes equality of two strings" {
        $diffs = New-Object System.Collections.Generic.List[DiffMatchPatch.Diff]
        $diffs.Add((New-Object DiffMatchPatch.Diff('Equal', 'abc')))
        Get-CharDiff 'abc' 'abc' | Should -Be $diffs
    }
    It "It recognizes a simple insertion in one of the strings" {
        $diffs = New-Object System.Collections.Generic.List[DiffMatchPatch.Diff]
        $diffs.Add((New-Object DiffMatchPatch.Diff('Equal', 'ab')))
        $diffs.Add((New-Object DiffMatchPatch.Diff('Insert', '123')))
        $diffs.Add((New-Object DiffMatchPatch.Diff('Equal', 'c')))
        Get-CharDiff 'abc' 'ab123c' | Should -Be $diffs
    }
    It "It recognizes a simple deletion in one of the strings" {
        $diffs = New-Object System.Collections.Generic.List[DiffMatchPatch.Diff]
        $diffs.Add((New-Object DiffMatchPatch.Diff('Equal', 'a')))
        $diffs.Add((New-Object DiffMatchPatch.Diff('Delete', '123')))
        $diffs.Add((New-Object DiffMatchPatch.Diff('Equal', 'bc')))
        Get-CharDiff 'a123bc' 'abc' | Should -Be $diffs
    }
}
