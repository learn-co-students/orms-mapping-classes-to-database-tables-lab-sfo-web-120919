require "pry"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  @@all = []

  attr_reader :name, :grade, :id

  def initialize(name, grade)
    @id = nil
    @name = name
    @grade = grade

    self.class.all << self
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    s = DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1")[0][0]
    #binding.pry
  end

  def self.all
    @@all
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students 
      SQL
    DB[:conn].execute(sql)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      grade INTEGER
      )
      SQL

    DB[:conn].execute(sql)
  end

  def self.create(student_info)
    new_student = self.new(student_info[:name], student_info[:grade])
    new_student.save
    new_student
  end
end
