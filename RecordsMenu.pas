unit RecordsMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
   HighScore = Record
      NickName: String[15];
      Score: Integer;
   end;
  tRecordsList = array[3..5] of HighScore;
  TRecords = class(TForm)
    BackgroundImage: TImage;
    pnlNick: TFlowPanel;
    pnlScore: TFlowPanel;
    mplMode: TFlowPanel;
    pnlMode4x4: TFlowPanel;
    pnlMode5x5: TFlowPanel;
    pnlNick3x3: TFlowPanel;
    pnlNick4x4: TFlowPanel;
    pnlNick5x5: TFlowPanel;
    pnlScore3x3: TFlowPanel;
    pnlScore4x4: TFlowPanel;
    pnlScore5x5: TFlowPanel;
    pnlMode3x3: TFlowPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Records: TRecords;
  RecordsList: tRecordsList;

implementation

{$R *.dfm}

uses Menu;

procedure TRecords.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   MainMenu.Show;
end;

procedure TRecords.FormCreate(Sender: TObject);
const
   FileName = 'HighScores.rcd';
   AccessError = 'Failed to load the table with records!';
var
   RecordsFile: File of tRecordsList;
   NewUser: Boolean;
   I: Byte;
begin
   NewUser := False;
   try
      if (FileExists(FileName)) then
      begin
          AssignFile(RecordsFile, FileName);
          Reset(RecordsFile);
          Read(RecordsFile, RecordsList);
          CloseFile(RecordsFile);
      end
      else
      begin
         NewUser := True;
      end
   except
      MessageDlg(AccessError, mtError, [mbRetry], 0);
      NewUSer := True;
   end;
   if (NewUser) then
   begin
      for I := 3 to 5 do
      begin
         RecordsList[I].Score := 0;
      end;
   end;
end;

procedure TRecords.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_ESCAPE) then
      Close;
end;

procedure TRecords.FormShow(Sender: TObject);
begin
   if (RecordsList[3].Score <> 0) then
   begin
      pnlNick3x3.Caption := RecordsList[3].NickName;
      pnlScore3x3.Caption := IntToStr(RecordsList[3].Score);
   end;
   if (RecordsList[4].Score <> 0) then
   begin
      pnlNick4x4.Caption := RecordsList[4].NickName;
      pnlScore4x4.Caption := IntToStr(RecordsList[4].Score);
   end;
   if (RecordsList[5].Score <> 0) then
   begin
      pnlNick5x5.Caption := RecordsList[5].NickName;
      pnlScore5x5.Caption := IntToStr(RecordsList[5].Score);
   end;
end;

end.
