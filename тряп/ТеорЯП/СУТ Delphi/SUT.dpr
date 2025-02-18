program SUT;

uses
  Forms,
  MainSUT in 'MainSUT.pas' {frmMainSUT};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SUT';
  Application.CreateForm(TfrmMainSUT, frmMainSUT);
  Application.Run;
end.
