unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ButtonGroup;

type
  TMainMenu = class(TForm)
    BackgroundImage: TImage;
    btGame4x4: TButton;
    btGame5x5: TButton;
    btRecords: TButton;
    GameLabel: TFlowPanel;
    btExit: TButton;
    btGame3x3: TButton;
    btOptions: TButton;
    procedure btExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btGame5x5Click(Sender: TObject);
    procedure btGame4x4Click(Sender: TObject);
    procedure btGame3x3Click(Sender: TObject);
    procedure btRecordsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btOptionsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainMenu: TMainMenu;
  GameSize: Byte = 5;

implementation

{$R *.dfm}

uses Game, RecordsMenu, Confirm, AboutDevTeam, Option, NewWinner;

function Confirmation(cfMessage: String): Boolean;
begin
   ConfirmMess := cfMessage;
   ConfirmationForm.ShowModal;
   Result := StateFlag;
end;


procedure TMainMenu.btExitClick(Sender: TObject);
begin
   Close;
end;

procedure TMainMenu.btGame3x3Click(Sender: TObject);
begin
   GameSize := 3;
   Hide;
   SetWindowLong(GameMode.Handle, GWL_EXSTYLE,
      GetWindowLong(GameMode.Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
   GameMode.showmodal;
end;

procedure TMainMenu.btGame4x4Click(Sender: TObject);
begin
   GameSize := 4;
   Hide;
   SetWindowLong(GameMode.Handle, GWL_EXSTYLE,
      GetWindowLong(GameMode.Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
   GameMode.showmodal;
end;

procedure TMainMenu.btGame5x5Click(Sender: TObject);
begin
   GameSize := 5;
   Hide;
   SetWindowLong(GameMode.Handle, GWL_EXSTYLE,
      GetWindowLong(GameMode.Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
   GameMode.showmodal;
end;

procedure TMainMenu.btOptionsClick(Sender: TObject);
begin
   Options.ShowModal;
end;

procedure TMainMenu.btRecordsClick(Sender: TObject);
begin
   SetWindowLong(GameMode.Handle, GWL_EXSTYLE,
      GetWindowLong(GameMode.Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
   Records.showmodal;
end;

procedure TMainMenu.FormClose(Sender: TObject; var Action: TCloseAction);
const
   FileName = 'HighScores.rcd';
   AccessError = 'Failed to load the table with records!';
var
   RecordsFile: File of tRecordsList;
begin
   try
      AssignFile(RecordsFile, FileName);
      Rewrite(RecordsFile);
      Write(RecordsFile, RecordsList);
      CloseFile(RecordsFile);
   except
      MessageDlg(AccessError, mtError, [mbRetry], 0);
   end;
end;

procedure TMainMenu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
const
   AreSure = 'Are you sure you want to quit?';
begin
   CanClose := Confirmation(AreSure);
end;

end.
