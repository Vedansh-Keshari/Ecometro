import sqlite3
from flask import Flask, request, jsonify
from gpt4all import GPT4All
from getpass import getpass

app = Flask(__name__)
model = GPT4All("wizardlm-13b-v1.2.Q4_0.gguf")

@app.route('/chatbot', methods=['GET'])
def chatbot():
    # Extract query parameters from the URL
    prompt = request.args.get('prompt')
    print("/n Prompt By User:" + prompt)
    temperature = float(request.args.get('temperature', 0.7))

    # Check if prompt is provided
    if prompt is None:
        return jsonify({'error': 'Prompt parameter is missing'}), 400

    # Generate response from the GPT-4 model
    with model.chat_session():
        response = model.generate(prompt=prompt, temp=temperature, max_tokens=1024)

    # Return response
    print(response)
    return jsonify({'response': response})
def create_connection(database):
    """Create a database connection to the SQLite database."""
    conn = None
    try:
        conn = sqlite3.connect(database)
        print(f"Connected to database: {database}")
    except sqlite3.Error as e:
        print(e)
    return conn

def create_products_table(conn):
    sql = ''' CREATE TABLE IF NOT EXISTS products (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                item_name TEXT NOT NULL,
                product_type TEXT NOT NULL,
                vendor_name TEXT NOT NULL,
                email TEXT NOT NULL,
                contact_no TEXT NOT NULL,
                location TEXT NOT NULL,
                working_days TEXT NOT NULL,
                working_time TEXT NOT NULL
            )'''
    cur = conn.cursor()
    cur.execute(sql)
    print("Products table created successfully.")

# Function to insert product data into the products table
def insert_product(conn, product_data):
    sql = ''' INSERT INTO products(item_name, product_type, vendor_name, email, contact_no, location, working_days, working_time)
              VALUES(?,?,?,?,?,?,?,?) '''
    cur = conn.cursor()
    cur.execute(sql, product_data)
    conn.commit()
    print("Product data inserted successfully.")

# Function to fetch all product data from the products table
def fetch_products(conn):
    cur = conn.cursor()
    cur.execute("SELECT * FROM products")
    rows = cur.fetchall()
    products = []
    for row in rows:
        product = {
            "item_name": row[1],
            "product_type": row[2],
            "vendor_name": row[3],
            "email": row[4],
            "contact_no": row[5],
            "location": row[6],
            "working_days": row[7],
            "working_time": row[8]
        }
        products.append(product)
    return products

@app.route('/products', methods=['POST'])
def register_product():
    database = r"users.db"  # SQLite database file
    conn = create_connection(database)

    # Create the products table if it doesn't exist
    with conn:
        create_products_table(conn)

    # Get product data from the request
    product_data = request.get_json()
    item_name = product_data.get("item_name")
    product_type = product_data.get("product_type")
    vendor_name = product_data.get("vendor_name")
    email = product_data.get("email")
    contact_no = product_data.get("contact_no")
    location = product_data.get("location")
    working_days = product_data.get("working_days")
    working_time = product_data.get("working_time")

    # Insert product data into the products table
    product = (item_name, product_type, vendor_name, email, contact_no, location, working_days, working_time)
    insert_product(conn, product)

    return jsonify({"message": "Product registered successfully."})

@app.route('/products', methods=['GET'])
def get_products():
    database = r"users.db"  # SQLite database file
    conn = create_connection(database)

    # Fetch all product data from the products table
    with conn:
        products = fetch_products(conn)

    return jsonify(products)
def create_user(conn, user):
    """Create a new user."""
    sql = ''' INSERT INTO users(email, password, phone_number, name)
              VALUES(?,?,?,?) '''
    cur = conn.cursor()
    cur.execute(sql, user)
    conn.commit()
    return cur.lastrowid

def authenticate_user(conn, email, password):
    """Authenticate user with email and password."""
    cur = conn.cursor()
    cur.execute("SELECT * FROM users WHERE email = ? AND password = ?", (email, password))
    user = cur.fetchone()
    return user

