unit Apollo_Types;

interface

uses
  System.Classes;

type
  TSimpleMethod = procedure of object;

  TSimpleMethods = TArray<TSimpleMethod>;

  TSimpleMethodsHelper = record helper for TSimpleMethods
    function Count: Integer;
    function GetInstance(const aIndex: Integer): Pointer;
    procedure Add(aSimpleMethod: TSimpleMethod);
    procedure Exec;
    procedure Remove(const aData: Pointer); overload;
    procedure Remove(aSimpleMethod: TSimpleMethod); overload;
  end;

  TNotifyEventItem = record
    NotifyEvent: TNotifyEvent;
    Sender: TObject;
  end;

  TNotifyEvents = TArray<TNotifyEventItem>;

  TNotifyEventsHelper = record helper for TNotifyEvents
    procedure Add(aSender: TObject; aNotifyEvent: TNotifyEvent);
    procedure Exec;
  end;

  TIntefacedObjectNotUsingReference = class(TObject)
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  end;

  ISourceFreeNotification = interface
  ['{087E30AF-C13E-4B9C-861F-42FFC335B747}']
    procedure AddFreeNotify(aNotifyEvent: TNotifyEvent);
  end;

implementation

{TSimpleMethodsHelper}

procedure TSimpleMethodsHelper.Add(aSimpleMethod: TSimpleMethod);
begin
  Self := Self + [aSimpleMethod];
end;

function TSimpleMethodsHelper.Count: Integer;
begin
  Result := Length(Self);
end;

procedure TSimpleMethodsHelper.Exec;
var
  SimpleMethod: TSimpleMethod;
begin
  for SimpleMethod in Self do
    SimpleMethod;
end;

function TSimpleMethodsHelper.GetInstance(const aIndex: Integer): Pointer;
begin
  Result := TMethod(Self[aIndex]).Data;
end;

procedure TSimpleMethodsHelper.Remove(aSimpleMethod: TSimpleMethod);
var
  i: Integer;
begin
  for i := Length(Self) - 1 downto 0 do
    if TMethod(Self[i]).Data = TMethod(aSimpleMethod).Data then
      Delete(Self, i, 1);
end;

procedure TSimpleMethodsHelper.Remove(const aData: Pointer);
var
  i: Integer;
begin
  for i := Length(Self) - 1 downto 0 do
    if TMethod(Self[i]).Data = aData then
      Delete(Self, i, 1);
end;

{ TNotifyEventsHelper }

procedure TNotifyEventsHelper.Add(aSender: TObject; aNotifyEvent: TNotifyEvent);
var
  Item: TNotifyEventItem;
begin
  Item.Sender := aSender;
  Item.NotifyEvent := aNotifyEvent;

  Self := Self + [Item];
end;

procedure TNotifyEventsHelper.Exec;
var
  Item: TNotifyEventItem;
begin
  for Item in Self do
    Item.NotifyEvent(Item.Sender);
end;

{ TIntefacedObjectNotUsingReference }

function TIntefacedObjectNotUsingReference.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TIntefacedObjectNotUsingReference._AddRef: Integer;
begin
  Result := -1;
end;

function TIntefacedObjectNotUsingReference._Release: Integer;
begin
  Result := -1;
end;

end.
