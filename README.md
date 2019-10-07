# PSDiff
PowerShell wrapper + additional functionality around the diff part of https://github.com/google/diff-match-patch

This is using a slightly customized version of the c# version provided in the diff-match-patch repository (mainly replacing protected by public and implementing the suggested line and word modes).

![OutConsoleDiff](https://github.com/DBremen/PSDiff/blob/master/OutConsoleDiff.PNG)
For usage check the documentation and the tests.
The PSDiff module exports the following functions:


| Function | Synopsis | Documentation |
| --- | --- | --- |
| ConvertFrom-DiffToHtml | Convert a diff to hmtl, output to file and open in browser (unless specified) | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/ConvertFrom-DiffToHtml.md) |
| ConvertFrom-DiffToText | Converts a diff (output of one of the Get-*Diff commands) to a source (text1) and destination (text2) | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/ConvertFrom-DiffToText.md) |
| Get-CharDiff | Get a diff of two strings character by character | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/Get-CharDiff.md) |
| Get-CommonOverlapLength | Get the length of a common suffix or prefix overlap for two strings | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/Get-CommonOverlapLength.md) |
| Get-CommonPrefixLength | Get the length of a common prefix for two strings | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/Get-CommonPrefixLength.md) |
| Get-CommonSuffixLength | Get the length of a common suffix for two strings | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/Get-CommonSuffixLength.md) |
| Get-LineDiff | Get a diff of two texts based on lines rather than chars or words | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/Get-LineDiff.md) |
| Get-WordDiff | Get a diff of two texts based on words rather than chars | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/Get-WordDiff.md) |
| Out-ConsoleDiff | Diffs two strings and outputs the results side by side in the console color coded and with line numbers. | [Link](https://github.com/DBremen/PSDiff/blob/master/PSDiff/docs/Out-ConsoleDiff.md) |
