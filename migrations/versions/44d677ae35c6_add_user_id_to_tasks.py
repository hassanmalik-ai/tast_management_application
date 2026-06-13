"""add user_id to tasks

Revision ID: 44d677ae35c6
Revises: 9ce01bbd19da
Create Date: 2026-06-13 18:20:20.025917

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '44d677ae35c6'
down_revision: Union[str, Sequence[str], None] = '9ce01bbd19da'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.add_column('tasks', sa.Column('user_id', sa.Integer(), nullable=True))
    op.create_foreign_key('fk_tasks_user_id_users', 'tasks', 'users', ['user_id'], ['id'], onupdate='CASCADE')


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_constraint('fk_tasks_user_id_users', 'tasks', type_='foreignkey')
    op.drop_column('tasks', 'user_id')
