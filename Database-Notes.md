### Postgres Commands

### Connect Database

### Same Host
   - psql -d <db-name> -U <username> -W
 (-W - forces psql to ask for the user password before connecting to the database)

### Different Host
   - psql -h <db-address> -d <db-name> -U <username> -W

### List all Database -  \l

### Switch Another Database -  \c

### List All Table   -   \dt

### Describe Table    - \d ( if want more - \d+ )

### List all schema    -  \dn

### List users and roles  -  \du

### List all functions    -  \df

### Save query result to a file - \o <file-name>

### Quit sql   - \q

### SQL ( Structured Query Language - SEQUEL )

- excecute queries
- fetch data
- insert, update, and delete records in a database (DML operations)
- create new objects in a database (DDL operations)

  

- SELECT DISTINCT name,description FROM task WHERE name

- sudo -i -u postgres
  psql -d databasename
- SELECT * FROM "user" WHERE "email" = 'admin@gmail.co';   
- UPDATE "account"
   SET "level" = 100
   WHERE "email" = 'admin@gmail.com';


  ### DUMP and Restore Database

  pg_dump -U postgres -h localhost -p 5432 -d learningwithus -F c -b -v -f learnwithus.dump

 -  sudo nano /etc/ssh/sshd_config
 -  Comment Out these two lines
      PubkeyAuthentication yes
      AuthorizedKeysFile .ssh/authorized_keys

-    sudo systemctl restart ssh
-        chmod 700 ~/.ssh
         chmod 600 ~/.ssh/authorized_keys

- In Local , Generate SSH, copy and insert to it

-    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"


- scp root@170.64.231.139:~/todolist.dump ~/Desktop
  

