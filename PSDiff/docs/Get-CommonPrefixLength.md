# Get-CommonPrefixLength

## SYNOPSIS
Get the length of a common prefix for two strings

## SYNTAX

```
Get-CommonPrefixLength [-Text1] <Object> [-Text2] <Object>
```

## DESCRIPTION
Function from https://github.com/google/diff-match-patch

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# returns 4


Get-CommonPrefixLength "1234abcdef" "1234xyz"
```
## PARAMETERS

### -Text1
The first string

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
The second string

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


