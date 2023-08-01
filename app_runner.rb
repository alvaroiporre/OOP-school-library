require_relative 'app'
require_relative 'teacher'
require_relative 'student'
require 'json'

class AppRunner
  def initialize
    @app = App.new
    
    people = read_data_from_file('people.json')
    people.each do |p|
      if p['type'] == 'Teacher'
        @app.people << Teacher.new(id: p['id'], name: p['name'], age: p['age'], parent_permission: p['parent_permission'], specialization: p['specialization'])
      elsif
        @app.people << Student.new(id: p['id'], name: p['name'], age: p['age'], parent_permission: p['parent_permission'], classroom: p['classrooom'])
      end
    end
  end

  def run
    puts 'Welcome to Library App!'

    loop do
      display_options
      choice = gets.chomp.to_i
      if choice == 7
        store_data(@app.people, 'people.json')
        break
      end

      handle_choice(choice)
    end

    puts 'Exiting...'
  end

  private

  def display_options
    puts 'Please choose an option:'
    puts '1. List all books.'
    puts '2. List all people.'
    puts '3. Create a person (teacher or student, not a plain Person).'
    puts '4. Create a book.'
    puts '5. Create a rental.'
    puts '6. List all rentals for a given person id.'
    puts '7. Exit.'
  end

  def handle_choice(choice)
    case choice
    when 1
      @app.list_all_books
    when 2
      @app.list_all_people
    when 3
      @app.create_person_interactively
    when 4
      @app.create_book_interactively
    when 5
      @app.create_rental_interactively
    when 6
      handle_list_rentals_for_person
    else
      puts 'Invalid option. Please try again.'
    end
  end

  def handle_list_rentals_for_person
    puts 'Enter person ID to list rentals:'
    person_id = gets.chomp.to_i
    @app.list_rentals_for_person(person_id)
  end

  def read_data_from_file(filename)
    data = []
    begin
      file = File.open(filename, 'r')
      data = JSON.parse(file.read())
    rescue Exception => e
      file = File.open(filename, 'w')
      file.write('')
      file.close()
    end
    data
  end

  def store_data(data, filename)
    object_data = []
    data.each do |o|
      object_data << o.to_object 
    end
    json_data = JSON.generate(object_data)
    File.open(filename, 'w') do |file|
      file.write(json_data)
    end
  end
end
