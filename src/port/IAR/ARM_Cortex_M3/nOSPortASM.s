/*
 * Copyright (c) 2014-2016 Jim Tremblay
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

    RSEG    CODE:CODE(2)
    thumb

    EXTERN nOS_runningThread
    EXTERN nOS_highPrioThread

    PUBLIC PendSV_Handler

PendSV_Handler:
    /* Save PSP before doing anything, PendSV_Handler already running on MSP */
    MRS         R0,         PSP
    ISB

    /* Get the location of nOS_runningThread */
    LDR         R3,         =nOS_runningThread
    LDR         R2,         [R3]

    /* Push remaining registers on thread stack */
    STMDB       R0!,        {R4-R11}

    /* Save PSP to nOS_Thread object of current running thread */
    STR         R0,         [R2]

    /* Get the location of nOS_highPrioThread */
    LDR         R1,         =nOS_highPrioThread
    LDR         R2,         [R1]

    /* Copy nOS_highPrioThread to nOS_runningThread */
    STR         R2,         [R3]

    /* Restore PSP from nOS_Thread object of high prio thread */
    LDR         R0,         [R2]

    /* Pop registers from thread stack */
    LDMIA       R0!,        {R4-R11}

    /* Restore PSP to high prio thread stack */
    MSR         PSP,        R0
    ISB

    BX          LR

    END
