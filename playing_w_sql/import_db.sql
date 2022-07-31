drop table plays;
drop table playwrights;

create table plays (
    id integer primary key,
    title text not null,
    year integer not null,
    playwright_id integer not null,

    foreign key (playwright_id) references playwrights(id)
);

create table playwrights ( 
    id integer primary key,
    name text not null,
    birth_year integer
);


-- cant create any instances of plays until there are playwrigths

insert into
    playwrights (name, birth_year)
values
    ('Arthur Miller', 1915),
    ('Eugene O''Neill', 1888); -- in sql you use another ' to indicate you want to include it in your string


insert into
    plays(title, year, playwright_id)
values -- use embedded queries to get the playwright id
    ('All My Sons', 1947,   
                            (
                            select 
                                id 
                            from
                                playwrights
                            where 
                                name = 'Arthur Miller'
                            )),
    ('Long day''s journey into night', 1956, 
                            (
                            select
                                id
                            from
                                playwrights
                            where
                                name = 'Eugene O''Neill'
                            ));

-- create the db file with sqlite3 by running 'cat import_db.sql | foo.db'
--     cat takes the output of the first file and puts it in the second file (creating a new file if neccessary)
-- open the db in sqlite3 by running 'sqlite3 <.db file>'
-- once in sqlite 3 you can use multiple commands to view the database such as:
--     * '.tables' to see all the tables in the database
--     * '.schema' to see the db schema