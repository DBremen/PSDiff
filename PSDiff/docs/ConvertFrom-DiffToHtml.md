# ConvertFrom-DiffToHtml

## SYNOPSIS
Convert a diff to hmtl, output to file and open in browser (unless specified)

## SYNTAX

```
ConvertFrom-DiffToHtml [-Diff] <Object> [-NoFile] [-NoOpen]
```

## DESCRIPTION
Function from https://github.com/google/diff-match-patch

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CharDiff 'this and that' 'tit and tat' | ConvertFrom-DiffToHtml
```
## PARAMETERS

### -Diff
The diffs (output from Get-*Diff command) to be converted to html

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

### -NoFile
Switch parameter if specified, the command will only return the html output

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoOpen
Switch parameter if specified, the command will put the html into a file and only return the path to the file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