@app.route('/register', methods=['POST'])
def register():
    database = r"users.db"  # SQLite database file
    conn = create_connection(database)

    # Create the users table if it doesn't exist
    with conn:
        conn.execute('''CREATE TABLE IF NOT EXISTS users (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        email TEXT NOT NULL,
                        password TEXT NOT NULL,
                        phone_number TEXT NOT NULL,
                        name TEXT NOT NULL
                        )''')

    # Get user data from the request
    user_data = request.get_json()
    email = user_data.get("email")
    password = user_data.get("password")
    phone_number = user_data.get("phone_number")
    name = user_data.get("name")

    # Insert user into the database
    user = (email, password, phone_number, name)
    user_id = create_user(conn, user)

    return jsonify({"message": f"User with ID {user_id} created successfully."})

@app.route('/login', methods=['POST'])
def login():
    database = r"users.db"  # SQLite database file
    conn = create_connection(database)

    # Get user data from the request
    user_data = request.get_json()
    email = user_data.get("email")
    password = user_data.get("password")

    # Authenticate user
    user = authenticate_user(conn, email, password)
    if user:
        return jsonify({"message": "Authentication successful."})
    else:
        return jsonify({"message": "Authentication failed."}), 401

def create_user_stats_table(conn):
    sql = '''CREATE TABLE IF NOT EXISTS user_stats (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                email TEXT UNIQUE NOT NULL,
                co2_saved REAL DEFAULT 0,
                co2_goal REAL DEFAULT 0
            )'''
    cursor = conn.cursor()
    cursor.execute(sql)
    print("User stats table created successfully.")

# Function to insert user stats into the user_stats table
def insert_user_stats(conn, email, co2_saved, co2_goal):
    cursor = conn.cursor()
    cursor.execute("INSERT INTO user_stats (email, co2_saved, co2_goal) VALUES (?, ?, ?)", (email, co2_saved, co2_goal))
    conn.commit()
    print("User stats inserted successfully.")

# Function to fetch user stats by email from the user_stats table
def fetch_user_stats(conn, email):
    cursor = conn.cursor()
    cursor.execute("SELECT co2_saved, co2_goal FROM user_stats WHERE email=?", (email,))
    row = cursor.fetchone()
    if row:
        co2_saved, co2_goal = row
        return {"co2_saved": co2_saved, "co2_goal": co2_goal}
    else:
        return None

# Create the user stats table if it doesn't exist
def create_user_stats_table(conn):
    sql = '''CREATE TABLE IF NOT EXISTS user_stats (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                email TEXT UNIQUE NOT NULL,
                co2_saved REAL DEFAULT 0,
                co2_goal REAL DEFAULT 0
            )'''
    cursor = conn.cursor()
    cursor.execute(sql)
    print("User stats table created successfully.")

@app.route('/user_stats/<email>', methods=['GET', 'PUT'])
def user_stats(email):
    conn = create_connection()
    if conn:
        try:
            cursor = conn.cursor()
            if request.method == 'GET':
                stats = fetch_user_stats(conn, email)
                if stats:
                    conn.close()
                    return jsonify(stats), 200
                else:
                    conn.close()
                    return jsonify({"message": "User not found."}), 404
            elif request.method == 'PUT':
                data = request.get_json()
                co2_saved = data.get("co2_saved")
                co2_goal = data.get("co2_goal")
                cursor.execute("INSERT OR IGNORE INTO user_stats (email, co2_saved, co2_goal) VALUES (?, ?, ?)",
                               (email, co2_saved, co2_goal))
                cursor.execute("UPDATE user_stats SET co2_saved=?, co2_goal=? WHERE email=?",
                               (co2_saved, co2_goal, email))
                conn.commit()
                conn.close()
                return jsonify({"message": "User stats updated successfully."}), 200
        except Exception as e:
            print(e)
            return jsonify({"message": "Failed to update user stats."}), 500
    else:
        return jsonify({"message": "Failed to connect to the database."}), 500

if __name__ == '__main__':
    app.run(debug=True)
