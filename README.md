# Netflix Content Creators Database Project

## Table of Contents
- [Introduction](#introduction)
- [Stage 1 – Schema Design, Creation & Data Insertion](#stage-1--schema-design-creation--data-insertion)  
  - [Diagrams](#diagrams)
  - [Database Creation & Basic SQL Commands](#database-creation--basic-sql-commands)
  - [Data Insertion](#data-insertion)
  - [Backup](#backup1)
- [Stage 2 – Advanced Queries and Constraints](#stage-2--advanced-queries-and-constraints)
  - [Queries](#queries)
  - [RollbackCommit](#rollbackcommit)
  - [Constraints](#constraints)
  - [Backup](#backup2)
---

## Introduction
This project aims to design and implement a relational database system for managing **Netflix content creators** and their related data. The system includes entities such as content creators, agents, contracts, productions, awards, and user feedback.  
The goal is to apply database design principles (up to 3NF), execute SQL operations, and demonstrate multi-method data insertion.

---

## Stage 1 – Schema Design, Creation & Data Insertion

### Diagrams

- **[ERD (Entity-Relationship Diagram)](Stage1/Diagrams/ERD_Diagram.png)**  
  _Link to ERD diagram file or image_

- **[DSD (Detailed Schema Diagram)](Stage1/Diagrams/DSD_Diagram.png)**  
  _Link to DSD document or image_

---

### Database Creation & Basic SQL Commands

- **[CREATE](Stage1/SQL_Programming/CreateTable)**  
  _SQL script for creating the database schema_

- **[INSERT](Stage1/SQL_Programming/InsertTable)**  
  _SQL script with manual data insertions_

- **[SELECT](Stage1/SQL_Programming/SelectTable)**  
  _Examples of SELECT queries (coming soon)_

- **[DROP](Stage1/SQL_Programming/DropTable)**  
  _SQL script for dropping tables_

---

### Data Insertion

- **[Python Script](Stage1/seed_data/Python._Programming/Insert_Data.py)**  
  _Automated data generation using Python_

- **[SQL INSERT](Stage1/seed_data/SQL_Script)**  
  _Manual SQL-based insertion_

- **[CSV Files](Stage1/seed_data/Filesmockaroo)**  
  _Data import from structured CSVs_

---

### Backup1

- **[Database Backup](Stage1/Backup/Backup080525_0045)**  
  _backup file_

---

## Stage 2 – Advanced Queries and Constraints

### Queries 

#### Select Queries

- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._


#### Update Queries

- **[Before Deletion](Stage2/Queries/update_queries/update_contracts_payment_old_active_creators.sql)**  
  _Initial state of the `Feedback` table before executing the DELETE command._

- **[Before Deletion](Stage2/Queries/update_queries/update_genre_high_feedback_productions.sql)**  
  _Initial state of the `Feedback` table before executing the DELETE command._

- **[Before Deletion](Stage2/Queries/update_queries/update_production_rating_low_feedback_old_releases.sql)**  
  _Initial state of the `Feedback` table before executing the DELETE command._


#### Delete Queries

- **[Before Deletion](Stage2/Queries/delete_queries/delete_agents_with_no_creators.sql)**  
  _Initial state of the `Feedback` table before executing the DELETE command._

- **[Before Deletion](Stage2/Queries/delete_queries/delete_august_feedbacks_with_low_rating.sql)**  
  _Initial state of the `Feedback` table before executing the DELETE command._

- **[Before Deletion](Stage2/Queries/delete_queries/delete_feedbacks_with_low_rating_older_than_3_years.sql)**  
  _Initial state of the `Feedback` table before executing the DELETE command._


---

### RollbackCommit
_This section demonstrates the effect of DELETE operations with and without COMMIT, using ROLLBACK to undo changes or confirm that changes are irreversible._ 


#### Rollback

- **[Before Deletion](Stage2/RollbackCommit/Rollback/before_deletion_1.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._

- **[DELETE Executed](Stage2/RollbackCommit/Rollback/Delete_command_2.jpeg)**  
  _The SQL query used to delete all feedback with a rating below 2 and older than 3 years._

- **[After Deletion](Stage2/RollbackCommit/Rollback/3_after_deletion_before_rollback.jpeg)**  
  _Database state after executing the DELETE command and before the ROLLBACK._

- **[Rollback Executed](Stage2/RollbackCommit/Rollback/4_rollback_executed.jpeg)**  
  _Execution of the ROLLBACK command to undo the deletion._

- **[After Rollback](Stage2/RollbackCommit/Rollback/5_after_rollback.jpeg)**  
  _Final state of the table showing that the deleted feedback rows were successfully restored._


#### Commit

- **[Before Deletion](Stage2/RollbackCommit/Commit/before_deletion_commit_1.jpeg)**  
  _Initial state of the `Agent` table before executing the DELETE command._

- **[DELETE Executed](Stage2/RollbackCommit/Commit/Delete_command_commit_2.jpeg)**  
  _The SQL query used to delete all agents who are not assigned to any content creator._

- **[After Deletion](Stage2/RollbackCommit/Commit/after_deletion_before_commit_3.jpeg)**  
  _Database state after executing the DELETE command and before issuing the COMMIT._

- **[Commit Executed](Stage2/RollbackCommit/Commit/commit_executed_4.jpeg)**  
  _Execution of the COMMIT command to make the deletion permanent._

- **[Rollback Attempted](Stage2/RollbackCommit/Commit/after_commit_attempted_rollback_5.jpeg)**  
  _Attempted rollback after commit – no data was restored, as expected._

- **[Final State After Commit](Stage2/RollbackCommit/Commit/final_state_after_commit_6.jpeg)**  
  _Final state of the `Agent` table confirming that the deleted records were permanently removed._

---

### constraints

---

### Backup2

- **[Database Backup](Stage1/Backup/Backup080525_0045)**  
 _backup file_
---
