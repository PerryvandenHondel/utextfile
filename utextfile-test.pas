program UTextFileTest;


uses
  SysUtils,
  UTextFile;


var
	tf: CTextFile;
  tfr: CTextFile;
  
  
begin
	tf := CTextFile.Create('utexttest.txt');
	tf.OpenFileWrite();
	Writeln('The status of ' + tf.GetPath + ' is ' + BoolToStr(tf.GetStatus, 'OPEN', 'CLOSED'));
  tf.WriteToFile('test text');
  tf.WriteToFile('test text2');
  tf.WriteToFile('testline');
  
  tf.CloseFile();
  
  tfr := CTextFile.Create('utexttest.txt');
  tfr.OpenFileRead();
  Writeln('The status of ' + tfr.GetPath + ' is ' + BoolToStr(tfr.GetStatus, 'OPEN', 'CLOSED'));
  repeat
    WriteLn(IntToStr(tfr.GetCurrentLine()) + ': ' + tfr.ReadFromFile());
    
  until tfr.GetEof();
  
  tfr.CloseFile();

  WriteLn('Size of ', tfr.GetPath, ' is ', tfr.GetFileSize());
end.