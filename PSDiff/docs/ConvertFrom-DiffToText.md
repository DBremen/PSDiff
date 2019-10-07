# ConvertFrom-DiffToText

## SYNOPSIS
Converts a diff (output of one of the Get-*Diff commands) to a source (text1) and destination (text2)

## SYNTAX

```
ConvertFrom-DiffToText [-Diff] <Object>
```

## DESCRIPTION
Function from https://github.com/google/diff-match-patch

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$srcText = "jumps over the lazy"


$destText = "jumped over a lazy"
$res = Get-CharDiff $srcText $destText | ConvertFrom-DiffToText
```
## PARAMETERS

### -Diff
The diffs (output from Get-*Diff command) to be converted to text1 and text2

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


