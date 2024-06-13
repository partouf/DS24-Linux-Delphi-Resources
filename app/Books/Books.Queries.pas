unit Books.Queries;

interface

uses
  FireDac.Comp.Client,
  Data.DB;

type
  TBooksQueries = class
  public
    class function SelectAll(const Connection: TFDConnection): TDataset;
  end;

implementation

{ TBooksQueries }

class function TBooksQueries.SelectAll(const Connection: TFDConnection): TDataset;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  Query.Connection := Connection;
  Query.SQL.Text := 'select * from Book';
  Query.Open;

  Result := Query;
end;

end.
