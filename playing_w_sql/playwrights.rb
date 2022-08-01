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

class Playwright
    attr_accessor :name, :birth_year

    def self.all
        
        writers = PlayDBConnection.instance.execute("SELECT * FROM playwrights")

        writers.map {|writer| Playwright.new(writer)}
    end

    def self.find_by_name(name)
        PlayDBConnection.instance.execute(<<-SQL, name)
            SELECT
                *
            FROM
                playwrights
            WHERE
                name = ?
        SQL
    end

    def initialize(options)
        @id, @name, @birth_year = options['id'], options['name'], options['birth_year']
    end

    def create
        raise "#{self} is already in the database" if @id

        PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year)
                            INSERT INTO
                                playwrights (name, birth_year)
                            VALUES
                                (?,?)
                        SQL

        @id = PlayDBConnection.instance.last_insert_row_id
    end

    def update
        raise "#{self} is not in the database" unless @id

        PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year, @id)
            UPDATE
                playwrights
            SET
                name = ?, birth_year = ?
            WHERE
                id = ?
        SQL
    end

    def get_plays
        PlayDBConnection.instance.execute(<<-SQL, @id)
            SELECT
                *
            FROM 
                plays
            WHERE
                playwright_id = ?
        SQL
    end
end