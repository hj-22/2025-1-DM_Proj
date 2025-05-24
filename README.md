# 2025-1-DM_Proj
데이터마이닝 프로젝트


### eBird 파생변수
**환경 변화가 있었는가?**  
* 과거 3년, 2년, 작년 대비 해당 월의 철새/텃새 수 평균을 구하고 증감을 구함.
    * 과거 데이터: 해당 달 관측치의 평균. (해당 "시즌"의 대략적인 추세를 반영)
    * 현재 데이터: 최근 7일 관측치의 평균. (가까운 과거)
* 산새/물새 관측수도 동일하게 과거 lag으로 => 철새/텃새 구분x
  
**flocking bird**  
* flocking score를 구한 다음, flocking score가 top10인 새들(=> 위험 종을 필터링)이 과거 5년 해당 달에 얼마나 관측되었는가를 관측 빈도수의 평균으로 나타냄.
  
**충돌을 일으킨 종에 대한 정보(train/trest split 이후)**  
* train 데이터에서 사고를 가장 많이 일으킨 종 10개를 선택
* flockig bird 처리와 동일하게.
=> 각 철새의 개체수가 전체 철새 관측 수 중 차지하는 비율을 계산하고, 비율이 top20인 것을 고름. => 과거 관측 기록 기준으로 보았을 때 그 달에 관측될 확률로 계산할 수 있음.  
해당 날짜가 몇 종의 철새의 이동 기간에 포함이 되는지?


=> 이 시즌에 무리지어 다니는 새들이 얼마나 관측이 되었는가.
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

https://transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ&QO_fu146_anzr=b0-gvzr
- On-Time : Reporting Carrier On-Time Performance (1987-present)
- Flight Delay에 대한 데이터. 미국 주 단위별로 항공편 운항 스케줄 정보가 있음.

https://data.cnra.ca.gov/dataset/usfws-administrative-waterfowl-flyway-boundaries](https://sos.noaa.gov/catalog/datasets/bird-migration-patterns-western-hemisphere/
- 미국 해양대기청
- 118개 종에 대한 일별 중심위치

### 논문
**A Predictive Ensemble Model to Minimize Bird Strike Occurrences on Aircrafts at U.S. Airports**
- https://scholarspace.library.gwu.edu/concern/gw_etds/wd375x08n
- 덴버 국제공항 항공편 데이터로 prediction
- 다른 공항에 대해서도 이런 데이터가 있는지 찾아보면 좋겠다.

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
    - https://www.ncei.noaa.gov/access/search/data-search/global-hourly
    - 미국 해양대기청(NOAA) 소속 환경정보센터
        - https://www.ncei.noaa.gov/data/global-hourly/doc/isd-format-document.pdf
        - 이건 컬럼 설명이 들어있는 document
  - NUM_ENGS, AC_MASS는 비행기 정보로부터 추론
  - HEIGHT, SPEED, PHASE OF FLIGHT는 단순 보팅이나 평균으로 채운 모델과 아예 뺀 모델 두 가지 중에 성능이 높은 것을 선택한다.
  - ENG_1_POS ~ ENG_2_POS 까지는 일단 뺀다.
      - ENG_1_POS는 

### 그 밖에
- (250516) negative class를 104483개로 다시 샘플링.
    - undersampling 한 것이기 때문에 probability calibration 필요; **Calibrating Probability with Undersampling for Unbalanced Classification** 참조 
- (250516) 태스크를 bird strike occurence classfication으로 바꿨기 때문에 airline, AC_MASS 등은 채우지 않는다.
    - 만약 채우고 싶다면...
    - airline code(OP_UNIQUE_CARRIER, 두글자짜리)를 ICAO 기준의 세자리 코드로 매핑. BTS 데이터베이스에 있는 reporting_airline 룩업테이블이랑 IATA_CODE_Reporting_Airline 룩업테이블, https://en.wikipedia.org/wiki/List_of_airline_codes 의 테이블 이용하면 될듯
    - AC_MASS는 전체 birdstrike data(17만개) 기준 N-number로 서치 돌렸을때 97000개 정도 채워짐
- (250502) OPERATOR 클러스터링 / AC_CLASS는 비행기 제조사로 대체
- (250202) HEIGHT, SPEED 결측치는 PHASE_OF_FLIGHT 기준 mean으로 대체
- TIME 버리고 TIME_OF_DAY만 쓰기
    - (250425) 미국 해양대기청에서 발표한 sunset, sunrise time 산출 공식으로 매뉴얼하게 채움
- AIRCRAFT는 분해해서 AMA랑 AMO로 쓰기
  - 추가 데이터로 서치?
  - 안쓸수도 있다.
      - (250423) 안 쓰는 게 나을듯. 중요한 건 AC_MASS일 것 같은데, AC_MASS가 NA인 데이터는 AIRCRAFT가 UNKNOWN이거나 제조사 이름만 존재함. 세부 기종을 알 수 없음.
- AC_CLASS에서 (balloon처럼) 소수 카테고리는 그냥 제거.
- (250423) AC_CLASS, AC_MASS 가 NA인 것들을 제거함. 625개 정도.
- ENG_POS 계열은 유의미할지 잘 모르겠다.
  - 가능하면 버리고 싶다.
- DAMAGE_LEVEL을 그대로 쓸지?
  - 아니면 Y 만들때 가중치로?
  - (250422) DAM_XXX 계열의 총합이 클수록 DAMAGE_LEVEL도 심각해지는 경향이 있음.
  - (250422) INDICATED_DAMAGE 컬럼
      - DAM_XXX 계열이 하나라도 1이면 INDICATED_DAMAGE는 1로 표기되어 있음. 모두 0이면 INDICATED_DAMAGE는 0.
      - INDICATED_DAMAGE가 1인데 DAMAGE_LEVEL이 N=None이 아닌 행이 1개 존재. 제거해도 될 듯.
- 반응변수 생성
  - DAMAGE_LEVEL
      - NaN인 term은 DAMAGE_SUM으로 대체한다.

  
