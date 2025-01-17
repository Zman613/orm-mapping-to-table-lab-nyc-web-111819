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
    DB[:conn].execute <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade INTEGER
      )
      SQL
  end

  def self.drop_table
    DB[:conn].execute <<-SQL
      DROP TABLE students
    SQL
  end

  def save
    DB[:conn].execute <<-SQL
      INSERT INTO students (name, grade)
      VALUES ('#{self.name}', '#{self.grade}')
      SQL

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student 
  end
end
