require './api_documenter.rb'
include ApiDocumenter

document do |d|
  d.title 'Library'
  d.add_route do |r|
    r.verb 'POST'
    r.uri '/book'
    r.request do |req|
      req.description 'Create a new book.'
      req.spec do |s|
        s.table [
          ['title', 'string', 'Title of the book.'],
          ['author', 'string', 'Author of the book.'],
          ['copies', 'integer', 'Number of copies of this book in the library.']
        ]
        s.example(
          'title': 'A Tale of Two Cities',
          'author': 'Charles Dickens',
          'copies': 5
        )
      end
    end
  end
  d.add_route do |r|
    r.verb 'PATCH'
    r.uri '/book/id'
    r.request do |req|
      req.description 'Update a book\'s properties.'
      req.spec do |s|
        s.table [
          ['title', 'string', 'Title of the book.'],
          ['author', 'string', 'Author of the book.'],
          ['copies', 'integer', 'Number of copies of this book in the library.']
        ]
        s.example(
          'copies': 4
        )
      end
    end
  end
end
