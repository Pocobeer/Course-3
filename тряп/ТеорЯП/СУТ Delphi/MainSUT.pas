unit MainSUT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, xmldom, XMLIntf, msxmldom, XMLDoc;

type
  TfrmMainSUT = class(TForm)
    GrBoxProg: TGroupBox;
    StBarProg: TStatusBar;
    Label2: TLabel;
    memError: TMemo;
    lblZagRez: TLabel;
    memToken: TMemo;
    btnLoad: TButton;
    btnSave: TButton;
    btnScan: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    memData: TMemo;
    Label1: TLabel;
    XMLDoc: TXMLDocument;
    GrBoxLR: TGroupBox;
    btnSut: TButton;
    btnLoadXml: TButton;
    GrBoxLL: TGroupBox;
    btnSutLL: TButton;
    btnLoadLL: TButton;
    REdProg: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
    procedure btnSutClick(Sender: TObject);
    procedure btnLoadXmlClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnLoadLLClick(Sender: TObject);
    procedure btnSutLLClick(Sender: TObject);
    procedure REdProgChange(Sender: TObject);
    procedure REdProgKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure REdProgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainSUT: TfrmMainSUT;

implementation

{$R *.dfm}

type
//����������� ������ (���� �������)
  tLexCode = ( //������� ������� �� ����, � ������ �� �������
    //�������� �����
    lcProg,   //1 - prog
    lcStart,  //2 - start
    lcStop,   //3 - stop
    lcVar,    //4 - var
    //������ ������
    lcSemi,   //5 - ����� � ������� ;
    lcColon,  //6 - ��������� :
    lcComma,  //7 - ������� ,
    lcOpPar,  //8 - ����������� ������ (
    lcClPar,  //9 - ����������� ������ )
    lcAss,    //10 - ������������ :=
    lcAdd,    //11 - ���������� �������� + � -
    lcMult,   //12 - ����������������� �������� * � /
    lcId,     //13 - ������������� id
    lcNum,    //14 - ����� num
    //���������
    lcEof,    //15 - ������ ����� �����
    lcErr);   //16 - ����������� ������
  tElLexClass = record //����������� ������ � ��� ���
    LexName: string;   //����������� ������������ ������
    LexCode: tLexCode; //��� ������������ ������ (������)
  end;
//��������� ��������������� ��� �����
  tCatId = (
    catNoCat,    //�������� ���������
    catProgName, //��� ���������
    catTypeName, //��� ����
    catVarName, //��� ����������
    catConst);    //�����
//���� ����� ������ (������� type)
  tTypesCode = (
    typeVoid,  //���������� ����
    typeInt,   //����� ���
    typeReal);  //������������ ���
//������� ���� ������
  tType = record
    TypeCode: tTypesCode; //��� ���� ������
    Width: integer; //������ ����
  end;
//�������� ��� ����. ������� lcAdd, lcMult
  tOperCode = (
    //���������� �������� (������� op)
    opAdd, //�������� '+'
    opSub, //��������� '-'
    //����������������� �������� (������� op)
    opMult, //��������� '*'
    opDiv, //������� '/'
    //������������ �������
    opAss); //���� x := y
//���� ��� ������� �������� (������������ ��� ������� ������)
  tPntElTblIde = ^tElemTblIde; //��������� �� ������ ����. ��������
  tElemTblIde = record //������ ������� �������� (���� �������� ������)
    RowNum: Byte; //����� ������, ����� ������ ��� ����������� �������� ������
                  //��� id � num (�� ����� ������ ���, � ���� ���������
                  //�� ���� �������� ������ ��������)
    Lex: string; //������� �������������� ��� �����
    Cat: tCatId; //��������� �������������� ��� �����
    Typ: tType; //��� (type - �������� �����, ������� ���� ������� Typ)
    Addr: integer; //����� ���������� � ������
    NextEl: tPntElTblIde; //����. ������� ������� ��������
  end;
  tTblIde = record //������� ��������
    NumRows: integer; //����� ����� (�����), ����� ������ ��� ��������� RowNum
    PntFirst: tPntElTblIde; //��������� �� ������ ����
  end;
//��������� ������
  tToken = record
    Code: tLexCode; //��� ������ (������������ ������)
    Attr: Pointer; //������� ������
    Name: string; //����������� ������ (��� ������������)
    LexBeg, LexEnd: Word; //��� ����������� ������
  end;
//������� ������ ��� ������������� ���������
  tPntNodeInt = ^tNodeForInt;
  tNodeForInt = record //���� ������
    Info: integer; //�������� ��������
    Next: tPntNodeInt; //��������� �� ��������� ����
  end;
//������� ������ ��� ����������
  tPntNodePnt = ^tNodeForPnt;
  tNodeForPnt = record //���� ������
    Info: Pointer; //���������
    Next: tPntNodePnt; //��������� �� ��������� ����
  end;
//��� ����� �������
  tIntStack = record
    Top: tPntNodeInt; //��������� �� ������� (������ ������� ������)
  end;
//��� ����� ���������
  tPntStack = record
    Top: tPntNodePnt; //��������� �� ������� �����
  end;
//������� LR-������� �������
  tElemLR = record
    ElType: Byte; //��� �������� (lrErr, lrShift, lrReduct, lrStop)
    ElPar: Byte; //�������� �������� (��� �������� �������� - ��� ����� ���������,
                //��� �������� ������� - ����� ������ ����� ������������ ���������
    Left: Byte; //��� ������ ����������� ������������ ���������
    Act: Byte; //��� ������� �������� (0, ���� �������� ���)
  end;
  tInst = record //������������ ������� (��������)
    Op: tOperCode; //��� ��������
    Arg1, Arg2, Res: Pointer;
  end;
//������� LL-������� �������
  tElemLL = record
    Jump: Word; //���� ���������
    Accept: Boolean; //���� ������
    Stack: Boolean; //���� �����
    Action: Byte; //���� ��������
    Error: Boolean; //���� ������
    Terminals: set of tLexCode; //������ ����� ����������
  end;
const
  //����������� ����. ������� � ����
  LexClass: array [tLexCode] of tElLexClass = (
    (LexName: 'prog';  LexCode: lcProg),
    (LexName: 'start'; LexCode: lcStart),
    (LexName: 'stop';  LexCode: lcStop),
    (LexName: 'var';   LexCode: lcVar),
    (LexName: ';';     LexCode: lcSemi),
    (LexName: ':';     LexCode: lcColon),
    (LexName: ',';     LexCode: lcComma),
    (LexName: '(';     LexCode: lcOpPar),
    (LexName: ')';     LexCode: lcClPar),
    (LexName: 'ass';   LexCode: lcAss),
    (LexName: '+';     LexCode: lcAdd),
    (LexName: '*';     LexCode: lcMult),
    (LexName: 'id';    LexCode: lcId),
    (LexName: 'num';   LexCode: lcNum),
    (LexName: 'eof';   LexCode: lcEof),
    (LexName: 'err';   LexCode: lcErr));
  LastKeyWord = lcVar; //��������� �������� ����� � ������ ��� �� ������
//��� Scaner � SelectLexemes, ������� ����������
  Letters = ['A'..'Z', '�'..'�', '�']; //�����
  Digits = ['0'..'9'];                //�����
