import tkinter as tk
from tkinter import messagebox
from crud_screen import CrudApp
from query_function_screen import QueryFunctionApp


def open_crud_screen():
    crud_window = tk.Toplevel()
    app = CrudApp(crud_window)


def open_query_function_screen():
    win = tk.Toplevel()
    QueryFunctionApp(win)


def launch_dashboard():
    root = tk.Tk()
    root.title("Dashboard")
    root.geometry("400x300")

    tk.Label(root, text="Welcome to the management interface", font=("Arial", 14)).pack(pady=20)
    tk.Button(root, text="🔧 Data managment (CRUD)", command=open_crud_screen, width=30).pack(pady=10)
    tk.Button(root, text="📊 Queries / Functions / Procedures", command=open_query_function_screen, width=30).pack(pady=10)
    tk.Button(root, text="🚪 Exit", command=root.quit, width=30).pack(pady=10)

    root.mainloop()
