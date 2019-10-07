# Get-LineDiff

## SYNOPSIS
Get a diff of two texts based on lines rather than chars or words

## SYNTAX

```
Get-LineDiff [-Text1] <Object> [-Text2] <Object> [[-Delimiter] <Object>]
```

## DESCRIPTION
Function from https://github.com/google/diff-match-patch

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-lineDiff (get-content .\txt1.txt -raw) (get-content .\txt2.txt -raw)
```
## PARAMETERS

### -Text1
The first text

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text2
The second text

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Delimiter
The line delimiter for the text elements.
Defaults to "\`r\`n"

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: `r`n
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