//������� ��������� ��� ���������.
//��� ���������� ������ ������, �������������� �������, ����� ����. ������� NomStrOfTP
  JumpTbl: array [1..19,0..7] of integer = (
//����-��: 0   1   2   3   4   5   6   7
    {1} ( -1, -9,-11,-12,-17,-13,-14,  7), //';' ����� � �������
    {2} (  1, -9,-11,-12,-17,-13,-14,  7), //':' ���������
    {3} ( -2, -9,-11,-12,-17,-13,-14,  7), //',' �������
    {4} (-16, -9,-11,  4,-17,-13,-14,  7), //'.' �����
    {5} ( -3, -9,-11,-12,-17,-13,-14,  7), //'(' ����������� ������
    {6} ( -4, -9,-11,-12,-17,-13,-14,  7), //')' ����������� ������
    {7} ( -5, -9,-11,-12,-17,-13,-14,  7), //'+' ����
    {8} ( -6, -9,-11,-12,-17,-13,-14,  7), //'-' �����
    {9} ( -7, -9,-11,-12,-17,-13,-14,  7), //'*' ���������
   {10} ( -8, -9,-11,-12,-17,-13,-14,  7), //'/' �������
   {11} (-16,-10,-11,-12,-17,-13,-14,  7), //'=' �����
   {12} (  2, -9,  2,-12,-17,-13,-14,  7), //l �����
   {13} (  3, -9,  2,  3,  5,  5,-14,  7), //d �����
   {14} (  7, -9,-11,-12,-17,-13,-14,  7), //���.����
   {15} (-16, -9,-11,-12,-17,-13,-14,-15), //���.����
   {16} (  6, -9,-11,-12,-17,-13,  6,  7), //sp ������
   {17} (  6, -9,-11,-12,-17,-13,  6,  7), //tab ���������
   {18} (  6, -9,-11,-12,-17,-13,  6,  7), //lf ������� ������
   {19} (-16, -9,-11,-12,-17,-13,-14,  7)); //������ �������
  //�������� ��������� �������� (������� fs)
  fsSemi = -1;     //����� � ������� ';'
  fsComma = -2;    //������� ','
  fsOpPar = -3;    //����������� ������ '('
  fsClPar = -4;    //����������� ������ ')'
  fsAddAdd = -5;   //���������� �������� '+'
  fsAddSub = -6;   //���������� ��������� '-'
  fsMultMult = -7; //����������������� ��������� '*'
  fsMultDiv = -8;  //����������������� ������� '/'
  fsColon = -9;    //��������� ':'
  fsAss = -10;     //������������ ':='
  fsNumInt = -12;  //����� num �����
  fsNumReal = -13; //����� num ������������
  fsId = -11;      //������������� id
  fsTab = -14;     //���������, ������� � �.�.
  fsCom = -15;     //�����������
  fsEr1 = -16;     //������� �� ����� ���������� � ������� �������
  fsEr2 = -17;     //�������� ������ �����
  fsErCom = -18;   //��� ������� ����� �����������
  fsEof = -19;     //������ ����� �����
  //������� ���������� ��������� ������������, ���� ��� ����� �����������
  isCom = 7;       //���������� ��������� �����������
//*****************
  //���������� �������� ��������� ���������
  MaxDataMem = 500; //������������ ������ ������ ������
  MaxInstrMem = 1000; //������������ ������ ������ ������
  MaxStateLR = 300; //������������ ����� ��������� (�����) ������� �������
  MaxSymLR = 300; //������������ ����� �������� (��������) LR-������� �������
  MaxRowLL = 300; //������������ ����� ����� LL-������� �������
  //������� ���������������� ����� � ������ (������� w)
  wInt = 4; //�����
  wReal = 8; //������������
  wBool = 1; //���������
  //���� ��������� LR-������� ������� (���� ElType) (������� lr)
  lrErr = 0; //������� ������
  lrShift = 1; //������� ��������
  lrReduct = 2; //������� �������
  lrStop = 3; //������� ��������
var
  ReadedFileName: String;
  ChangeProg: Boolean;
  TblIde: tTblIde; //������� ��������
  CntTmpVar, NumColLR, NumNeTerm, NumStrLL, LngTxt: integer;
  StrProg: string; //����� - ����� �����
  f, r: integer; //f-������ ������ �������, r-����������� �� f �� ����� �������
//��� LR-�������
  LRTbl: array [1..MaxStateLR,1..MaxSymLR] of tElemLR; //LR-������� �������
  //������� ���. �����������: 1..NumNeTerm - �����������,
  //NumNeTerm+1..NumColLR - ���������, ����������� �� xml-�����
  SymsLR: array [1..MaxSymLR] of string;
  //������������ ����� ����. ������� (��������� �� LexClass) � �������
  //�������� � ����. �������
  LexCodeLR: array [tLexCode] of integer;
//******************
  AttrSt: tPntStack; //���� ���������
  ParserSt: tIntStack; //���� ��������� �������
//  AttrSt, ParserSt:tStack; //���� ��������� � ���� ���������
//��� ��������� ����. ����
  DataMem: array [0..MaxDataMem] of Byte; //������ ������
  InstrMem: array [0..MaxInstrMem] of tInst; //������ ������
	NextAddr: integer; //����� ��������� ��������� ������ � ������ ������.
	NextInstr: integer; //����� ��������� ������������ ������� � ������ ������.
  LLTbl: array [1..MaxRowLL] of tElemLL; //LL-������� �������

procedure ClearTblIde;
//������� ������� ��������
var
  p: tPntElTblIde;
begin
  while TblIde.PntFirst <> nil do
  begin
    p:=TblIde.PntFirst;
    TblIde.PntFirst:=p.NextEl;
    Dispose(p);
  end;
  TblIde.NumRows:=0;
end;

//��� Scaner � SelectLexemes, ������� ����������
function SearchLexKey(Lex: string): tLexCode;
//����� ��������� �����. ���������� ��� ������ ��� lcErr, ���� �� �������.
//�������� ����� � ������� LexClass � 1-� �� cntKeys �������
//��� ����������� �������� ���� � LexClass - �������� �����!!!
var
  LexCd: tLexCode;
  str: string;
begin //������� ���������������� �����
  str:=AnsiLowerCase(Lex);
  LexCd:=Low(tLexCode);
  while LexCd <= LastKeyWord do //����� ��������� �����
  begin
   if str = LexClass[LexCd].LexName then //�������
     Break;
   LexCd:=succ(LexCd);
  end;
  if LexCd > LastKeyWord then //������� �� �������
    Result:=lcErr
  else Result:=LexClass[LexCd].LexCode; //������� �������. ��� �������� �����
end; //SearchLexKey

function NumRowOfJT(Sym: char): integer;
//���������� ����� ������ � ������� ��������� JumpTbl ��� ������� Sym
var
  StrUp:string;
  CharUp:char;
begin
  StrUp:=Sym;
  StrUp:=AnsiUpperCase(StrUp);
  CharUp:=StrUp[1];
  if CharUp in Letters then Result:=12 //�����
  else if Sym in Digits then Result:=13 //�����
  else
    case Sym of
      ';': Result:=1;
      ':': Result:=2;
      ',': Result:=3;
      '.': Result:=4;
      '(': Result:=5;
      ')': Result:=6;
      '+': Result:=7;
      '-': Result:=8;
      '*': Result:=9;
      '/': Result:=10;
      '=': Result:=11;
      '{': Result:=14;
      '}': Result:=15;
      ' ': Result:=16;
      #9: Result:=17; //���������
      #10,#13: Result:=18; //������� ������
      else Result:=19; //����� ������ ������
    end;
end; //NumRowOfJT
//****************************************

procedure AddElemTblIde(Lex: string; Cat: tCatId; Typ: tType);
//���������� �������� � ������� ��������
var
  p: tPntElTblIde;
begin
  TblIde.NumRows:=TblIde.NumRows+1;
  New(p);
  p^.RowNum:=TblIde.NumRows;
  p^.Lex:=Lex;
  p^.Cat:=Cat;
  p^.Typ:=Typ;
  p^.Addr:=-1;
  p^.NextEl:=TblIde.PntFirst;
  TblIde.PntFirst:=p;
end;

procedure AddBaseTypes;
//���������� � ������� �������� ���������������� ����� (���������� � ������ ������)
var
  t: tType;
begin
  t.TypeCode:=typeInt;
  t.Width:=wInt;
  AddElemTblIde('integer', catTypeName, t);
  t.TypeCode:=typeReal;
  t.Width:=wReal;
  AddElemTblIde('real', catTypeName, t);
end; //AddBaseTypes

procedure SelectLexemes;    
//��������� ������ ������ �������� ����, ����� � ������������
//� �������� ������ ������������� ���������
//������������ ��� � � ������� ��� �� �������� �������, ������� NumRowOfJT
//� SearchLexKey. ������� ��� ������� �����������
var
  lf, lr, State, RowNum, i, LngPrgTxt, CurPoz: integer;
  NoToken: Boolean;
  Lex, PrgTxt: string;
  Sym: char;
  LexCode: tLexCode;
