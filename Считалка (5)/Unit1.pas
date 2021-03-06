unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  chain = ^elem;

  elem = record
    name: string;
    link: chain;
  end;

  TForm1 = class(TForm)
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    Button3: TButton;
    ListBox3: TListBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure chainCycle;
    procedure delElem;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  s: string;
  currentWord, wordCount, currentUser: byte;
  p, q: chain;
  n: integer;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  f: textFile;
  i: Integer;
begin
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName + '/res/lists');
  if OpenDialog1.execute then
  begin
    listBox1.Clear;
    n := 0;
    assignFile(f, OpenDialog1.FileName);
    reset(f);
    new(p);
    new(q);
    q := p;
    while not eof(f) do
    begin
      readln(f, q^.name);
      new(q^.link);
      q := q^.link;
      inc(n);
    end;

    q := p;
    for i := 1 to n do
    begin
      listBox1.Items.Add(IntToStr(i) + ') ' + q^.name);
      q := q^.link;
      if i=n then
        q^.link := nil;
    end;

    closeFile(f);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  f: textFile;
  str: string;
  symbol: string;
  wordArr: array[1..100] of string;
  i, j: byte;
begin
  OpenDialog2.InitialDir := ExtractFilePath(Application.ExeName + '/res/countings');
  if OpenDialog2.Execute then
  begin
    assignFile(f, OpenDialog2.FileName);
    reset(f);
    s := '';
    while not eof(f) do
    begin
      readln(f, str);
      s := s+str;
    end;
    closeFile(f);

    j := 1;
    wordCount := 0;
    while s.Length>0 do
    begin
      symbol := '';
      i := 1;
      while (s[i]<>' ') and (i<=s.Length) do
      begin
        symbol := symbol +  s[i];
        inc(i);
      end;
      delete(s, 1, i);
      inc(wordCount);
      listBox2.Items.Add(IntToStr(j) + ') ' +symbol);
      inc(j);
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  currentWord := 0;
  currentUser := 0;
  q := p;
  Timer1.Enabled := true;
end;

procedure TForm1.chainCycle;
begin
  if q^.link = nil then
  begin
    q := p;
    currentUser := 1;
//    ListBox1.ItemIndex := 0;
//    dec(currentWord);
  end
  else
    q := q^.link;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if currentWord>=wordCount then
  begin
    Timer1.Enabled := false;
    delElem();
  end
  else
  begin
    ListBox2.ItemIndex := currentWord;
    ListBox1.ItemIndex := currentUser;
    inc(currentWord);
    inc(currentUser);
    chainCycle();
  end;
end;

procedure TForm1.delElem;
var
  i: Integer;
  d: chain;
begin
  q := p;
  dec(n);
  if currentUser=1 then
  begin
    d := p;
    if d^.link = nil then
     showMessage('vse')
    else
    begin
      p := p^.link;
      listBox3.Items.Add(d^.name);
      dispose(d);
    end;
  end
  else
  begin
    for i := 1 to currentUser-2 do
      q := q^.link;

    d := q^.link;
    listBox3.Items.Add(d^.name);
    q^.link := q^.link^.link;
    dispose(d);
  end;

  listBox1.Clear;
  q := p;
  for i := 1 to n do
  begin
    listBox1.Items.Add(IntToStr(i) + ') ' + q^.name);
    q := q^.link;
    if i=n then
      q^.link := nil;
  end;
end;

end.
