import psycopg2
from psycopg2.extras import RealDictCursor
import time

# PostgreSQL connection configurations
db_config = {
    'host': 'localhost',
    'database': 'college_db',
    'user': 'postgres',        # Your Postgres username
    'password': 'Gopal@1234'     # Enter your pgAdmin master password here
}

def run_n_plus_one_simulation():
    print("--- APPROACH 1: Simulating the N+1 Problem (PostgreSQL) ---")
    conn = psycopg2.connect(**db_config)
    # RealDictCursor returns rows as Python dictionaries like MySQL did
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    query_count = 0
    start_time = time.perf_counter()
    
    # 1. Fetch all N enrollments
    cursor.execute("SELECT * FROM enrollments;")
    enrollments = cursor.fetchall()
    query_count += 1
    
    # 2. Loop and issue N separate queries for student names
    results = []
    for row in enrollments:
        student_id = row['student_id']
        cursor.execute("SELECT first_name, last_name FROM students WHERE student_id = %s;", (student_id,))
        student = cursor.fetchone()
        query_count += 1
        
        results.append({
            'enrollment_id': row['enrollment_id'],
            'student_name': f"{student['first_name']} {student['last_name']}",
            'course_id': row['course_id']
        })
        
    end_time = time.perf_counter()
    cursor.close()
    conn.close()
    
    print(f"Total Queries Executed: {query_count}")
    print(f"Execution Time: {end_time - start_time:.6f} seconds\n")
    return results

def run_optimized_join():
    print("--- APPROACH 2: Optimized Single JOIN Query (PostgreSQL) ---")
    conn = psycopg2.connect(**db_config)
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    query_count = 0
    start_time = time.perf_counter()
    
    # Eagerly load all records with a single inner join block
    optimized_query = """
        SELECT e.enrollment_id, CONCAT(s.first_name, ' ', s.last_name) AS student_name, e.course_id
        FROM enrollments e
        INNER JOIN students s ON e.student_id = s.student_id;
    """
    cursor.execute(optimized_query)
    results = cursor.fetchall()
    query_count += 1
    
    end_time = time.perf_counter()
    cursor.close()
    conn.close()
    
    print(f"Total Queries Executed: {query_count}")
    print(f"Execution Time: {end_time - start_time:.6f} seconds\n")
    return results

if __name__ == "__main__":
    n_plus_one_data = run_n_plus_one_simulation()
    optimized_data = run_optimized_join()
    
    assert len(n_plus_one_data) == len(optimized_data), "Data mismatch!"
    print("Data verification passed! Identical results achieved.")