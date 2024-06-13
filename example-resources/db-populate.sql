
CREATE TABLE Book (
    [Id] [int] IDENTITY(1,1),
    [Title] [varchar](250),
    CONSTRAINT PK_Book_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY];
GO

CREATE TABLE Category (
    [Id] [int] IDENTITY(1,1),
    [Tag] [varchar](50)
    CONSTRAINT PK_Category_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY];
GO

CREATE TABLE Author (
    [Id] [int] IDENTITY(1,1),
    [LastName] [varchar](250),
    CONSTRAINT PK_Author_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY];
GO

CREATE TABLE BookAuthor (
    [BookId] [int],
    [AuthorId] [int],
    CONSTRAINT PK_BookAuthor PRIMARY KEY CLUSTERED (BookId, AuthorId)
) ON [PRIMARY];
GO

CREATE TABLE BookCategory (
    [BookId] [int],
    [CategoryId] [int],
    CONSTRAINT PK_BookCategory PRIMARY KEY CLUSTERED (BookId, CategoryId)
) ON [PRIMARY];
GO

ALTER TABLE BookAuthor
   ADD CONSTRAINT FK_BookAuthor_Book FOREIGN KEY (BookId)
      REFERENCES Book (Id)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
GO

ALTER TABLE BookAuthor
   ADD CONSTRAINT FK_BookAuthor_Author FOREIGN KEY (AuthorId)
      REFERENCES Author (Id)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
GO

ALTER TABLE BookCategory
   ADD CONSTRAINT FK_BookCategory_Book FOREIGN KEY (BookId)
      REFERENCES Book (Id)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
GO

ALTER TABLE BookCategory
   ADD CONSTRAINT FK_BookCategory_Category FOREIGN KEY (CategoryId)
      REFERENCES Category (Id)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
GO

INSERT INTO Author ([LastName]) VALUES ('Stroustrup'), ('Sweigart'), ('Cantu'), ('Magni');
INSERT INTO Book ([Title]) VALUES ('A Tour of C++'), ('Automate The Boring Stuff With Python'), ('Delphi GUI Programming with FireMonkey');
INSERT INTO Category ([Tag]) VALUES ('c++'), ('python'), ('delphi'), ('pascal'), ('gui');

INSERT INTO BookAuthor ([BookId], [AuthorId]) 
SELECT Id AS BookId, (SELECT Id FROM Author WHERE LastName='Stroustrup') AS AuthorId
FROM Book
WHERE Title='A Tour of C++';

INSERT INTO BookAuthor ([BookId], [AuthorId]) 
SELECT Id AS BookId, (SELECT Id FROM Author WHERE LastName='Sweigart') AS AuthorId
FROM Book
WHERE Title='Automate The Boring Stuff With Python';

INSERT INTO BookAuthor ([BookId], [AuthorId]) 
SELECT Id AS BookId, (SELECT Id FROM Author WHERE LastName='Cantu') AS AuthorId
FROM Book
WHERE Title='Delphi GUI Programming with FireMonkey';

INSERT INTO BookAuthor ([BookId], [AuthorId]) 
SELECT Id AS BookId, (SELECT Id FROM Author WHERE LastName='Magni') AS AuthorId
FROM Book
WHERE Title='Delphi GUI Programming with FireMonkey';

INSERT INTO BookCategory ([BookId], [CategoryId]) 
SELECT Id AS BookId, (SELECT Id FROM Category WHERE Tag='c++') AS CategoryId
FROM Book
WHERE Title='A Tour of C++';

INSERT INTO BookCategory ([BookId], [CategoryId]) 
SELECT Id AS BookId, (SELECT Id FROM Category WHERE Tag='python') AS CategoryId
FROM Book
WHERE Title='Automate The Boring Stuff With Python';

INSERT INTO BookCategory ([BookId], [CategoryId]) 
SELECT Id AS BookId, (SELECT Id FROM Category WHERE Tag='delphi') AS CategoryId
FROM Book
WHERE Title='Delphi GUI Programming with FireMonkey';

INSERT INTO BookCategory ([BookId], [CategoryId]) 
SELECT Id AS BookId, (SELECT Id FROM Category WHERE Tag='pascal') AS CategoryId
FROM Book
WHERE Title='Delphi GUI Programming with FireMonkey';

INSERT INTO BookCategory ([BookId], [CategoryId]) 
SELECT Id AS BookId, (SELECT Id FROM Category WHERE Tag='gui') AS CategoryId
FROM Book
WHERE Title='Delphi GUI Programming with FireMonkey';
