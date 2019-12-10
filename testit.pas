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

	tf := CTextFile.CreateTheFile(path);
	tf.OpenFileForWrite();
	Writeln('The status of ' + tf.GetPath + ' is ' + BoolToStr(tf.GetStatus, 'OPEN', 'CLOSED'));
  tf.WriteToFile('test text');
  tf.WriteToFile('test text2');
  tf.WriteToFile('testline');
  
  tf.CloseTheFile();
  
  tfr := CTextFile.CreateTheFile(path);
  tfr.OpenFileForRead();
  Writeln('The status of ' + tfr.GetPath + ' is ' + BoolToStr(tfr.GetStatus, 'OPEN', 'CLOSED'));
  repeat
    WriteLn(IntToStr(tfr.GetLineNumber()) + ': ' + tfr.ReadFromFile());
  until tfr.GetEof();
  
  //WriteLn('Size of ', tfr.GetPath, ' is ', tfr.GetFileSize());

  tfr.CloseTheFile();


  path := '/tmp/firstname.log';
  tf := CTextFile.CreateTheFile(path);
  tf.OpenFileForWrite();
  tf.WriteToFile('firstname line');
  tf.CloseTheFile();
  tf.RenameTheFile('newname.log');


end.