begin
  SendMessage(frmMainSUT.REdProg.Handle, WM_SETREDRAW, 0, 0); //�� ��������
  CurPoz:=frmMainSUT.REdProg.SelStart;
  PrgTxt:=Trim(frmMainSUT.REdProg.Text);
  LngPrgTxt:=Length(PrgTxt);
  lf:=1; //1-� ������ ������
  NoToken:=true;
  while NoToken do
  begin
    State:=0; //��������� ��������� ��������
    if lf > LngPrgTxt then //�������� �����
      Break;
    lr:=lf; //������ ������ �������
    while State >= 0 do //���� �� �������� ���������
    begin
      if lr > LngPrgTxt then  //�������� �����
      begin
        if State = isCom then //��� ����� �����������
          Sym:='}' //������� ����� ����������� ��� ���������� �������
        else Sym:=' ' //������� ����������� ��� ���������� �������
      end else Sym:=PrgTxt[lr];
      RowNum:=NumRowOfJT(Sym); //����� ������ ����. ���������
      State:=JumpTbl[RowNum,State]; //��������� ���������
      if State >= 0 then
        lr:=lr+1; //��������� ������� ������
    end;
    case State of
      fsId: //�������������
        begin
          Lex:='';
          for i:=lf to lr-1 do Lex:=Lex+PrgTxt[i]; //������������ �������
          LexCode:=SearchLexKey(Lex); //����� � ������� �������� ����
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          if LexCode <> lcErr then //�������� �����
          begin
            frmMainSUT.REdProg.SelAttributes.Color:=clBlue; //�������� �������� �����
            frmMainSUT.REdProg.SelAttributes.Style:=[fsBold]; //�������� �������� �����
          end else // frmMainSUT.REdProg.Font.Style:=[]; //�� �������� �����
          begin
            frmMainSUT.REdProg.SelAttributes.Color:=clBlack; //�������� �������� �����
            frmMainSUT.REdProg.SelAttributes.Style:=[]; //�������� �������� �����
          end;
          lf:=lr; //������ ������ ��������� ������� � ������ �������� ������ �������
        end;
      fsNumInt, fsNumReal: //�����
        begin
          Lex:='';
          for i:=lf to lr-1 do Lex:=Lex+PrgTxt[i]; //������������ �������
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          frmMainSUT.REdProg.SelAttributes.Color:=clRed; //�������� �������� �����
          frmMainSUT.REdProg.SelAttributes.Style:=[]; //�������� �������� �����
          lf:=lr; //������ ������ ��������� ������� � ������ �������� ������ �������
        end;
      fsCom: //�����������
        begin
          Lex:='';
          for i:=lf to lr do Lex:=Lex+PrgTxt[i]; //������������ �������
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          frmMainSUT.REdProg.SelAttributes.Color:=clGreen; //�������� �������� �����
          frmMainSUT.REdProg.SelAttributes.Style:=[]; //�������� �������� �����
          lf:=lr+1; //������ ������ ��������� ������� ��� ��������
        end;
      fsColon, fsTab: //������� 1
        begin
          Lex:='';
          for i:=lf to lr-1 do Lex:=Lex+PrgTxt[i]; //������������ �������
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          frmMainSUT.REdProg.SelAttributes.Color:=clBlack; //�������� �������� �����
          frmMainSUT.REdProg.SelAttributes.Style:=[]; //�������� �������� �����
          lf:=lr; //������ ������ ��������� ������� � ������ �������� ������ �������
        end;
      else //��������� �������� 0
        begin
          Lex:='';
          for i:=lf to lr do Lex:=Lex+PrgTxt[i]; //������������ �������
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          frmMainSUT.REdProg.SelAttributes.Color:=clBlack; //�������� �������� �����
          frmMainSUT.REdProg.SelAttributes.Style:=[]; //�������� �������� �����
          lf:=lr+1; //������ ������ ��������� ������� ��� ��������
        end;
    end; //case State
    State:=0; //���������� ��������
  end;
  frmMainSUT.REdProg.SelStart:=CurPoz;
  frmMainSUT.REdProg.SelLength:=0;
  //�� ��������
  SendMessage(frmMainSUT.REdProg.Handle, WM_SETREDRAW, 1, 0);
  frmMainSUT.REdProg.Repaint;
end;

function Scaner: tToken;
//���������� ��������� �����.
var
  State,i,RowNum: integer;
  NoToken: Boolean;
  LexCode: tLexCode;
  Lex: string;
  Sym: char;
  pOper: ^tOperCode;
  pRowIde: tPntElTblIde;
  t: tType;

  function SearchLex(Lex: string; Cat: tCatId; Typ: tType): tPntElTblIde;
  //����� ������� �������������� ��� �����, ��� �������������, �������.
  //���������� ��������� �� ���� ������
  var
    p: tPntElTblIde;
    str: string;
  begin
    str:=AnsiLowerCase(Lex);
    p:=TblIde.PntFirst;
    while p <> nil do
    begin
      if str = AnsiLowerCase(p^.Lex) then
        Break;
      p:=p^.NextEl;
    end;
    if p = nil then //�������� ������� � ����. ��������
    begin
      AddElemTblIde(Lex, Cat, Typ);
      Result:=TblIde.PntFirst; //���������� ������ � ������
    end else Result:=p;
  end; //SearchLex

