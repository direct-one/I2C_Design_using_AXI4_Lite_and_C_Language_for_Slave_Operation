/*
 * ap_main.h
 *
 *  Created on: 2026. 5. 2.
 *      Author: kccistc
 */

#ifndef SRC_AP_MAIN_AP_MAIN_H_
#define SRC_AP_MAIN_AP_MAIN_H_

#include <stdint.h>

#include "../driver/LED/LED.h"
#include "../driver/Button/Button.h"
#include "../driver/Switch/Switch.h"
#include "../HAL/I2C/I2C.h"
#include "../HAL/GPIO/GPIO.h"
#include "../driver/FND/FND.h"

void ap_init();
void ap_excute();



#endif /* SRC_AP_MAIN_AP_MAIN_H_ */
