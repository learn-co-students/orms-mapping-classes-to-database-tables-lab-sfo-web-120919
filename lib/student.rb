class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name VARCHAR, 
        grade VARCHAR
      )
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.drop_table #why wouldnt we set a var here and call in the drop command?
    sql = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(name:, grade:)
   student = Student.new(name, grade)
   student.save
   student
  end
  
  
end
