# utextfile
Pascal unit for handling text files.

# Usage

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
      WriteLn(IntToStr(tfr.GetCurrentLine()) + ': ' + tfr.ReadFromFile());
    until tfr.GetEof();
    tfr.CloseFile();          
