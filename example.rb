require './api_documenter.rb'
include ApiDocumenter

document 'Library' do
  route verb: 'POST', uri: '/book' do
    request 'Create a new book.' do
      spec [
        ['title', 'string', 'Title of the book.'],
        ['author', 'string', 'Author of the book.'],
        ['copies', 'integer', 'Number of copies of this book in the library.']
      ] do
        {
          'title': 'A Tale of Two Cities',
          'author': 'Charles Dickens',
          'copies': 5
        }
      end
    end
  end
  route verb: 'PATCH', uri: '/book/id' do
    request 'Update a book\'s properties.' do
      spec [
        ['title', 'string', 'Title of the book.'],
        ['author', 'string', 'Author of the book.'],
        ['copies', 'integer', 'Number of copies of this book in the library.']
      ] do
        {
        'copies': 4
        }
      end
    end
  end
end
