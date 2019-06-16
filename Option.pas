unit Option;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls;

type
  TOptions = class(TForm)
    bgOptions: TImage;
    btSound: TButton;
    btAbout: TButton;
    btRules: TButton;
    procedure FormShow(Sender: TObject);
    procedure btSoundClick(Sender: TObject);
    procedure btAboutClick(Sender: TObject);
    procedure btRulesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Options: TOptions;
  SoundOn: Boolean = False;

implementation

{$R *.dfm}

uses Menu, AboutDevTeam, Rule;

procedure TOptions.btAboutClick(Sender: TObject);
begin
   AboutDev.ShowModal;
end;

procedure TOptions.btRulesClick(Sender: TObject);
begin
   Rules.ShowModal;
end;

procedure TOptions.btSoundClick(Sender: TObject);
begin
   SoundOn := not SoundOn;
   if (SoundOn) then
   begin
      btSound.Caption := 'Sound (On)'
   end
   else
   begin
      btSound.Caption := 'Sound (Off)'
   end;
end;

procedure TOptions.FormShow(Sender: TObject);
const
   btLeft = 30;
begin
   btSound.Top := 40;
   btSound.Left := btLeft;

   btAbout.Left := btLeft;
   btAbout.Top := btSound.Top + btSound.Height + 15;

   btRules.Left := btLeft;
   btRules.Top := btAbout.Top + btAbout.Height + 15;

   if (SoundOn) then
   begin
      btSound.Caption := 'Sound (On)'
   end
   else
   begin
      btSound.Caption := 'Sound (Off)'
   end;
end;

end.
