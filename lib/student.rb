require "pry"
class Student
  attr_reader :name, :grade, :id
  def initialize(name, grade)
    @name = name
    @grade = grade
  end
  def self.create_table
    sql = <<-SQL
              CREATE TABLE students (id INTEGER PRIMARY KEY,
              name TEXT,
              grade TEXT)
            SQL
    DB[:conn].execute(sql)
  end
  def save
    sql = <<-SQL
                INSERT INTO students (name,grade)
                VALUES (?,?)
             SQL
    DB[:conn].execute(sql,self.name,self.grade)
    sql = <<-SQL
                SELECT * FROM students 
            SQL
    record = DB[:conn].execute(sql)
    record.each do |ele|
      @id = ele[0]
    end
  end
  def self.drop_table
    sql = <<-SQL
                  DROP TABLE students 
              SQL
              DB[:conn].execute(sql) 
  end
  def self.create(student)
    # binding.pry
    student1 = Student.new(student[:name],student[:grade])
    student1.save
    student1
  end
end
