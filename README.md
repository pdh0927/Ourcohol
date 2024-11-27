## 프로젝트 정보



- **작업 기간** : 23.03 - 23.06 (약 4개월)
- **인원** : 1명
- **내 역할(기여도)** : 기획(100%), 앱 개발(100%), 백엔드 개발(100%)
- **프로젝트 목적**
    - 술만 마시는 사회초년생들의 술자리 문화 개선
    - 매번 즐기는 술자리를 추억으로 만들어주기 위해
    - 사회초년생들에게 음주 정보 제공
- **프로젝트 내용**
    - 술자리 모임 기록 (누구 마셨는지, 얼마나 마셨는지, 어디서 마셨는지, 어떤 모임인지, 당시 사진 등)
    - 술자리 기록을 추억으로 캘린더에서 확인하고 댓글을 남길 수 있음
    - 내 주량을 설정하고, 그 이상 마셨을 시 알림
    - 토크 주제, 숙취 해소법, 술자리 예절 등 여러 유용한 술자리 팁 제공
- 대표 사용 기술 : `Provider`, `ImagePicker`, `ImageCopper`, `Image Base64 디코딩` 등

---

# OURcohol

> 술자리를 더욱 즐겁게 하고, 그 술자리를 기억하기 위한 서비스  

✋ 더 이상 술만 마시는 술자리는 그만  
📆 친구들과의 술자리를 캘린더 형태로 추억하자  
💡여러 유용한 술자리 꿀팁까지  

[시연 영상](https://www.youtube.com/watch?v=hxkt6XDSpJI)

---

## 주요 기능 및 트러블 슈팅



### 술자리 추억 달력

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2FOURcohol%2F1.png?alt=media&token=03749dc9-0fec-46f1-bf27-39b3c9432d56" alt="술자리 추억 달력" width="300"/>

- **기능 설명**
    - 술자리의 대표 이미지를 기록 및 표시하여 시각적 추억을 확인
    - 특정 날짜를 선택하여 해당 날짜의 술자리 정보를 확인
- **구현 기술**
    - 이미지를 표시하기 위해 외부 달력 라이브러리를 사용하지 않고, **커스텀 달력을 직접 설계 및 구현**
    - `http` 라이브러리를 활용하여 Django 서버와 통신
    - `Image.network`를 사용하지 않고 서버에서 받은 이미지 데이터를 `base64`로 디코딩하여 달력 UI에 표시
- **문제점**
    - 달력을 구현할 때, 4주 또는 5주를 보여줘야 하는 달, 시작 요일에 따른 빈 칸 처리 등 여러 조건을 관리하는 데 어려움을 겪음
- **해결책**
    - 각 달의 시작 요일과 총일 수를 기반으로 동적으로 주 단위를 계산하도록 알고리즘을 설계
    - `startDayOfWeek`와 `countThisMonth` 변수를 사용해 달력의 시작과 끝을 명확히 구분

---

### 술자리 추억 Detail

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2FOURcohol%2F2.png?alt=media&token=773e494d-e0b4-4da6-9957-a717e8a35786" alt="술자리 추억 Detail" width="300"/>

- **기능 설명**
    - 사용자가 기록한 술자리를 다시 볼 수 있는 추억 페이지 제공
    - 사진, 음주량, 댓글 등을 통해 과거의 술자리 추억을 시각적으로 확인 가능
    - 술자리 참여자들의 음주 데이터, 사용자가 남긴 댓글을 통해 회상하는 경험 제공
- **구현 기술**
    - `비동기 HTTP` 요청을 통해 댓글 추가 및 데이터를 갱신
- **문제점**
    - 혼자 진행하는 프로젝트임에도 **백엔드와 앱 개발 간 통신에서 데이터 형식 및 에러 처리의 불일치** 문제가 발생
- **해결책**
    - **구현에 앞서 철저한 설계가 필요함**을 느끼고 다음 프로젝트부터 적용할 예정

---

### 술자리 파티 즐기기

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2FOURcohol%2F3.png?alt=media&token=2b996096-daef-46d6-82fc-8d849bf99b4d" alt="술자리 파티 즐기기" width="300"/>

- **기능 설명**
    - 사용자 간 술 소비량을 제공하고 이를 바탕으로 재미있는 랭킹 시스템 제공
    - 사용자 사진을 업로드하거나 이미지를 통해 추억을 남길 수 있는 기능 제공
    - 사용자의 요청에 따라 실시간으로 데이터를 갱신하고 테이블 정보를 업데이트
    - 설정해 놓은 주량에 따라서 주량 초과 알림 제공
- **구현 기술**
    - `ImagePicker` 및 `ImageCropper`를 사용하여 사용자가 술자리 사진을 업로드하고 편집할 수 있도록 구현
    - `Image.memory`를 활용해 서버에서 받은 Base64 인코딩 이미지를 디코딩하여 UI에 표시
    - `http.MultipartRequest`를 사용하여 서버에 이미지 데이터를 PATCH 방식으로 업로드
    - `Provider`를 통해 상태를 관리하며, 실시간으로 UI와 데이터를 동기화하여 사용자 경험을 최적화
- **문제점**
    - 다른 사용자가 술 소비 데이터를 추가할 때 실시간으로 내 UI에도 자동으로 반영되도록 구현하려 했으나, `Listen`을 사용하면 리소스 소모가 커지는 문제가 발생
    - 이미지 데이터를 서버에서 가져오는 방법에 대한 이해가 부족하여 구현에 어려움을 겪음
- **해결책**
    - 실시간 업데이트 대신, 새로고침 버튼을 눌렀을 때 데이터를 서버에서 불러와 UI를 갱신하는 방식으로 구현하여 리소스 사용을 최소화하고 성능을 최적화
    - `Image.memory`를 활용해 서버에서 받은 Base64 데이터를 디코딩하여 표시했으며, 다음 프로젝트에서는 더 효율적인 `Network` 기반 이미지 로딩 방식을 적용할 계획

---

### 회원가입

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2FOURcohol%2F4.png?alt=media&token=b50d5775-f750-4f43-956c-f6cf3f7ae59f" alt="회원가입" width="300"/>

- **기능 설명**
    - 이메일 형식을 체크하여 사용할 수 있는 이메일인지 알림
    - 비밀번호 확인 기능 제공
    - 이메일 인증을 통한 무분별한 가입 최소화
- **구현 기술**
    - 직접 `Django의 이메일 인증`을 구현하여 Flutter에서 적용

---

### 술자리 Tips

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2FOURcohol%2F5.png?alt=media&token=326ab157-7aee-4968-b2e5-fc42b34205d1" alt="술자리 Tips" width="300"/>

- **기능 설명**
    - 토크 주제, 숙취 해소법, 술자리 예절 등 여러 유용한 술자리 팁 제공
