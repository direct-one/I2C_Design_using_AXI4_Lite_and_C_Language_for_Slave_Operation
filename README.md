# AXI4_Lite_I2C

# 📝 I2C Protocol Manual Controller

본 프로젝트는 I2C 통신 프로토콜의 각 단계(Condition)를 독립적인 하드웨어 버튼으로 제어하여, 통신 흐름을 단계별로 검증하고 외부 슬레이브 장치를 제어하는 **I2C 마스터 컨트롤 시스템**입니다.
## Ip Block Diagram 
<img width="1595" height="746" alt="image" src="https://github.com/user-attachments/assets/3ee3ecc4-784b-4e2c-950f-eb3c323a139b" />


## 📌 주요 특징

- **Step-by-Step I2C Control**: 자동화된 통신이 아닌, 사용자가 버튼을 눌러 `START`, `WRITE`, `READ`, `STOP` 조건을 개별적으로 발생시킵니다.
- **Interactive Debugging**: `xil_printf`를 통한 실시간 로그 출력으로 현재 하드웨어 상태(Busy/Done 등)를 UART 터미널에서 확인할 수 있습니다.
- **DIP Switch Data Mapping**: 전송할 데이터를 소스 코드 수정 없이 DIP 스위치(`GPIOA`)를 통해 실시간으로 변경 가능합니다.
- **Visual Output**: 수신된 I2C 데이터를 FND(7-Segment)에 즉시 시각화합니다.

## 🛠️ 하드웨어 구성 (Peripheral Mapping)

| **기능** | **입력 장치** | **포트 (GPIO)** | **설명** |
| --- | --- | --- | --- |
| **I2C Start** | Button 0 | `GPIOD Pin 4` | I2C Start Condition 발생 |
| **I2C Write** | Button 1 | `GPIOD Pin 5` | DIP 스위치 설정값 전송 |
| **I2C Read** | Button 2 | `GPIOD Pin 6` | 데이터 수신 (NACK 응답 후 FND 표시) |
| **I2C Stop** | Button 3 | `GPIOD Pin 7` | I2C Stop Condition 발생 |
| **Data Input** | DIP SW | `GPIOA [0:7]` | 전송할 8-bit 데이터 설정 |
| **Data Output** | FND | `FND_PORT` | 수신된 8-bit 데이터 표시 |

## 📂 소프트웨어 로직 흐름

### 1. 초기화 (`ap_init`)

- I2C 통신 모듈 초기화 (`I2C_init`).
- 사용자 인터페이스(Button, Switch, FND) 활성화.
- 최초 FND 값을 `0`으로 초기화하여 시스템 준비 상태 표시.

### 2. 메인 루프 (`ap_excute`)

- **Start Condition**: `hbtncstart` 감지 시 버스 점유 시작.
- **Write Sequence**: `hbtncwrite` 감지 시 현재 DIP 스위치의 상태값을 읽어 슬레이브로 전송.
- **Read Sequence**: `hbtncread` 감지 시 슬레이브로부터 데이터를 읽어오며, 읽기가 끝나면 `I2C_NACK`를 보냄. 수신 데이터는 FND에 업데이트.
- **Stop Condition**: `hbtncstop` 감지 시 통신 종료 및 버스 해제.

## 💻 핵심 코드 인터페이스

C

```c
// I2C 수동 제어 로직 예시
if(Button_GetState(&hbtncstart) == ACT_PUSHED){
    I2C_Start(); // Start 신호 발생
}

if(Button_GetState(&hbtncwrite) == ACT_PUSHED){
    uint8_t sw_state = Switch_ReadExcute(&switch_mode);
    I2C_Write(sw_state); // 스위치 데이터 전송
}

if(Button_GetState(&hbtncread) == ACT_PUSHED){
    uint8_t rx_data = I2C_Read(I2C_NACK); // 데이터 수신 및 NACK 전송
    FND_SetNum(rx_data); // 결과 표시
}
```

## 📅 프로젝트 정보

- **작성일**: 2026. 05. 02.
- **작성자**: 김성훈
- **대상 플랫폼**: RISC-V / ARM 기반 FPGA SoC 시스템
