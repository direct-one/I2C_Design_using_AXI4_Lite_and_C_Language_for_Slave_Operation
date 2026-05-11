/*
 * Switch.h
 *
 *  Created on: 2026. 5. 2.
 *      Author: kccistc
 */

#ifndef SRC_DRIVER_SWITCH_SWITCH_H_
#define SRC_DRIVER_SWITCH_SWITCH_H_

#include <stdint.h>
#include "../../HAL/GPIO/GPIO.h"


typedef enum {
	Down = 0,
	Up = 1
}switch_state_t;



typedef enum {
	N_ACT = 0,
	ACT_DOWN,
	ACT_UP,
}switch_act_t;


typedef struct {
	GPIO_Typedef_t *GPIOx;
	uint32_t GPIO_Pin;
	switch_state_t prevState;

}sw_t;



void Switch_init(sw_t *sw, GPIO_Typedef_t *GPIOx, uint32_t GPIO_Pin);
uint8_t Switch_Excute(sw_t *sw);
uint8_t Switch_ReadExcute(sw_t *sw);


#endif /* SRC_DRIVER_SWITCH_SWITCH_H_ */
