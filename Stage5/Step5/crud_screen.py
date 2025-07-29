import tkinter as tk
from tkinter import ttk, messagebox
import psycopg2
from db_connection import connect_to_db
# ------------------------------------------------------------
# File: crud_screen.py
# ------------------------------------------------------------
# This module implements the CRUD (Create, Read, Update, Delete)
# operations for managing database tables.
# Features:
#   - Dropdown menu to select a table
#   - Treeview widget to display table data
#   - Buttons to add, edit, delete, and refresh records
# The CRUD screen dynamically fetches table columns and data
# from PostgreSQL and allows real-time data manipulation.
# ------------------------------------------------------------


TABLES = {
    "Content Creator": "content_creator",
    "Contract": "contract",
    "Production": "production",
    "Award": "award",
    "Agent": "agent",
    "FeedBack": "feedback",
    "Datacenters": "datacenters",
    "Servers": "servers",
    "Error Logs": "errorlogs",
    "Maintenance Records": "maintenancerecords",
    "Network Usage": "networkusage",
    "Streaming Sessions": "streamingsessions",
    "Production Deployment": "productiondeployment"
}


class CrudApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Data management (CRUD)")
        self.conn = connect_to_db()

        self.selected_table = tk.StringVar()
        self.selected_table.set("Content Creator")

        tk.Label(root, text="Choose a table :").pack(pady=5)
        tk.OptionMenu(root, self.selected_table, *TABLES.keys(), command=self.load_table).pack()

        self.tree = ttk.Treeview(root)
        self.tree.pack(pady=10, fill=tk.BOTH, expand=True)

        self.btn_frame = tk.Frame(root)
        self.btn_frame.pack(pady=5)

        tk.Button(self.btn_frame, text="🔄 Refresh", command=self.refresh).grid(row=0, column=0, padx=5)
        tk.Button(self.btn_frame, text="➕ Add row", command=self.insert_row).grid(row=0, column=1, padx=5)
        tk.Button(self.btn_frame, text="✏️ Update row", command=self.update_row).grid(row=0, column=2, padx=5)
        tk.Button(self.btn_frame, text="❌ Delete row", command=self.delete_row).grid(row=0, column=3, padx=5)

        self.load_table("Content Creator")

    def load_table(self, table_label):
        for item in self.tree.get_children():
            self.tree.delete(item)

        table = TABLES[table_label]

        try:
            cur = self.conn.cursor()
            cur.execute(f"SELECT * FROM {table}")
            rows = cur.fetchall()
            colnames = [desc[0] for desc in cur.description]

            self.tree["columns"] = colnames
            self.tree["show"] = "headings"
            for col in colnames:
                self.tree.heading(col, text=col)
                self.tree.column(col, width=100)

            for row in rows:
                self.tree.insert("", tk.END, values=row)

            cur.close()
        except Exception as e:
            messagebox.showerror("Error: ", f"Unable to load data : {e}")

    def refresh(self):
        self.load_table(self.selected_table.get())

    def insert_row(self):
        table = TABLES[self.selected_table.get()]

        def submit():
            try:
                cur = self.conn.cursor()
                columns = ", ".join(fields.keys())
                placeholders = ", ".join(["%s"] * len(fields))
                values = [entry.get() for entry in fields.values()]
                cur.execute(
                    f"INSERT INTO {table} ({columns}) VALUES ({placeholders})",
                    values)
                self.conn.commit()
                cur.close()
                popup.destroy()
                self.refresh()
                messagebox.showinfo("Success", "Line inserted.")
            except Exception as e:
                messagebox.showerror("Error", f"Insertion failed : {e}")

        popup = tk.Toplevel()
        popup.title("Add a row")

        cur = self.conn.cursor()
        cur.execute(f"SELECT * FROM {table} LIMIT 1")
        colnames = [desc[0] for desc in cur.description]
        cur.close()

        fields = {}
        for idx, col in enumerate(colnames):
            tk.Label(popup, text=col).grid(row=idx, column=0, padx=5, pady=5)
            entry = tk.Entry(popup)
            entry.grid(row=idx, column=1, padx=5, pady=5)
            fields[col] = entry

        tk.Button(popup, text="Validate", command=submit).grid(
            row=len(colnames), column=0, columnspan=2, pady=10)

    def update_row(self):
        selected = self.tree.selection()
        if not selected:
            messagebox.showwarning("No slection",
                                   "Select a line to edit.")
            return

        table = TABLES[self.selected_table.get()]
        selected_values = self.tree.item(selected[0])["values"]
        colnames = self.tree["columns"]

        def submit():
            try:
                cur = self.conn.cursor()
                set_clause = ", ".join([f"{col} = %s" for col in colnames[1:]])
                values = [fields[col].get() for col in colnames[1:]]
                values.append(
                    fields[colnames[0]].get())
                cur.execute(
                    f"UPDATE {table} SET {set_clause} WHERE {colnames[0]} = %s",
                    values)
                self.conn.commit()
                cur.close()
                popup.destroy()
                self.refresh()
                messagebox.showinfo("Success", "Updated line.")
            except Exception as e:
                messagebox.showerror("Error",
                                     f"Update failed : {e}")

        popup = tk.Toplevel()
        popup.title("Edit a line")

        fields = {}
        for idx, (col, val) in enumerate(zip(colnames, selected_values)):
            tk.Label(popup, text=col).grid(row=idx, column=0, padx=5, pady=5)
            entry = tk.Entry(popup)
            entry.insert(0, val)
            entry.grid(row=idx, column=1, padx=5, pady=5)
            fields[col] = entry

        tk.Button(popup, text="Validate", command=submit).grid(
            row=len(colnames), column=0, columnspan=2, pady=10)

    def delete_row(self):
        selected = self.tree.selection()
        if not selected:
            messagebox.showwarning("No selection", "Select a line to delete.")
            return

        table = TABLES[self.selected_table.get()]
        try:
            cur = self.conn.cursor()
            col_id = self.tree["columns"][0]
            val_id = self.tree.item(selected[0])["values"][0]
            cur.execute(f"DELETE FROM {table} WHERE {col_id} = %s", (val_id,))
            self.conn.commit()
            cur.close()
            self.refresh()
            messagebox.showinfo("Success", "Line deleted.")
        except Exception as e:
            messagebox.showerror("Error", f"Delete failed : {e}")
