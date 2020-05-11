unit Test.EqualSpan;

interface

uses
  Generics.Collections, Generics.Defaults,
  DUnitX.TestFramework,
  EqualSpan;

type
  TItem = Char;
  TItemList = TList<TItem>;

  TSpan = record
    Start: Integer;
    Stop: Integer;
    constructor Create(Start, Stop: Integer);
  end;

  TSpanList = TList<TSpan>;

  [TestFixture]
  TTestEqualSpan = class(TObject)
  private
    List: TItemList;
    EqualSpan: TEqualSpan<Char>;
    Start, Stop: Integer;
    SpanList: TSpanList;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('0', ',')]
    [TestCase('1', 'a,')]
    [TestCase('2', 'aa,01')]
    [TestCase('3a', 'aab,01')]
    [TestCase('3b', 'abb,12')]
    [TestCase('3c', 'aaa,02')]
    [TestCase('3d', 'abc,')]
    [TestCase('4', 'abbc,12')]
    [TestCase('5', 'abbcc,1234')]
    [TestCase('6', 'abbcdd,1245')]
    [TestCase('7', 'abbcdde,1245')]
    [TestCase('8', 'abbcddee,124567')]
    procedure TestEqualSpan(const Input, Expected: string);
  end;

implementation

uses
  System.SysUtils;

procedure TTestEqualSpan.Setup;
begin
  List := TItemList.Create;
  SpanList := TSpanList.Create;
end;

procedure TTestEqualSpan.TearDown;
begin
  EqualSpan.Free;
  SpanList.Free;
  List.Free;
end;

procedure StrToItemList(const Input: string; List: TItemList);
var
  Ch: Char;
begin
  for Ch in Input do begin
    List.Add(Ch);
  end;
end;

function SpanListToStr(List: TSpanList): string;
var
  Span: TSpan;
begin
  Result := '';
  for Span in List do begin
    Result := Result + IntToStr(Span.Start) + IntToStr(Span.Stop);
  end;
end;

procedure TTestEqualSpan.TestEqualSpan(const Input, Expected: string);
begin
  StrToItemList(Input, List);
  EqualSpan := TEqualSpan<TItem>.Create(List);
  Start := 0; // Set starting index
  while EqualSpan.Get(Start, Stop) do begin
    SpanList.Add(TSpan.Create(Start, Stop));
    Start := Stop + 1; // Set starting index
  end;
  Assert.AreEqual(SpanListToStr(SpanList), Expected);
end;

{ TSpan }

constructor TSpan.Create(Start, Stop: Integer);
begin
  Self.Start := Start;
  Self.Stop := Stop;
end;

initialization

TDUnitX.RegisterTestFixture(TTestEqualSpan);

end.
