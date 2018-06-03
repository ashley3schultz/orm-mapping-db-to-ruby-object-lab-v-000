require 'pry'
class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    o = self.new
    o.id = row[0]
    o.name = row[1]
    o.grade = row[2]
    @@all << o
    o
    # create a new Student object given a row from the database
  end

  def self.all
    all = DB[:conn].execute("SELECT * FROM students")
    all.each {|row| new_from_db(row)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    student = new_from_db(row)
    student
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
