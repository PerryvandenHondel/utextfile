program UTextFileTest;


uses
  SysUtils,
  UTextFile;


var
	tf: CTextFile;
  tfr: CTextFile;
  path: AnsiString;

  
  
begin
  path := '/tmp/utextfile/test.log';

	tf := CTextFile.Create(path);
	tf.OpenFileWrite();
	Writeln('The status of ' + tf.GetPath + ' is ' + BoolToStr(tf.GetStatus, 'OPEN', 'CLOSED'));
  tf.WriteToFile('test text');
  tf.WriteToFile('test text2');
  tf.WriteToFile('testline');
  
  tf.CloseFile();
  
  tfr := CTextFile.Create(path);
  tfr.OpenFileRead();
  Writeln('The status of ' + tfr.GetPath + ' is ' + BoolToStr(tfr.GetStatus, 'OPEN', 'CLOSED'));
  repeat
    WriteLn(IntToStr(tfr.GetCurrentLine()) + ': ' + tfr.ReadFromFile());
    
  until tfr.GetEof();
  
 

  WriteLn('Size of ', tfr.GetPath, ' is ', tfr.GetFileSize());

   tfr.CloseFile();
end.