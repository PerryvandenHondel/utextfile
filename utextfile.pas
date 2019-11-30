{******************************************************************************
                                                                              
   Unit UTextFile                                                              
   
  Usage  
	var
		tf: CTextFile;
		tfr: CTextFile;
	
    // Writing
    tf := CTextFile.Create('testcreate.txt');
    tf.OpenFileWrite();
    Writeln('The status of ' + tf.GetPath + ' is ' + BoolToStr(tf.GetStatus, 'OPEN', 'CLOSED'));
    tf.WriteToFile('test text');
    tf.WriteToFile('test text2');
    tf.CloseFile();
  
    // Reading
    tfr := CTextFile.Create('testread2.txt');
    tfr.OpenFileRead();
    Writeln('The status of ' + tfr.GetPath + ' is ' + BoolToStr(tfr.GetStatus, 'OPEN', 'CLOSED'));
    repeat
      WriteLn(IntToStr(tfr.GetLineNumber()) + ': ' + tfr.ReadFromFile());
    until tfr.GetEof();
    tfr.CloseFile();                                                
		
		02	2014-11-24	
		01	2014-11-18 
		
	NOTE: Use AnsiStrings to support long strings (len>255)
		
******************************************************************************}


unit UTextFile;


{$MODE OBJFPC} // Do not forget this ever
{$M+}
{$H+}


interface


uses
	SysUtils;
	//USupportLibrary;

  
type
	CTextFile = Class
	
	private
		path : string;
		isOpen : boolean;
		textFile : Text;
		lineCount : integer;
		alreadyExists: boolean;
	
	public
		//function ReadFromFile() : string; // v01
		constructor Create(pathNew : string);
		function AppendingToFile(): boolean;
		function GetLineNumber() : integer;
		function GetEof() : boolean;
		function GetPath() : string;
		function GetStatus() : boolean;
		function ReadFromFile() : AnsiString; // v02
		procedure CloseFile();
		procedure DeleteFile();
		procedure OpenFileRead();
		procedure OpenFileWrite();
		procedure WriteToFile(line : AnsiString);
		function DoesFileExists(): boolean;
	end;

	
Implementation


constructor CTextFile.Create(pathNew : string);
begin
	path := pathNew;
	lineCount := 0;
	alreadyExists := false;
end; // of constructor CTextFile.Create


procedure CTextFile.OpenFileWrite();
var
	dirs: string;
begin
	//WriteLn('CTextFile.OpenFileWrite(): ' + path);
	
	// Get the folder of the pat
	dirs := ExtractFilePath(path);
	//WriteLn(dirs);
	if Length(dirs) > 0 then
	begin
		// Create a folder tree when needed.
		// Windows: MakeFolderTree(path);
        if ForceDirectories(dirs) = false then
			WriteLn('UTEXTFILE: OpenFileRead(): Could not create the directory structure for ', path);
	end;
	
	{$I+}
	Assign(textFile, path);
	if FileExists(path) = false then
	begin
		// file doesn't exist, create it
		Rewrite(textFile);
		alreadyExists := false; // Read value with AppendingToFile()
		isOpen := True;
	end
	else
	begin
		// file does exist, open it.
		Append(textFile);
		alreadyExists := true; // Read value with AppendingToFile()
		isOpen := True;
	end;
end; // of procedure CTextFile.OpenFileWrite()


procedure CTextFile.OpenFileRead();
begin
	{$I+}
	Assign(textFile, path);
	try
		Reset(textFile);
		lineCount := 0;
	except
		on E: EInOutError do
		begin	
			WriteLn('UTEXTFILE: OpenFileRead(): File handling occurred. Details: ' + E.ClassName + '/' + E.Message);
		end;
	end;
	isOpen := True;
end; // of procedure CTextFile.OpenFileRead()


procedure CTextFile.CloseFile();
begin
  isOpen := False;
  Close(textFile);
end; // procedure CTextFile.CloseFile


function CTextFile.AppendingToFile(): boolean;
//
//	Returns
//		True when the file already exists
//		False when the file is new
begin
	AppendingToFile := alreadyExists;
end; // of function CTextFile.AppendingToFile


function CTextFile.GetPath() : string;
begin
	GetPath := path;
end; // function CTextFile.GetPath


procedure CTextFile.DeleteFile();
begin
	if isOpen = True then
	begin
		// Close the file when it still open.
		Close(textFile);
	end;
	sysutils.DeleteFile(path);
end;  // procedure CTextFile.DeleteFile


function CTextFile.GetStatus() : boolean;
begin
	GetStatus := isOpen;
end; // of function CTextFile.GetStatus


function CTextFile.DoesFileExists(): boolean;
begin
	DoesFileExists := alreadyExists;
end; // of function CTextFile.DoesFileExists()


procedure CTextFile.WriteToFile(line : Ansistring);
begin
	//WriteLn('CTextFile.WriteToFile():', line);
	WriteLn(textFile, line);
end; // procedure CTextFile.WriteToFile


function CTextFile.ReadFromFile() : AnsiString;
var
	buffBig: AnsiString; // v02: old: Array[0..4096] of Char;
begin
	Inc(lineCount);
	Readln(textFile, buffBig);
	ReadFromFile := buffBig;
end; // of function CTextFile.ReadFromFile


function CTextFile.GetLineNumber() : integer;
begin
	GetLineNumber := lineCount;
end; // function CTextFile.GetLineNumber


function CTextFile.GetEof() : boolean;
begin
	GetEof := Eof(textFile);
end; // of function CTextFile.GetEof()


end. // of unit UTextFile