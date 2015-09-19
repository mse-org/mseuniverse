How to make a simple MySQL MSEgui application without code:

Place a tmysqlconnection component from tab DB on the form, name it "conn".
Place a tmsesqltransaction component from tab DB on the form, name it "trans".
In "conn.transaction" select "trans".
Place a tmsesqlquery component from tab DB on the form, name it "query".
In "query.database" select "conn".
In "query.SQL" enter "select * from table1".
In "conn" enter the values for "DatabaseName", "HostName", "UserName" and 
 "Password".
If the database is utf-8 encoded set "conn.controller.options.dbo_utf8" 
 to "true".
Place a tmsedatasource component from tab DB on the form, name it "dataso".
In "dataso.dataset" select "query".
Place a tdbnavigator component from tab DB on the form, name it "dbnav".
In "dbnav.datasource" select dataso.
Place a tdbstringgrid component from tab DB on the form, name it "grid".
In "grid.datalink.datasource" select "dataso".
Set "grid.options.dsgo_autofields to "true".
Set "query.active" to "true".

The database should contain a table "table1" with an autoinc primary key field.