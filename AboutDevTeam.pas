unit AboutDevTeam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.MPlayer;

type
  TAboutDev = class(TForm)
    BackGround: TImage;
    MainTimer: TTimer;
    MainInfo: TLabel;
    bgMusic: TMediaPlayer;
    procedure FormShow(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutDev: TAboutDev;
  ShiftToTop: Double = 400;
  CorrectFile: Boolean;

implementation

{$R *.dfm}

uses Menu, Option;

procedure TAboutDev.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if (CorrectFile) then
   begin
      bgMusic.Stop;
      bgMusic.Close;
   end;
end;

procedure TAboutDev.FormShow(Sender: TObject);
const
   Error = ' AudioFile not found';
   Information = 'In a distant galaxy a war broke out for the best design' + #13#10 +
    'of the game 2048. In 2019, the development team from the' + #13#10 +
    'group 851001, headed by Stanislav Elovsky, decided to go '+ #13#10 +
    'to bed for this war once and for all. This is how the' + #13#10 +
    '"2048 Stars" software appeared.'+ #13#10 + #13#10 +

    'Development team:' + #13#10 +
    'Team Leader - Elovsky Stanislav  ' + #13#10 +
    'Chief Designer - Elovsky Stanislav ' + #13#10 +
    'Chief Programmer - Elovsky Stanislav' + #13#10 +
    'Creative Director - Elovsky Stanislav  ' + #13#10 + #13#10 +

    'Testing team:' + #13#10 +
    'Chief Tester - Zabenko Tamara' + #13#10 +
    'Thank you for your attention to this program.';
begin
   ShiftToTop := 400;
   MainInfo.Top := Round(ShiftToTop);
   MainInfo.Left := 60;
   MainInfo.Width := 580;
   MainInfo.Caption := Information;
   MainTimer.Enabled := True;
   try
      CorrectFile := True;
      bgMusic.FileName := 'starwars.mp3';
      bgMusic.Open;
   Except
      on E: Exception do
      begin
         CorrectFile := False;
         MessageDlg(Error ,mtError, [mbOk], 0);
      end;
   end;
   if (SoundOn) and CorrectFile then
   begin
      bgMusic.Play;
   end;
end;

procedure TAboutDev.MainTimerTimer(Sender: TObject);
const
   TopBorder = 700;
begin
   ShiftToTop := ShiftToTop - 0.3;
   MainInfo.Top := Round(ShiftToTop);
   if (MainInfo.Top + TopBorder = 0) then
   begin
      MainTimer.Enabled := False;
      close;
   end;
end;

end.
