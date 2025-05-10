/*
20250510(토) 오후 9:56

개선방안:
1. 불필요한 서브쿼리 및 UNION ALL 제거
2. Stocks 테이블을 단 1회만 순회하여 성능 향상
3. CASE WHEN을 사용하여 조건별로 손익 처리
4. 가독성 향상: 더 짧고 명확한 로직
*/

-- 내코드
select stock_name ,  sum(capital_gain_loss) capital_gain_loss

from
(select  stock_name , -1* sum(price) capital_gain_loss
from Stocks
where operation = 'Buy' 
group by stock_name

UNION ALL

select  stock_name , sum(price) capital_gain_loss
from Stocks
where operation = 'Sell' 
group by stock_name) A

group by stock_name


-- 개선된 코드  
SELECT 
    stock_name, 
    SUM(CASE 
            WHEN operation = 'Buy' THEN -price
            WHEN operation = 'Sell' THEN price
            ELSE 0 
        END) AS capital_gain_loss
FROM Stocks
GROUP BY stock_name;
