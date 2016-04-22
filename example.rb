require './api_documenter.rb'
include ApiDocumenter

document do
  title 'Library'
  add_route do
    verb 'POST'
    uri '/book'
    request do
      description 'Create a new book.'
      spec do
        table [
          ['title', 'string', 'Title of the book.'],
          ['author', 'string', 'Author of the book.'],
          ['copies', 'integer', 'Number of copies of this book in the library.']
        ]
        example(
          'title': 'A Tale of Two Cities',
          'author': 'Charles Dickens',
          'copies': 5
        )
      end
    end
  end
  add_route do
    verb 'PATCH'
    uri '/book/id'
    request do
      description 'Update a book\'s properties.'
      spec do
        table [
          ['title', 'string', 'Title of the book.'],
          ['author', 'string', 'Author of the book.'],
          ['copies', 'integer', 'Number of copies of this book in the library.']
        ]
        example(
          'copies': 4
        )
      end
    end
  end
end
