/*
20250510(토) 오후 9:02
개선방안:
- 기존 함수는 LIMIT N으로 잘라낸 뒤, COUNT로 정확히 N개인지 조건검사를 하고, MIN으로 값을 추출하는 방식이라 불필요하게 복잡했음.
- DISTINCT + LIMIT 조합으로도 N번째 급여를 얻을 수 있음.
- OFFSET을 사용하면 조건 검사 없이도 정확히 N번째 급여를 직접 조회할 수 있음.
- 따라서 IF문 제거, 서브쿼리 간소화, 가독성과 실행 효율성 모두 향상시킴.
*/
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
     select if(count(salary) = N, min(salary) ,null)
     from (
     select distinct salary
     from employee
     order by salary desc
     limit N) a
  );
END;


CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
set N=N-1;
  RETURN (
    SELECT DISTINCT salary
    FROM employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET N
  );
END;