begin
  NoToken:=true;
  while NoToken do
  begin
    State:=0; //��������� ��������� ��������
    if f > LngTxt then //������������� ���� �����
    begin
      State:=fsEof; //������������ ����� eof
      Break;
    end;
    r:=f; //������ ������ �������
    while State >= 0 do //���� �� �������� ���������
    begin
      if r > LngTxt then  //������������� ���� �����
      begin
        if State = isCom then //��� ����� �����������
        begin
          State:=fsErCom;
          Break;
        end else //�������� ������-����������� ��� ���������� ������������� �������
        begin
          Sym:=' ';
        end;
      end else Sym:=StrProg[r];
      RowNum:=NumRowOfJT(Sym); //����� ������ ����. ���������
      State:=JumpTbl[RowNum,State]; //��������� ���������
      if State >= 0 then
        r:=r+1; //��������� ������� ������
    end;
    if State = fsTab then //���������� ������� � �.�.
      f:=r //������ ������ ��������� ������� � ������ �������� ������ �������
    else if State = fsCom then //���������� �����������
      f:=r+1 //������ ������ ��������� ������� (�������� ������� ���)
    else NoToken:=false; //���� ������������ �����
  end;
  //��������� �������� ��������� � ������������ �������
  case State of
    fsSemi: //����� � ������� ';', ������� = 0
      begin
        Result.Code:=lcSemi;
        Result.Attr:=nil;
        Result.Name:=';';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsComma: //������� ',', ������� = 0
      begin
        Result.Code:=lcComma;
        Result.Attr:=nil;
        Result.Name:=',';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsOpPar: //����������� ������ '(', ������� = 0
      begin
        Result.Code:=lcOpPar;
        Result.Attr:=nil;
        Result.Name:='(';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsClPar: //����������� ������ ')', ������� = 0
      begin
        Result.Code:=lcClPar;
        Result.Attr:=nil;
        Result.Name:=')';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsAddAdd: //���������� �������� '+', ������� = 0
      begin
        Result.Code:=lcAdd;
        New(pOper);
        pOper^:=opAdd;
        Result.Attr:=pOper;
        Result.Name:='+';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsAddSub: //���������� ��������� '-', ������� = 0
      begin
        Result.Code:=lcAdd;
        New(pOper);
        pOper^:=opSub;
        Result.Attr:=pOper;
        Result.Name:='+';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsMultMult: //����������������� ��������� '*', ������� = 0
      begin
        Result.Code:=lcMult;
        New(pOper);
        pOper^:=opMult;
        Result.Attr:=pOper;
        Result.Name:='*';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsMultDiv: //����������������� ������� '/', ������� = 0
      begin
        Result.Code:=lcMult;
        New(pOper);
        pOper^:=opDiv;
        Result.Attr:=pOper;
        Result.Name:='*';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsColon: //��������� ':', ������� = 1
      begin
        Result.Code:=lcColon;
        Result.Attr:=nil;
        Result.Name:=':';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r; //������ ����. �������
      end;
    fsAss: //������������ ':=', ������� = 0
      begin
        Result.Code:=lcAss;
        Result.Attr:=nil;
        Result.Name:='ass';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //������ ����. �������
      end;
    fsNumInt,fsNumReal: //�����, ������� = 1
      begin
        Lex:='';
        for i:=f to r-1 do Lex:=Lex+StrProg[i]; //������������ �������
        if State = fsNumReal then
        begin
          t.TypeCode:=typeReal;
          t.Width:=wReal;
          pRowIde:=SearchLex(Lex, catConst, t);
        end else
        begin
          t.TypeCode:=typeInt;
          t.Width:=wInt;
          pRowIde:=SearchLex(Lex, catConst, t);
        end;
        Result.Code:=lcNum;
        Result.Attr:=pRowIde;
        Result.Name:='num';
        Result.LexBeg:=f;
        Result.LexEnd:=r-1;
        f:=r; //������ ����. �������
      end;
    fsId: //�������������, ������� = 1
      begin
        Lex:='';
        for i:=f to r-1 do Lex:=Lex+StrProg[i]; //������������ �������
        LexCode:=SearchLexKey(Lex); //����� � ������� �������� ����
        if LexCode <> lcErr then //�������� �����
        begin
          Result.Code:=LexCode;
          Result.Attr:=nil;
          Result.Name:=LexClass[LexCode].LexName;
          Result.LexBeg:=f;
          Result.LexEnd:=r-1;
        end else //�������������
        begin
          t.TypeCode:=typeVoid;
          pRowIde:=SearchLex(Lex, catNoCat, t);
          Result.Code:=lcId;
          Result.Attr:=pRowIde;
          Result.Name:='id';
          Result.LexBeg:=f;
          Result.LexEnd:=r-1;
        end;
        f:=r; //������� = 1, ������ ����. �������
      end;
    fsEr1: //������� �� ����� ���������� � ������� �������
      begin
        with frmMainSUT.memError do
        begin
          frmMainSUT.REdProg.SetFocus;
          frmMainSUT.REdProg.SelStart:=r-1;
          Lines.Clear;
          Lines.Add('���������� ����������� ������ LexErr_1:');
          Lines.Add('������� �� ����� ���������� � ������� �������!');
          Lines.Add('������: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
            ' ������� � ������: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
          frmMainSUT.REdProg.SelLength:=1;
        end;
        Result.Code:=lcErr;
      end;
    fsEr2: //�������� ������ �����
      begin
        with frmMainSUT.memError do
        begin
          frmMainSUT.REdProg.SetFocus;
          frmMainSUT.REdProg.SelStart:=r-1;
          Lines.Clear;
          Lines.Add('���������� ����������� ������ LexErr_2:');
          Lines.Add('������������ ������ �����!');
          Lines.Add('������: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
            ' ������� � ������: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
          frmMainSUT.REdProg.SelLength:=1;
        end;
        Result.Code:=lcErr;
      end;
    fsErCom: //��� ������� ����� �����������
      begin
        with frmMainSUT.memError do
        begin
          frmMainSUT.REdProg.SetFocus;
          frmMainSUT.REdProg.SelStart:=r-1;
          Lines.Clear;
          Lines.Add('���������� ����������� ������ LexErr_3:');
          Lines.Add('�������� ����� ������������!');
          Lines.Add('������: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
            ' ������� � ������: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
        end;
        Result.Code:=lcErr;
      end;
    fsEof: //������ ����� �����
      begin
        Result.Code:=lcEof; //����� ��������, ��������� ������ ����� �����
        Result.Attr:=nil;
        Result.Name:='eof';
      end;
  end; //case State
end; //Scaner

//�������� �� ������ ����� �����
procedure Push(x: integer; var S: tIntStack);
var p: tPntNodeInt;
begin
  New(p);
  p^.Info:=x;
  p^.Next:=S.Top;
  S.Top:=p;
end; //Push
function Pop(var S: tIntStack): integer;
var p: tPntNodeInt;
begin
  Result:=S.Top^.Info;
  p:=S.Top;
  S.Top:=p^.Next;
  Dispose(p);
end; //Pop
procedure ClearStack(var S: tIntStack);
var p: tPntNodeInt;
begin
  while S.Top <> nil do
  begin
    p:=S.Top;
    S.Top:=p^.Next;
    Dispose(p);
  end;
end; //ClearStack
function StackTop(S: tIntStack): integer;
begin
  Result:=S.Top^.Info;
end; //StackTop
function StackEmpty(var S: tIntStack): Boolean;
begin
  Result:=S.Top = nil;
end; //StackEmpty

//�������� �� ������ ���������� (�������)
procedure PushPnt(x: Pointer; var S: tPntStack);
var p: tPntNodePnt;
begin
  New(p);
  p^.Info:=x;
  p^.Next:=S.Top;
  S.Top:=p;
end; //PushPnt
function PopPnt(var S: tPntStack): Pointer;
var p: tPntNodePnt;
begin
  Result:=S.Top^.Info;
  p:=S.Top;
  S.Top:=p^.Next;
  Dispose(p);
end; //PopPnt
procedure ClearStackPnt(var S: tPntStack);
var p: tPntNodePnt;
begin
  while S.Top <> nil do
  begin
    p:=S.Top;
    S.Top:=p^.Next;
    Dispose(p);
  end;
end; //ClearStackPnt
function StackTopPnt(S: tPntStack): Pointer;
begin
  Result:=S.Top^.Info;
end; //StackTopPnt
function StackEmptyPnt(var S: tPntStack): Boolean;
begin
  Result:=S.Top = nil;
end; //StackEmptyPnt

function OutInstr(Ind: integer): string;
//����������� ������������ �������
var
  Str, Go: string;
  pi: ^integer;
  p: tPntElTblIde;
begin
  Str:=IntToStr(Ind);
  while Length(Str) < 3 do Str:='0'+Str;
  Str:=Str+':   ';
  case InstrMem[Ind].Op of
    opAss:
      begin
        p:=InstrMem[Ind].Res;
        Str:=Str+p.Lex+' := ';
        p:=InstrMem[Ind].Arg1;
        Str:=Str+p.Lex;
      end;
    opAdd, opSub, opMult, opDiv:
      begin
        p:=InstrMem[Ind].Res;
        Str:=Str+p.Lex+' := ';
        p:=InstrMem[Ind].Arg1;
        Str:=Str+p.Lex;
        case InstrMem[Ind].Op of
          opAdd: Str:=Str+' + ';
          opSub: Str:=Str+' - ';
          opMult: Str:=Str+' * ';
          opDiv: Str:=Str+' / ';
        end; //case InstrMem[Ind].Op
        p:=InstrMem[Ind].Arg2;
        Str:=Str+p.Lex;
      end;
  end; //case
  Result:=Str;
end; //OutInstr

procedure OutDataMem;
//����������� ������ ������
var
  sl: TStringList;
  p: tPntElTblIde;
  str,Addr: string;
begin
  sl:=TStringList.Create;
  sl.Sorted:=true;
  p:=TblIde.PntFirst;
  while p <> nil do
  begin
    if p^.Cat = catVarName then
    begin
      Addr:=IntToStr(p.Addr);
      while Length(Addr) < 3 do Addr:='0'+Addr;
      str:=Addr+':   '+p^.Lex+'    Width: '+IntToStr(p^.Typ.Width);
      sl.Add(str);
    end;
    p:=p^.NextEl;
  end;
  frmMainSUT.memData.Lines.Assign(sl);
  FreeAndNil(sl);
end; //OutDataMem

//��������� ������������ ������ ��� LR-�������
procedure Syntax_Error_LR(State: Byte; Token: tToken);
var
  Soob, LstSym: String;
  i:integer;
begin
  with frmMainSUT.memError do
  begin
    frmMainSUT.REdProg.SetFocus;
    frmMainSUT.REdProg.SelStart:=Token.LexBeg-1;
    Lines.Clear;
    //��������� ���������
    LstSym:='';
    for i:=NumNeTerm+1 to NumColLR do
    begin
      if LRTbl[State,i].ElType <> lrErr then
        if LstSym <> '' then
          LstSym:=LstSym+', �'+SymsLR[i]+'�'
        else LstSym:='�'+SymsLR[i]+'�';
    end;
    Soob:='���������� �������: '+LstSym;
    Lines.Add('���������� �������������� ������ SynErr: ������������ ������!');
    Lines.Add(Soob);
    Lines.Add('������: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
      ' ������� � ������: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
    frmMainSUT.REdProg.SelLength:=Token.LexEnd-Token.LexBeg+1;
  end;
end; //Syntax_Error_LR

//��������� ������������ ������ ��� LL-�������
procedure Syntax_Error_LL(NStr: Byte; Token: tToken);
var
  Soob, LstSym: String;
  Lex,LexHigh: tLexCode;
  i:integer;
begin
  with frmMainSUT.memError do
  begin
    frmMainSUT.REdProg.SetFocus;
    frmMainSUT.REdProg.SelStart:=Token.LexBeg-1;
    Lines.Clear;
    //��������� ���������
    LstSym:='';
    Lex:=Low(tLexCode);
    LexHigh:=High(tLexCode);
    while Lex <= LexHigh do
    begin
      if Lex in LLTbl[NStr].Terminals then
        if LstSym <> '' then
          LstSym:=LstSym+', �'+LexClass[Lex].LexName+'�'
        else LstSym:='�'+LexClass[Lex].LexName+'�';
      Lex:=succ(Lex);
    end;
    Soob:='���������� �������: '+LstSym;
    Lines.Add('���������� �������������� ������ SynErr: ������������ ������!');
    Lines.Add(Soob);
    Lines.Add('������: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
      ' ������� � ������: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
    frmMainSUT.REdProg.SelLength:=Token.LexEnd-Token.LexBeg+1;
  end;
end; //Syntax_Error_LL

procedure Type_Error(Code: Byte; Token: tToken);
var Soob: String;
begin
  with frmMainSUT.memError do
  begin
    frmMainSUT.REdProg.SetFocus;
    frmMainSUT.REdProg.SelStart:=Token.LexBeg-1;
    Lines.Clear;
    case Code of
      1:Soob:='��������� ���������� ��������������';
      2:Soob:='������������� �� �������� ������ ����';
      3:Soob:='������������� �� �������� ������ ����������';
      4:Soob:='��������������� �����';
      5:Soob:='������������� �� ��������';
    end;
    Lines.Add('���������� ������������� ������ TypeErr_'+IntToStr(Code)+':');
    Lines.Add(Soob);
    Lines.Add('������: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
      ' ������� � ������: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
    frmMainSUT.REdProg.SelLength:=Token.LexEnd-Token.LexBeg+1;
  end;
end; //Type_Error

//������������� ��������

procedure AddType(Pnt: tPntElTblIde; Cat: tCatId; Typ: tType);
//���������� ���� � ������ �������� � ������ Pnt ������� ��������
begin //�� ������� �������� �� ������ ���������� ������!!! ���� �������!!!
  Pnt^.Cat:=Cat; //��������� ���������
  Pnt^.Typ:=Typ; //��������� ����
  if Cat = catVarName then
  begin
    while (NextAddr mod Typ.Width) <> 0 do NextAddr:=NextAddr+1; //������������ ������
    Pnt.Addr:=NextAddr; //��������� ������ ������
    NextAddr:=NextAddr+Typ.Width; //����� ��������� ��������� ������
  end else Pnt.Addr:=-1; //��� ������ ������
end; //AddType

function NewTemp(Typ: tType): tPntElTblIde;
//���������� ����� ��������� ���������� � ������� ��������
var
  Str: String;
  p: tPntElTblIde;
begin
  CntTmpVar:=CntTmpVar+1;
  Str:='$'+IntToStr(CntTmpVar); //��������� �������
  AddElemTblIde(Str, catVarName, Typ);
  p:=TblIde.PntFirst; //���������� ������ � ������
  AddType(p, catVarName, Typ);
  Result:=p;
end; //NewTemp

function MakeList(i: integer): tPntNodeInt;
//������� ����� �������������� ������, ��������� ������ �� i
var
  p: tPntNodeInt;
begin
  New(p);
  p^.Info:=i;
  p^.Next:=nil;
  Result:=p;
end; //MakeList

function Merge(p1, p2: tPntNodeInt): tPntNodeInt;
//���������� ������, �� ������� ��������� p1 � p2
var
  p: tPntNodeInt;
begin
  if p1 <> nil then //������ p1 ��������
  begin
    p:=p1;
    while p^.Next <> nil do p:=p^.Next; //���� ��������� ���� ������
    p^.Next:=p2; //������ p2 ������������ � ����� ������ p1
    Result:=p1;
  end else Result:=p2;
end; //Merge

procedure BackPatch(var p: tPntNodeInt; i: integer);
//������������� i � �������� ������� ����� � ������ ������� �� ������, �� ������� ��������� p
var
  NInst: integer;
  q: tPntNodeInt;
  pint: ^Integer;
begin
  while p <> nil do
  begin
    NInst:=p^.Info;
    New(pint);
    pint^:=i;
    InstrMem[NInst].Res:=pint;
    q:=p;
    p:=p^.Next;
    Dispose(q);
  end;
end; //BackPatch

procedure Gen(Op: tOperCode; Arg1, Arg2, Res: Pointer);
//��������� ������������ ������� � ���� ��������
//�� ������� �������� �� ������ ���������� ������!!! ���� �������!!!
begin
  InstrMem[NextInstr].Op:=Op;
  InstrMem[NextInstr].Arg1:=Arg1;
  InstrMem[NextInstr].Arg2:=Arg2;
  InstrMem[NextInstr].Res:=Res;
  NextInstr:=NextInstr+1;
end; //Gen

function A1(Token: tToken): Boolean; //true - �������; false - ������
var
  p: tPntElTblIde;
  t: tType;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat <> catNoCat then
  begin
    Result:=false;
    Type_Error(1, Token); //��������� ����������
    Exit;
  end;
  t.TypeCode:=typeVoid;
  AddType(p, catProgName, t);
end; //A1
function A2(Token: tToken): Boolean; //true - �������; false - ������
var
  p: tPntElTblIde;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat <> catNoCat then
  begin
    Result:=false;
    Type_Error(1, Token); //��������� ����������
    Exit;
  end;
  PushPnt(p, AttrSt);
end; //A2
procedure A3;
var
  t1: ^tType;
  t2: tPntElTblIde;
begin
  t1:=PopPnt(AttrSt); //������� LstId.type
  t2:=PopPnt(AttrSt); //������� id.pnt
  AddType(t2, catVarName, t1^);
end; //A3
procedure A4;
var
  t1: ^tType;
  t2: tPntElTblIde;
begin
  t1:=PopPnt(AttrSt); //������� LstId1.type
  t2:=PopPnt(AttrSt); //������� id.pnt
  AddType(t2, catVarName, t1^);
  PushPnt(t1, AttrSt); //������� LstId.type
end; //A4
function A5(Token: tToken): Boolean; //true - �������; false - ������
var
  p: tPntElTblIde;
  pt: ^tType;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat <> catTypeName then
  begin
    Result:=false;
    Type_Error(2, Token); //�� ��� ����
    Exit;
  end;
  New(pt);
  pt^:=p^.Typ;
  PushPnt(pt, AttrSt); //������� LstId.type
end; //A5
function A6(Token: tToken): Boolean; //true - �������; false - ������
var
  p: tPntElTblIde;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat = catNoCat then
  begin
    Result:=false;
    Type_Error(5, Token); //�� �������� �������������
    Exit;
  end;
  if p^.Cat <> catVarName then
  begin
    Result:=false;
    Type_Error(3, Token); //�� ��� ����������
    Exit;
  end;
  PushPnt(p, AttrSt); //������� id.pnt
end; //A6
function A7(Token: tToken): Boolean; //true - �������; false - ������
var
  t1, t3: tPntElTblIde;
  t2: ^tType;
  pi: ^integer;
begin
  Result:=true;
  t1:=PopPnt(AttrSt); //������� Expr.addr
  t2:=PopPnt(AttrSt); //������� Expr.type
  t3:=PopPnt(AttrSt); //������� id.pnt
  if t3^.Typ.TypeCode <> t2^.TypeCode then
  begin
    Result:=false;
    Type_Error(4, Token); //��������������� �����
    Exit;
  end;
  Gen(opAss, t1, nil, t3); //������� ���� x:=y
end; //A7
procedure A8(Token: tToken);
begin
  PushPnt(Token.Attr, AttrSt); //������� rel.op ��� +.op ��� *.op
end; //A8
function A9(Token: tToken): Boolean; //true - �������; false - ������
var
  t1, t4, t6: tPntElTblIde;
  t2, t5: ^tType;
  t3: ^tOperCode;
begin
  Result:=true;
  t1:=PopPnt(AttrSt); //������� Term.addr
  t2:=PopPnt(AttrSt); //������� Term.type
  t3:=PopPnt(AttrSt); //������� +.op
  t4:=PopPnt(AttrSt);  //������� Expr1.addr
  t5:=PopPnt(AttrSt); //������� Expr1.type
  if t5^.TypeCode <> t2^.TypeCode then
  begin
    Result:=false;
    Type_Error(4, Token); //��������������� �����
    Exit;
  end;
  PushPnt(t2, AttrSt); //������� Expr.type
  t6:=NewTemp(t2^);
  PushPnt(t6, AttrSt); //������� Expr.addr
  Gen(t3^, t4, t1, t6);
end; //A9
procedure A12(Token: tToken);
var
  p: tPntElTblIde;
  pt: ^tType;
begin
  p:=Token.Attr;
  New(pt);
  pt^:=p^.Typ;
  PushPnt(pt, AttrSt); //������� Factor.type
  PushPnt(p, AttrSt); //������� Factor.addr
end; //A12
function A13(Token: tToken): Boolean; //true - �������; false - ������
var
  p: tPntElTblIde;
  pt: ^tType;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat = catNoCat then
  begin
    Result:=false;
    Type_Error(5, Token); //�� �������� �������������
    Exit;
  end;
  if p^.Cat <> catVarName then
  begin
    Result:=false;
    Type_Error(3, Token); //�� ��� ����������
    Exit;
  end;
  New(pt);
  pt^:=p^.Typ;
  PushPnt(pt, AttrSt); //������� Factor.type
  PushPnt(p, AttrSt); //������� Factor.addr
end; //A13

//���������� ������������� ��������
function Semantic_Action(ActionCode: Byte; Token: tToken): Boolean; //true - �������, false - ������
begin
  Result:=true;
  case ActionCode of
    1: if not A1(Token) then Result:=false;
    2: if not A2(Token) then Result:=false;
    3: A3;
    4: A4;
    5: if not A5(Token) then Result:=false;
    6: if not A6(Token) then Result:=false;
    7: if not A7(Token) then Result:=false;
    8: A8(Token);
    9: if not A9(Token) then Result:=false;
   10: A8(Token);
   11: if not A9(Token) then Result:=false;
   12: A12(Token);
   13: if not A13(Token) then Result:=false;
  end;
end; //Semantic_Action


function SUT_LR: Boolean; //������� ��-����������
//���������� true, ���� ��� ������
var
  Token, PredToken: tToken; //���������� �� ������� �����
  ElemLR: tElemLR; //������� ������� �������
  i, Sym: Byte; //Sym - ������� ������ ������� (���� ��� ������, ���� ��� �����������
  tmp, State: Byte; //State - ������� ��������� ����� �������
  Lex: tLexCode;
//���� ������� SUT_LR
begin
  StrProg:=Trim(frmMainSUT.REdProg.Text);
  LngTxt:=Length(StrProg);
  if LngTxt = 0 then
  begin
    Application.MessageBox('����������� �������� ���������!',
      '��������������',mb_OK+mb_IconHand);
    Exit;
  end;
  //������������� ������� ��������
  TblIde.NumRows:=0;
  TblIde.PntFirst:=nil;
  NextAddr:=0; NextInstr:=0; CntTmpVar:=0; f:=1;
  AddBaseTypes; //���������� � ������� �������� ���������������� �����
  frmMainSUT.memToken.Lines.Clear;
  frmMainSUT.memData.Lines.Clear;
  frmMainSUT.memError.Lines.Clear;
  Result:=true;
  ParserSt.Top:=nil;
  AttrSt.Top:=nil;
	Push(1,ParserSt); //��������� ��������� � ����
	Token:=Scaner; //��������� ������ �� �������
  PredToken:=Token;
  if Token.Code <> lcErr then //��� ����������� ������
  begin
    ElemLR.ElType:=0;
    Lex:=Token.Code; //Lex - ��������� ������� ������
    Sym:=LexCodeLR[Lex]; //������������� ��������� � ������� � ����. �������
    while ElemLR.ElType <> lrStop do //���� �� ������� ��������
    begin
      State:=StackTop(ParserSt); //������� ��������� �����������
      ElemLR:=LRTbl[State,Sym];
      case ElemLR.ElType of
        lrErr:  //�������������� ������
          begin
            Syntax_Error_LR(State,Token);
            Result:=false;
            ElemLR.ElType:=lrStop; //����� ����� �� �����
          end;
        lrShift: //������� ��������
          begin
            Push(ElemLR.ElPar,ParserSt); //��������� � ����
            if Sym > NumNeTerm then //��������, ������� ���
            begin
              PredToken:=Token;
              Token:=Scaner; //��������� ���������� ������
              Lex:=Token.Code; //Lex - ��������� ������� ������
              Sym:=LexCodeLR[Lex]; //������������� ��������� � ������� � ����. �������
              if Token.Code = lcErr then //����������� ������
              begin
                Result:=false;
                ElemLR.ElType:=lrStop; //����� ����� �� �����
              end;
            end else
            begin
              Lex:=Token.Code;
              Sym:=LexCodeLR[Lex]; //������������� ��������� � ������� � ����. �������
            end;
          end;
        lrReduct: //������� �������
          begin
            for i:=1 to ElemLR.ElPar do
              tmp:=Pop(ParserSt); //�������� ������� ��������� �����
            Sym:=ElemLR.Left; //���������� ����� ����� ��� ����� ������� ������
            if ElemLR.Act <> 0 then //���� ��������
              if not Semantic_Action(ElemLR.Act,PredToken) then //��������� ��������
              begin
                Result:=false;
                ElemLR.ElType:=lrStop; //����� ����� �� �����
              end;
          end;
      end;
    end;
  end;
end; //SUT_LR

function SUT_LL: Boolean; //������� ��-����������
//���������� true, ���� ��� ������
var
  Token, PredToken: tToken; //���������� �� ������� �����
  i: Byte;
  NextSym: Boolean;
//���� ������� SUT_LL
begin
  StrProg:=Trim(frmMainSUT.REdProg.Text);
  LngTxt:=Length(StrProg);
  if LngTxt = 0 then
  begin
    Application.MessageBox('����������� �������� ���������!',
      '��������������',mb_OK+mb_IconHand);
    Exit;
  end;
  //������������� ������� ��������
  TblIde.NumRows:=0;
  TblIde.PntFirst:=nil;
  NextAddr:=0; NextInstr:=0; CntTmpVar:=0; f:=1;
  AddBaseTypes; //���������� � ������� �������� ���������������� �����
  frmMainSUT.memToken.Lines.Clear;
  frmMainSUT.memData.Lines.Clear;
  frmMainSUT.memError.Lines.Clear;
  Result:=true;
  ParserSt.Top:=nil; //��������� ��������� �����
  AttrSt.Top:=nil;
  Push(0,ParserSt); //� ���� 0
  i:=1; //����� 1-� ������ ������� �������
  NextSym:=true;
	Token:=Scaner; //��������� ������ �� �������
  PredToken:=Token;
	while (Token.Code <> lcEof) or (i <> 0) do
  begin
    if (LLTbl[i].Action <> 0) or (Token.Code in LLTbl[i].Terminals) then
    begin
      if LLTbl[i].Action <> 0 then //������ ������������� ������� ��������
        if not Semantic_Action(LLTbl[i].Action,PredToken) then //��������� ��������
        begin Result:=false; Break; end;
      NextSym:=LLTbl[i].Accept;
      if LLTbl[i].Jump <> 0 then
      begin
        if LLTbl[i].Stack then Push(i+1,ParserSt);
        i:=LLTbl[i].Jump;
      end else i:=Pop(ParserSt);
    end else
    begin
      if not LLTbl[i].Error then
      begin
        i:=i+1;
        NextSym:=false;
      end else
      begin
        Syntax_Error_LL(i,Token);
        Result:=false;
        Break;
      end
    end;
    if NextSym then
    begin
      PredToken:=Token;
    	Token:=Scaner; //��������� ���������� ������ �� �������
    end;
  end; //while
end; //SUT_LL

procedure TfrmMainSUT.FormCreate(Sender: TObject);
var
  Direct: string;
begin
  NumColLR:=0;
  NumNeTerm:=0;
  ReadedFileName:='';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  StBarProg.Panels[0].Text:=' ������: 1';
  StBarProg.Panels[1].Text:=' ������� � ������: 1';
  StBarProg.Panels[2].Text:=' ���������: ���';
  lblZagRez.Caption:='���������� ������������';
end;

procedure TfrmMainSUT.FormActivate(Sender: TObject);
begin
  btnScan.Enabled:=false;
  btnSut.Enabled:=false;
  btnSutLL.Enabled:=false;
  ChangeProg:=false;
end;

procedure TfrmMainSUT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ChangeProg then //��������� ��������
    if Application.MessageBox('� ���� ������� ���������'#13+
        '��������� ���������?',
        '������',mb_IconQuestion+mb_YesNo) = idYes
    then btnSaveClick(Sender);
end;

procedure TfrmMainSUT.btnLoadClick(Sender: TObject);
var
  Direct: string;
begin
  if ChangeProg then //��������� ��������
    if Application.MessageBox('� ������� ���� ������� ���������'#13+
        '��������� ���������� ����?',
        '������',mb_IconQuestion+mb_YesNo) = idYes
    then btnSaveClick(Sender);
  OpenDialog1.Title:='�������� �������� ���������';
  OpenDialog1.DefaultExt:='txt';
  OpenDialog1.Filter:='��������� �����|*.txt';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  OpenDialog1.InitialDir:=Direct;
  OpenDialog1.FileName:='';
  if OpenDialog1.Execute then
  begin
    REdProg.Lines.LoadFromFile(OpenDialog1.FileName);
    ReadedFileName:=OpenDialog1.FileName;
    StBarProg.Panels[2].Text:=' ���������: ���';
    ChangeProg:=false;
    REdProg.SetFocus;
    memToken.Clear;
    memError.Clear;
    memData.Clear;
    btnScan.Enabled:=true;
  end;
end;

procedure TfrmMainSUT.btnSaveClick(Sender: TObject);
var
  Direct: string;
begin
  SaveDialog1.Title:='���������� �������� ���������';
  SaveDialog1.DefaultExt:='txt';
  SaveDialog1.Filter:='��������� �����|*.txt';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  SaveDialog1.InitialDir:=Direct;
  SaveDialog1.FileName:=ReadedFileName;
  if SaveDialog1.Execute then
  begin
    REdProg.PlainText:=true; //�� ��������� ��������������
    REdProg.Lines.SaveToFile(SaveDialog1.FileName);
    REdProg.PlainText:=false;
    ReadedFileName:=SaveDialog1.FileName;
    StBarProg.Panels[2].Text:=' ���������: ���';
    ChangeProg:=false;
    Application.MessageBox('���� ������� ��������!',
      '�������������� ���������',mb_OK+mb_IconInformation);
  end;
end;

procedure TfrmMainSUT.btnScanClick(Sender: TObject);
var
  Token: tToken;
  Ostanov: Boolean;
  StrToken,StrAttr,StrCom: string;
  AttrVal: integer;
  OpCode: tOperCode;
  pOpCode: ^tOperCode;
  p: ^integer;
  pRowIde: tPntElTblIde;
begin
  lblZagRez.Caption:='�������������� ������';
  StrProg:=Trim(REdProg.Text);
  LngTxt:=Length(StrProg);
  if LngTxt = 0 then
  begin
    Application.MessageBox('����������� �������� ���������!',
      '��������������',mb_OK+mb_IconHand);
    Exit;
  end;
  //������������� ������� ��������
  TblIde.NumRows:=0;
  TblIde.PntFirst:=nil;
  f:=1;
  AddBaseTypes; //���������� � ������� �������� ���������������� �����
  memToken.Lines.Clear;
  memError.Lines.Clear;
  memData.Lines.Clear;
  Ostanov:=false;
  while not Ostanov do
  begin
    Token:=Scaner;
    if Token.Code <> lcErr then //������� �������������� �����
    begin
      StrCom:='';
      if Token.Code in [lcId, lcNum] then
      begin
        pRowIde:=Token.Attr;
        AttrVal:=pRowIde^.RowNum; //����� ������ ������� ��������
        StrAttr:=IntToStr(AttrVal);
//        StrAttr:=IntToStr(Integer(pRowIde)); //����� ������
        StrCom:='  (�������: '+pRowIde^.Lex+')';
      end else if Token.Code in [lcAdd, lcMult] then
      begin
        pOpCode:=Token.Attr;
        OpCode:=pOpCode^;
        AttrVal:=Ord(OpCode);
        StrAttr:=IntToStr(AttrVal);
        case OpCode of
          opAdd: StrCom:=' (��������: +)';
          opSub: StrCom:=' (��������: -)';
          opMult: StrCom:=' (��������: *)';
          opDiv: StrCom:=' (��������: /)';
        end; //case pOpCode^
      end else StrAttr:='null';
      StrToken:='<'+Token.Name+',  '+StrAttr+'> '+StrCom;
      memToken.Lines.Add(StrToken);
      if Token.Code = lcEof then
        Ostanov:=true; //������ ����� �����
    end else Ostanov:=true; //Code=lcErr - ����������� ������
  end;
  if Token.Code <> lcErr then
    memError.Lines.Add('����������� ������ ������� ��������');
  memToken.SelStart := memToken.Perform(EM_LINEINDEX, 0, 0);
  memToken.Perform(EM_SCROLLCARET, 0, 0);
  ClearTblIde;
end;

procedure TfrmMainSUT.btnSutClick(Sender: TObject);
var
  i: integer;
begin
  if NumColLR = 0 then
  begin
    Application.MessageBox('����������� ������� �������! ���� ���������!',
      '��������������',mb_OK+mb_IconHand);
    btnLoadXML.SetFocus;
    Exit;
  end;
  if SUT_LR then
  begin
    lblZagRez.Caption:='������������ �������';
    for i:=0 to NextInstr-1 do
      memToken.Lines.Add(OutInstr(i));
    OutDataMem;
    memError.Lines.Clear;
    memError.Lines.Add('��-���������� ������� ���������');
  end;
  ClearTblIde;
end;

procedure TfrmMainSUT.btnLoadXmlClick(Sender: TObject);
var
  Direct,AttrStr: string;
  RootNode,ColsNode,DataNode,TmpNode: IXMLNode;
  i,j,k,TmpInt,State: integer;
  Lex,LexHigh: tLexCode;
begin
  State:=0;
  NumColLR:=0;
  OpenDialog1.Title:='�������� LR-������� �������';
  OpenDialog1.DefaultExt:='xml';
  OpenDialog1.Filter:='xml-�����|*.xml';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  OpenDialog1.InitialDir:=Direct;
  OpenDialog1.FileName:='';
  if OpenDialog1.Execute then
    try
      XMLDoc.LoadFromFile(OpenDialog1.FileName);
      XMLDoc.Active:=true;
    except
      Application.MessageBox('� ����� ��� ������ ������, ��������, ���� ���������!',
        '�������� LR-������� �������',mb_IconHand+mb_Ok);
      Exit;
    end;
  RootNode:=XMLDoc.DocumentElement;
  if RootNode.NodeName <> 'SLR_Table' then
  begin
    Application.MessageBox('� ����� ��� ������ ������, ��������, ���� ���������!',
      '�������� LR-������� �������',mb_OK+mb_IconHand);
    Exit;
  end;
  ColsNode:=RootNode.ChildNodes.FindNode('Columns');
  //�������� ������������
  DataNode:=ColsNode.ChildNodes.FindNode('Neterms');
  for i := 0 to DataNode.ChildNodes.Count - 1 do
  begin
    TmpNode:=DataNode.ChildNodes[i];
    AttrStr:=VarToStr(TmpNode.Attributes['ColNum']);
    NumColLR:=StrToInt(AttrStr); //����� ������� LR-������� �������
    AttrStr:=VarToStr(TmpNode.Attributes['Lexeme']);
    SymsLR[NumColLR]:=AttrStr;
  end;
  NumNeTerm:=NumColLR;
  //�������� ����������
  DataNode:=ColsNode.ChildNodes.FindNode('Terms');
  for i := 0 to DataNode.ChildNodes.Count - 1 do
  begin
    TmpNode:=DataNode.ChildNodes[i];
    AttrStr:=VarToStr(TmpNode.Attributes['ColNum']);
    NumColLR:=StrToInt(AttrStr); //����� ������� LR-������� �������
    AttrStr:=VarToStr(TmpNode.Attributes['Lexeme']);
    SymsLR[NumColLR]:=AttrStr;
    //����� ������� ��������� � ��������� ������ ������� � �� ��� ����
    Lex:=Low(tLexCode);
    LexHigh:=High(tLexCode);
    while Lex <= LexHigh do
    begin
      if LexClass[Lex].LexName = AttrStr then
        Break;
      Lex:=succ(Lex);
    end;
    if Lex > LexHigh then //�� �������
    begin
      Application.MessageBox(PChar('� ������ ����������� ������� �� �������'+
        ' ����������� ������������ ������ �'+AttrStr+'�!'),
        '��������������',mb_OK+mb_IconHand);
      Exit;
    end else LexCodeLR[LexClass[Lex].LexCode]:=NumColLR;
  end;
  //�������� ������� �������
  for i:=1 to RootNode.ChildNodes.Count - 1 do
  begin
    DataNode:=RootNode.ChildNodes[i];
    AttrStr:=VarToStr(DataNode.Attributes['NSost']);
    State:=StrToInt(AttrStr);
    for j:=0 to DataNode.ChildNodes.Count - 1 do
    begin
      TmpNode:=DataNode.ChildNodes[j];
      AttrStr:=VarToStr(TmpNode.Attributes['ColNum']);
      TmpInt:=StrToInt(AttrStr); //������� � ��
      AttrStr:=VarToStr(TmpNode.Attributes['ElType']);
      LRTbl[State,TmpInt].ElType:=StrToInt(AttrStr);
      AttrStr:=VarToStr(TmpNode.Attributes['ElPar']);
      LRTbl[State,TmpInt].ElPar:=StrToInt(AttrStr);
      AttrStr:=VarToStr(TmpNode.Attributes['Left']);
      if AttrStr <> '' then
      begin //����� ���� �������
        k:=1;
        while SymsLR[k] <> AttrStr do k:=k+1;
      end else k:=0;
      LRTbl[State,TmpInt].Left:=k;
      AttrStr:=VarToStr(TmpNode.Attributes['Act']);
      if AttrStr <> '' then
      begin
        Delete(AttrStr,1,1);
        LRTbl[State,TmpInt].Act:=StrToInt(AttrStr);
      end else LRTbl[State,TmpInt].Act:=0;
    end;
  end;
  btnSut.Enabled:=true;
end;

procedure TfrmMainSUT.btnLoadLLClick(Sender: TObject);
var
  Direct,AttrStr: string;
  i,j,NStr: integer;
  Lex,LexHigh: tLexCode;
  RootNode,TmpNode,TermsNode: IXMLNode;
begin
  NumStrLL:=0;
  OpenDialog1.Title:='�������� LL-������� �������';
  OpenDialog1.DefaultExt:='xml';
  OpenDialog1.Filter:='xml-�����|*.xml';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  OpenDialog1.InitialDir:=Direct;
  OpenDialog1.FileName:='';
  if OpenDialog1.Execute then
    try
      XMLDoc.LoadFromFile(OpenDialog1.FileName);
      XMLDoc.Active:=true;
    except
      Application.MessageBox('� ����� ��� ������ ������, ��������, ���� ���������!',
        '�������� LL-������� �������',mb_IconHand+mb_Ok);
      Exit;
    end;
  RootNode:=XMLDoc.DocumentElement;
  if RootNode.NodeName <> 'LL_Table' then
  begin
    Application.MessageBox('� ����� ��� ������ ������, ��������, ���� ���������!',
      '�������� LL-������� �������',mb_OK+mb_IconHand);
    Exit;
  end;
  //�������� ������� �������
  for i:=0 to RootNode.ChildNodes.Count - 1 do
  begin
    TmpNode:=RootNode.ChildNodes[i];
    AttrStr:=VarToStr(TmpNode.Attributes['NStr']);
    NStr:=StrToInt(AttrStr);
    AttrStr:=VarToStr(TmpNode.Attributes['Jump']);
    LLTbl[NStr].Jump:=StrToInt(AttrStr);
    AttrStr:=VarToStr(TmpNode.Attributes['Accept']);
    LLTbl[NStr].Accept:=AttrStr = 'True';
    AttrStr:=VarToStr(TmpNode.Attributes['Stack']);
    LLTbl[NStr].Stack:=AttrStr = 'True';
    AttrStr:=VarToStr(TmpNode.Attributes['Action']);
    if AttrStr <> '' then
    begin
      Delete(AttrStr,1,1);
      LLTbl[NStr].Action:=StrToInt(AttrStr);
    end else LLTbl[NStr].Action:=0;
    AttrStr:=VarToStr(TmpNode.Attributes['Error']);
    LLTbl[NStr].Error:=AttrStr = 'True';
    TermsNode:=TmpNode.ChildNodes.FindNode('Terminals');
    LLTbl[NStr].Terminals:=[];
    for j:=0 to TermsNode.ChildNodes.Count - 1 do
    begin
      TmpNode:=TermsNode.ChildNodes[j];
      AttrStr:=VarToStr(TmpNode.Attributes['Lexeme']);
      //����� ������� ��������� � ����������� ��� ����
      Lex:=Low(tLexCode);
      LexHigh:=High(tLexCode);
      while Lex <= LexHigh do
      begin
        if LexClass[Lex].LexName = AttrStr then
          Break;
        Lex:=succ(Lex);
      end;
      if Lex > LexHigh then //�� �������
      begin
        Application.MessageBox(PChar('� ������ ����������� ������� �� �������'+
          ' ����������� ������������ ������ �'+AttrStr+'�!'),
          '��������������',mb_OK+mb_IconHand);
        Exit;
      end else Include(LLTbl[NStr].Terminals,LexClass[Lex].LexCode);
    end;
  end;
  NumStrLL:=NStr;
  btnSutLL.Enabled:=true;
end;

procedure TfrmMainSUT.btnSutLLClick(Sender: TObject);
var
  i: integer;
begin
  if NumStrLL = 0 then
  begin
    Application.MessageBox('����������� ������� �������! ���� ���������!',
      '��������������',mb_OK+mb_IconHand);
    btnLoadXML.SetFocus;
    Exit;
  end;
  if SUT_LL then
  begin
    lblZagRez.Caption:='������������ �������';
    for i:=0 to NextInstr-1 do
      memToken.Lines.Add(OutInstr(i));
    OutDataMem;
    memError.Lines.Clear;
    memError.Lines.Add('��-���������� ������� ���������');
  end;
end;

procedure TfrmMainSUT.REdProgChange(Sender: TObject);
begin
  StBarProg.Panels[2].Text:=' ���������: ����';
  btnScan.Enabled:=not(Trim(REdProg.Text) = '');
  ChangeProg:=true;
  if REdProg.Text <> '' then SelectLexemes;
end;

procedure TfrmMainSUT.REdProgKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  StBarProg.Panels[0].Text:=' ������: '+IntToStr(REdProg.CaretPos.Y+1);
  StBarProg.Panels[1].Text:=' ������� � ������: '+IntToStr(REdProg.CaretPos.X+1);
end;

procedure TfrmMainSUT.REdProgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  StBarProg.Panels[0].Text:=' ������: '+IntToStr(REdProg.CaretPos.Y+1);
  StBarProg.Panels[1].Text:=' ������� � ������: '+IntToStr(REdProg.CaretPos.X+1);
end;

end.
