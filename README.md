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

- **[Count Active Creators per Agent](Stage2/Queries/select_queries/select_active_creators_per_agent.sql)**  
  _This query identifies agents managing at least two currently active creators who have, on average, been with them for at least two years,
  and ranks these agents by the average duration of their creators' affiliation._
  
- **[Agents with Multiple Active Creators](Stage2/Queries/select_queries/select_agents_with_multiple_active_creators.sql)**  
  _Lists agents representing multiple active content creators._
  
- **[Agents with Top Creators](Stage2/Queries/select_queries/select_agents_with_top_creators.sql)**  
  _Lists agents with creators averaging feedback rating above 8 in 5 years._
  
- **[Average Ratings by Type and Year](Stage2/Queries/select_queries/select_average_ratings_by_type_and_year.sql)**  
  _Calculates average production ratings by type and release year._
  
- **[Average Payment per Month](Stage2/Queries/select_queries/select_avg_payment_per_month.sql)**  
  _Calculates average monthly payment for each content creator._
  
- **[Award Winners Without Recent Contracts](Stage2/Queries/select_queries/select_award_winners_no_recent_contract.sql)**  
  _This query selects active content creators who have received at least one award but have not been involved in any contracts in the past three years, showing their name, join date, award name, and award year._
  
- **[Contracts and Payments per Creator Year](Stage2/Queries/select_queries/select_contracts_per_creator_year_.sql)**  
  _Summarizes number of contracts and total payments by creator per year._
  
- **[Creators in This Year’s Productions](Stage2/Queries/select_queries/select_creators_in_productions_this_year.sql)**  
  _Lists creators involved in productions released this year._
  
- **[High Feedback and Rated Productions](Stage2/Queries/select_queries/select_productions_with_high_feedback_and_rating.sql)**  
  _Select productions with average feedback greater than 8 and rating greater than 7.5._

- **[Genres with Negative Feedback](Stage2/Queries/select_queries/select_genres_with_negative_feedback.sql)**  
  _This query identifies genres with at least 3 negative reviews (ratings ≤ 6), showing the average rating and total count of such feedback,
  sorted by lowest average rating._

- **[Summer High-Rated Productions](Stage2/Queries/select_queries/select_summer_high_rated_productions.sql)**  
  _Lists summer releases with production rating above 8 and their average feedback._


#### Update Queries

- **[Update Old Active Contracts](Stage2/Queries/update_queries/update_contracts_payment_old_active_creators.sql)**  
  _Increases payment by 10% for active creators with old contracts._

- **[Update Genre for High-Rated Productions](Stage2/Queries/update_queries/update_genre_high_feedback_productions.sql)**  
  _Sets genre to "על טבעי" for productions with average rating greater than 5._

- **[Downgrade Ratings for Old Low-Rated Productions](Stage2/Queries/update_queries/update_production_rating_low_feedback_old_releases.sql)**  
  _Reduces rating by 10% for old productions with low feedback._


#### Delete Queries

- **[Delete Agents Without Linked Creators](Stage2/Queries/delete_queries/delete_agents_with_no_creators.sql)**  
  _Deletes agents not associated with any content creators._

- **[Delete Low-Rated August Feedbacks](Stage2/Queries/delete_queries/delete_august_feedbacks_with_low_rating.sql)**  
  _Deletes feedbacks from August with a rating below 4._

- **[Delete Old Low Feedbacks](Stage2/Queries/delete_queries/delete_feedbacks_with_low_rating_older_than_3_years.sql)**  
  _Deletes feedbacks rated below 2 and older than 3 years._


---

### RollbackCommit
_This section demonstrates the effect of DELETE operations with and without COMMIT, using ROLLBACK to undo changes or confirm that changes are irreversible._ 


#### Rollback

- **[Rollback Script – Feedback Deletion](Stage2/RollbackCommit/Rollback/Rollback.sql)**  
   _Deletes all feedback with a rating below 2 and older than 3 years. This action is followed by a ROLLBACK_
  
