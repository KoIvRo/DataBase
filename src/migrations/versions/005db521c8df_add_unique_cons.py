"""add unique cons

Revision ID: 005db521c8df
Revises: 464ccdd0262a
Create Date: 2026-04-16 20:15:30.653236

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '005db521c8df'
down_revision: Union[str, Sequence[str], None] = '464ccdd0262a'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
