program Game2048;



{$R *.dres}

uses
  Vcl.Forms,
  Menu in 'Menu.pas' {MainMenu},
  Vcl.Themes,
  Vcl.Styles,
  Game in 'Game.pas' {GameMode},
  RecordsMenu in 'RecordsMenu.pas' {Records},
  NewWinner in 'NewWinner.pas' {NewRecord},
  Confirm in 'Confirm.pas' {ConfirmationForm},
  AboutDevTeam in 'AboutDevTeam.pas' {AboutDev},
  Option in 'Option.pas' {Options},
  Rule in 'Rule.pas' {Rules};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainMenu, MainMenu);
  Application.CreateForm(TGameMode, GameMode);
  Application.CreateForm(TRecords, Records);
  Application.CreateForm(TNewRecord, NewRecord);
  Application.CreateForm(TConfirmationForm, ConfirmationForm);
  Application.CreateForm(TAboutDev, AboutDev);
  Application.CreateForm(TOptions, Options);
  Application.CreateForm(TRules, Rules);
  Application.Run;
end.
