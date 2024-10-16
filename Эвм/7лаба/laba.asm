 ;ІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІ
 ;ІІ                                                      ІІ
 ;ІІ         ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї          ІІ
 ;ІІ         і Џ ђ Ћ ѓ ђ Ђ Њ Њ Ђ   L O C K E R і          ІІ
 ;ІІ         АДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДЩ          ІІ
 ;ІІ                                                      ІІ
 ;ІІ ќв® аҐ§Ё¤Ґв п Їа®Ја ¬¬  COM вЁЇ , "§ ЇЁа ой п"    ІІ
 ;ІІ ўаҐ¬п  Є« ўЁ вгаг. Џа®Ја ¬¬   ЇҐаҐеў влў Ґв  ўҐЄв®а  ІІ
 ;ІІ ЇаҐалў Ёп Int09 Ё § Ё¬ Ґв ў аҐ§Ё¤ҐвҐ 5232 Ў ©в.   ІІ
 ;ІІ                                                      ІІ
 ;ІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІІ


 PROGRAM   segment
           assume CS:PROGRAM
           org   100h         ;Їа®ЇгбЄ PSP ¤«п COM-Їа®Ја ¬¬л

 Start:    jmp   InitProc     ;ЇҐаҐе®¤   ЁЁжЁ «Ё§ жЁо


 ;°°°°°°°°° ђ … ‡ € „ … Ќ ’ Ќ › …   „ Ђ Ќ Ќ › … °°°°°°°°°°°°

 FuncNum   equ   0EEh           ;ҐбгйҐбвўгой п дгЄжЁп ЇаҐ-
                                ;алў Ёп BIOS Int16h
 CodeOut   equ   2D0Ch          ;Є®¤,ў®§ўа й Ґ¬л©  иЁ¬ ®Ў-
                                ;а Ў®взЁЄ®¬ Int16h
 TestInt09 equ   9D0Ah          ;б«®ў® ЇҐаҐ¤ Int09h
 TestInt16 equ   3AFAh          ;б«®ў® ЇҐаҐ¤ Int16h

 OldInt09  label dword          ;б®еа Ґл© ўҐЄв®а Int09h:
  OfsInt09 dw    ?              ;   ҐЈ® б¬ҐйҐЁҐ
  SegInt09 dw    ?              ;   Ё бҐЈ¬Ґв

 OldInt16  label dword          ;б®еа Ґл© ўҐЄв®а Int16h:
  OfsInt16 dw    ?              ;   ҐЈ® б¬ҐйҐЁҐ
  SegInt16 dw    ?              ;   Ё бҐЈ¬Ґв

 OK_Text   db    0              ;ЇаЁ§ Є Ј иҐЁп нЄа  
 Sign      db    ?              ;Є®««ЁзҐбвў®  ¦ вЁ© Ctrl
 VideoLen  equ   800h           ;¤«Ё  ўЁ¤Ґ®ЎгдҐа 

 VideoBuf  db    160 dup(' ')
 db  13 dup(' ')
 db 'ЙНННННННННННННННННННННННННННННННННННННННННННННННННННН»'
 db  26 dup(' ')
 db 'є                                                    є'
 db  26 dup(' ')
 db 'є   „«п а §Ў«®ЄЁа®ўЄЁ  ¦¬ЁвҐ ваЁ а §  Q   є'
 db  26 dup(' ')
 db 'є                                                    є'
 db  26 dup(' ')
 db 'є                                                    є'
 db  26 dup(' ')
 db 'ИННННННННННННННННННННННННННННННННННННННННННННННННННННј'
 db  2000 dup(' ')

 AttrBuf   db    VideoLen dup(07h)  ; ваЁЎгвл нЄа  
 VideoBeg  dw    0B800h         ; ¤аҐб  з «  ўЁ¤Ґ®®Ў« бвЁ
 VideoOffs dw    ?              ;б¬ҐйҐЁҐ  ЄвЁў®© бва Ёжл
 CurSize   dw    ?              ;б®еа Ґл© а §¬Ґа Єгаб®а 

 ;°°°°°° ђ … ‡ € „ … Ќ ’ Ќ › …   Џ ђ Ћ – … „ “ ђ › °°°°°°°°°

 ;
 ;ЏЋ„ЏђЋѓђЂЊЊЂ ЋЃЊ…ЌЂ ‚€„…ЋЋЃ‹Ђ‘’€ ‘ Ѓ“”…ђЋЊ ЏђЋѓђЂЊЊ›

 VideoXcg proc
     lea   DI,VideoBuf   ;ў DI -  ¤аҐб ЎгдҐа  бЁ¬ў®«®ў
     lea   SI,AttrBuf    ;ў SI -  ¤аҐб ЎгдҐа   ваЁЎгв®ў

     mov   AX,VideoBeg   ;їў ES - бҐЈ¬Ґвл©  ¤аҐб
     mov   ES,AX         ;Щ з «  ўЁ¤Ґ®®Ў« бвЁ

     mov   CX,VideoLen   ;ў CX - ¤«Ё  ўЁ¤Ґ®ЎгдҐа 
     mov   BX,VideoOffs  ;ў BX -  з. б¬ҐйҐЁҐ бва®ЄЁ

   Draw:
     mov   AX,ES:[BX]    ;ї®Ў¬Ґпвм бЁ¬ў®«/ ваЁЎгв  
     xchg  AH,DS:[SI]    ;інЄа Ґ б бЁ¬ў®«®¬ Ё  ваЁЎг-
     xchg  AL,DS:[DI]    ;ів®¬ Ё§ ЎгдҐа®ў
     mov   ES:[BX],AX    ;Щ

     inc   SI            ;їгўҐ«ЁзЁвм  ¤аҐб
     inc   DI            ;Щў ЎгдҐа е

     inc   BX            ;їгўҐ«ЁзЁвм  ¤аҐб
     inc   BX            ;Щў ўЁ¤Ґ®ЎгдҐаҐ

     loop  Draw          ;б¤Ґ« вм ¤«п ўбҐ© ўЁ¤Ґ®®Ў« бвЁ
     ret                 ;ў®§ўа в
 VideoXcg endp

 ;
 ;ЋЃђЂЃЋ’—€Љ Џђ…ђ›‚ЂЌ€џ Int09h (Џђ…ђ›‚ЂЌ€… Ћ’ Љ‹Ђ‚€Ђ’“ђ›)

     dw    TestInt09     ;б«®ў® ¤«п ®Ў аг¦ҐЁп ЇҐаҐеў в 

 Int09Hand proc
     push  AX            ;ї
     push  BX            ;і
     push  CX            ;іб®еа Ёвм
     push  DI            ;іЁбЇ®«м§гҐ¬лҐ
     push  SI            ;іаҐЈЁбвал
     push  DS            ;і
     push  ES            ;Щ

     push  CS            ;їгЄ § вм DS  
     pop   DS            ;Щ иг Їа®Ја ¬¬г

     in    AL,60h        ;Ї®«гзЁвм бЄ  Є®¤  ¦ в®© Є« ўЁиЁ

     cmp   AL,2Dh        ;їЇа®ўҐаЁвм   бЄ -Є®¤ Є« ўЁиЁ
     jne   Exit_09       ;Щ<L> Ё ўл©вЁ, Ґб«Ё Ґ ®

     xor   AX,AX         ;ї
     mov   ES,AX         ;іЇа®ўҐаЁвм д« ЈЁ Є« ўЁ вгал  
     mov   AL,ES:[418h]  ;і ¦ вЁҐ <Ctrl+Alt>
     and   AL,03h        ;і
     cmp   AL,03h        ;і
     je    Cont          ;Щ

   Exit_09:
     jmp   Exit09        ;ўле®¤

   Cont:


     sti                 ;а §аҐиЁвм ЇаҐалў Ёп

     mov   AH,0Fh        ;їЇ®«гзЁвм вҐЄгйЁ©
     int   10h           ;ЩўЁ¤Ґ®аҐ¦Ё¬
     cmp   AL,2          ;ї
     je    InText        ;іЇҐаҐ©вЁ   InText
     cmp   AL,3          ;іҐб«Ё аҐ¦Ё¬
     je    InText        ;івҐЄбв®ўл© 80#25
     cmp   AL,7          ;і
     je    InText        ;Щ

     jmp   short SwLoop1 ;Ё зҐ - Їа®ЇгбвЁвм

  InText:
     xor   AX,AX         ;їгбв ®ўЁвм бҐЈ¬Ґвл©
     mov   ES,AX         ;Щ ¤аҐб ў 0000h

     mov   AX,ES:[44Eh]  ;їЇ®«гзЁвм б¬ҐйҐЁҐ  ЄвЁў®©
     mov   VideoOffs,AX  ;Щбва Ёжл ў VideoOffs

     mov   AX,ES:[44Ch]  ;їба ўЁвм ¤«Ёг ўЁ¤Ґ®ЎгдҐа 
     cmp   AX,1000h      ;іб 1000h.…б«Ё Ґ а ў®,
     jne   Exit009       ;ів® аҐ¦Ё¬ EGA Lines
                         ;Щ(нЄа  вгиЁвм Ґ  ¤®)
     mov   AH,03h        ;їЁ зҐ б®еа Ёвм
     int   10h           ;іа §¬Ґа Єгаб®а 
     mov   CurSize,CX    ;Щў CurSize

     mov   AH,01h        ;ї
     mov   CH,20h        ;іЁ Ї®¤ ўЁвм ҐЈ®
     int   10h           ;Щ

     mov   OK_Text,01h   ;гбв ®ўЁвм ЇаЁ§ Є Ј иҐЁп
                         ;нЄа  
     call  VideoXcg      ;Ё ўл§ў вм Їа®жҐ¤гаг Ј иҐЁп

   SwLoop1:
     in    AL,60h        ;ў AL - Є®¤  ¦ в®© Є« ўЁиЁ
     cmp   AL, 10h        ;їҐб«Ё  ¦ в  Ctrl - в®  
     je    SwLoop2       ;ЩЇа®ўҐаЄг ®вЇгбЄ Ёп
     cmp   AL,90h        ;їҐб«Ё Ўл«  ®вЇгйҐ  Ctrl, в®
     je    SwLoop1       ;Щ¤ «миҐ   ®Їа®б Є« ўЁ вгал
     mov   Sign,0        ;Ё зҐ бЎа®бЁвм Є®«-ў®  ¦ вЁ©
     jmp   short SwLoop1 ;Ё б®ў    ®Їа®б Є« ўЁ вгал

   SwLoop2:
     in    AL,60h        ;ў AL - бЄ  Є®¤ Є« ўЁиЁ
     cmp   AL,90h        ;їҐб«Ё Ґ Є®¤ ®вЇгбЄ Ёп Ctrl, в®
     jne   SwLoop2       ;Щ®¦Ё¤ вм ®вЇгбЄ Ёп Є« ўЁиЁ
     inc   Sign          ;гўҐ«ЁзЁвм Є®«-ў® ў¦ вЁ©   Ctrl
     cmp   Sign,3        ;їҐб«Ё ҐйҐ Ґ  ¦ «Ё 3-Ё а § ,в®
     jne   SwLoop1       ;ЩЇҐаҐ©вЁ   ®Їа®б Є« ўЁ вгал

     mov   Sign,0        ;бЎа®бЁвм Є®«-ў®  ¦ вЁ©   Ctrl

     cmp   OK_Text,01h   ;їҐб«Ё нЄа  Ґ Ўл« ўлЄ«озҐ,
     jne   Exit009       ;Щв® ўле®¤

     call  VideoXcg      ;Ё зҐ ўЄ«озЁвм нЄа 

     mov   AH,01h        ;ї
     mov   CX,CurSize    ;іў®ббв ®ўЁвм Єгаб®а
     int   10h           ;Щ

     mov   OK_Text,0h    ;бЎа®бЁвм ЇаЁ§ Є Ј иҐЁп нЄа  

   Exit009:
     xor   AX,AX         ;ї
     mov   ES,AX         ;і®зЁбвЁвм д« ЈЁ  ¦ вЁп
     mov   AL,ES:[417h]  ;і<Control+Alt> Ї®  ¤аҐбг
     and   AL,11110011b  ;і0000h:0417h Ё д« ЈЁ
     mov   ES:[417h],AL  ;і<LeftControl+LeftAlt>
     mov   AL,ES:[418h]  ;іЇ®  ¤аҐбг 0000h:0418h
     and   AL,11111100b  ;і
     mov   ES:[418h],AL  ;Щ

     mov   AL,20h        ;ї®Ўб«г¦Ёвм Є®ва®««Ґа
     out   20h,AL        ;ЩЇаҐалў Ё©

     cli                 ;§ ЇаҐвЁвм ЇаҐалў Ёп
     pop   ES            ;ї
     pop   DS            ;і
     pop   SI            ;іў®ббв ®ўЁвм
     pop   DI            ;іЁбЇ®«м§гҐ¬лҐ
     pop   CX            ;іаҐЈЁбвал
     pop   BX            ;і
     pop   AX            ;Щ
     iret                ;ўл©вЁ Ё§ ЇаҐалў Ёп

   Exit09:
     cli                 ;§ ЇаҐвЁвм ЇаҐалў Ёп
     pop   ES            ;ї
     pop   DS            ;і
     pop   SI            ;іў®ббв ®ўЁвм
     pop   DI            ;іЁбЇ®«м§гҐ¬лҐ
     pop   CX            ;іаҐЈЁбвал
     pop   BX            ;і
     pop   AX            ;Щ
     jmp   CS:OldInt09   ;ї;ЇҐаҐ¤ вм гЇа ў«ҐЁҐ "Ї® жҐЇ®зЄҐ"
                         ;Щ;б«Ґ¤гойҐ¬г ®Ўа Ў®взЁЄг Int09h
 Int09Hand endp

 ;
 ;ЋЃђЂЃЋ’—€Љ Џђ…ђ›‚ЂЌ€џ Int16h (‚€„…Ћ ”“ЌЉ–€€ BIOS)

     dw    TestInt16     ;б«®ў® ¤«п ®Ў аг¦ҐЁп ЇҐаҐеў в 

 Presense proc
     cmp   AH,FuncNum    ;®Ўа йҐЁҐ ®в  иҐ© Їа®Ја ¬¬л?
     jne   Pass          ;Ґб«Ё Ґв в® ЁзҐЈ® Ґ ¤Ґ« вм
     mov   AX,CodeOut    ;Ё зҐ ў AX гб«®ў«Ґл© Є®¤
     iret                ;Ё ў®§ўа вЁвмбп

   Pass:
     jmp   CS:OldInt16   ;ЇҐаҐ¤ вм гЇа ў«ҐЁҐ "Ї® жҐЇ®зЄҐ"
                         ;б«Ґ¤гойҐ¬г ®Ўа Ў®взЁЄг Int16h
 Presense endp


 ;°°°°°°°° Ќ … ђ … ‡ € „ … Ќ ’ Ќ › …   „ Ђ Ќ Ќ › … °°°°°°°°°

 ResEnd      db    ?    ;Ў ©в ¤«п ®ЇаҐ¤Ґ«ҐЁп Ја Ёжл аҐ-
                        ;§Ё¤Ґв®© з бвЁ Їа®Ја ¬¬л
 On          equ   1    ;§ зҐЁҐ "гбв ®ў«Ґ" ¤«п  д« Ј®ў
 Off         equ   0    ;§ зҐЁҐ "бЎа®иҐ" ¤«п д« Ј®ў
 Bell        equ   7    ;Є®¤ бЁ¬ў®«  BELL
 CR          equ   13   ;Є®¤ бЁ¬ў®«  CR
 LF          equ   10   ;Є®¤ бЁ¬ў®«  LF
 MinDosVer   equ   2    ;¬ЁЁ¬ «м п ў®§¬®¦ п ўҐабЁп DOS

 InstFlag    db    ?    ;д« Ј  «ЁзЁп Їа®Ја ¬¬л ў Ї ¬пвЁ
 SaveCS      dw    ?    ;б®еа Ґл© CS аҐ§Ё¤Ґв®© Їа®Ј-
                        ;а ¬¬л

 Copyright   db CR,LF,' L O C K E R  ¤Ґ¬®бва жЁ® п Їа®'
             db 'Ја ¬¬ ',CR,LF,LF,'$'
 VerDosMsg   db 'ЋиЁЎЄ : ҐЄ®ааҐЄв п ўҐабЁп DOS'
             db Bell,CR,LF,'$'
 InstMsg     db 'Џа®Ја ¬¬  LOCKER гбв ®ў«Ґ .„«п бпвЁп Ёб'
             db 'Ї®«м§г©вҐ Є«оз /u',CR,LF
             db '„«п "§ ЇЁа Ёп"  ¦¬ЁвҐ <Ctrl+Alt+X>',CR,LF
             db '„«п "®вЇЁа Ёп" ваЁ¦¤л  ¦¬ЁвҐ <Q>'
             db CR,LF,'$'
 AlreadyMsg  db 'ЋиЁЎЄ : LOCKER г¦Ґ аҐ§Ё¤Ґв  ў Ї ¬пвЁ'
             db Bell,CR,LF,'$'
 UninstMsg   db 'Џа®Ја ¬¬  LOCKER бпв  б аҐ§Ё¤Ґв '
             db CR,LF,'$'
 NotInstMsg  db 'ЋиЁЎЄ : Їа®Ја ¬¬  LOCKER Ґ гбв ®ў«Ґ '
             db Bell,CR,LF,'$'
 NotSafeMsg  db 'ЋиЁЎЄ : бпвм б аҐ§Ё¤Ґв  Їа®Ја ¬¬г LOCKER'
             db ' ў ¤ л© ¬®¬Ґв',CR,LF,'Ґў®§¬®¦® Ё§-§  '
             db 'ЇҐаҐеў в  ҐЄ®в®але ўҐЄв®а®ў',Bell,CR,LF,'$'


 ;°°°°°° Ќ … ђ … ‡ € „ … Ќ ’ Ќ › …   Џ ђ Ћ – … „ “ ђ › °°°°°

 ;
 ;‚Љ‹ћ—Ђ…Њ›‰ ”Ђ‰‹ „‹џ ‚›ЏЋ‹Ќ…Ќ€џ ЏђЋ–…„“ђ› ‚›‚Ћ„Ђ €Ќ”ЋђЊЂ–€€

 Locker      equ   0      ;Ё¬п ¤«п Ё¤ҐвЁдЁЄ жЁЁ Їp®Јp ¬¬л
                          ;ў® ўЄ«оз Ґ¬®¬ д ©«Ґ
 include     INFO.INC     ;ўЄ«оз Ґ¬л© д ©« б Їа®жҐ¤га®© ўл-
                          ;ў®¤  Ёд®а¬ жЁЁ

 ;
 ;ѓ‹Ђ‚ЌЂџ ЏђЋ–…„“ђЂ €Ќ€–€Ђ‹€‡Ђ–€€

 InitProc proc
     mov   AH,09h          ;ї
     lea   DX,Copyright    ;іўлўҐбвЁ  з «м®Ґ б®®ЎйҐЁҐ
     int   21h             ;Щ

     lea   DX,VerDosMsg    ;їЇа®ўҐаЁвм ўҐабЁо DOS Ё ўл-
     call  ChkDosVer       ;іўҐбвЁ б®®ЎйҐЁҐ,Ґб«Ё ҐЇ®¤-
     jc    Output          ;Ще®¤пй п

     call  PresentTest     ;Їа®ўҐаЁвм  «ЁзЁҐ ў Ї ¬пвЁ

     mov   BL,DS:[5Dh]     ;ї
     and   BL,11011111b    ;і
     cmp   BL,'I'          ;іа §®Ўа вм Є«оз (§ ®бЁвбп
     je    Install         ;іў ®Ў« бвм FCB1 PSP)
     cmp   BL,'U'          ;і
     je    Uninst          ;Щ

     call  @InfoAbout      ;ўлўҐбвЁ Ёд®а¬ жЁо
     jmp   short ToDos     ;Ё ўҐагвмбп ў DOS
                           ;Ґб«Ё Є«оз Ґ в®в
   Install:
     lea   DX,AlreadyMsg
     cmp   InstFlag,On     ;їҐб«Ё г¦Ґ гбв ®ў«Ґ ,в®
     je    Output          ;ЩЇҐаҐ©вЁ   ўлў®¤ б®®ЎйҐЁп

     xor   AX,AX           ;їЁ зҐ Ї®«гзЁвм  з «®
     mov   ES,AX           ;іўЁ¤Ґ®®Ў« бвЁ : Ґб«Ё ў Ў ©вҐ Ї®
     mov   AL,ES:[411h]    ;і ¤аҐбг 0000h:0411h гбв ®ў«Ґ
     and   AL,30h          ;і3-© ЎЁв,в® бҐЈ¬Ґвл©  ¤аҐб  -
     cmp   AL,30h          ;із «  ўЁ¤Ґ®®Ў« бвЁ 0B000h Ё зҐ
     jne   Vid1            ;ібҐЈ¬Ґвл©  ¤аҐб а ўҐ 0B800h
     mov   VideoBeg,0B000h ;Щ

   Vid1:
     call  GrabIntVec      ;§ еў вЁвм г¦лҐ ўҐЄв®а 

     mov   AX,DS:[2Ch]     ;ї®бў®Ў®¤Ёвм ®Єаг¦ҐЁҐ,ўл¤Ґ«Ґ-
     mov   ES,AX           ;і®Ґ Їа®Ја ¬¬Ґ ¤«п г¬ҐмиҐЁп
     mov   AH,49h          ;і§ Ё¬ Ґ¬®© ў аҐ§Ё¤ҐвҐ Ї ¬пвЁ
     int   21h             ;Щ

     mov   AH,09h          ;їўлўҐбвЁ б®®ЎйҐЁҐ ®Ў гбв ®ўЄҐ
     lea   DX,InstMsg      ;іў аҐ§Ё¤Ґв
     int   21h             ;Щ

     lea   DX,ResEnd       ;ї§ ўҐаиЁвм Ё ®бв ўЁвм Їа®Ја ¬-
     int   27h             ;Щ¬г ў аҐ§Ё¤ҐвҐ

   Uninst:
     lea   DX,NotInstMsg   ;їҐб«Ё Їа®Ја ¬¬  Ґ гбв ®ў«Ґ ,
     cmp   InstFlag,Off    ;ів® ўлўҐбвЁ б®®ЎйҐЁҐ ®Ў нв®¬
     je    Output          ;Щ

     lea   DX,NotSafeMsg   ;їҐб«Ё Їа®Ја ¬¬г Ґў®§¬®¦®
     call  TestIntVec      ;ібпвм б аҐ§Ё¤Ґв ,в® ўлўҐбвЁ
     jc    Output          ;Щб®®ЎйҐЁҐ ®Ў нв®¬

     call  FreeIntVec      ;®бў®Ў®¤Ёвм ўҐЄв®а  ЇаҐалў Ё©

     mov   AH,49h          ;ї®бў®Ў®¤Ёвм Ї ¬пвм,§ Ё¬ Ґ¬го
     mov   ES,SaveCS       ;іаҐ§Ё¤Ґв®© з бвмо Їа®Ја ¬¬л
     int   21h             ;Щ

     lea   DX,UninstMsg

   Output:
     mov   AH,09h          ;їўлўҐбвЁ г¦®Ґ б®®ЎйҐЁҐ
     int   21h             ;Щ

   ToDos:
     mov   AX,4C00h        ;їўҐагвмбп ў DOS б Є®¤®¬
     int   21h             ;Щ§ ўҐаиҐЁп 0
     ret                   ;ў®§ўа в
 InitProc endp

 ;
 ;ЏђЋ–…„“ђЂ ЏђЋ‚…ђЉ€ ‚…ђ‘€€ DOS
 ;ў®§ўа й Ґв гбв ®ў«Ґл© д« Ј ЇҐаҐ®б ,Ґб«Ё
 ;ўҐабЁп DOS ¬ҐмиҐ § ¤ ®© ў MinDosVer

 ChkDosVer proc
     mov   AH,30h         ;їЇ®«гзЁвм ў AX ®¬Ґа ўҐабЁЁ
     int   21h            ;ЩDOS
     cmp   AL,MinDosVer   ;ба ўЁвм ҐҐ б ¬ЁЁ¬ «м®©

     clc                  ;бЎа®бЁвм д« Ј ЇҐаҐ®б  (CF)
     jge   Norma          ;Ґб«Ё ўҐабЁп Ї®¤е®¤пй п
     stc                  ;Ё зҐ гбв ®ўЁвм д« Ј ЇҐаҐ®б 

   Norma:
     ret                  ;ў®§ўа в
 ChkDosVer endp

 ;
 ;ЏђЋ–…„“ђЂ ЋЏђ…„…‹…Ќ€џ ЌЂ‹€—€џ ЏђЋѓђЂЊЊ› ‚ ЏЂЊџ’€

 PresentTest proc
     mov   InstFlag,Off   ;бЎа®бЁвм д« Ј  «ЁзЁп ў аҐ§Ё¤ҐвҐ
     mov   AH,FuncNum     ;ї®Ўа вЁвмбп Є  иҐ¬г Їа®жҐббг
     int   16h            ;Щ
     cmp   AX,CodeOut     ;Ї®«гзЁ«Ё ®вўҐв?
     jne   Return         ;Ґб«Ё Ґв,в® Є®Ґж
     mov   InstFlag,On    ;Ё зҐ гбв ®ўЁвм д« Ј  «ЁзЁп
   Return:
     ret                  ;ў®§ўа в
 PresentTest endp

 ;
 ;ЏђЋ–…„“ђЂ ‡Ђ•‚Ђ’Ђ ‚…Љ’ЋђЋ‚ Џђ…ђ›‚ЂЌ€‰

 GrabIntVec proc
     mov   AX,3509h       ;їб®еа Ёвм ў® ўгваҐЁе ЇҐаҐ-
     int   21h            ;і¬Ґле бв ал© ўҐЄв®а ЇаҐалў -
     mov   OfsInt09,BX    ;іЁп Int09h
     mov   SegInt09,ES    ;Щ

     mov   AX,3516h       ;їб®еа Ёвм ў® ўгваҐЁе ЇҐаҐ-
     int   21h            ;і¬Ґле бв ал© ўҐЄв®а ЇаҐалў -
     mov   OfsInt16,BX    ;іЁп Int16h
     mov   SegInt16,ES    ;Щ

     mov   AX,2509h       ;їгбв ®ўЁвм Int09Hand ў Є зҐбвўҐ
     lea   DX,Int09Hand   ;і®ў®Ј® ®Ўа Ў®взЁЄ  ЇаҐалў Ёп
     int   21h            ;ЩInt09

     mov   AX,2516h       ;їгбв ®ўЁвм Presense ў Є зҐбвўҐ
     lea   DX,Presense    ;і®ў®Ј® ®Ўа Ў®взЁЄ  ЇаҐалў Ёп
     int   21h            ;ЩInt16h
     ret
 GrabIntVec endp

 ;
 ;ЏђЋ–…„“ђЂ ЏђЋ‚…ђЉ€ Џ…ђ…•‚Ђ’Ђ ‚…Љ’ЋђЋ‚ Џђ…ђ›‚ЂЌ€‰
 ;ў®§ўа й Ґв гбв ®ў«Ґл© д« Ј ЇҐаҐ®б  ў б«гз Ґ ЇҐаҐеў в 
 ;е®вп Ўл ®¤®Ј® ўҐЄв®а  ЇаҐалў Ёп

 TestIntVec proc
     mov   AX,3509h            ;їЇа®ўҐаЁвм, е®¤Ёвбп «Ё Є®-
     int   21h                 ;і¤®ў®Ґ б«®ў® ЇҐаҐ¤ ®Ўа Ў®в-
     cmp   ES:[BX-2],TestInt09 ;ЩзЁЄ®¬ ЇаҐалў Ёп Int09
     stc                       ;гбв ®ўЁвм д« Ј ЇҐаҐ®б  CF,
     jne   Cant                ;Ґб«Ё ЇаҐалў ЁҐ ЇҐаҐеў вЁ«Ё

     mov   AX,3516h            ;їЇа®ўҐаЁвм, е®¤Ёвбп «Ё Є®-
     int   21h                 ;і¤®ў®Ґ б«®ў® Ї®аҐ¤ ®Ўа Ў®в-
     cmp   ES:[BX-2],TestInt16 ;ЩзЁЄ®¬ ЇаҐалў Ёп Int16h
     stc                       ;гбв ®ўЁвм д« Ј ЇҐаҐ®б  CF,
     jne   Cant                ;Ґб«Ё ЇаҐалў ЁҐ ЇҐаҐеў вЁ«Ё

     mov   SaveCS,ES           ;§ Ї®¬Ёвм CS аҐ§Ё¤Ґв®©
     clc                       ;Їа®Ја ¬¬л,бЎа®бЁвм д« Ј
                               ;ЇҐаҐ®б 
   Cant:
     ret                       ;ў®§ўа в
 TestIntVec endp

 ;
 ;ЏђЋ–…„“ђЂ ‚Ћ‘‘’ЂЌЋ‚‹…Ќ€џ ‡Ђ•‚Ђ—…ЌЌ›• ‚…Љ’ЋђЋ‚ Џђ…ђ›‚ЂЌ€‰

 FreeIntVec proc
     push  DS             ;б®еа Ёвм DS

     mov   AX,2509h       ;їў®ббв ®ўЁвм ўҐЄв®а ЇаҐалў Ёп
     mov   DS,ES:SegInt09 ;іInt09h Ё§ ўгваҐЁе ЇҐаҐ¬Ґле
     mov   DX,ES:OfsInt09 ;іаҐ§Ё¤Ґв®© Їа®Ја ¬¬л
     int   21h            ;Щ

     mov   AX,2516h       ;їў®ббв ®ўЁвм ўҐЄв®а ЇаҐалў Ёп
     mov   DS,ES:SegInt16 ;іInt16h Ё§ ўгваҐЁе ЇҐаҐ¬Ґле
     mov   DX,ES:OfsInt16 ;іаҐ§Ё¤Ґв®© Їа®Ја ¬¬л
     int   21h            ;Щ

     pop   DS             ;ў®ббв ®ўЁвм DS
     ret                  ;ў®§ўа в
 FreeIntVec endp

 PROGRAM   ends
           end   Start
