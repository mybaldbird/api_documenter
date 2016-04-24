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
          table [
            ['title', 'string', 'Title of the book.'],
            ['author', 'string', 'Author of the book.'],
            ['copies', 'integer', 'Number of copies of the book in the library.']
          ]
          example(
            title: 'A Tale of Two Cities',
            author: 'Charles Dickens',
            copies: 5
          )
        end
      end
    end
    route do
      verb 'PATCH'; uri '/books/`id`'; id 'books-update'
      request do
        description 'Update the properties of a book.'
        spec do
          table [
            ['title', 'string', 'Title of the book.'],
            ['author', 'string', 'Author of the book.'],
            ['copies', 'integer', 'Number of copies of the book in the library.']
          ]
          example(
            copies: 4
          )
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
            table [
              ['name', 'string', 'Name of the employee.'],
              ['title', 'string', 'Job title of the employee.'],
              ['favorite', 'integer', 'ID of their favorite [books:book].']
            ]
            example(
              name: 'Bob Loblaw',
              title: 'Internet Marketing Manager',
              favorite: 1
            )
          end
        end
      end
      route do
        verb 'PATCH'; uri '/employees/`id`'; id 'employees-update'
        request do
          description 'Update the properties of an employee.'
          spec do
            table [
              ['name', 'string', 'Name of the employee.'],
              ['title', 'string', 'Job title of the employee.'],
              ['favorite', 'integer', 'ID of their favorite [books:book].']
            ]
            example(
              title: 'Janitor'
            )
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
            table [
              ['name', 'string', 'Name of the volunteer.'],
              ['title', 'string', 'Job title of the volunteer.']
            ]
            example(
              name: 'Vin Diesel',
              title: 'Bookmobile Driver'
            )
          end
        end
      end
      route do
        verb 'PATCH'; uri '/volunteers/`id`'; id 'volunteers-update'
        request do
          description 'Update the properties of a volunteer.'
          spec do
            table [
              ['name', 'string', 'Name of the volunteer.'],
              ['title', 'string', 'Job title of the volunteer.']
            ]
            example(
              title: 'Library Assistant'
            )
          end
        end
      end
    end
  end
end
