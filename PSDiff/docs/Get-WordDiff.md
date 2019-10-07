# Get-WordDiff

## SYNOPSIS
Get a diff of two texts based on words rather than chars

## SYNTAX

```
Get-WordDiff [-Text1] <Object> [-Text2] <Object> [[-Delimiter] <Object>]
```

## DESCRIPTION
Function from https://github.com/google/diff-match-patch

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-WordDiff "this is a test" "this is not a test"
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
The delimter that separate the words in the text.
Defaults to " "

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


