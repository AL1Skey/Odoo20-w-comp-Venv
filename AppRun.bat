@echo off
cd /D "D:\dev\odoo-20.0"
venv\Scripts\activate
python -m pip install -r requirements.txt
python odoo-bin -c odoo.conf
pause