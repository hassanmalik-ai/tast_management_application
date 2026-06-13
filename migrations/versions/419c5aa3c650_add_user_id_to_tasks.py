"""add user_id to tasks

Revision ID: 419c5aa3c650
Revises: 44d677ae35c6
Create Date: 2026-06-13 18:27:15.500680

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '419c5aa3c650'
down_revision: Union[str, Sequence[str], None] = '44d677ae35c6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
