unit Books.Controller;

interface

uses
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Server,
  MVCFramework.Serializer.Commons,
  Books.Models;

type
  [MVCPath('/books')]
  TBooksController = class(TMVCController)
  public
    [MVCPath('/')]
    [MVCProduces('application/json')]
    [MVCHTTPMethod([httpGET])]
    [MVCDoc('Returns the Book list as a JSON Array of JSON Objects')]
    function GetBooks: TObjectList<TBook>;
  end;

implementation

uses
  DataMod_Database,
  FireDAC.Comp.Client,
  Books.Queries;

function TBooksController.GetBooks: TObjectList<TBook>;
var
  Connection: TFDConnection;
begin
  Result := TObjectList<TBook>.Create;

  // todo: should be using https://github.com/GDKsoftware/firedac-threaded
  Connection := dmDatabase.NewConnection;
  try
    var Dataset := TBooksQueries.SelectAll(Connection);
    try
      while not Dataset.Eof do
      begin
        var Book := TBook.Create;
        Book.Title := Dataset.FieldByName('Title').AsString;
        Result.Add(Book);

        Dataset.Next;
      end;
    finally
      Dataset.Free;
    end;
  finally
    Connection.Free;
  end;
end;

end.
