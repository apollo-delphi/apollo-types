unit Apollo_Types;

interface

uses
  System.Classes;

type
  TSimpleMethod = procedure of object;

  TSimpleMethods = TArray<TSimpleMethod>;

  TSimpleMethodsHelper = record helper for TSimpleMethods
    procedure Add(aSimpleMethod: TSimpleMethod);
    procedure Exec;
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

procedure TSimpleMethodsHelper.Exec;
var
  SimpleMethod: TSimpleMethod;
begin
  for SimpleMethod in Self do
    SimpleMethod;
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
