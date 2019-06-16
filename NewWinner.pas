unit NewWinner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TNewRecord = class(TForm)
    BackgroundImage: TImage;
    pncCongratulate: TFlowPanel;
    NickEdit: TEdit;
    btConfirm: TButton;
    procedure btConfirmClick(Sender: TObject);
    procedure NickEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewRecord: TNewRecord;


implementation

{$R *.dfm}

uses RecordsMenu, Menu, Game;

procedure TNewRecord.btConfirmClick(Sender: TObject);
const
   EmptyEdit = 'Sorry, but the nickname must consist of at least one character.';
begin
   if (Length(NickEdit.Text) <> 0) then
   begin
      RecordsList[GameSize].Score := Score;
      RecordsList[GameSize].NickName := NickEdit.Text;
      Close;
   end
   else
   begin
      MessageDlg(EmptyEdit, mtError, [mbOk], 0);
   end;
end;

procedure TNewRecord.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   NickEdit.Text := '';
end;

procedure TNewRecord.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_ESCAPE) then
      Close;
end;

procedure TNewRecord.NickEditKeyPress(Sender: TObject; var Key: Char);
const
   TooLargeNick = 'Sorry, but the nickname should consist of no more than 15 characters.';
begin
   if (Key = #13) then
   begin
      btConfirm.OnClick(Sender);
   end
   else
   begin
      if (Length(NickEdit.Text) = 15) and (Key <> #8) then
      begin
         MessageDlg(TooLargeNick, mtError, [mbOk], 0);
      end;
   end;

end;

end.
