--This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
require "luasql.postgres"
envv = assert (luasql.postgres())
con = assert (envv:connect('testdb', 'testuser', 'password', "127.0.0.1", 5432))

-- DROP ANY EXISTING PEOPLE TABLE
res = con:execute("DROP TABLE people")

-- RECREATE PEOPLE TABLE
res = assert (con:execute[[
	CREATE TABLE people(
		id integer,
		fname text,
		lname text,
		job text
	)
]])

-- ADD SOME PEOPLE TO THE PEOPLE TABLE
res = assert(con:execute("INSERT INTO people " ..
	"VALUES (1, 'Roberto', 'Ierusalimschy', 'Programmer')"))
res = assert(con:execute("INSERT INTO people " ..
	"VALUES (2, 'Barack', 'Obama', 'President')"))
res = assert(con:execute("INSERT INTO people " ..
	"VALUES (3, 'Taylor', 'Swift', 'Singer')"))
res = assert(con:execute("INSERT INTO people " ..
	"VALUES (4, 'Usain', 'Bolt', 'Sprinter')"))

-- RETRIEVE THE PEOPLE TABLE SORTED BY LAST NAME INTO CURSOR
cur = assert (con:execute"SELECT * from people order by lname")

-- LOOP THROUGH THE CURSOR AND PRINT
print()
print(string.format("%15s  %-15s %-15s %-15s",
	"#", "FNAME", "LNAME", "JOB"))
print(string.format("%15s  %-15s %-15s %-15s",
	"-", "-----", "-----", "---"))
row = cur:fetch ({}, "a")
while row do
	print(string.format("%15d  %-15s %-15s %-15s",
		row.id, row.fname, row.lname, row.job))
	row = cur:fetch (row, "a")
end
print()

-- CLOSE EVERYTHING
cur:close()
con:close()
envv:close()

