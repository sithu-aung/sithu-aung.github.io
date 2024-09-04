### Postgres DB Update

- sudo -i -u postgres
  psql -d databasename
- SELECT * FROM "user" WHERE "email" = 'admin@gmail.co';   
- UPDATE "account"
   SET "level" = 100
   WHERE "email" = 'admin@gmail.com';

