
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, Date, Numeric, TIMESTAMP
from sqlalchemy.orm import declarative_base, relationship, sessionmaker, joinedload
from datetime import datetime
from urllib.parse import quote_plus

# =============================================================================
# Database Configuration & Engine Setup (Pointing purely to college_db_orm)
# =============================================================================
pwd = quote_plus("Gopal@12345")
url = f"mysql+mysqlconnector://root:{pwd}@localhost:3306/college_db"
engine = create_engine(url, echo=True) # Enabling logger auditing configuration

Base = declarative_base()

# =============================================================================
# Structural Model Mapping Declarations
# =============================================================================
class Department(Base):
    __tablename__ = 'departments'
    department_id = Column(Integer, primary_key=True, autoincrement=True)
    dept_name = Column(String(100), nullable=False)

class Student(Base):
    __tablename__ = 'students'
    student_id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    phone_number = Column(String(11))
    department_id = Column(Integer, ForeignKey('departments.department_id'))

class Course(Base):
    __tablename__ = 'courses'
    course_id = Column(Integer, primary_key=True, autoincrement=True)
    course_name = Column(String(150), nullable=False)
    course_code = Column(String(20), unique=True)

class Enrollment(Base):
    __tablename__ = 'enrollments'
    enrollment_id = Column(Integer, primary_key=True, autoincrement=True)
    student_id = Column(Integer, ForeignKey('students.student_id'))
    course_id = Column(Integer, ForeignKey('courses.course_id'))
    grade = Column(String(2))
    
    student = relationship("Student")
    course = relationship("Course")

# =============================================================================
# Execution Block Routine
# =============================================================================
if __name__ == "__main__":
    # Ensure tables are built fresh inside college_db_orm
    Base.metadata.create_all(engine)
    
    Session = sessionmaker(bind=engine)
    session = Session()

    # Seed mock rows if the database workspace tables are empty
    if session.query(Enrollment).count() == 0:
        print("\n[INFO] Seeding data records for N+1 validation layout...")
        stu = Student(first_name="Gopal", last_name="P", email="gopal@test.com", phone_number="9856325895")
        crs = Course(course_name="Computer Science", course_code="CS101")
        session.add_all([stu, crs])
        session.commit()
        
        enr = Enrollment(student_id=stu.student_id, course_id=crs.course_id, grade="A")
        session.add(enr)
        session.commit()

    # -------------------------------------------------------------------------
    # 87. Lazy Query Execution (Triggers the N+1 problem)
    # -------------------------------------------------------------------------
    print("\n" + "="*80)
    print("RUNNING STEP 87: IDENTIFYING THE N+1 QUERY (LAZY LOADING)")
    print("="*80 + "\n")

    lazy_enrollments = session.query(Enrollment).all()

    print("\n--- [START] Looping through lazy results (Watch extra SELECT statements print) ---")
    for e in lazy_enrollments:
        print(f"[OUTPUT] Enrollment ID: {e.enrollment_id} | Student: {e.student.first_name} | Course: {e.course.course_name}")
    print("--- [END] Lazy loading loop completed ---")

    # -------------------------------------------------------------------------
    # 88 & 89. Optimized Query Execution using joinedload (Exactly 1 Query)
    # -------------------------------------------------------------------------
    print("\n" + "="*80)
    print("RUNNING STEPS 88 & 89: FIXING N+1 USING JOINEDLOAD (EAGER LOADING)")
    print("="*80 + "\n")

    eager_enrollments = (
        session.query(Enrollment)
        .options(
            joinedload(Enrollment.student), 
            joinedload(Enrollment.course)
        )
        .all()
    )

    print("\n--- [START] Looping through eager results (No extra queries triggered) ---")
    for e in eager_enrollments:
        print(f"[OUTPUT] Enrollment ID: {e.enrollment_id} | Student: {e.student.first_name} | Course: {e.course.course_name}")
    print("--- [END] Eager loading loop completed ---")

    session.close()