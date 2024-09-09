# encodeDecodeBase64

## Introduction


Inspired from GitHub article:

* How can I split a text file using PowerShell?
  `https://stackoverflow.com/questions/1001776/how-can-i-split-a-text-file-using-powershell`

... and the answer from Typhlosaurus (https://stackoverflow.com/users/311372/typhlosaurus)

http://stackoverflow.com/a/11010158/215200


... and awayken (https://stackoverflow.com/users/215200/awayken) who posted the following GitHub gist:

* awayken/Split-File.ps1
  `https://gist.github.com/awayken/5861923`

## Usage

This PowerShell script was created and tested with version 5.1 on Windows 10.

If/when/maybe I have time I will test on other platforms such as Ubuntu.

## Execution

These examples asume the above PowerShell session.

### Split base64 file by specifying only the input file

The script will assume an output file size of 1 MiB.

`.\split_text_file_PowerShell5\Split_file_v2.ps1 -inFile myTestFile.b64`

### Split base64 file by specifying the input file and size of output file(s).

This example specifies that the output file size should be 2 MiB instead of the default 1 MiB.

`.\split_text_file_PowerShell5\Split_file_v2.ps1 -inFile myTestFile.b64 -outputFileSize 2MB`

### Split base64 file by specifying the input file and name of output file(s).

`.\split_text_file_PowerShell5\Split_file_v2.ps1 -inFile myTestFile.b64 -outFile fooFile.b64`

### Test and verify

This will have to wait until I create the corresponding script to put these split files back together.

## Author

Andrew Nagy

https://www.linkedin.com/in/andrew-e-nagy/
