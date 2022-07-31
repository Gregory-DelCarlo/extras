# wtf is an orm

---

## the basics

- object relational mapping
- basically abstracts the interaction with a db into objects
  (i.e. classes and methods)
- data returned by the database comes in the form of a nested array when using raw sql
  - [[1,'All My Sons',1947,1],...]
  - this is super messy and requires you embedding sql code into your source code
- what if we could just query the db and return the data using plays.all

---

## This is what a basic orm object would look like

``` Ruby
class Play
  def self.all
  ## get all the plays stored in the database
  end

  def initialize(options)
    ## create a new instance of the play class
  end

  def create
  ## create a new row in the db table using the information in self
  end

  def update
    ## sends a query to the db that updates the tables info
  end
end  
```

---

## SQL injection attacks

- **BE AWARE THESE ARE SCARY**
- Basically this happens when you incorrectly give properties access to your sql queries
-- When you write SQL queries that take in ruby variables **NEVER** use the actual variables
-- instead use '?' which reads the passed variables in order and assigns them appropriately
  - in SQLite3's gem using this method automatically removes any characters that may be malicious
  - for example if the user set a variable like this `playwright_id  = "3; DROP TABLE plays"` and the var @playwright_id was used directly, creating this play would end up deleting the whole table
  - this is called 'sanitizing' the user passed arguements

### Don't do this

``` Ruby
PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
            INSERT INTO
                plays (title, year, playwright_id)
            VALUES
                (@title, @year, @playwright_id)
            SQL
```

### Do this

``` Ruby
PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
            INSERT INTO
                plays (title, year, playwright_id)
            VALUES
                (?, ?, ?) -- references the vars passed in order 
            SQL
```
