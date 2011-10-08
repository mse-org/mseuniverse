unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets,
 msedataedits,mseedit,msestrings,msetypes,msebitmap,msedatanodes,msefiledialog,
 msegrids,mselistbrowser,msesys,msetimer,msegraphedits,lMimeWrapper, lSMTP,lNet,
 lNetSSL,msethreadcomp;

type
 tmainfo = class(tmseform)
   tgroupbox1: tgroupbox;
   appMainMenu: tmainmenu;
   tgroupbox2: tgroupbox;
   memoText: tmemoedit;
   openDlg: tfiledialog;
   timerQuit: ttimer;
   statusBar: tlabel;
   smptSendProgress: tprogressbar;
   btnSend: tbutton;
   emailFrom: tstringedit;
   emailTo: tstringedit;
   emailSubject: tstringedit;
   smtpServer: tstringedit;
   smtpPort: tintegeredit;
   btnConnect: tbutton;
   btnAuth: tbutton;
   popupAttachments: tpopupmenu;
   gridAttach: tstringgrid;
   connThread: tthreadcomp;
   useSSL: tbooleanedit;
   btnTLS: tbutton;
   procedure exitApp(const sender: TObject);
   procedure showAbout(const sender: TObject);
   procedure showLogFeatures(const sender: TObject);
   procedure doTimerQuit(const sender: TObject);
   
   procedure doInit(const sender: TObject);
   procedure doFinish(const sender: TObject);
   procedure SMTPError(const msg: string; aSocket: TLSocket);
   procedure SMTPConnect(aSocket: TLSocket);
   procedure SMTPDisconnect(aSocket: TLSocket);
   procedure SMTPSent(aSocket: TLSocket; const Bytes: Integer);
   procedure SMTPFailure(aSocket: TLSocket;
  		const aStatus: TLSMTPStatus);
   procedure SMTPReceive(aSocket: TLSocket);
   procedure SMTPSuccess(aSocket: TLSocket;
  		const aStatus: TLSMTPStatus);
   procedure RefreshFeatureList;
   procedure SSLSessionSSLConnect(aSocket: TLSocket);
  
   procedure doConnect(const sender: TObject);
   procedure doAuth(const sender: TObject);
   procedure doSendMail(const sender: TObject);
   procedure doAddAttachments(const sender: TObject);
   procedure doDelAttachements(const sender: TObject);
   procedure mangeConn(const sender: tthreadcomp);
   procedure checkForClose(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure startTLS(const sender: TObject);
   procedure checkSSL(const sender: TObject);
   protected
   
    SMTP : TLSMTPClient;
    SSLSession: TLSSLSession;
    FDataSent: Int64;
    FDataSize: Int64;
    FMimeStream: TMimeStream;
    FQuit: Boolean; // to see if we force quitting
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm, authenticate, logfeatures, sysutils;
 
procedure tmainfo.exitApp(const sender: TObject);
begin
	close;
end;

procedure tmainfo.showAbout(const sender: TObject);
begin
end;

procedure tmainfo.showLogFeatures(const sender: TObject);
begin
	logfeaturesfo.Activate;
end;

procedure tmainfo.doTimerQuit(const sender: TObject);
begin
  FQuit := True;
  Close;
end;

procedure tmainfo.SMTPConnect(aSocket: TLSocket);
begin
  statusBar.caption := 'Connected to server...';
  logfeaturesfo.MemoLogs.editor.inserttext(statusBar.caption);
  btnSend.Enabled := SMTP.Connected;
  btnConnect.Caption := 'Disconnect';
end;

procedure tmainfo.SMTPDisconnect(aSocket: TLSocket);
begin
  btnAuth.Visible := False;
  //ButtonTLS.Visible := False;
  statusBar.caption := 'Disconnected from server';
  logfeaturesfo.MemoLogs.editor.inserttext(statusBar.caption);
  btnSend.Enabled := SMTP.Connected;
  btnConnect.Caption := 'Connect';
end;

procedure tmainfo.SMTPError(const msg: string; aSocket: TLSocket);
begin
  SMTPDisconnect(nil);
  statusBar.caption := msg;
  logfeaturesfo.MemoLogs.editor.inserttext(msg);
  //logfeaturesfo.MemoLogs.Text := logfeaturesfo.MemoLogs.Text + msg;
end;

procedure tmainfo.doInit(const sender: TObject);
begin
	application.createform(tauthenticatefo,authenticatefo);
	application.createform(tlogfeaturesfo,logfeaturesfo);
	SSLSession := TLSSLSession.Create(self);
	SSLSession.OnSSLConnect := @SSLSessionSSLConnect;
	SSLSession.SSLActive := False;
	SMTP := TLSMTPClient.Create(self);
	SMTP.StatusSet := [ssCon, ssEhlo, ssAuthLogin, ssAuthPlain, ssData, ssQuit];
	SMTP.Session := SSLSession;
	SMTP.OnConnect := @SMTPConnect;
	SMTP.OnDisConnect := @SMTPDisConnect;
	SMTP.OnError := @SMTPError;
	SMTP.OnFailure := @SMTPFailure;
	SMTP.OnReceive := @SMTPReceive;
	SMTP.OnSent := @SMTPSent;
	SMTP.OnSuccess := @SMTPSuccess;
	SMTP.Timeout := 100;
	FMimeStream := TMimeStream.Create;
	FMimeStream.AddTextSection(''); // for the memo
	FQuit := False;
end;

procedure tmainfo.doFinish(const sender: TObject);
begin
	FQuit := True;
	connThread.Active := False;
    FMimeStream.Free;
end;

procedure tmainfo.doConnect(const sender: TObject);
begin
  if (not SMTP.Connected) and (btnConnect.Caption = 'Connect') then begin
  	//writeln(smtpServer.value,':',smtpPort.value);
   	FQuit := False;
    connThread.Active := True;
    SMTP.Connect(smtpServer.value, smtpPort.value);
    btnConnect.Caption := 'Connecting';
    statusBar.caption := 'Connecting...';
  end else if btnConnect.Caption = 'Connecting' then begin
    SMTP.Disconnect;
    btnConnect.Caption := 'Connect';
    statusBar.caption := 'Aborted connect!';
    FQuit := True;
  end else
    SMTP.Quit; // server will respond and we'll make a clean disconnect (see SMTP rfc)
end;

procedure tmainfo.doAuth(const sender: TObject);
var
  aName, aPass: string;
begin
	if authenticatefo.Show(true) = mr_Ok then
	begin
		aName := authenticatefo.loginName.value;
		aPass := authenticatefo.loginPassword.value;
		if SMTP.HasFeature('AUTH LOGIN') then // use login if possible
			SMTP.AuthLogin(aName, aPass)
		else if SMTP.HasFeature('AUTH PLAIN') then // fall back to plain if possible
			SMTP.AuthPlain(aName, aPass);
	end;
end;

procedure tmainfo.doSendMail(const sender: TObject);
begin
  if Length(emailFrom.Text) < 6 then
    statusBar.caption := '"Mail from" info is missing or irrelevant'
  else if Length(emailTo.Text) < 6 then
    statusBar.caption := '"Mail to" info is missing or irrelevant'
  else begin
    FMimeStream.Reset; // make sure we can read it again
    TMimeTextSection(FMimeStream[0]).Text := MemoText.Text; // change to text

    smptSendProgress.value := 0;
    FDataSent := 0;
    FDataSize := FMimeStream.Size; // get size to send
    
    SMTP.SendMail(emailFrom.Text, emailTo.Text, emailSubject.Text, FMimeStream); // send the stream
  end;
end;

procedure tmainfo.SMTPSent(aSocket: TLSocket; const Bytes: Integer);
begin
  FDataSent := FDataSent + Bytes;
  
  smptSendProgress.value := Round((FDataSent / FDataSize) * 100);
end;

procedure tmainfo.SMTPFailure(aSocket: TLSocket;
  const aStatus: TLSMTPStatus);
begin
  case aStatus of
    ssCon,
    ssEhlo: RefreshFeatureList;
    ssData: begin
              ShowMessage('Error sending message');
              SMTP.Rset;
            end;
    ssQuit: begin
              SMTP.Disconnect;
              Close;
            end;
  end;
end;

procedure tmainfo.SMTPReceive(aSocket: TLSocket);
var
  s, st: string;
begin
  if SMTP.GetMessage(s) > 0 then begin
    st := StringReplace(s, #13, '', [rfReplaceAll]);
    st := StringReplace(st, #10, '', [rfReplaceAll]);
    statusBar.caption := st;
    logfeaturesfo.MemoLogs.editor.inserttext(s);
  end;
end;

procedure tmainfo.doAddAttachments(const sender: TObject);
begin
  if openDlg.Execute = mr_Ok then
    if FileExists(openDlg.controller.FileName) then begin
      FMimeStream.AddFileSection(openDlg.controller.FileName);
      gridAttach.appendrow(ExtractFileName(openDlg.controller.FileName));
    end;
end;

procedure tmainfo.doDelAttachements(const sender: TObject);
begin
  if  (gridAttach.row >= 0)
  and (gridAttach.row < FMimeStream.Count - 1) then begin
    FMimeStream.Delete(gridAttach.row + 1); // 0th is the text of memo
    gridAttach.deleterow(gridAttach.row);
  end;
end;

procedure tmainfo.SMTPSuccess(aSocket: TLSocket;
  const aStatus: TLSMTPStatus);
begin
  case aStatus of
    ssCon : begin
              if SMTP.HasFeature('EHLO') then // check for EHLO support
                SMTP.Ehlo(smtpServer.value)
              else
                SMTP.Helo(smtpServer.value);
            end;
    ssEhlo: RefreshFeatureList;
    
    ssAuthLogin,
    ssAuthPlain : btnAuth.Visible := False;

    ssData: ShowMessage('Message sent successfuly');
    ssQuit: begin
              SMTP.Disconnect;
              if timerQuit.Enabled then Close;
            end;
  end;
end;

procedure tmainfo.RefreshFeatureList;
begin
  with logfeaturesfo do begin
    gridFeatures.Clear;
    //gridFeatures[0].datalist.assign(SMTP.FeatureList);
  end;
  //btnTLS.Visible := SMTP.HasFeature('STARTTLS');
  btnAuth.Visible := SMTP.HasFeature('AUTH PLAIN') or SMTP.HasFeature('AUTH LOGIN');
end;

procedure tmainfo.SSLSessionSSLConnect(aSocket: TLSocket);
begin
  statusBar.caption := 'TLS handshake complete';
  logfeaturesfo.MemoLogs.editor.inserttext(statusBar.caption);
  { re-ehlo to get new feature list, do this here, not on SMTPSuccess because
    handshake can take time and while it's in progress, sending of any data
    including SMTP commands is going to fail and disconnect us! }
  SMTP.Ehlo;
end;

procedure tmainfo.mangeConn(const sender: tthreadcomp);
begin
	while not FQuit do begin
		SMTP.CallAction;
	end;
end;

procedure tmainfo.checkForClose(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
  if not FQuit and SMTP.Connected then begin
    amodalresult := mr_Cancel; // make sure we quit gracefuly
    SMTP.Quit; // the quit success/failure CBs will close our form
    timerQuit.Enabled := True; // if this runs out, quit ungracefully
  end;
end;

procedure tmainfo.startTLS(const sender: TObject);
begin
	SMTP.StartTLS;
end;

procedure tmainfo.checkSSL(const sender: TObject);
begin
  SSLSession.SSLActive := useSSL.value;
  if useSSL.value then begin
    if smtpPort.value = 25 then
      smtpPort.value := 465;
  end else begin
    if smtpPort.value = 465 then
      smtpPort.value := 25;
  end;
end;

end.
