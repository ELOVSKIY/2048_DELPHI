unit Rule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TRules = class(TForm)
    bgRules: TImage;
    Title: TLabel;
    Description: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Rules: TRules;

implementation

{$R *.dfm}

uses Option;

procedure TRules.FormShow(Sender: TObject);
const
   Rules = 'Use the keyboard arrows to move the tiles on the game board.'+
      ' Tiles with the same numbers are glued together if there are no ' +
      'obstacles between them. Your task is to break the record of the ' +
      'previous player or win, getting a tile with the number 2048.';
begin
   Description.Width := Width - 50;
   Description.Caption := Rules;
end;

end.
