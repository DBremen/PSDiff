# Out-ConsoleDiff

## SYNOPSIS
Diffs two strings and outputs the results side by side in the console color coded and with line numbers.

## SYNTAX

```
Out-ConsoleDiff [-Text1] <Object> [-Text2] <Object> [[-ReplacementDelimiter] <Object>]
```

## DESCRIPTION
Uses Get-CharDiff but adds handing of array input (strings with multiple lines need to be split by new line) 
by inserting a replacementchar to mark new lines.
The color coding is done using ansi escape sequences.
White on
red for deletions and white on green for insertions.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# Using file content as input


$txt1 = (get-content "c:\txt1.txt")
$txt2 = (get-content "c:\txt2.txt")
Out-ConsoleDiff $txt1 $txt2
```
### -------------------------- EXAMPLE 2 --------------------------
```
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
```
## PARAMETERS

### -Text1
{{Fill Text1 Description}}

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
{{Fill Text2 Description}}

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

### -ReplacementDelimiter
The string used to replace newline characters internally, Defaults to 'ÜÜÜ'

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: ÜÜÜ
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



