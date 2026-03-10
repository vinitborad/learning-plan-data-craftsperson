-- syntax
WITH RECURSIVE cte_name AS (
  -- 1. THE ANCHOR MEMBER
  -- This defines the starting point (e.g., the CEO or the Root Folder)
  SELECT columns FROM table WHERE parent_id IS NULL

  UNION ALL

  -- 2. THE RECURSIVE MEMBER
  -- This joins the table back to the CTE itself to find the next level
  SELECT t.columns 
  FROM table t
  INNER JOIN cte_name c ON t.parent_id = c.id
)
-- 3. THE FINAL SELECT
SELECT * FROM cte_name;


-- employee hierarchy example
WITH RECURSIVE EmployeeHierarchy AS (
  SELECT 
    emp_id, 
    name, 
    manager_id, 
    1 AS level,
    name::TEXT AS path
  FROM employees
  WHERE manager_id IS NULL

  UNION ALL

  SELECT 
    e.emp_id, 
    e.name, 
    e.manager_id, 
    eh.level + 1,
    eh.path || ' -> ' || e.name
  FROM employees e
  INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy ORDER BY level;


-- file system example
WITH RECURSIVE FolderContent AS (
  SELECT id, name, size_kb
  FROM files
  WHERE id = 2

  UNION ALL

  SELECT f.id, f.name, f.size_kb
  FROM files f
  INNER JOIN FolderContent fc ON f.parent_id = fc.id
)
SELECT SUM(size_kb) AS total_folder_size FROM FolderContent;