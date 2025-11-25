#!/bin/bash
set -xe

DB_ENDPOINT="${DB_ENDPOINT}"
DB_USER="${DB_USER}"
DB_PASS="${DB_PASS}"
DB_NAME="tennisdb"

yum update -y

# Install dependencies
yum install -y python3 python3-pip

# Add PostgreSQL repo
cat << 'EOF' > /etc/yum.repos.d/pgdg.repo
[pgdg15]
name=PostgreSQL 15 for RHEL/CentOS 9 - x86_64
baseurl=https://download.postgresql.org/pub/repos/yum/15/redhat/rhel-9-x86_64
enabled=1
gpgcheck=0
EOF

# Refresh repo cache
yum clean all
yum makecache

# Install PostgreSQL client
yum install -y postgresql15

pip3 install flask psycopg2-binary gunicorn

# Wait for DB to be ready
for i in {1..60}; do
  PGPASSWORD="${DB_PASS}" psql -h "${DB_ENDPOINT}" -U "${DB_USER}" -d "${DB_NAME}" -c "SELECT 1;" && break
  sleep 10
done

# Create schema
cat <<EOF | PGPASSWORD="${DB_PASS}" psql -h "${DB_ENDPOINT}" -U "${DB_USER}" -d "${DB_NAME}"
CREATE TABLE IF NOT EXISTS tennis_players (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    grand_slams INT,
    masters INT,
    total_atp_titles INT,
    olympic_gold INT,
    weeks_at_no1 INT
);
EOF

# Seed data
cat <<EOF | PGPASSWORD="${DB_PASS}" psql -h "${DB_ENDPOINT}" -U "${DB_USER}" -d "${DB_NAME}"
INSERT INTO tennis_players
(name, grand_slams, masters, total_atp_titles, olympic_gold, weeks_at_no1)
VALUES
('Novak Djokovic', 24, 40, 98, 1, 428),
('Roger Federer', 20, 28, 103, 1, 310),
('Rafael Nadal', 22, 36, 92, 1, 209),
('Pete Sampras', 14, 11, 64, 0, 286),
('Bjorn Borg', 11, 3, 64, 0, 109)
ON CONFLICT DO NOTHING;
EOF

# Create app directory and app.py
mkdir -p /opt/tennis

cat << 'EOF' > /opt/tennis/app.py
import os
import psycopg2
from flask import Flask, render_template_string

app = Flask(__name__)

HTML = """<!doctype html>
<title>Tennis GOATs</title>
<h1>Top tennis players by Grand Slams</h1>
<table border="1" cellpadding="6">
<tr>
  <th>Name</th><th>GS</th><th>Masters</th><th>ATP titles</th>
  <th>Olympic Gold</th><th>Weeks No.1</th>
</tr>
{% for p in players %}
<tr>
  <td>{{ p[0] }}</td>
  <td>{{ p[1] }}</td>
  <td>{{ p[2] }}</td>
  <td>{{ p[3] }}</td>
  <td>{{ p[4] }}</td>
  <td>{{ p[5] }}</td>
</tr>
{% endfor %}
</table>
"""

def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ["DB_HOST"],
        dbname=os.environ.get("DB_NAME", "tennisdb"),
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASS"],
        connect_timeout=5,
    )
    return conn

@app.route("/")
def index():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        """
        SELECT name, grand_slams, masters, total_atp_titles,
               olympic_gold, weeks_at_no1
        FROM tennis_players
        ORDER BY grand_slams DESC, weeks_at_no1 DESC;
        """
    )
    players = cur.fetchall()
    cur.close()
    conn.close()
    return render_template_string(HTML, players=players)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
EOF

# Create systemd service
cat <<EOF > /etc/systemd/system/tennis.service
[Unit]
Description=Tennis Demo App
After=network.target

[Service]
WorkingDirectory=/opt/tennis
ExecStart=/usr/local/bin/gunicorn -b 0.0.0.0:80 app:app
Environment=DB_HOST=${DB_ENDPOINT}
Environment=DB_NAME=${DB_NAME}
Environment=DB_USER=${DB_USER}
Environment=DB_PASS=${DB_PASS}
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable tennis
systemctl start tennis
