import sys
from os.path import abspath, dirname

# This line ensures Python can find your models file in the current directory
sys.path.insert(0, dirname(abspath(__file__)) + "/..")

from logging.config import fileConfig
from sqlalchemy import engine_from_config
from sqlalchemy import pool
from alembic import context

# -------------------------------------------------------------------------
# IMPORT YOUR BASE METADATA HERE
# -------------------------------------------------------------------------
# If your models are in a file named something else (e.g., db.py, database.py),
# change 'from models' to match that filename (e.g., 'from database import Base')
try:
    from models import Base
    target_metadata = Base.metadata
except ImportError:
    try:
        from main import Base
        target_metadata = Base.metadata
    except ImportError:
        raise ImportError(
            "Could not import your 'Base' model. Please change line 17 in "
            "migrations/env.py to point to your SQLAlchemy models file."
        )
# -------------------------------------------------------------------------

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

def run_migrations_offline() -> None:
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()