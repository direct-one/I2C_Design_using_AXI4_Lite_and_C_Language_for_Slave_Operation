/*
 * Switch.c
 *
 *  Created on: 2026. 5. 2.
 *      Author: kccistc
 */

#include "Switch.h"





void Switch_init(sw_t *sw, GPIO_Typedef_t *GPIOx, uint32_t GPIO_Pin)
{   
    GPIO_SetMode(GPIOA, GPIO_Pin, INPUT);
	sw->GPIOx = GPIOA;
	sw->GPIO_Pin = GPIO_Pin;
	sw->prevState = Down;


}

uint8_t Switch_Excute(sw_t *sw)
{
    switch_state_t curState = GPIO_ReadPin(sw->GPIOx, sw->GPIO_Pin);
	if(sw->prevState == Down && curState == Up){
		sw->prevState = Up;
		return ACT_UP;
	}
	else if(sw->prevState == Up && curState == Down){
		sw->prevState = Down;
		return ACT_DOWN;
	}
	return N_ACT;

}

uint8_t Switch_ReadExcute(sw_t *sw)
{
    return (uint8_t)(sw->GPIOx->IDR);
}





