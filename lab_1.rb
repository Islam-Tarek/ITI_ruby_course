
class Book
  attr_accessor :title, :author, :ISBN
  def initialize(title, author, isbn)
    @title = title
    @author = author
    @ISBN = isbn
  end

end

class Inventory
  # attr_accessor :books[]

  def initialize
    # @books = []
    if !File.exist?('books_inventory.txt')
      File.open('books_inventory.txt', 'w');
      File.close()
    end
    
  end

  def add_book(book)
    
    File.open('books_inventory.txt', 'a') do |file|
      file.puts "#{book.title} , #{book.author} , #{book.ISBN} "
    end
    File.close('books_inventory.txt')
  end

def remove_book(isbn)
  return "File not found" unless File.exist?('books_inventory.txt')
  
  book_status = false
  content = []
  
  # Read all lines first
  File.open('books_inventory.txt', 'r') do |file|
    file.each_line do |line|
      if line.include?(isbn)
        book_status = true
      else
        content << line
      end
    end
  end
  
  # Write back filtered content
  File.open('books_inventory.txt', 'w') do |file|
    content.each { |line| file.write(line) }
  end
  
  book_status ? "The book deleted successfully" : "The book not found"
end

  def find_book(searchTerm)
    found_book = "-"
    File.open('books_inventory.txt', 'r') do |file|
      file.each_line do |line|
        if line.include?(searchTerm)
          found_book = line
          break
        end
      end
    end
    return found_book == '-' ? "The book not found" : found_book
  end

  def list_books
    File.open('books_inventory.txt', 'r') do |file|
      file.each_line do |line|
        puts line
      end
    end
  end

end

# book1 = Book.new 'book1', 'author1', '123'
# book2 = Book.new 'book2', 'author2', '234'
# book3 = Book.new 'book3', 'author3', '345'
# book4 = Book.new 'book4', 'author4', '456'
# book5 = Book.new 'book5', 'author5', '567'
# book6 = Book.new 'book6', 'author6', '678'


invertory = Inventory.new
# invertory.add_book book1
# invertory.add_book book2
# invertory.add_book book3
# invertory.add_book book4
# invertory.add_book book5
# invertory.add_book book6
# 

# puts invertory.find_book '567'
# puts invertory.find_book 'book3'
# puts invertory.find_book 'author4'

# puts invertory.find_book '965'
# puts invertory.find_book 'author9'
# puts invertory.find_book 'book8'
# 

# puts invertory.remove_book '234'

# invertory.list_books