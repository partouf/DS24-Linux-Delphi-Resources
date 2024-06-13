unit Books.Models;

interface

type
  TBook = class
  private
    FTitle: string;
  public
    property Title: string read FTitle write FTitle;
  end;

implementation

end.
