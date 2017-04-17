import uuid
import MySQLdb

connector = MySQLdb.connect(
        user     = 'dorian',
        password = 'password',
        host     = 'uuid.c9pxhxbdcuca.ap-northeast-1.rds.amazonaws.com',
        db       = 'uuid'
        )

cursor = connector.cursor()

for i in range(10):
    uuid_str = str(uuid.uuid4())
    #sql = 'insert into uuid.python (`uuid`) values (' + "'" + str(uuid.uuid4()) + "'" + ');'
    sql = "insert into `uuid`.`python` (`uuid`) values (%s);"
    cursor.execute(sql, (uuid_str, ))
    print(uuid_str)

cursor.close
connector.close

#while 1 == 1:
#  aaa = str(uuid.uuid4())

