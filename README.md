# 2025-1-DM_Proj
데이터마이닝 프로젝트


### ./data
* `Bird_strikes.csv` : row가 적은 데이터.
* `database.csv` : 보다 많고 자세함. → main

### 다음에 할 일 → 4/25까지

- y 만들기
    - imbalance가 있다면 smote로 해보기
- eda 하기
- 피처 생성 아이디어가 있으면 기록
    - train 시에 새의 종은 사용하기 어려운 점을 고려하기.

### 참고용 링크
https://nationalzoo.si.edu/migratory-birds/migratory-birds-tracking-table
- Bird ID, 종, 날짜, 위/경도 정보 포함
- 종별로 평균낸 다음 해당 날짜에 어떤 새 군집이 얼마나 가까이 있는지에 대한 변수를 만들 수 있을 것 같다.
https://www.sciencebase.gov/catalog/item/66d9ed16d34eef5af66d534b
- 미국 지질조사국 데이터(Stop50 형식으로 관측했다는데 뭔지 모르겠음)
- 캐나다, 미국 정보 모두 포함, 1966~2023년까지 존재
