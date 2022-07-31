require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super('plays.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Play
    attr_accessor :title, :year, :playwright_id

    def self.all
    ## get all the plays stored in the database
        data = PlayDBConnection.instance.execute("
            SELECT 
                *
            FROM
                plays
            ")  ## instance grabs the singleton of the db class (i.e connects to the datbase)
        
        data.map { |datum| Play.new(datum) }  ## creates a new instance of Play for each row found in the db
    end
  
    def initialize(options)
    ## create a new instance of the play class
        @id = options['id']
        @title = options['title']
        @year = options['year']
        @playwright_id = options['playwright_id']
    end
  
    def create
    ## create a new row in the db table using the information in self
        raise "#{self} is already in the database" if @id
        ## adding vars at the end of the execute sends them to the heredoc
        PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
            INSERT INTO --id is automatically generated
                plays (title, year, playwright_id)
            VALUES
                (?, ?, ?) -- references the vars passed in order 
            SQL
            ## SQL is just a var here but using the language name tells the ide
                # how to provide proper syntax highlighting
        # what is a heredoc?
        # basically is allows you to write a bit of code that will be interpreted
        # as a string when passed to ruby code
        @id = PlayDBConnection.instance.last_insert_row_id
    end
  
    def update
    ## sends a query to the db that updates the tables info
        raise "#{self} does not exist" unless @id

        PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id, @id)
            UPDATE
                plays
            SET
                title = ?, year = ?, playwright_id = ?
            WHERE
                id = ?
            SQL
    end
end 