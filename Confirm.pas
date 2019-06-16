unit Confirm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg;

type
  TConfirmationForm = class(TForm)
    BackGround: TImage;
    btYes: TButton;
    btNo: TButton;
    Information: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btYesClick(Sender: TObject);
    procedure btNoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfirmationForm: TConfirmationForm;
  StateFlag: Boolean;
  ConfirmMess: String;

implementation

{$R *.dfm}

uses Game, Menu;

procedure TConfirmationForm.btNoClick(Sender: TObject);
begin
   Close;
end;

procedure TConfirmationForm.btYesClick(Sender: TObject);
begin
   StateFlag := True;
   Close;
end;

procedure TConfirmationForm.FormShow(Sender: TObject);
begin
   StateFlag := False;
   Information.Width := 320;
   Information.Caption := ConfirmMess;
end;

end.
