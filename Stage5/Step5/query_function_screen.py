import tkinter as tk
from tkinter import ttk, messagebox
import psycopg2
from db_connection import connect_to_db


class QueryFunctionApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Queries / Functions / Procedures")
        self.conn = connect_to_db()

        # Dictionaries with queries and functions
        self.queries = {
            "1. Update payment of former active creators": """
                UPDATE Contract
                SET Payment = Payment * 1.1
                WHERE CreatorID IN (
                    SELECT CreatorID
                    FROM Content_Creator
                    WHERE IsActive = TRUE
                )
                AND EXTRACT(YEAR FROM StartDate) <= EXTRACT(YEAR FROM CURRENT_DATE) - 5;
            """,
            "2. Changing the genre of good feedback productions": """
                UPDATE Production
                SET Genre = 'על טבעי'
                WHERE ProductionID IN (
                    SELECT P.ProductionID
                    FROM Production P
                    JOIN Feedback F ON P.ProductionID = F.ProductionID
                    GROUP BY P.ProductionID
                    HAVING AVG(F.FeedbackRating) > 5
                );
            """,
            "3. Reduce the rating of old, poorly rated productions": """
                UPDATE Production
                SET ProductionRating = ProductionRating * 0.9
                WHERE ProductionID IN (
                    SELECT P.ProductionID
                    FROM Production P
                    JOIN Feedback F ON P.ProductionID = F.ProductionID
                    WHERE EXTRACT(YEAR FROM P.ReleaseDate) <= EXTRACT(YEAR FROM CURRENT_DATE) - 10
                    GROUP BY P.ProductionID
                    HAVING AVG(F.FeedbackRating) < 6
                );
            """,
            "4. Delete agents without creators": """
                DELETE FROM Agent
                WHERE AgentID NOT IN (
                    SELECT DISTINCT AgentID FROM Content_Creator
                    WHERE AgentID IS NOT NULL
                );
            """,
            "5. Delete feedbacks August with rating < 4": """
                DELETE FROM Feedback
                WHERE EXTRACT(MONTH FROM FeedbackDate) = 8
                AND FeedbackRating < 4;
            """,
            "6. Delete feedbacks < 2 and 3 years old": """
                DELETE FROM Feedback
                WHERE FeedbackRating < 2
                AND FeedbackDate < CURRENT_DATE - INTERVAL '3 years';
            """,
            "7. Number of active creators per agent": """
                SELECT
                    A.AgentFullName,
                    COUNT(CC.CreatorID) AS ActiveCreators
                FROM Agent A
                JOIN Content_Creator CC ON A.AgentID = CC.AgentID
                WHERE CC.IsActive = TRUE
                GROUP BY A.AgentFullName
                ORDER BY ActiveCreators DESC;
            """,
            "8. Agents with multiple active creators": """
                SELECT
                    A.AgentFullName,
                    COUNT(CC.CreatorID) AS ActiveCreators
                FROM Agent A
                JOIN Content_Creator CC ON A.AgentID = CC.AgentID
                WHERE CC.IsActive = TRUE
                GROUP BY A.AgentFullName
                ORDER BY ActiveCreators DESC;
            """,
            "9. Agents with top creators (feedback > 8)": """
                SELECT
                    A.AgentFullName,
                    COUNT(DISTINCT CC.CreatorID) AS TopCreatorsCount
                FROM Agent A
                JOIN Content_Creator CC ON A.AgentID = CC.AgentID
                JOIN Contract C ON CC.CreatorID = C.CreatorID
                JOIN Production P ON C.ProductionID = P.ProductionID
                JOIN Feedback F ON P.ProductionID = F.ProductionID
                WHERE EXTRACT(YEAR FROM F.FeedbackDate) >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
                GROUP BY A.AgentFullName
                HAVING AVG(F.FeedbackRating) > 8
                ORDER BY TopCreatorsCount DESC;
            """,
            "10. Average grades by type and year": """
                SELECT
                    ProductionType,
                    EXTRACT(YEAR FROM ReleaseDate) AS ReleaseYear,
                    AVG(ProductionRating) AS AverageRating
                FROM Production
                GROUP BY ProductionType, EXTRACT(YEAR FROM ReleaseDate)
                ORDER BY AverageRating DESC;
            """,
            "11. Select average payment per month per creator": """
                SELECT
                    CC.Content_CreatorFullName,
                    EXTRACT(YEAR FROM C.StartDate) AS StartYear,
                    EXTRACT(MONTH FROM C.StartDate) AS StartMonth,
                    ROUND(AVG(C.Payment), 2) AS AvgPayment
                FROM Contract C
                JOIN Content_Creator CC ON C.CreatorID = CC.CreatorID
                GROUP BY CC.Content_CreatorFullName, EXTRACT(YEAR FROM C.StartDate), EXTRACT(MONTH FROM C.StartDate)
                ORDER BY AvgPayment DESC;
            """,
            "12. Select award winners with no recent contract": """
                SELECT DISTINCT
                    CC.Content_CreatorFullName,
                    CC.JoinDate,
                    A.AwardName,
                    A.AwardYear
                FROM Content_Creator CC
                JOIN Award A ON CC.CreatorID = A.CreatorID
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM Contract C
                    WHERE C.CreatorID = CC.CreatorID
                      AND EXTRACT(YEAR FROM C.EndDate) >= EXTRACT(YEAR FROM CURRENT_DATE) - 3
                )
                ORDER BY A.AwardYear DESC;
            """,
            "13. Select number of contracts per creator per year": """
                SELECT
                    CC.Content_CreatorFullName,
                    A.AgentFullName,
                    EXTRACT(YEAR FROM C.StartDate) AS ContractYear,
                    COUNT(C.ContractID) AS NumContracts,
                    SUM(C.Payment) AS TotalPayments
                FROM Contract C
                JOIN Content_Creator CC ON C.CreatorID = CC.CreatorID
                LEFT JOIN Agent A ON CC.AgentID = A.AgentID
                GROUP BY CC.Content_CreatorFullName, A.AgentFullName, EXTRACT(YEAR FROM C.StartDate)
                ORDER BY TotalPayments DESC;
            """,
            "14. Select creators in productions released this year": """
                SELECT DISTINCT
                    CC.Content_CreatorFullName,
                    P.Title,
                    P.ReleaseDate
                FROM Content_Creator CC
                JOIN Contract C ON CC.CreatorID = C.CreatorID
                JOIN Production P ON C.ProductionID = P.ProductionID
                WHERE EXTRACT(YEAR FROM P.ReleaseDate) = EXTRACT(YEAR FROM CURRENT_DATE);
            """,
            "15. Select productions with high feedback and rating": """
                SELECT
                    P.Title,
                    P.ProductionRating,
                    AVG(F.FeedbackRating) AS AverageFeedback
                FROM Production P
                JOIN Feedback F ON P.ProductionID = F.ProductionID
                GROUP BY P.Title, P.ProductionRating
                HAVING AVG(F.FeedbackRating) > 8.0 AND P.ProductionRating > 7.5
                ORDER BY AverageFeedback DESC;
            """,
            "16. Select productions with negative feedback": """
                SELECT
                    P.Title,
                    F.FeedbackRating,
                    F.FeedbackComment,
                    F.FeedbackDate
                FROM Production P
                JOIN Feedback F ON P.ProductionID = F.ProductionID
                WHERE F.FeedbackRating <= 6
                ORDER BY F.FeedbackDate DESC;
            """,
            "17. Select released productions with ratings and feedback": """
                SELECT
                    P.Title,
                    P.ReleaseDate,
                    P.ProductionRating,
                    ROUND(AVG(F.FeedbackRating), 2) AS AvgFeedback
                FROM Production P
                JOIN Feedback F ON P.ProductionID = F.ProductionID
                GROUP BY P.Title, P.ReleaseDate, P.ProductionRating
                ORDER BY AvgFeedback DESC;
            """,
            "18. Select summer productions with high rating and feedback": """
                SELECT
                    P.Title,
                    P.ReleaseDate,
                    P.ProductionRating,
                    ROUND(AVG(F.FeedbackRating), 2) AS AvgFeedback
                FROM Production P
                JOIN Feedback F ON P.ProductionID = F.ProductionID
                WHERE EXTRACT(MONTH FROM P.ReleaseDate) BETWEEN 6 AND 8
                  AND P.ProductionRating > 8
                GROUP BY P.Title, P.ReleaseDate, P.ProductionRating
                ORDER BY AvgFeedback DESC;
            """
        }

        self.functions = {
            "calculate_total_payments_for_active_creators": """
                SELECT * FROM calculate_total_payments_for_active_creators();
            """,
            "get_server_error_summary": """
                        SELECT * FROM get_server_error_summary();

            """
        }

        self.procedures = {
            "delete_old_feedbacks_and_count": "CALL public.delete_old_feedbacks_and_count()",
            "update_server_status_by_network": "CALL update_server_status_by_network()"
        }

        self.selected_query = None
        self.selected_function = None
        self.selected_procedure = None

        self.setup_ui()

    def setup_ui(self):
        frame = tk.Frame(self.root)
        frame.pack(pady=10, padx=10, fill=tk.BOTH, expand=True)

        # Queries
        query_frame = tk.Frame(frame)
        query_frame.pack(side=tk.LEFT, padx=10, fill=tk.BOTH, expand=True)

        tk.Label(query_frame, text="Available SQL queries").pack()
        self.query_listbox = tk.Listbox(query_frame, height=6)
        for key in self.queries:
            self.query_listbox.insert(tk.END, key)
        self.query_listbox.pack(fill=tk.BOTH, expand=True)
        self.query_listbox.bind("<<ListboxSelect>>", self.on_query_select)

        # Functions
        func_frame = tk.Frame(frame)
        func_frame.pack(side=tk.LEFT, padx=10, fill=tk.BOTH, expand=True)

        tk.Label(func_frame, text="Available Functions/Procedures").pack()
        self.function_listbox = tk.Listbox(func_frame, height=6)
        for key in self.functions:
            self.function_listbox.insert(tk.END, key)
        self.function_listbox.pack(fill=tk.BOTH, expand=True)
        self.function_listbox.bind("<<ListboxSelect>>", self.on_function_select)

        # Procedures
        proc_frame = tk.Frame(frame)
        proc_frame.pack(side=tk.LEFT, padx=10, fill=tk.BOTH, expand=True)

        tk.Label(proc_frame, text="Procedures").pack()
        self.procedure_listbox = tk.Listbox(proc_frame, height=6)
        for key in self.procedures:
            self.procedure_listbox.insert(tk.END, key)
        self.procedure_listbox.pack(fill=tk.BOTH, expand=True)
        self.procedure_listbox.bind("<<ListboxSelect>>",
                                    self.on_procedure_select)

        # run and reset button
        button_frame = tk.Frame(self.root)
        button_frame.pack(pady=5)

        tk.Button(button_frame, text="🚀 EXECUTE",
                  command=self.execute_selected).pack(side=tk.LEFT, padx=10)
        tk.Button(button_frame, text="🧹 Clear Output",
                  command=self.clear_output).pack(side=tk.LEFT, padx=10)

        # Exit button
        self.output_frame = tk.Frame(self.root)
        self.output_frame.pack(pady=10, fill=tk.BOTH, expand=True)

        self.tree = ttk.Treeview(self.output_frame)
        self.tree.pack(fill=tk.BOTH, expand=True)

    def on_query_select(self, event):
        self.selected_query = self.query_listbox.get(self.query_listbox.curselection())
        self.selected_function = None
        self.function_listbox.selection_clear(0, tk.END)

    def on_function_select(self, event):
        self.selected_function = self.function_listbox.get(self.function_listbox.curselection())
        self.selected_query = None
        self.query_listbox.selection_clear(0, tk.END)

    def on_procedure_select(self, event):
        selection = self.procedure_listbox.curselection()
        if selection:
            self.selected_procedure = self.procedure_listbox.get(selection)
            self.selected_function = None
            self.selected_query = None
            self.query_listbox.selection_clear(0, tk.END)
            self.function_listbox.selection_clear(0, tk.END)

    def execute_selected(self):
        self.clear_output()

        query_text = None

        if self.selected_query:
            query_text = self.queries[self.selected_query].strip()
        elif self.selected_function:
            query_text = self.functions[self.selected_function].strip()
        elif self.selected_procedure:
            query_text = self.procedures[self.selected_procedure].strip()
        else:
            messagebox.showwarning("No selection",
                                   "Please select a query, function, or procedure to execute.")
            return

        try:
            cur = self.conn.cursor()

            # Special function management with cursor
            if self.selected_function == "get_server_error_summary":
                cur.execute("BEGIN;")
                cur.execute("SELECT get_server_error_summary();")
                fetch_cur = self.conn.cursor()
                fetch_cur.execute("FETCH ALL IN error_summary_cursor;")
                rows = fetch_cur.fetchall()
                columns = [desc[0] for desc in fetch_cur.description]
                fetch_cur.close()
                cur.execute("COMMIT;")

            # SELECT management (simple queries or functions that return results)
            elif query_text.lower().startswith("select"):
                cur.execute(query_text)
                rows = cur.fetchall()
                columns = [desc[0] for desc in cur.description]

            # Procedure management
            elif self.selected_procedure:
                if self.selected_procedure == "delete_old_feedbacks_and_count":
                    cur.execute("CALL delete_old_feedbacks_and_count(%s);",
                                (None,))
                else:
                    cur.execute(query_text)
                self.conn.commit()
                cur.close()
                messagebox.showinfo("Success",
                                    f" Procedure '{self.selected_procedure}' executed successfully.")
                return

            # Management of action queries (UPDATE / DELETE / INSERT)
            else:
                cur.execute(query_text)
                self.conn.commit()
                cur.close()
                messagebox.showinfo("Success",
                                    " Operation executed successfully.")
                return  # pas besoin d'affichage

            # Display if result available
            if not rows:
                self.output_text.insert(tk.END,
                                        " Executed successfully — no data to show.")
                cur.close()
                return

            self.tree["columns"] = columns
            self.tree["show"] = "headings"
            for col in columns:
                self.tree.heading(col, text=col)
                self.tree.column(col, width=120)
            for row in rows:
                self.tree.insert("", tk.END, values=row)

            cur.close()

        except Exception as e:
            messagebox.showerror("Execution Error", str(e))

    def clear_output(self):
        for item in self.tree.get_children():
            self.tree.delete(item)
        self.tree["columns"] = []

