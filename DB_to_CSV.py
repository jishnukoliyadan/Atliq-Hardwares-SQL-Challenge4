import os
import shutil
import pandas as pd
from tqdm import tqdm
import mysql.connector
from credentials import db_password

mydb = mysql.connector.connect(host = 'localhost', user = 'root', password = db_password, database = 'gdb023')
cursorObject = mydb.cursor()

if os.path.isdir('DB_CSVs'):
    shutil.rmtree('DB_CSVs')
os.mkdir('DB_CSVs')


query = '''
        SHOW TABLES
        '''
cursorObject.execute(query)
tables_list = cursorObject.fetchall()

print('Converting SQL Database tables into CSV file')

for table in tqdm(tables_list):
    # print(table[0])
    cursorObject.execute(f'SELECT * FROM {table[0]}')
    df = pd.DataFrame(cursorObject.fetchall(), columns = cursorObject.column_names)
    df.to_csv(f'DB_CSVs/{table[0]}.csv', index= False)
