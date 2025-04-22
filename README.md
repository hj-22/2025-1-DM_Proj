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
- 캐나다, 미국 정보 모두 포함, 1966~2023년까지 존재 (여름철에 한번씩만 조사)
- 우리가 참고할 만한 파일은 MigrantsNonBreeder.zip
- 각 route의 좌표 정보는 Routes.csv에 명기됨

https://science.ebird.org/en/use-ebird-data/download-ebird-data-products
- eBird 데이터(코넬대...)
- R auk 패키지로 읽을 수 있음
- 2002년쯤부터 현재까지 있다고 한다(확인필요)

### 결측치 처리
- TIME_OF_DAY
  - TIME, MONTH, DATE, 좌표 기반으로 KNN
    - TIME이 없는 건?
      - 삭제하거나,
      - TIME을 빼고 전체 데이터로 돌려본다.
- weather (SKY, PRECIPITATION)
  - 아마 PRECIPITATION이 NaN이면 비가 안왔을 가능성이 높다. (0으로 처리)
  - sky의 경우는, 날짜와 좌표 기반으로 데이터를 추가적으로 찾아서 넣기.
    - 정 안되면 0으로
  - NUM_ENGS, AC_MASS는 비행기 정보로부터 추론

### 그 밖에
- TIME 버리고 TIME_OF_DAY만 쓰기
- AIRCRAFT는 분해해서 AMA랑 AMO로 쓰기
  - 추가 데이터로 서치?
  - 안쓸수도 있다.
      - (250422) AMA, AMO의 코드 테이블을 찾지 못함. 대신 기종별 정보가 있는 테이블을 찾았는데, 여기서 Manufacturer와 모델을 뽑아서 쓰면 될 것 같음. 
- AC_CLASS에서 (balloon처럼) 소수 카테고리는 그냥 제거.
- ENG_POS 계열은 유의미할지 잘 모르겠다.
  - 가능하면 버리고 싶다.
- DAMAGE_LEVEL을 그대로 쓸지?
  - 아니면 Y 만들때 가중치로?
  - DAM_XXX 계열의 총합이 클수록 DAMAGE_LEVEL도 심각해지는 경향이 있음.
  - INDICATED_DAMAGE 컬럼
      - DAM_XXX 계열이 하나라도 1이면 INDICATED_DAMAGE는 1로 표기되어 있음. 모두 0이면 INDICATED_DAMAGE는 0.
      - INDICATED_DAMAGE가 1인데 DAMAGE_LEVEL이 N=None이 아닌 행이 1개 존재. 제거해도 될 듯. 
- 반응변수 생성
  - AIRPLANE CRASH SEVERITY PREDICTION USING MACHINE LEARNING (Mehta et al., 2021)이랑 똑같이 만든다.
      - (250422) 이 논문의 기준을 적용하기에는 fatality에 대한 컬럼이 결측치가 너무 많아서 어려울지도 모름.
      - NR_INJURIES 컬럼은 NaN이 아닌 값이 112개, NR_FATALITIES는 6개밖에 없음.
      - damage 기준은 DAMAGE_LEVEL을 사용해도 될 것 같음.

  
