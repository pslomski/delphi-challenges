unit EqualSpan;

interface

uses
  Generics.Collections, Generics.Defaults;

type

  TEqualSpan<T> = class
  private
    List: TList<T>; // CtorDI
    Comparer: IComparer<T>; // CtorDI
  public
    constructor Create(List: TList<T>; Comparer: IComparer<T> = nil);
    function Get(var Start, Stop: Integer): Boolean;
  end;

implementation

uses
  System.Math;

constructor TEqualSpan<T>.Create(List: TList<T>; Comparer: IComparer<T>);
begin
  inherited Create;
  Self.List := List;
  if Assigned(Comparer) then
    Self.Comparer := Comparer
  else
    Self.Comparer := TComparer<T>.Default;
end;

function TEqualSpan<T>.Get(var Start, Stop: Integer): Boolean;
begin
  Result := False;
  Stop := Start + 1;
  while Stop < List.Count do begin
    if Comparer.Compare(List[Start], List[Stop]) = 0 then begin
      Inc(Stop);
      Result := True;
    end
    else begin
      if Stop - Start > 1 then begin
        Dec(Stop);
        Break;
      end
      else begin
        Inc(Start);
        Stop := Start + 1;
        Result := False;
      end;
    end;
  end;
  Stop := Min(Stop, List.Count - 1);
end;

end.
