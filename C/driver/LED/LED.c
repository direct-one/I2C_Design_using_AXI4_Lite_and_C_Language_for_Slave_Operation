/*
 * LED.c
 *
 *  Created on: 2026. 4. 30.
 *      Author: kccistc
 */


#include "LED.h"



//uint8_t led_State = 0;
//uint8_t led_state_1 = 3;
//uint32_t prevTimeCounter = 0;


void LED_Init(){
    GPIO_SetMode(LED_PORT, LED_PIN_0|LED_PIN_1|LED_PIN_2|LED_PIN_3|LED_PIN_4|LED_PIN_5|LED_PIN_6|LED_PIN_7, OUTPUT);
    GPIOB->ODR = 0;
}


void LED_State_blink()
{
    //GPIOB->ODR = 0;
    if(I2C->O_SIGNAL & (1<<0)){
        GPIO_WritePin(LED_PORT,(1<<LED_PIN_0), SET);
    }
    if(I2C->O_SIGNAL & (1<<1)){
        GPIO_WritePin(LED_PORT,(1<<LED_PIN_1), SET);
    }


}




//void LED_UpCounterShift_Excute(){
//    //0.5sec
//    if(millis() - prevTimeCounter <= 100){
//        return;
//    }
//    prevTimeCounter = millis();
//    
//    GPIOC->ODR = 0;
//    GPIO_WritePin(GPIOC, (1<<led_State), SET);
//    led_State++;
//
//    if(led_State >= 4){
//     led_State = 0; 
//     }
//
//}
//
//void LED_TimeClockShift_Excute(){
//    
//    //0.1sec
//    if(millis() - prevTimeCounter <= 500 ){
//		return;
//    }
//	prevTimeCounter = millis();
//    
//    GPIOC->ODR = 0;
//    GPIO_WritePin(GPIOC,(1<<led_state_1) , SET);
//
//    if(led_state_1 == 0){
//        led_state_1 = 2;
//    } else {
//        led_state_1--;
//    }
//}
//
//
//void LED_TimeClock_H_M_Excute(){
//    
//    uint8_t led_state_h_m = 4;
//
//    GPIO_WritePin(GPIOC, (1<<led_state_h_m),SET);
//
//
//}
//
//void LED_TimeClock_S_M_Excute(){
//    
//    uint8_t led_state_s_m = 3; 
//
//    GPIO_WritePin(GPIOC, (1<<led_state_s_m), SET);
//
//}
//
//void LED_UpCounter_mode_Excute(){
//    
//    uint8_t led_state_UC = 6;
//
//    GPIO_WritePin(GPIOC, (1<<led_state_UC),SET);
//
//
//}
//
//void LED_TimeClock_mode_Excute(){
//    
//    uint8_t led_state_TC= 5;
//
//    GPIO_WritePin(GPIOC, (1<<led_state_TC),SET);
//    
//    
//}
//
//
