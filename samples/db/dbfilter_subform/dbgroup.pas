unit DbGroup;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
msesimplewidgets,mseevent,msegraphics,classes,mclasses,msegraphutils,mseact,
 mseguiglob, msedb,msewidgets;
type
  TDBgroup = class(tgroupbox)
   private
  FDataLink: TFieldDataLink;  
  function GetDataSource:tmseDataSource;
  procedure SetDataSource(Value: TmseDataSource);
  public 
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published 
    property DataSource: TmseDataSource 
    read GetDataSource write SetDataSource; 
   end;
 
implementation


function TDBGroup.GetDataSource:tmseDataSource;
begin
  Result := tmsedatasource(FDataLink.DataSource);
 
end;

procedure TDBGroup.SetDataSource(Value: TmseDataSource);
begin
  FDataLink.DataSource := Value;
end;

constructor TDBGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
end;

destructor TDBGroup.Destroy;
begin
  FDataLink.Free;
  inherited Destroy;
end;
end.
//{$R *.DFM}
