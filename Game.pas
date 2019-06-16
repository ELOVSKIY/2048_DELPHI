unit Game;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.ColorGrd, Vcl.Imaging.pngimage, Vcl.ComCtrls,
  Vcl.ExtDlgs, Math, Vcl.Buttons, Vcl.MPlayer;

type
    WordMatrix =  array of array of Word;
    TGameMode = class(TForm)
    BackgroundImage: TImage;
    pnlScore: TFlowPanel;
    GameField: TDrawGrid;
    pnlNumberScore: TFlowPanel;
    btNewGame: TSpeedButton;
    btMoveBack: TSpeedButton;
    Player: TMediaPlayer;
    btOptions: TSpeedButton;
    procedure DrawGrid(Sender: TObject);
    procedure btMoveBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClearGrid(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btNewGameClick(Sender: TObject);
    procedure GameFieldKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btOptionsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   GameMode: TGameMode;
   Cells, Memory: WordMatrix;
   ScoreMemory, Score: Integer;
   GameStart, CorrectFile: Boolean;

implementation

{$R *.dfm}

uses Menu, NewWinner, RecordsMenu, Confirm, Option;

function Confirmation(cfMessage: String): Boolean;
begin
   ConfirmMess := cfMessage;
   ConfirmationForm.ShowModal;
   Result := StateFlag;
end;

function MemoryMove(Cells: WordMatrix): WordMatrix;
var
   I, J: Byte;
   Memory: WordMatrix;
begin
   SetLength(Memory, Length(Cells), Length(Cells));
   for I := 0 to High(Cells) do
      for J := 0 to High(Cells) do
         Memory[I][J] := Cells[I][J];
   MemoryMove := Memory;
end;

procedure ClearCells();
var
   I, J: Byte;
begin
   for I := 0 to High(Cells) do
      for J := 0 to High(Cells) do
         Cells[I][J] := 0;
end;

procedure GenerateNumber();
var
   I, R, J, Counter, Position: Byte;
begin
   Randomize;
   Counter := 0;
   if (Random(10) = 0) then R := 4 else R := 2;
   for I := 0 to High(Cells) do
   begin
      for J := 0 to High(Cells) do
      begin
         if (Cells[I][J] = 0) then
            Inc(Counter);
      end;
   end;
   Counter  := Random(Counter);
   for I := 0 to High(Cells) do
   begin
      for J := 0 to High(Cells) do
      begin
         if (Cells[I][J] = 0) then
         begin
            if (Counter =  0)  then
               Cells[I][J] := R;
            Dec(Counter);
         end;
      end;
   end;
end;

function CanMove(): Boolean;
var
   I, J: ShortInt;
   Move: Boolean;
begin
   {$B-}
   Move := False;
   for I := 0 to High(Cells) do
   begin
      for J := 0 to High(Cells) do
      begin
         if (not Move) then
         begin
            if((Cells[I][J] = 0) or ((J <> 0) and (Cells[I][J] = Cells[I][J - 1]))) then
               Move := True;
         end;
      end;
   end;
   for J := 0 to High(Cells) do
   begin
      for I := 0 to High(Cells) do
      begin
         if (not Move) then
         begin
            if((Cells[I][J] = 0) or ((I <> 0) and (Cells[I][J] = Cells[I - 1][J]))) then
               Move := True;
         end;
      end;
   end;
   Result := Move;
end;

procedure Swap(var A, B: Word);
var
   Temp: Word;
begin
   Temp := A;
   A := B;
   B := Temp;
end;

procedure ShiftToRight(I: ShortInt);
var
   J, K: ShortInt;
begin
   for K := High(Cells) - 1 Downto 0 do
   begin
      J := K;
      if(Cells[I][J] <> 0) then
      begin
         while((J < High(Cells)) and (Cells[I][J + 1] = 0)) do
         begin
            Swap(Cells[I][J], Cells[I][J + 1]);
            Inc(J)
         end;
      end;
   end;
end;

procedure ShiftToBotton(J: ShortInt);
var
   I, K: ShortInt;
begin
   for K := High(Cells) Downto 0 do
   begin
      I := K;
      if(Cells[I][J] <> 0) then
      begin
         while((I < High(Cells)) and (Cells[I + 1][J] = 0)) do
         begin
            Swap(Cells[I][J], Cells[I + 1][J]);
            Inc(I);
         end;
      end;
   end;
end;

procedure ShiftToLeft(I: ShortInt);
var
   J, K: ShortInt;
begin
   for K := 1 to High(Cells) do
   begin
      J := K;
      if(Cells[I][J] <> 0) then
      begin
         while((J > 0) and (Cells[I][J - 1] = 0)) do
         begin
            Swap(Cells[I][J], Cells[I][J - 1]);
            Dec(J)
         end;
      end;
   end;
end;

procedure ShiftToTop(J: ShortInt);
var
   I, K: ShortInt;
begin
   for K := 1 to High(Cells) do
   begin
      I := K;
      if(Cells[I][J] <> 0) then
      begin
         while((I > 0) and (Cells[I - 1][J] = 0)) do
         begin
            Swap(Cells[I][J], Cells[I - 1][J]);
            Dec(I)
         end;
      end;
   end;
end;

procedure MoveRight();
var
   I, J: ShortInt;
   Move: Boolean;
begin
   Move := False;
   for I := 0 to High(Cells) do
   begin
      if(not Move) then
      begin
         J := 0;
         while ((J <= High(Cells)) and (Cells[I][J] = 0)) do
            Inc(J);
         while(J <= High(Cells)) do
         begin
            if((Cells[I][J] = 0) or ((J <> 0) and (Cells[I][J] = Cells[I][J - 1]))) then
               Move := True;
            Inc(J);
         end;
      end;
   end;
   if Move then
   begin
      ScoreMemory := Score;
      Memory := MemoryMove(Cells);
      for I := 0 to High(Cells) do
      begin
         ShiftToRight(I);
         for J := High(Cells) downto 1 do
            if (Cells[I][J] = Cells[I][J - 1]) and (Cells[I][J] <> 0) then
            begin
               Cells[I][J] := Cells[I][J] * 2;
               Inc(Score, Cells[I][J]);
               Cells[I][J - 1] := 0;
            end;
         ShiftToRight(I);
      end;
      GenerateNumber;
   end;
end;

procedure MoveBottom();
var
   I, J: ShortInt;
   Move: Boolean;
begin
   Move := False;
   for J := 0 to High(Cells) do
   begin
      if(not Move) then
      begin
         I := 0;
         while ((I < High(Cells)) and (Cells[I][J] = 0)) do
            Inc(I);
         while(I <= High(Cells)) do
         begin
            if((Cells[I][J] = 0) or ((I <> 0) and (Cells[I][J] = Cells[I - 1][J]))) then
               Move := True;
            Inc(I);
         end;
      end;
   end;
   if Move then
   begin
      ScoreMemory := Score;
      Memory := MemoryMove(Cells);
      for J := 0 to High(Cells) do
      begin
         ShiftToBotton(J);
         for I := High(Cells) downto 1 do
            if (Cells[I][J] = Cells[I - 1][J]) and (Cells[I][J] <> 0) then
            begin
               Cells[I][J] := Cells[I][J] * 2;
               Inc(Score, Cells[I][J]);
               Cells[I - 1][J] := 0
            end;
         ShiftToBotton(J);
      end;
      GenerateNumber;
   end;
end;

procedure MoveTop();
var
   I, J: ShortInt;
   Move: Boolean;
begin
   Move := False;
   for J := 0 to High(Cells) do
   begin
      if (not Move) then
      begin
         I := High(Cells);
         while ((I > 0) and (Cells[I][J] = 0)) do
            Dec(I);
         while(I >= 0) do
         begin
            if((Cells[I][J] = 0) or ((I <> High(Cells)) and (Cells[I][J] = Cells[I + 1][J]))) then
               Move := True;
            Dec(I);
         end;
      end;
   end;

   if Move then
   begin
      ScoreMemory := Score;
      Memory := MemoryMove(Cells);
      for J := 0 to High(Cells) do
      begin
         ShiftToTop(J);
         for I := 0 to High(Cells) - 1 do
            if (Cells[I][J] = Cells[I + 1][J]) and (Cells[I][J] <> 0) then
            begin
               Cells[I][J] := Cells[I][J] * 2;
               Inc(Score, Cells[I][J]);
               Cells[I + 1][J] := 0
            end;
         ShiftToTop(J);
      end;
      GenerateNumber;
   end;
end;

procedure MoveLeft();
var
   I, J: ShortInt;
   Move: Boolean;
begin
   Move := False;
   for I := 0 to High(Cells) do
   begin
      if (not Move) then
      begin
         J := High(Cells);
         while ((J > 0) and (Cells[I][J] = 0)) do
            Dec(J);
         while(J >= 0) do
         begin
            if((Cells[I][J] = 0) or ((J <> High(Cells)) and (Cells[I][J] = Cells[I][J + 1]))) then
               Move := True;
            Dec(J);
         end;
      end;
   end;
   if Move then
   begin
      ScoreMemory := Score;
      Memory := MemoryMove(Cells);
      for I := 0 to High(Cells) do
      begin
         ShiftToLeft(I);
         for J := 0 to High(Cells) - 1 do
            if (Cells[I][J] = Cells[I][J + 1]) and (Cells[I][J] <> 0) then
            begin
               Cells[I][J] := Cells[I][J] * 2;
               Inc(Score, Cells[I][J]);
               Cells[I][J + 1] := 0;
            end;
         ShiftToLeft(I);
      end;
      GenerateNumber;
   end;
end;

procedure TGameMode.btNewGameClick(Sender: TObject);
begin
   GameStart := True;
   Score := 0;
   ClearCells();
   Memory := MemoryMove(Cells);
   GenerateNumber;
   GenerateNumber;
   btMoveBack.Enabled := False;
   DrawGrid(Sender);
end;

procedure TGameMode.btOptionsClick(Sender: TObject);
begin
   Player.Stop;
   Options.ShowModal;
   if (SoundOn) and CorrectFile then
   begin
      Player.Play;
   end
end;

procedure TGameMode.DrawGrid(Sender: TObject);
const
   Prefix = 'Bitmap_';
var
   I, J, K, Temp: Word;
   Path: String;
   CellIcon: TBitmap;
begin
   CellIcon := TBitmap.Create;
   Temp := 1;
   ClearGrid(Sender);
   for K := 1 to 11 do
   begin
      Temp := Temp * 2;
      Path := Prefix + IntToStr(Temp);
      CellIcon.LoadFromResourceName(hInstance, Path);
      for I := 0 to High(Cells) do
      begin
         for J := 0 to High(Cells) do
         begin
            if (Cells[I][J] = Temp) then
            begin
               GameField.Canvas.StretchDraw(GameField.CellRect(J,I), CellIcon);
            end;
         end;
      end;
   end;
   pnlNumberScore.Caption := IntToStr(Score);
   btMoveBack.Enabled := True;
end;

procedure TGameMode.Cleargrid(Sender: Tobject);
var
   I, J: Word;
   CellIcon: TBitmap;
begin
   CellIcon := TBitmap.Create;
   CellIcon.LoadFromResourceName(hInstance, 'Bitmap_0');
      for I := 0 to High(Cells) do
         for J := 0 to High(Cells) do
               GameField.Canvas.StretchDraw(GameField.CellRect(J,I), CellIcon);
end;

procedure TGameMode.btMoveBackClick(Sender: TObject);
begin
   Cells := MemoryMove(Memory);
   Score := ScoreMemory;
   DrawGrid(Sender);
   btMoveBack.Enabled := False;
end;

procedure TGameMode.FormClose(Sender: TObject; var Action: TCloseAction);
const
   Confirm = 'Your result broke the record, do you want to record it?';
begin
   if (Score > RecordsList[GameSize].Score) then
   begin
      if (Confirmation(Confirm)) then
      begin
         NewRecord.ShowModal;
      end;
   end;
   if (CorrectFile) then
   begin
      Player.Stop;
      Player.Close;
   end;
   MainMenu.Show;
end;

procedure TGameMode.FormShow(Sender: TObject);
const
   SideSize = 64;
   Error = ' AudioFile not found';
var
   I: Byte;
begin
   Score := 0;
   btMoveBack.Enabled := False;
   SetLength(Cells, GameSize, GameSize);
   GameField.RowCount := GameSize;
   GameField.ColCount := GameSize;
   GameField.FixedCols := GameSize - 1;
   GameField.FixedRows := GameSize - 1;
   begin
      for I := 0 to GameField.RowCount - 1 do
      begin
         GameField.ColWidths[I] := SideSize;
         GameField.RowHeights[I] := SideSize;
      end;

      GameField.Height := SideSize * GameSize + 12;
      GameField.Width := SideSize * GameSize + 10;

      btNewGame.Left := GameField.Left + GameField.Width + 15;
      btMoveBack.Left := btNewGame.Left + btNewGame.Width + 20;
      btMoveBack.Top := GameField.Top + GameField.Height - btMoveBack.Height;
      btNewGame.Top := btMoveBack.Top;
      btOptions.Left := btNewGame.Left;
      btOptions.Top :=  btNewGame.Top - btOptions.Height - 15;

      pnlScore.Left := btNewgame.Left;
      pnlScore.Width := btNewGame.Width + 10;
      pnlNumberScore.Left := btMoveBack.Left - 10;
      pnlNumberScore.Width := btMoveBack.Width + 10;

      GameMode.Height := GameField.Top + GameField.Height + 80;
      GameMode.Width := btMoveBack.Left + btMoveBack.Width + 80;
   end;

   begin
      begin
         try
            CorrectFile := True;
            Player.FileName := 'dancing.mp3';
            Player.Open;
         Except
            on E: Exception do
            begin
               CorrectFile := False;
               MessageDlg(Error ,mtError, [mbOk], 0);
            end;
         end;
      end;
      if (SoundOn) and CorrectFile then
      begin
         Player.Play;
      end
      else
      begin
         Player.Stop;
      end;
   end;
end;

procedure TGameMode.GameFieldKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
   GameOver = 'It was a great game, do you wanna restart it?';
begin
   if GameStart then
   begin
      if CanMove then
      begin
         if (Key = VK_DOWN) then
         begin
            MoveBottom;
            DrawGrid(Sender);
         end;
         if (Key = VK_LEFT) then
         begin
            MoveLeft;
            DrawGrid(Sender);
         end;
         if (Key = VK_UP) then
         begin
            MoveTop;
            DrawGrid(Sender);
         end;
         if (Key = VK_RIGHT) then
         begin
            MoveRight;
            DrawGrid(Sender);
         end;
      end;
      if (not CanMove) then
      begin
         if (Score > RecordsList[GameSize].Score) then
         begin
            NewRecord.ShowModal;
         end;
         if (Confirmation(GameOver)) then
         begin
            btNewGameClick(Sender);
         end
         else
         begin
            Close;
         end;
      end;
   end;
end;


end.
