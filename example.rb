require './api_documenter.rb'
include ApiDocumenter

document do
  title 'Library'
  description 'API for managing a library.'
  group do
    name 'Books'; id 'books'
    description 'API calls for the books object.'
    route do 
      verb 'POST'; uri '/books'; id 'books-create'
      request do
        description 'Create a new book.'
        spec do
          row ['title', 'string', 'Title of the book.']
          row ['author', 'string', 'Author of the book.']
          row ['copies', 'integer', 'Number of copies of the book in the library.']
          example do
            header 'POST /books'
            json(
              title: 'A Tale of Two Cities',
              author: 'Charles Dickens',
              copies: 5
            )
          end
        end
      end
      response do
        title 'Success'
        description 'The book was created successfully.'
        spec do
          row ['id', 'integer', 'ID of the book.']
          row ['title', 'string', 'Title of the book.']
          row ['author', 'string', 'Author of the book.']
          row ['copies', 'integer', 'Number of copies of the book in the library.']
          example do
            header 'Response code 200'
            json(
              id: 1,
              title: 'A Tale of Two Cities',
              author: 'Charles Dickens',
              copies: 5
            )
          end
        end
      end
    end
  end
  group do
    name 'Staff'; id 'staff'
    description 'API calls for managing staff members.'
    group do
      name 'Employees'; id 'employees'
      description 'Staff members earning wages.'
      route do
        verb 'POST'; uri '/employees'; id 'employees-create'
        request do
          description 'Create a new employee.'
          spec do
            row ['name', 'string', 'Name of the employee.']
            row ['title', 'string', 'Job title of the employee.']
            row ['favorite', 'integer', 'ID of their favorite [books:book].']
            example do
              header 'POST /employees'
              json(
                name: 'Bob Loblaw',
                title: 'Internet Marketing Manager',
                favorite: 1
              )
            end
          end
        end
      end
    end
    group do
      name 'Volunteers'; id 'volunteers'
      description 'Staff members not earning wages.'
      route do
        verb 'POST'; uri '/volunteers'; id 'volunteers-create'
        request do
          description 'Create a new volunteer.'
          spec do
            row ['name', 'string', 'Name of the volunteer.']
            row ['title', 'string', 'Job title of the volunteer.']
            example do
              header 'POST /volunteers'
              json(
                name: 'Vin Diesel',
                title: 'Bookmobile Driver'
              )
            end
          end
        end
      end
      route do
        verb 'PATCH'; uri '/volunteers/`id`'; id 'volunteers-update'
        request do
          description 'Update the properties of a volunteer.'
          spec do
            row ['name', 'string', 'Name of the volunteer.']
            row ['title', 'string', 'Job title of the volunteer.']
            example do
              header 'PATCH /volunteers/23'
              json(
                title: 'Library Assistant'
              )
            end
          end
        end
      end
    end
  end
end
