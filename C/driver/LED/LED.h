/*
 * LED.h
 *
 *  Created on: 2026. 4. 30.
 *      Author: kccistc
 */

#include <stdint.h> 

#ifndef SRC_DRIVER_LED_LED_H_
#define SRC_DRIVER_LED_LED_H_


#include "../../HAL/GPIO/GPIO.h"
#include "../../common/common.h"
#include "../../HAL/I2C/I2C.h"

#define LED_PORT GPIOB

#define LED_PIN_0 GPIO_PIN_0
#define LED_PIN_1 GPIO_PIN_1
#define LED_PIN_2 GPIO_PIN_2
#define LED_PIN_3 GPIO_PIN_3
#define LED_PIN_4 GPIO_PIN_4
#define LED_PIN_5 GPIO_PIN_5
#define LED_PIN_6 GPIO_PIN_6
#define LED_PIN_7 GPIO_PIN_7


void LED_Init();
void LED_State_blink();

//void LED_UpCounterShift_Excute();
//void LED_TimeClockShift_Excute();
//void LED_TimeClock_H_M_Excute();
//void LED_TimeClock_S_M_Excute();
//void LED_TimeClock_mode_Excute();
//void LED_UpCounter_mode_Excute();


#endif /* SRC_DRIVER_LED_LED_H_ */
