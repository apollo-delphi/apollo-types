unit Apollo_Types;

interface

type
  TSimpleMethod = procedure of object;

  TSimpleMethods = TArray<TSimpleMethod>;

  TSimpleMethodsHelper = record helper for TSimpleMethods
    procedure Add(aSimpleMethod: TSimpleMethod);
    procedure Exec;
  end;

implementation

{TSimpleMethodsHelper}

procedure TSimpleMethodsHelper.Add(aSimpleMethod: TSimpleMethod);
begin
  Self := Self + [aSimpleMethod];
end;

procedure TSimpleMethodsHelper.Exec;
var
  SimpleMethod: TSimpleMethod;
begin
  for SimpleMethod in Self do
    SimpleMethod;
end;

end.
