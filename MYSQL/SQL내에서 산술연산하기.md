

## **1. 직접 산술 연산이 가능한 경우**
### **(1) WHERE, SELECT, HAVING 등 일반 SQL 절**
```sql
SELECT salary FROM employee WHERE id = N - 1;  -- 가능
SELECT N - 1 AS offset_value;                 -- 가능
```
→ 대부분의 SQL 절에서는 변수 연산이 허용.

### **(2) PREPARED STATEMENT (동적 SQL)**
```sql
SET @sql = CONCAT('SELECT salary FROM employee LIMIT ', N-1, ', 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
```
→ 문자열로 쿼리를 조합하면 연산 가능 (함수 내에서는 비권장).

---

## **2. 직접 산술 연산이 불가능한 경우 (변수로 미리 계산 필요)**
### **(1) LIMIT 절에서 변수 연산**
```sql
-- 오류 발생 (X)
SELECT salary FROM employee LIMIT N-1, 1;

-- 정상 작동 (O)
SET @offset = N - 1;
SELECT salary FROM employee LIMIT @offset, 1;
```
→ **`LIMIT`에서는 변수 연산 불가능**, 반드시 미리 계산된 변수 사용.

### **(2) OFFSET 절에서 변수 연산 (MySQL 8.0+)**
```sql
-- 오류 발생 가능 (X)
SELECT salary FROM employee LIMIT 1 OFFSET N-1;

-- 정상 작동 (O)
SET @offset = N - 1;
SELECT salary FROM employee LIMIT 1 OFFSET @offset;
```
→ `OFFSET`도 `LIMIT`과 동일한 제약 적용.

---

## **3. 함수 내에서 안전하게 사용하는 방법**
```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  DECLARE offset_val INT;
  SET offset_val = N - 1;  -- 변수로 계산 후 사용
  
  RETURN (
    SELECT DISTINCT salary
    FROM employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET offset_val  -- 계산된 변수 사용
  );
END;
```
→ **함수 내에서는 변수 연산을 미리 처리**하는 것이 안전.

---

## **결론**
- **`WHERE`, `SELECT` 등 일반 SQL 절** → 직접 연산 가능  
- **`LIMIT`, `OFFSET`** → **변수 연산 불가능**, 반드시 미리 계산 후 변수로 전달  
- **함수 내에서는 변수 계산을 미리 수행**하는 것이 안정적  