- **[Before Deletion](Stage2/RollbackCommit/Rollback/1_before_deletion.jpeg)**  
  _Initial state of the `Feedback` table before executing the DELETE command._

- **[DELETE Executed](Stage2/RollbackCommit/Rollback/2_Delete_command.jpeg)**  
  _The SQL query used to delete all feedback with a rating below 2 and older than 3 years._

- **[After Deletion](Stage2/RollbackCommit/Rollback/3_after_deletion_before_rollback.jpeg)**  
  _Database state after executing the DELETE command and before the ROLLBACK._

- **[Rollback Executed](Stage2/RollbackCommit/Rollback/4_rollback_executed.jpeg)**  
  _Execution of the ROLLBACK command to undo the deletion._

- **[After Rollback](Stage2/RollbackCommit/Rollback/5_after_rollback.jpeg)**  
  _Final state of the table showing that the deleted feedback rows were successfully restored._


#### Commit

- **[Commit Script – Agent Deletion](Stage2/RollbackCommit/Commit/delete_Commit_And_Rollback_demo.sql)**    
   _Deletes all agents not assigned to any content creator. This action is followed by a COMMIT._  
- **[Before Deletion](Stage2/RollbackCommit/Commit/1_before_deletion_commit.jpeg)**  
  _Initial state of the `Agent` table before executing the DELETE command._

- **[DELETE Executed](Stage2/RollbackCommit/Commit/2_Delete_command_commit.jpeg)**  
  _The SQL query used to delete all agents who are not assigned to any content creator._

- **[After Deletion](Stage2/RollbackCommit/Commit/3_after_deletion_before_commit.jpeg)**  
  _Database state after executing the DELETE command and before issuing the COMMIT._

- **[Commit Executed](Stage2/RollbackCommit/Commit/4_commit_executed.jpeg)**  
  _Execution of the COMMIT command to make the deletion permanent._

- **[Rollback Attempted](Stage2/RollbackCommit/Commit/5_after_commit_attempted_rollback.jpeg)**  
  _Attempted rollback after commit – no data was restored, as expected._

- **[Final State After Commit](Stage2/RollbackCommit/Commit/6_final_state_after_commit.jpeg)**  
  _Final state of the `Agent` table confirming that the deleted records were permanently removed._

---

### constraints
**_This stage was critical to maintaining database reliability by enforcing data validity rules and preventing inconsistent entries._**  
  In this stage, several constraints were added to ensure data integrity and consistency within the database. Initially, SELECT queries were executed to identify any existing records that violated the intended constraints. Where necessary, these records were updated with default or corrected values to maintain data validity before the constraints were enforced.

The implemented constraints include:

- **Check constraint on `Feedback.FeedbackRating`** — values are restricted between 1 and 10; invalid ratings were updated to the default value of 5.0.
- **Default value for `Feedback.FeedbackDate`** — missing dates were set to the current date, and a default of `CURRENT_DATE` was established.
- **Positive payment constraint on `Contract.Payment`** — negative payment values were corrected to zero, and a check constraint was added to prevent negative values.
- **Date order constraint on `Contract`** — `EndDate` must be later than `StartDate`; invalid dates were adjusted to be 30 days after the start date.
- **Valid year range on `Award.AwardYear`** — values are limited between the year 1900 and the current date; invalid years were updated to the current date.
- **NOT NULL constraint on `Agent.Email`** — null email values were replaced with a default email before enforcing the constraint.
- **Check constraint on `Production.ProductionRating`** — ratings must be between 0 and 10; invalid ratings were updated to 5.0.
- **Default value for `Feedback.FeedbackRating`** — a default rating of 5.0 was set.

All constraints were implemented via `ALTER TABLE` statements adding `CHECK`, `DEFAULT`, and `NOT NULL` constraints, following the correction of existing data where necessary to comply with the new rules.

For full details, [see thee Constraints SQL script](Stage2/Constraints/CheckAndFixConstraints.sql).


---

### Backup2

- **[Database Backup](Stage2/Backup2/Backup1505_1917)**  
 _backup file_
---
