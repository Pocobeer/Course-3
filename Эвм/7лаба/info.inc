 @TopRow     equ   1
 @LeftCol    equ   3
 @BotRow     equ   22
 @RightCol   equ   76
 @MsgAddres  dw    ?
 @VGAFlag    db    1
 @ScrBufSeg  dw    0B800h
 @PageOfs    dw    ?
 @SaveRegime db    ?
 @Attr1      db    74*8 dup(1Ch),74*2 dup(0)
 @Attr2      db    74*13 dup(1Eh)
 @PelRegMas  db    300h dup(?)

 ifdef       Color
 @ColorInfo  db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC� '
             db    ' �                                                                      � '
             db    ' �                   CCCCC  CCCCC  C     CCCCC  CCCCC                   � '
             db    ' �                   C      C   C  C     C   C  C   C                   � '
             db    ' �                   C      C   C  C     C   C  CCCC                    � '
             db    ' �                   CCCCC  CCCCC  CCCCC CCCCC  C  CC                   � '
             db    ' �                                                                      � '
             db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ����������������������������������������������������������������������ͻ '
             db    ' �  COLOR - �� ������C 樮 �  �C��C ��  �� �ᯮ�짮� �� ��⥬��  � '
             db    ' �  �C���� MS DOS � BIOS  ��� IBM-ᮢ���⨬��  �������C��. COLOR ��-  � '
             db    ' �  ������ ������� ��C�� 16 梥⮢�� C�����C�� � � ��� ����� �C �-  � '
             db    ' �  ���, ������� � ᨥ�� 梥⮢. ��C ����� �����⢫���� �� ��� -  � '
             db    ' �  ��:                                                                 � '
             db    ' �     7,8,9         - 㢥��票� ����� �C ᮣ�, ������� � ᨥ��;    � '
             db    ' �     4,5,6         - 㬥�襨� ����� �C ᮣ�, ������� � ᨥ��;    � '
             db    ' �     gray+ � gray- - ᬥ  ����塞��� 梥⮢��� C�����C ;            � '
             db    ' �     Enter         - � ��C襨� �C��C ��� � ��C ���� �������;    � '
             db    ' �     Esc           - � ��C襨� �C��C ��� � ����� ������� � ���C�.  � '
             db    ' ����������������������������������������������������������������������ͼ '
 endif

 ifdef       Defend
 @DefendInfo db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC� '
             db    ' �                                                                      � '
             db    ' �               CCCCC  CCCCC  CCCCC  CCCCC  C    C  CCCCC              � '
             db    ' �               C   C  CCCC   CCCC   CCCC   CCC  C  C   C              � '
             db    ' �               C   C  C      C      C      C  CCC  C   C              � '
             db    ' �               CCCCC  CCCCC  C      CCCCC  C    C  CCCCC              � '
             db    ' �                                                                      � '
             db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ����������������������������������������������������������������������ͻ '
             db    ' �  DEFEND - �� ������C 樮 � �C��C ��  �� �ᯮ�짮� �� ��⥬��  � '
             db    ' �  �C���� MS DOS � BIOS  ��� IBM-ᮢ���⨬�� �������C��. DEFEND � -  � '
             db    ' �  �� �� COM-C ��� �� ����C�� �� ��⮤�� �C��離� � �����   ��᪥.  � '
             db    ' �  ��᫥  ����C�� �� � �� �  �C��C ��  �뢥��� ᮮ�饨� � �� -  � '
             db    ' �  ����� C ��� ��. � �C��C ��� � �C���ᬮ�C�� �C�⨥ ��� ���  � -  � '
             db    ' �  ��� �� �� �稪�� � ��� �ᥬ���C��, �� ��� �� � ��� �C ���᪨  � '
             db    ' �  �����᫥��, � ��� ���� �� ���室�饩 ��� �C���C . �C� � ��᪥  � '
             db    ' �  ���室��� �C��  �C����  � � �� ��� � �� ����� C �� , ���C� �  � '
             db    ' �  ��᫥��⢨� �� �� � ���, �᪮�쪮  㤫������. ������⢨�  � '
             db    ' �  ���� C ��  � ��� ��� ��C��� �맮��� ����� � �� �C�C� 樨. � '
             db    ' ����������������������������������������������������������������������ͼ '
 endif

 ifdef       Locker
 @LockerInfo db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC� '
             db    ' �                                                                      � '
             db    ' �               C      CCCCC  CCCCC  C  CC   CCCCC  CCCCC              � '
             db    ' �               C      C   C  C      CCC     CCCC   C   C              � '
             db    ' �               C      C   C  C      C CC    C      CCCC               � '
             db    ' �               CCCCC  CCCCC  CCCCC  C   CC  CCCCC  C  CC              � '
             db    ' �                                                                      � '
             db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ����������������������������������������������������������������������ͻ '
             db    ' �  LOCKER - �� ������C 樮 � �C��C ��  �� �ᯮ�짮� �� ��⥬��  � '
             db    ' �  �C���� MS DOS � BIOS  ��� IBM-ᮢ���⨬�� �������C��. LOCKER ��-  � '
             db    ' �  ������ "� ��C ��" �� �� ��C�   �C���  � 襣� ������⢨�, �᫨ ��  � '
             db    ' �  ��� ��-� �C��� �� ����C��� �� � ��� ���� ⥫쮣� ���� -  � '
             db    ' �  ⥫��� . �C� � ��᪥ �ᯮ������� ᫥���騥 ����:                 � '
             db    ' �     /i - ��� ����� �C��C ��� � C������;                            � '
             db    ' �     /u - ���� �C��C ��� � C������ .                                � '
             db    ' �  �� �� ��C   "� ��C ����"   � ⨥� <Cntrl+Alt+X> ,    "�⯨C ����"  � '
             db    ' �  �C��C ��  � ⨥�   <Cntrl>  (��-��-��). ��  �C㣮� ����  � '
             db    ' �  ��� ��� ������⢨� �맮��� ����� � �� �C�C� 樨.             � '
             db    ' ����������������������������������������������������������������������ͼ '
 endif

 ifdef       Floppy
 @FloppyInfo db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC� '
             db    ' �                                                                      � '
             db    ' �               CCCCC  C      CCCCC  CCCCC  CCCCC  C   C               � '
             db    ' �               CCCC   C      C   C  C   C  C   C  CC CC               � '
             db    ' �               C      C      C   C  CCCC   CCCC     C                 � '
             db    ' �               C      CCCCC  CCCCC  C      C        C                 � '
             db    ' �                                                                      � '
             db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ����������������������������������������������������������������������ͻ '
             db    ' �  FLOPPY - �� ������C 樮 � �C��C ��  �� �ᯮ�짮� �� ��⥬��  � '
             db    ' �  �C���� MS DOS � BIOS  ��� IBM-ᮢ���⨬�� �������C��. FLOPPY ��-  � '
             db    ' �  �  ���� �� � �C�� � ��� ��� �⥨�/� ���   floppy-��᪮����.    � '
             db    ' �  �C� � ��᪥ �ᯮ������� ᫥���騥 ����:                           � '
             db    ' �     /w - � ��  �� � ��� � ��� ���  � p������;                    � '
             db    ' �     /r - � ��  �� �⥨�/� ��� � ��� ���  � p������;             � '
             db    ' �     /n - ��⨥ � ��� � ��� ���  � p������;                       � '
             db    ' �     /u - ���� �C��C ��� � C������ .                                � '
             db    ' �  ��� ���  � C������ ⮫쪮 �C� ��C��� � ��᪥. �� �C㣮� ����   � '
             db    ' �  ��� ��� ������⢨� �맮��� ����� � �� �C�C� 樨.             � '
             db    ' ����������������������������������������������������������������������ͼ '
 endif

 ifdef       Elisa
 @ElisaInfo  db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC� '
             db    ' �                                                                      � '
             db    ' �                 CCCCC  C      CCCCC  CCCCC   CCC                     � '
             db    ' �                 CCCC   C        C    CCC    C   C                    � '
             db    ' �                 C      C        C       CC  CCCCC                    � '
             db    ' �                 CCCCC  CCCCC  CCCCC  CCCCC  C   C                    � '
             db    ' �                                                                      � '
             db    ' CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC '
             db    '                                                                          '
             db    '                                                                          '
             db    ' ����������������������������������������������������������������������ͻ '
             db    ' �  ELISA - �� ������C 樮 � �C��C ��  �� �ᯮ�짮� �� ��⥬��   � '
             db    ' �  �C���� MS DOS � BIOS ��� IBM-ᮢ���⨬�� �������C��. ELISA ���-   � '
             db    ' �  �C�������� �������, ���� � �����   �C�������⥫����  ������-   � '
             db    ' �  �C . �C� � ��᪥ �ᯮ������� ᫥���騥 ����:                     � '
             db    ' �     /i - ��� ����� �C��C ��� � C������ (install);                  � '
             db    ' �     /u - ���� �C��C ��� � C������  (uninstall).                    � '
             db    ' �  �� �C㣮� ���� ��� ��� ������⢨� �맮��� ����� � �� �-   � '
             db    ' �  C�C� 樨.                                                           � '
             db    ' �                                                                      � '
             db    ' �                                                                      � '
             db    ' ����������������������������������������������������������������������ͼ '
 endif

 @WriteInfo  proc
             push  ES

             ifdef Floppy
              lea   BP,@FloppyInfo
             endif

             ifdef Elisa             
              lea   BP,@ElisaInfo
             endif
             
             ifdef Locker
              lea   BP,@LockerInfo
             endif   

             ifdef Color
              lea   BP,@ColorInfo
             endif

             ifdef Defend
              lea   BP,@DefendInfo
             endif

             lea   SI,@Attr1
             mov   AX,@ScrBufSeg
             mov   ES,AX
             mov   DH,@TopRow
             mov   AL,160
             mul   DH
             mov   DI,AX
    @L1Draw: mov   DL,@LeftCol
             xor   BH,BH
             mov   BL,DL
             shl   BX,1
             add   BX,@PageOfs
    @L2Draw: mov   AH,DS:[SI]
             inc   SI
             mov   AL,DS:[BP]
             inc   BP
             mov   ES:[BX+DI],AX
             inc   BX
             inc   BX
             inc   DL
             cmp   DL,@RightCol
             jbe   @L2Draw
             add   DI,160
             inc   DH
             cmp   DH,@BotRow
             jbe   @L1Draw
             pop   ES
             ret
 @WriteInfo  endp
 
 @TestVideo  proc
             mov   AH,0Fh
             int   10h
             mov   @SaveRegime,AL
             cmp   AL,07h
             mov   AL,02h
             jne   @NotMDA

             mov   @ScrBufSeg,0B000h
             mov   AL,70h
             mov   CX,74*8
             lea   DI,@Attr1
             rep   stosb
             mov   AL,07h
             mov   CX,74*13
             lea   DI,@Attr2
             rep   stosb

   @NotMDA:  xor   AH,AH
             int   10h
             mov   CH,20h
             mov   AH,1
             int   10h

             push  ES
             xor   AX,AX
             mov   ES,AX
             mov   AX,ES:[44Eh]
             mov   @PageOfs,AX
             pop   ES
             
             mov   AX,1A00h
             int   10h
             cmp   AL,1Ah
             je    @EndTst
             dec   @VGAFlag

   @EndTst:  ret
 @TestVideo  endp

 @ReadPelReg proc
             mov   DX,3C7h
             xor   AL,AL
             cli
             out   DX,AL

             mov   CX,300h
             mov   DX,3C9h

   @NextPelR:in    AL,DX
             and   AL,3Fh
             stosb
             loop  @NextPelR

             sti
             ret
 @ReadPelReg endp

 @WritePelReg proc
             mov   DX,3C8h
             xor   AL,AL
             cli
             out   DX,AL

    @Vert:   mov   DX,3DAh
             in    AL,DX            
             and   AL,08h
             jz    @Vert

             mov   CX,300h
             mov   DX,3C9h

   @NextPelW:lodsb
             or    AL,AL
             jz    @OutPel
             add   AL,AH
             cmp   AL,0
             jg    @MaxPel
             mov   AL,0
             jmp   short @OutPel

   @MaxPel:  cmp   AL,3Fh
             jbe   @OutPel
             mov   AL,3Fh

   @OutPel:  out   DX,AL
             loop  @NextPelW

             sti
             ret
 @WritePelReg endp

 @BeepSound  proc
             mov     CX,90
             mov     DX,600
             mov     BX,600

             in      AL,61h
             and     AL,0FEh

    @L1Beep: push    CX
             or      AL,02h
             out     61h,AL

             mov     CX,DX
    @L2Beep: loop    @L2Beep
             sub     DX,5

             and     AL,0FDh
             out     61h,AL

             mov     CX,BX
    @L3Beep: loop    @L3Beep
             add     BX,5

             pop     CX
             loop    @L1Beep

             ret
 @BeepSound  endp

 @InfoAbout  proc
             cld
             mov   @MsgAddres,DX
             call  @TestVideo
             cmp   @VGAFlag,1
             jne   @NotVGA

             lea   DI,@PelRegMas
             call  @ReadPelReg
             mov   AH,-60
             lea   SI,@PelRegMas
             call  @WritePelReg

    @NotVGA: call  @WriteInfo
             cmp   @VGAFlag,1
             jne   @Key

             mov   AH,-60

    @Next:   inc   AH
             lea   SI,@PelRegMas
             call  @WritePelReg

             mov   CX,25000
    @Pausa:  loop  @Pausa

             cmp   AH,0
             jne   @Next

    @Key:    call  @BeepSound
             mov   AH,08h
             int   21h

             xor   AH,AH
             mov   AL,@SaveRegime
             int   10h
             ret 
 @InfoAbout  endp
