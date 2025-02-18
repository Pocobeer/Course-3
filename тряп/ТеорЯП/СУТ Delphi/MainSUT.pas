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
//лексические классы (коды токенов)
  tLexCode = ( //цифрами указаны не коды, а номера по порядку
    //ключевые слова
    lcProg,   //1 - prog
    lcStart,  //2 - start
    lcStop,   //3 - stop
    lcVar,    //4 - var
    //другие классы
    lcSemi,   //5 - точка с запятой ;
    lcColon,  //6 - двоеточие :
    lcComma,  //7 - запятая ,
    lcOpPar,  //8 - открывающая скобка (
    lcClPar,  //9 - закрывающая скобка )
    lcAss,    //10 - присваивание :=
    lcAdd,    //11 - аддитивная операция + и -
    lcMult,   //12 - мультипликативная операция * и /
    lcId,     //13 - идентификатор id
    lcNum,    //14 - число num
    //служебные
    lcEof,    //15 - маркер конца ввода
    lcErr);   //16 - лексическая ошибка
  tElLexClass = record //обозначения токена и его код
    LexName: string;   //обозначение лексического класса
    LexCode: tLexCode; //код лексического класса (токена)
  end;
//категории идентификаторов или число
  tCatId = (
    catNoCat,    //осутсвие категории
    catProgName, //имя программы
    catTypeName, //имя типа
    catVarName, //имя переменной
    catConst);    //число
//коды типов данных (префикс type)
  tTypesCode = (
    typeVoid,  //отсутствие типа
    typeInt,   //целый тип
    typeReal);  //вещественный тип
//элемент типа данных
  tType = record
    TypeCode: tTypesCode; //код типа данных
    Width: integer; //размер типа
  end;
//операции для лекс. классов lcAdd, lcMult
  tOperCode = (
    //аддитивные операции (префикс op)
    opAdd, //сложение '+'
    opSub, //вычитание '-'
    //мультипликативные операции (префикс op)
    opMult, //умножение '*'
    opDiv, //деление '/'
    //трехадресные команды
    opAss); //вида x := y
//типы для таблицы символов (организована как связный список)
  tPntElTblIde = ^tElemTblIde; //указатель на строку табл. символов
  tElemTblIde = record //строка таблицы символов (узел связного списка)
    RowNum: Byte; //номер строки, нужно только для отображения атрибута токена
                  //для id и num (по факту номера нет, а есть указатель
                  //на узел связного списка символов)
    Lex: string; //лексема идентификатора или числа
    Cat: tCatId; //категория идентификатора или число
    Typ: tType; //тип (type - ключевое слово, поэтому поле названо Typ)
    Addr: integer; //адрес размещения в памяти
    NextEl: tPntElTblIde; //след. элемент таблицы символов
  end;
  tTblIde = record //таблица символов
    NumRows: integer; //число узлов (строк), нужно только для установки RowNum
    PntFirst: tPntElTblIde; //указатель на первый узел
  end;
//структура токена
  tToken = record
    Code: tLexCode; //код токена (лексического класса)
    Attr: Pointer; //атрибут токена
    Name: string; //обозначение токена (для визуализации)
    LexBeg, LexEnd: Word; //для локализации ошибок
  end;
//связный список для целочисленных элементов
  tPntNodeInt = ^tNodeForInt;
  tNodeForInt = record //узел списка
    Info: integer; //значение атрибута
    Next: tPntNodeInt; //указатель на следующий узел
  end;
//связный список для указателей
  tPntNodePnt = ^tNodeForPnt;
  tNodeForPnt = record //узел списка
    Info: Pointer; //указатель
    Next: tPntNodePnt; //указатель на следующий узел
  end;
//для стека парсера
  tIntStack = record
    Top: tPntNodeInt; //указатель на вершину (первый элемент списка)
  end;
//для стека атрибутов
  tPntStack = record
    Top: tPntNodePnt; //указатель на вершину стека
  end;
//элемент LR-таблицы разбора
  tElemLR = record
    ElType: Byte; //тип элемента (lrErr, lrShift, lrReduct, lrStop)
    ElPar: Byte; //параметр элемента (для элемента переноса - это номер состояния,
                //для элемента свертки - длина правой части свертываемой продукции
    Left: Byte; //код левого нетерминала свертываемой продукции
    Act: Byte; //код символа действия (0, если действия нет)
  end;
  tInst = record //трехадресная команда (четверка)
    Op: tOperCode; //код операции
    Arg1, Arg2, Res: Pointer;
  end;
//элемент LL-таблицы разбора
  tElemLL = record
    Jump: Word; //поле переходов
    Accept: Boolean; //поле приема
    Stack: Boolean; //поле стека
    Action: Byte; //поле действия
    Error: Boolean; //поле ошибки
    Terminals: set of tLexCode; //список кодов терминалов
  end;
const
  //обозначения лекс. классов и коды
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
  LastKeyWord = lcVar; //последнее ключевое слово в списке для их поиска
//для Scaner и SelectLexemes, поэтому глобальные
  Letters = ['A'..'Z', 'А'..'Я', 'Ё']; //буквы
  Digits = ['0'..'9'];                //цифры
//Таблица переходов как константа.
//Для вычисления номера строки, сответствующей символу, нужна спец. функция NomStrOfTP
  JumpTbl: array [1..19,0..7] of integer = (
//Сост-ия: 0   1   2   3   4   5   6   7
    {1} ( -1, -9,-11,-12,-17,-13,-14,  7), //';' точка с запятой
    {2} (  1, -9,-11,-12,-17,-13,-14,  7), //':' двоеточие
    {3} ( -2, -9,-11,-12,-17,-13,-14,  7), //',' запятая
    {4} (-16, -9,-11,  4,-17,-13,-14,  7), //'.' точка
    {5} ( -3, -9,-11,-12,-17,-13,-14,  7), //'(' открывающая скобка
    {6} ( -4, -9,-11,-12,-17,-13,-14,  7), //')' закрывающая скобка
    {7} ( -5, -9,-11,-12,-17,-13,-14,  7), //'+' плюс
    {8} ( -6, -9,-11,-12,-17,-13,-14,  7), //'-' минус
    {9} ( -7, -9,-11,-12,-17,-13,-14,  7), //'*' умножение
   {10} ( -8, -9,-11,-12,-17,-13,-14,  7), //'/' деление
   {11} (-16,-10,-11,-12,-17,-13,-14,  7), //'=' равно
   {12} (  2, -9,  2,-12,-17,-13,-14,  7), //l буква
   {13} (  3, -9,  2,  3,  5,  5,-14,  7), //d цифра
   {14} (  7, -9,-11,-12,-17,-13,-14,  7), //фиг.откр
   {15} (-16, -9,-11,-12,-17,-13,-14,-15), //фиг.закр
   {16} (  6, -9,-11,-12,-17,-13,  6,  7), //sp пробел
   {17} (  6, -9,-11,-12,-17,-13,  6,  7), //tab табуляция
   {18} (  6, -9,-11,-12,-17,-13,  6,  7), //lf перевод строки
   {19} (-16, -9,-11,-12,-17,-13,-14,  7)); //другие символы
  //конечные состояния автомата (префикс fs)
  fsSemi = -1;     //точка с запятой ';'
  fsComma = -2;    //запятая ','
  fsOpPar = -3;    //открывающая скобка '('
  fsClPar = -4;    //закрывающая скобка ')'
  fsAddAdd = -5;   //аддитивная сложение '+'
  fsAddSub = -6;   //аддитивная вычитание '-'
  fsMultMult = -7; //мультипликативная умножение '*'
  fsMultDiv = -8;  //мультипликативная деление '/'
  fsColon = -9;    //двоеточие ':'
  fsAss = -10;     //присваивание ':='
  fsNumInt = -12;  //число num целое
  fsNumReal = -13; //число num вещественное
  fsId = -11;      //идентификатор id
  fsTab = -14;     //табуляция, пробелы и т.п.
  fsCom = -15;     //комментарии
  fsEr1 = -16;     //лексема не может начинаться с данного символа
  fsEr2 = -17;     //неверный формат числа
  fsErCom = -18;   //нет символа конца комментария
  fsEof = -19;     //маркер конца ввода
  //опасное внутреннее состояние комментариев, если нет конца комментария
  isCom = 7;       //внутреннее состояние комментария
//*****************
  //предельные значения различных элементов
  MaxDataMem = 500; //максимальный размер памяти данных
  MaxInstrMem = 1000; //максимальный размер памяти команд
  MaxStateLR = 300; //максимальное число состояний (строк) таблицы разбора
  MaxSymLR = 300; //максимальное число символов (столбцов) LR-таблицы разбора
  MaxRowLL = 300; //максимальное число строк LL-таблицы разбора
  //размеры предопределенных типов в байтах (префикс w)
  wInt = 4; //целый
  wReal = 8; //вещественный
  wBool = 1; //булевский
  //типы элементов LR-таблицы разбора (поле ElType) (префикс lr)
  lrErr = 0; //элемент ошибки
  lrShift = 1; //элемент переноса
  lrReduct = 2; //элемент свертки
  lrStop = 3; //элемент останова
var
  ReadedFileName: String;
  ChangeProg: Boolean;
  TblIde: tTblIde; //таблица символов
  CntTmpVar, NumColLR, NumNeTerm, NumStrLL, LngTxt: integer;
  StrProg: string; //буфер - копия теста
  f, r: integer; //f-первый символ лексемы, r-перемещение от f до конца лексемы
//для LR-разбора
  LRTbl: array [1..MaxStateLR,1..MaxSymLR] of tElemLR; //LR-таблица разбора
  //лексемы сим. граммматики: 1..NumNeTerm - нетерминалы,
  //NumNeTerm+1..NumColLR - терминалы, формируется из xml-файла
  SymsLR: array [1..MaxSymLR] of string;
  //соответствие кодов лекс. классов (константа из LexClass) и номеров
  //столбцов в табл. разбора
  LexCodeLR: array [tLexCode] of integer;
//******************
  AttrSt: tPntStack; //стек атрибутов
  ParserSt: tIntStack; //стек состояний парсера
//  AttrSt, ParserSt:tStack; //стек атрибутов и стек состояний
//для генерации пром. кода
  DataMem: array [0..MaxDataMem] of Byte; //память данных
  InstrMem: array [0..MaxInstrMem] of tInst; //память команд
	NextAddr: integer; //адрес очередной свободной ячейки в памяти данных.
	NextInstr: integer; //адрес очередной генерируемой команды в памяти команд.
  LLTbl: array [1..MaxRowLL] of tElemLL; //LL-таблица разбора

procedure ClearTblIde;
//очистка таблицы символов
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

//для Scaner и SelectLexemes, поэтому глобальные
function SearchLexKey(Lex: string): tLexCode;
//Поиск ключевого слова. Возвращает код токена или lcErr, если не найдено.
//ключевые слова в массиве LexClass с 1-й по cntKeys позицию
//все обозначения ключевых слов в LexClass - строчные буквы!!!
var
  LexCd: tLexCode;
  str: string;
begin //простой последовательный поиск
  str:=AnsiLowerCase(Lex);
  LexCd:=Low(tLexCode);
  while LexCd <= LastKeyWord do //Поиск ключевого слова
  begin
   if str = LexClass[LexCd].LexName then //найдено
     Break;
   LexCd:=succ(LexCd);
  end;
  if LexCd > LastKeyWord then //Лексема не найдена
    Result:=lcErr
  else Result:=LexClass[LexCd].LexCode; //Лексема найдена. Это ключевое слово
end; //SearchLexKey

function NumRowOfJT(Sym: char): integer;
//Возвращает номер строки в таблице переходов JumpTbl для символа Sym
var
  StrUp:string;
  CharUp:char;
begin
  StrUp:=Sym;
  StrUp:=AnsiUpperCase(StrUp);
  CharUp:=StrUp[1];
  if CharUp in Letters then Result:=12 //Буква
  else if Sym in Digits then Result:=13 //Цифра
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
      #9: Result:=17; //табуляция
      #10,#13: Result:=18; //перевод строки
      else Result:=19; //любой другой символ
    end;
end; //NumRowOfJT
//****************************************

procedure AddElemTblIde(Lex: string; Cat: tCatId; Typ: tType);
//добавление элемента в таблицу символов
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
//Добавление в таблицу символов предопределенных типов (добавление в начало списка)
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
//выделение цветом лексем ключевых слов, чисел и комментариев
//в исходном тексте транслируемой программы
//Используется как и в сканере тот же конечный автомат, функция NumRowOfJT
//и SearchLexKey. Поэтому они сделаны глобальными
var
  lf, lr, State, RowNum, i, LngPrgTxt, CurPoz: integer;
  NoToken: Boolean;
  Lex, PrgTxt: string;
  Sym: char;
  LexCode: tLexCode;
begin
  SendMessage(frmMainSUT.REdProg.Handle, WM_SETREDRAW, 0, 0); //от мерцания
  CurPoz:=frmMainSUT.REdProg.SelStart;
  PrgTxt:=Trim(frmMainSUT.REdProg.Text);
  LngPrgTxt:=Length(PrgTxt);
  lf:=1; //1-й символ строки
  NoToken:=true;
  while NoToken do
  begin
    State:=0; //Начальное состояние автомата
    if lf > LngPrgTxt then //кончился текст
      Break;
    lr:=lf; //первый символ лексемы
    while State >= 0 do //пока не конечное состояние
    begin
      if lr > LngPrgTxt then  //кончился текст
      begin
        if State = isCom then //нет конца комментария
          Sym:='}' //добавим конец комментария для завершения лексемы
        else Sym:=' ' //добавим разделитель для завершения лексемы
      end else Sym:=PrgTxt[lr];
      RowNum:=NumRowOfJT(Sym); //номер строки табл. переходов
      State:=JumpTbl[RowNum,State]; //Следующее состояние
      if State >= 0 then
        lr:=lr+1; //следующий входной символ
    end;
    case State of
      fsId: //идентификатор
        begin
          Lex:='';
          for i:=lf to lr-1 do Lex:=Lex+PrgTxt[i]; //Формирование лексемы
          LexCode:=SearchLexKey(Lex); //поиск в таблице ключевых слов
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          if LexCode <> lcErr then //ключевое слово
          begin
            frmMainSUT.REdProg.SelAttributes.Color:=clBlue; //выделить ключевое слово
            frmMainSUT.REdProg.SelAttributes.Style:=[fsBold]; //выделить ключевое слово
          end else // frmMainSUT.REdProg.Font.Style:=[]; //не ключевое слово
          begin
            frmMainSUT.REdProg.SelAttributes.Color:=clBlack; //выделить ключевое слово
            frmMainSUT.REdProg.SelAttributes.Style:=[]; //выделить ключевое слово
          end;
          lf:=lr; //первый символ следующей лексемы с учетом возврата одного символа
        end;
      fsNumInt, fsNumReal: //число
        begin
          Lex:='';
          for i:=lf to lr-1 do Lex:=Lex+PrgTxt[i]; //Формирование лексемы
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          frmMainSUT.REdProg.SelAttributes.Color:=clRed; //выделить ключевое слово
          frmMainSUT.REdProg.SelAttributes.Style:=[]; //выделить ключевое слово
          lf:=lr; //первый символ следующей лексемы с учетом возврата одного символа
        end;
      fsCom: //комментарий
        begin
          Lex:='';
          for i:=lf to lr do Lex:=Lex+PrgTxt[i]; //Формирование лексемы
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          frmMainSUT.REdProg.SelAttributes.Color:=clGreen; //выделить ключевое слово
          frmMainSUT.REdProg.SelAttributes.Style:=[]; //выделить ключевое слово
          lf:=lr+1; //первый символ следующей лексемы без возврата
        end;
      fsColon, fsTab: //возврат 1
        begin
          Lex:='';
          for i:=lf to lr-1 do Lex:=Lex+PrgTxt[i]; //Формирование лексемы
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          frmMainSUT.REdProg.SelAttributes.Color:=clBlack; //выделить ключевое слово
          frmMainSUT.REdProg.SelAttributes.Style:=[]; //выделить ключевое слово
          lf:=lr; //первый символ следующей лексемы с учетом возврата одного символа
        end;
      else //остальные возхврат 0
        begin
          Lex:='';
          for i:=lf to lr do Lex:=Lex+PrgTxt[i]; //Формирование лексемы
          frmMainSUT.REdProg.SelStart:=lf-1;
          frmMainSUT.REdProg.SelLength:=Length(Lex);
          frmMainSUT.REdProg.SelAttributes.Color:=clBlack; //выделить ключевое слово
          frmMainSUT.REdProg.SelAttributes.Style:=[]; //выделить ключевое слово
          lf:=lr+1; //первый символ следующей лексемы без возврата
        end;
    end; //case State
    State:=0; //перезапуск автомата
  end;
  frmMainSUT.REdProg.SelStart:=CurPoz;
  frmMainSUT.REdProg.SelLength:=0;
  //от мерцания
  SendMessage(frmMainSUT.REdProg.Handle, WM_SETREDRAW, 1, 0);
  frmMainSUT.REdProg.Repaint;
end;

function Scaner: tToken;
//Возвращает очередной токен.
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
  //Поиск лексемы идентификатора или числа, при необходимости, вставка.
  //Возвращает указатель на узел списка
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
    if p = nil then //добавить элемент в табл. символов
    begin
      AddElemTblIde(Lex, Cat, Typ);
      Result:=TblIde.PntFirst; //добавление всегда в начало
    end else Result:=p;
  end; //SearchLex

begin
  NoToken:=true;
  while NoToken do
  begin
    State:=0; //начальное состояние автомата
    if f > LngTxt then //просканирован весь текст
    begin
      State:=fsEof; //сформировать токен eof
      Break;
    end;
    r:=f; //первый символ лексемы
    while State >= 0 do //пока не конечное состояние
    begin
      if r > LngTxt then  //просканирован весь текст
      begin
        if State = isCom then //нет конца комментария
        begin
          State:=fsErCom;
          Break;
        end else //вставить пробел-разделитель для завершения распознавания лексемы
        begin
          Sym:=' ';
        end;
      end else Sym:=StrProg[r];
      RowNum:=NumRowOfJT(Sym); //номер строки табл. переходов
      State:=JumpTbl[RowNum,State]; //Следующее состояние
      if State >= 0 then
        r:=r+1; //следующий входной символ
    end;
    if State = fsTab then //отработаны пробелы и т.п.
      f:=r //первый символ следующей лексемы с учетом возврата одного символа
    else if State = fsCom then //отработаны комментарии
      f:=r+1 //первый символ следующей лексемы (возврата символа нет)
    else NoToken:=false; //надо сформировать токен
  end;
  //обработка конечных состояний и формирование токенов
  case State of
    fsSemi: //точка с запятой ';', возврат = 0
      begin
        Result.Code:=lcSemi;
        Result.Attr:=nil;
        Result.Name:=';';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsComma: //запятая ',', возврат = 0
      begin
        Result.Code:=lcComma;
        Result.Attr:=nil;
        Result.Name:=',';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsOpPar: //открывающая скобка '(', возврат = 0
      begin
        Result.Code:=lcOpPar;
        Result.Attr:=nil;
        Result.Name:='(';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsClPar: //закрывающая скобка ')', возврат = 0
      begin
        Result.Code:=lcClPar;
        Result.Attr:=nil;
        Result.Name:=')';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsAddAdd: //аддитивная сложение '+', возврат = 0
      begin
        Result.Code:=lcAdd;
        New(pOper);
        pOper^:=opAdd;
        Result.Attr:=pOper;
        Result.Name:='+';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsAddSub: //аддитивная вычитание '-', возврат = 0
      begin
        Result.Code:=lcAdd;
        New(pOper);
        pOper^:=opSub;
        Result.Attr:=pOper;
        Result.Name:='+';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsMultMult: //мультипликативная умножение '*', возврат = 0
      begin
        Result.Code:=lcMult;
        New(pOper);
        pOper^:=opMult;
        Result.Attr:=pOper;
        Result.Name:='*';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsMultDiv: //мультипликативная деление '/', возврат = 0
      begin
        Result.Code:=lcMult;
        New(pOper);
        pOper^:=opDiv;
        Result.Attr:=pOper;
        Result.Name:='*';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsColon: //двоеточие ':', возврат = 1
      begin
        Result.Code:=lcColon;
        Result.Attr:=nil;
        Result.Name:=':';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r; //начало след. лексемы
      end;
    fsAss: //присваивание ':=', возврат = 0
      begin
        Result.Code:=lcAss;
        Result.Attr:=nil;
        Result.Name:='ass';
        Result.LexBeg:=f;
        Result.LexEnd:=r;
        f:=r+1; //начало след. лексемы
      end;
    fsNumInt,fsNumReal: //число, возврат = 1
      begin
        Lex:='';
        for i:=f to r-1 do Lex:=Lex+StrProg[i]; //Формирование лексемы
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
        f:=r; //начало след. лексемы
      end;
    fsId: //идентификатор, возврат = 1
      begin
        Lex:='';
        for i:=f to r-1 do Lex:=Lex+StrProg[i]; //Формирование лексемы
        LexCode:=SearchLexKey(Lex); //поиск в таблице ключевых слов
        if LexCode <> lcErr then //ключевое слово
        begin
          Result.Code:=LexCode;
          Result.Attr:=nil;
          Result.Name:=LexClass[LexCode].LexName;
          Result.LexBeg:=f;
          Result.LexEnd:=r-1;
        end else //идентификатор
        begin
          t.TypeCode:=typeVoid;
          pRowIde:=SearchLex(Lex, catNoCat, t);
          Result.Code:=lcId;
          Result.Attr:=pRowIde;
          Result.Name:='id';
          Result.LexBeg:=f;
          Result.LexEnd:=r-1;
        end;
        f:=r; //возврат = 1, начало след. лексемы
      end;
    fsEr1: //лексема не может начинаться с данного символа
      begin
        with frmMainSUT.memError do
        begin
          frmMainSUT.REdProg.SetFocus;
          frmMainSUT.REdProg.SelStart:=r-1;
          Lines.Clear;
          Lines.Add('Обнаружена лексическая ошибка LexErr_1:');
          Lines.Add('Лексема не может начинаться с данного символа!');
          Lines.Add('строка: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
            ' позиция в строке: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
          frmMainSUT.REdProg.SelLength:=1;
        end;
        Result.Code:=lcErr;
      end;
    fsEr2: //неверный формат числа
      begin
        with frmMainSUT.memError do
        begin
          frmMainSUT.REdProg.SetFocus;
          frmMainSUT.REdProg.SelStart:=r-1;
          Lines.Clear;
          Lines.Add('Обнаружена лексическая ошибка LexErr_2:');
          Lines.Add('Неправильный формат числа!');
          Lines.Add('строка: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
            ' позиция в строке: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
          frmMainSUT.REdProg.SelLength:=1;
        end;
        Result.Code:=lcErr;
      end;
    fsErCom: //нет символа конца комментария
      begin
        with frmMainSUT.memError do
        begin
          frmMainSUT.REdProg.SetFocus;
          frmMainSUT.REdProg.SelStart:=r-1;
          Lines.Clear;
          Lines.Add('Обнаружена лексическая ошибка LexErr_3:');
          Lines.Add('Пропущен конец комментариев!');
          Lines.Add('строка: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
            ' позиция в строке: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
        end;
        Result.Code:=lcErr;
      end;
    fsEof: //маркер конца ввода
      begin
        Result.Code:=lcEof; //текст прочитан, формируем маркер конца ввода
        Result.Attr:=nil;
        Result.Name:='eof';
      end;
  end; //case State
end; //Scaner

//Операции со стеком целых чисел
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

//Операции со стеком указателей (парсера)
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
//Отображение трехадресной команды
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
//Отображение памяти данных
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

//Процедуры формирования ошибок для LR-разбора
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
    //генерация сообщения
    LstSym:='';
    for i:=NumNeTerm+1 to NumColLR do
    begin
      if LRTbl[State,i].ElType <> lrErr then
        if LstSym <> '' then
          LstSym:=LstSym+', «'+SymsLR[i]+'»'
        else LstSym:='«'+SymsLR[i]+'»';
    end;
    Soob:='Допустимые символы: '+LstSym;
    Lines.Add('Обнаружена синтаксическая ошибка SynErr: Недопустимый символ!');
    Lines.Add(Soob);
    Lines.Add('строка: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
      ' позиция в строке: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
    frmMainSUT.REdProg.SelLength:=Token.LexEnd-Token.LexBeg+1;
  end;
end; //Syntax_Error_LR

//Процедуры формирования ошибок для LL-разбора
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
    //генерация сообщения
    LstSym:='';
    Lex:=Low(tLexCode);
    LexHigh:=High(tLexCode);
    while Lex <= LexHigh do
    begin
      if Lex in LLTbl[NStr].Terminals then
        if LstSym <> '' then
          LstSym:=LstSym+', «'+LexClass[Lex].LexName+'»'
        else LstSym:='«'+LexClass[Lex].LexName+'»';
      Lex:=succ(Lex);
    end;
    Soob:='Допустимые символы: '+LstSym;
    Lines.Add('Обнаружена синтаксическая ошибка SynErr: Недопустимый символ!');
    Lines.Add(Soob);
    Lines.Add('строка: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
      ' позиция в строке: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
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
      1:Soob:='Повторное объявление идентификатора';
      2:Soob:='Идентификатор не является именем типа';
      3:Soob:='Идентификатор не является именем переменной';
      4:Soob:='Несовместимость типов';
      5:Soob:='Идентификатор не объявлен';
    end;
    Lines.Add('Обнаружена семантическая ошибка TypeErr_'+IntToStr(Code)+':');
    Lines.Add(Soob);
    Lines.Add('строка: '+IntToStr(frmMainSUT.REdProg.CaretPos.Y+1)+
      ' позиция в строке: '+IntToStr(frmMainSUT.REdProg.CaretPos.X+1));
    frmMainSUT.REdProg.SelLength:=Token.LexEnd-Token.LexBeg+1;
  end;
end; //Type_Error

//Семантические действия

procedure AddType(Pnt: tPntElTblIde; Cat: tCatId; Typ: tType);
//добавление типа и других значений в запись Pnt таблицы символов
begin //не сделана проверка на размер отведенной памяти!!! Надо сделать!!!
  Pnt^.Cat:=Cat; //установка категории
  Pnt^.Typ:=Typ; //установка типа
  if Cat = catVarName then
  begin
    while (NextAddr mod Typ.Width) <> 0 do NextAddr:=NextAddr+1; //выравнивание адреса
    Pnt.Addr:=NextAddr; //установка адреса памяти
    NextAddr:=NextAddr+Typ.Width; //адрес очередной свободной памяти
  end else Pnt.Addr:=-1; //нет адреса памяти
end; //AddType

function NewTemp(Typ: tType): tPntElTblIde;
//добавление новой временной переменной в таблицу символов
var
  Str: String;
  p: tPntElTblIde;
begin
  CntTmpVar:=CntTmpVar+1;
  Str:='$'+IntToStr(CntTmpVar); //формируем лексему
  AddElemTblIde(Str, catVarName, Typ);
  p:=TblIde.PntFirst; //добавление всегда в начало
  AddType(p, catVarName, Typ);
  Result:=p;
end; //NewTemp

function MakeList(i: integer): tPntNodeInt;
//создает новый одноэлементный список, состоящий только из i
var
  p: tPntNodeInt;
begin
  New(p);
  p^.Info:=i;
  p^.Next:=nil;
  Result:=p;
end; //MakeList

function Merge(p1, p2: tPntNodeInt): tPntNodeInt;
//объединяет списки, на которые указывают p1 и p2
var
  p: tPntNodeInt;
begin
  if p1 <> nil then //список p1 непустой
  begin
    p:=p1;
    while p^.Next <> nil do p:=p^.Next; //ищем последний узел списка
    p^.Next:=p2; //список p2 присоединяем в конец списка p1
    Result:=p1;
  end else Result:=p2;
end; //Merge

procedure BackPatch(var p: tPntNodeInt; i: integer);
//устанавливает i в качестве целевой метки в каждую команду из списка, на который указывает p
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
//формирует трехадресную команду в виде четверки
//не сделана проверка на размер отведенной памяти!!! Надо сделать!!!
begin
  InstrMem[NextInstr].Op:=Op;
  InstrMem[NextInstr].Arg1:=Arg1;
  InstrMem[NextInstr].Arg2:=Arg2;
  InstrMem[NextInstr].Res:=Res;
  NextInstr:=NextInstr+1;
end; //Gen

function A1(Token: tToken): Boolean; //true - успешно; false - ошибка
var
  p: tPntElTblIde;
  t: tType;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat <> catNoCat then
  begin
    Result:=false;
    Type_Error(1, Token); //повторное объявление
    Exit;
  end;
  t.TypeCode:=typeVoid;
  AddType(p, catProgName, t);
end; //A1
function A2(Token: tToken): Boolean; //true - успешно; false - ошибка
var
  p: tPntElTblIde;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat <> catNoCat then
  begin
    Result:=false;
    Type_Error(1, Token); //повторное объявление
    Exit;
  end;
  PushPnt(p, AttrSt);
end; //A2
procedure A3;
var
  t1: ^tType;
  t2: tPntElTblIde;
begin
  t1:=PopPnt(AttrSt); //атрибут LstId.type
  t2:=PopPnt(AttrSt); //атрибут id.pnt
  AddType(t2, catVarName, t1^);
end; //A3
procedure A4;
var
  t1: ^tType;
  t2: tPntElTblIde;
begin
  t1:=PopPnt(AttrSt); //атрибут LstId1.type
  t2:=PopPnt(AttrSt); //атрибут id.pnt
  AddType(t2, catVarName, t1^);
  PushPnt(t1, AttrSt); //атрибут LstId.type
end; //A4
function A5(Token: tToken): Boolean; //true - успешно; false - ошибка
var
  p: tPntElTblIde;
  pt: ^tType;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat <> catTypeName then
  begin
    Result:=false;
    Type_Error(2, Token); //не имя типа
    Exit;
  end;
  New(pt);
  pt^:=p^.Typ;
  PushPnt(pt, AttrSt); //атрибут LstId.type
end; //A5
function A6(Token: tToken): Boolean; //true - успешно; false - ошибка
var
  p: tPntElTblIde;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat = catNoCat then
  begin
    Result:=false;
    Type_Error(5, Token); //не объявлен идентификатор
    Exit;
  end;
  if p^.Cat <> catVarName then
  begin
    Result:=false;
    Type_Error(3, Token); //не имя переменной
    Exit;
  end;
  PushPnt(p, AttrSt); //атрибут id.pnt
end; //A6
function A7(Token: tToken): Boolean; //true - успешно; false - ошибка
var
  t1, t3: tPntElTblIde;
  t2: ^tType;
  pi: ^integer;
begin
  Result:=true;
  t1:=PopPnt(AttrSt); //атрибут Expr.addr
  t2:=PopPnt(AttrSt); //атрибут Expr.type
  t3:=PopPnt(AttrSt); //атрибут id.pnt
  if t3^.Typ.TypeCode <> t2^.TypeCode then
  begin
    Result:=false;
    Type_Error(4, Token); //несовместимость типов
    Exit;
  end;
  Gen(opAss, t1, nil, t3); //команда вида x:=y
end; //A7
procedure A8(Token: tToken);
begin
  PushPnt(Token.Attr, AttrSt); //атрибут rel.op или +.op или *.op
end; //A8
function A9(Token: tToken): Boolean; //true - успешно; false - ошибка
var
  t1, t4, t6: tPntElTblIde;
  t2, t5: ^tType;
  t3: ^tOperCode;
begin
  Result:=true;
  t1:=PopPnt(AttrSt); //атрибут Term.addr
  t2:=PopPnt(AttrSt); //атрибут Term.type
  t3:=PopPnt(AttrSt); //атрибут +.op
  t4:=PopPnt(AttrSt);  //атрибут Expr1.addr
  t5:=PopPnt(AttrSt); //атрибут Expr1.type
  if t5^.TypeCode <> t2^.TypeCode then
  begin
    Result:=false;
    Type_Error(4, Token); //несовместимость типов
    Exit;
  end;
  PushPnt(t2, AttrSt); //атрибут Expr.type
  t6:=NewTemp(t2^);
  PushPnt(t6, AttrSt); //атрибут Expr.addr
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
  PushPnt(pt, AttrSt); //атрибут Factor.type
  PushPnt(p, AttrSt); //атрибут Factor.addr
end; //A12
function A13(Token: tToken): Boolean; //true - успешно; false - ошибка
var
  p: tPntElTblIde;
  pt: ^tType;
begin
  Result:=true;
  p:=Token.Attr;
  if p^.Cat = catNoCat then
  begin
    Result:=false;
    Type_Error(5, Token); //не объявлен идентификатор
    Exit;
  end;
  if p^.Cat <> catVarName then
  begin
    Result:=false;
    Type_Error(3, Token); //не имя переменной
    Exit;
  end;
  New(pt);
  pt^:=p^.Typ;
  PushPnt(pt, AttrSt); //атрибут Factor.type
  PushPnt(p, AttrSt); //атрибут Factor.addr
end; //A13

//Выполнение семантических действий
function Semantic_Action(ActionCode: Byte; Token: tToken): Boolean; //true - успешно, false - ошибка
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


function SUT_LR: Boolean; //функция СУ-трансляции
//Возвращает true, если нет ошибок
var
  Token, PredToken: tToken; //полученный от сканера токен
  ElemLR: tElemLR; //Элемент таблицы разбора
  i, Sym: Byte; //Sym - входной символ парсера (либо код токена, либо код нетерминала
  tmp, State: Byte; //State - текущее состояние стека парсера
  Lex: tLexCode;
//тело функции SUT_LR
begin
  StrProg:=Trim(frmMainSUT.REdProg.Text);
  LngTxt:=Length(StrProg);
  if LngTxt = 0 then
  begin
    Application.MessageBox('Отсутствует тестовая программа!',
      'Предупреждение',mb_OK+mb_IconHand);
    Exit;
  end;
  //инициализация таблицы символов
  TblIde.NumRows:=0;
  TblIde.PntFirst:=nil;
  NextAddr:=0; NextInstr:=0; CntTmpVar:=0; f:=1;
  AddBaseTypes; //Добавление в таблицу символов предопределенных типов
  frmMainSUT.memToken.Lines.Clear;
  frmMainSUT.memData.Lines.Clear;
  frmMainSUT.memError.Lines.Clear;
  Result:=true;
  ParserSt.Top:=nil;
  AttrSt.Top:=nil;
	Push(1,ParserSt); //начальное состояние в стек
	Token:=Scaner; //получение токена от сканера
  PredToken:=Token;
  if Token.Code <> lcErr then //Нет лексической ошибки
  begin
    ElemLR.ElType:=0;
    Lex:=Token.Code; //Lex - очередной входной символ
    Sym:=LexCodeLR[Lex]; //сопоставление терминала и столбца в табл. разбора
    while ElemLR.ElType <> lrStop do //пока не элемент останова
    begin
      State:=StackTop(ParserSt); //текущее состояние анализатора
      ElemLR:=LRTbl[State,Sym];
      case ElemLR.ElType of
        lrErr:  //синтаксическая ошибка
          begin
            Syntax_Error_LR(State,Token);
            Result:=false;
            ElemLR.ElType:=lrStop; //чтобы выйти из цикла
          end;
        lrShift: //элемент переноса
          begin
            Push(ElemLR.ElPar,ParserSt); //состояние в стек
            if Sym > NumNeTerm then //терминал, принять его
            begin
              PredToken:=Token;
              Token:=Scaner; //получение следующего токена
              Lex:=Token.Code; //Lex - очередной входной символ
              Sym:=LexCodeLR[Lex]; //сопоставление терминала и столбца в табл. разбора
              if Token.Code = lcErr then //Лексическая ошибка
              begin
                Result:=false;
                ElemLR.ElType:=lrStop; //чтобы выйти из цикла
              end;
            end else
            begin
              Lex:=Token.Code;
              Sym:=LexCodeLR[Lex]; //сопоставление терминала и столбца в табл. разбора
            end;
          end;
        lrReduct: //элемент свертки
          begin
            for i:=1 to ElemLR.ElPar do
              tmp:=Pop(ParserSt); //удаление верхних элементов стека
            Sym:=ElemLR.Left; //нетерминал левой части как новый входной символ
            if ElemLR.Act <> 0 then //есть действие
              if not Semantic_Action(ElemLR.Act,PredToken) then //выполнить действия
              begin
                Result:=false;
                ElemLR.ElType:=lrStop; //чтобы выйти из цикла
              end;
          end;
      end;
    end;
  end;
end; //SUT_LR

function SUT_LL: Boolean; //функция СУ-трансляции
//Возвращает true, если нет ошибок
var
  Token, PredToken: tToken; //полученный от сканера токен
  i: Byte;
  NextSym: Boolean;
//тело функции SUT_LL
begin
  StrProg:=Trim(frmMainSUT.REdProg.Text);
  LngTxt:=Length(StrProg);
  if LngTxt = 0 then
  begin
    Application.MessageBox('Отсутствует тестовая программа!',
      'Предупреждение',mb_OK+mb_IconHand);
    Exit;
  end;
  //инициализация таблицы символов
  TblIde.NumRows:=0;
  TblIde.PntFirst:=nil;
  NextAddr:=0; NextInstr:=0; CntTmpVar:=0; f:=1;
  AddBaseTypes; //Добавление в таблицу символов предопределенных типов
  frmMainSUT.memToken.Lines.Clear;
  frmMainSUT.memData.Lines.Clear;
  frmMainSUT.memError.Lines.Clear;
  Result:=true;
  ParserSt.Top:=nil; //начальное состояние стека
  AttrSt.Top:=nil;
  Push(0,ParserSt); //в стек 0
  i:=1; //номер 1-й строки таблицы разбора
  NextSym:=true;
	Token:=Scaner; //получение токена от сканера
  PredToken:=Token;
	while (Token.Code <> lcEof) or (i <> 0) do
  begin
    if (LLTbl[i].Action <> 0) or (Token.Code in LLTbl[i].Terminals) then
    begin
      if LLTbl[i].Action <> 0 then //строка соответствует символу действия
        if not Semantic_Action(LLTbl[i].Action,PredToken) then //выполнить действия
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
    	Token:=Scaner; //получение следующего токена от сканера
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
  StBarProg.Panels[0].Text:=' Строка: 1';
  StBarProg.Panels[1].Text:=' Позиция в строке: 1';
  StBarProg.Panels[2].Text:=' Изменения: Нет';
  lblZagRez.Caption:='Результаты тестирования';
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
  if ChangeProg then //Программа изменена
    if Application.MessageBox('В тест внесены изменения'#13+
        'Сохранить изменения?',
        'Вопрос',mb_IconQuestion+mb_YesNo) = idYes
    then btnSaveClick(Sender);
end;

procedure TfrmMainSUT.btnLoadClick(Sender: TObject);
var
  Direct: string;
begin
  if ChangeProg then //Программа изменена
    if Application.MessageBox('В текущий тест внесены изменения'#13+
        'Сохранить предыдущий тест?',
        'Вопрос',mb_IconQuestion+mb_YesNo) = idYes
    then btnSaveClick(Sender);
  OpenDialog1.Title:='Загрузка тестовой программы';
  OpenDialog1.DefaultExt:='txt';
  OpenDialog1.Filter:='Текстовые файлы|*.txt';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  OpenDialog1.InitialDir:=Direct;
  OpenDialog1.FileName:='';
  if OpenDialog1.Execute then
  begin
    REdProg.Lines.LoadFromFile(OpenDialog1.FileName);
    ReadedFileName:=OpenDialog1.FileName;
    StBarProg.Panels[2].Text:=' Изменения: Нет';
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
  SaveDialog1.Title:='Сохранение тестовой программы';
  SaveDialog1.DefaultExt:='txt';
  SaveDialog1.Filter:='Текстовые файлы|*.txt';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  SaveDialog1.InitialDir:=Direct;
  SaveDialog1.FileName:=ReadedFileName;
  if SaveDialog1.Execute then
  begin
    REdProg.PlainText:=true; //не сохранять форматирование
    REdProg.Lines.SaveToFile(SaveDialog1.FileName);
    REdProg.PlainText:=false;
    ReadedFileName:=SaveDialog1.FileName;
    StBarProg.Panels[2].Text:=' Изменения: Нет';
    ChangeProg:=false;
    Application.MessageBox('Тест успешно сохранен!',
      'Информационное сообщение',mb_OK+mb_IconInformation);
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
  lblZagRez.Caption:='Сформированные токены';
  StrProg:=Trim(REdProg.Text);
  LngTxt:=Length(StrProg);
  if LngTxt = 0 then
  begin
    Application.MessageBox('Отсутствует тестовая программа!',
      'Предупреждение',mb_OK+mb_IconHand);
    Exit;
  end;
  //инициализация таблицы символов
  TblIde.NumRows:=0;
  TblIde.PntFirst:=nil;
  f:=1;
  AddBaseTypes; //Добавление в таблицу символов предопределенных типов
  memToken.Lines.Clear;
  memError.Lines.Clear;
  memData.Lines.Clear;
  Ostanov:=false;
  while not Ostanov do
  begin
    Token:=Scaner;
    if Token.Code <> lcErr then //получен сформированный токен
    begin
      StrCom:='';
      if Token.Code in [lcId, lcNum] then
      begin
        pRowIde:=Token.Attr;
        AttrVal:=pRowIde^.RowNum; //номер строки таблицы символов
        StrAttr:=IntToStr(AttrVal);
//        StrAttr:=IntToStr(Integer(pRowIde)); //вывод адреса
        StrCom:='  (лексема: '+pRowIde^.Lex+')';
      end else if Token.Code in [lcAdd, lcMult] then
      begin
        pOpCode:=Token.Attr;
        OpCode:=pOpCode^;
        AttrVal:=Ord(OpCode);
        StrAttr:=IntToStr(AttrVal);
        case OpCode of
          opAdd: StrCom:=' (операция: +)';
          opSub: StrCom:=' (операция: -)';
          opMult: StrCom:=' (операция: *)';
          opDiv: StrCom:=' (операция: /)';
        end; //case pOpCode^
      end else StrAttr:='null';
      StrToken:='<'+Token.Name+',  '+StrAttr+'> '+StrCom;
      memToken.Lines.Add(StrToken);
      if Token.Code = lcEof then
        Ostanov:=true; //маркер конца ввода
    end else Ostanov:=true; //Code=lcErr - лексическая ошибка
  end;
  if Token.Code <> lcErr then
    memError.Lines.Add('Лексический анализ успешно завершен');
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
    Application.MessageBox('Отсутствует таблица разбора! Надо загрузить!',
      'Предупреждение',mb_OK+mb_IconHand);
    btnLoadXML.SetFocus;
    Exit;
  end;
  if SUT_LR then
  begin
    lblZagRez.Caption:='Трехадресные команды';
    for i:=0 to NextInstr-1 do
      memToken.Lines.Add(OutInstr(i));
    OutDataMem;
    memError.Lines.Clear;
    memError.Lines.Add('СУ-трансляция успешно завершена');
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
  OpenDialog1.Title:='Загрузка LR-таблицы разбора';
  OpenDialog1.DefaultExt:='xml';
  OpenDialog1.Filter:='xml-файлы|*.xml';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  OpenDialog1.InitialDir:=Direct;
  OpenDialog1.FileName:='';
  if OpenDialog1.Execute then
    try
      XMLDoc.LoadFromFile(OpenDialog1.FileName);
      XMLDoc.Active:=true;
    except
      Application.MessageBox('В файле нет нужных данных, возможно, файл поврежден!',
        'Загрузка LR-таблицы разбора',mb_IconHand+mb_Ok);
      Exit;
    end;
  RootNode:=XMLDoc.DocumentElement;
  if RootNode.NodeName <> 'SLR_Table' then
  begin
    Application.MessageBox('В файле нет нужных данных, возможно, файл поврежден!',
      'Загрузка LR-таблицы разбора',mb_OK+mb_IconHand);
    Exit;
  end;
  ColsNode:=RootNode.ChildNodes.FindNode('Columns');
  //загрузка нетерминалов
  DataNode:=ColsNode.ChildNodes.FindNode('Neterms');
  for i := 0 to DataNode.ChildNodes.Count - 1 do
  begin
    TmpNode:=DataNode.ChildNodes[i];
    AttrStr:=VarToStr(TmpNode.Attributes['ColNum']);
    NumColLR:=StrToInt(AttrStr); //номер столбца LR-таблицы разбора
    AttrStr:=VarToStr(TmpNode.Attributes['Lexeme']);
    SymsLR[NumColLR]:=AttrStr;
  end;
  NumNeTerm:=NumColLR;
  //загрузка терминалов
  DataNode:=ColsNode.ChildNodes.FindNode('Terms');
  for i := 0 to DataNode.ChildNodes.Count - 1 do
  begin
    TmpNode:=DataNode.ChildNodes[i];
    AttrStr:=VarToStr(TmpNode.Attributes['ColNum']);
    NumColLR:=StrToInt(AttrStr); //номер столбца LR-таблицы разбора
    AttrStr:=VarToStr(TmpNode.Attributes['Lexeme']);
    SymsLR[NumColLR]:=AttrStr;
    //поиск лексемы терминала и установка номера столбца в ТР для него
    Lex:=Low(tLexCode);
    LexHigh:=High(tLexCode);
    while Lex <= LexHigh do
    begin
      if LexClass[Lex].LexName = AttrStr then
        Break;
      Lex:=succ(Lex);
    end;
    if Lex > LexHigh then //не найдена
    begin
      Application.MessageBox(PChar('В списке лексических классов не найдено'+
        ' обозначение лексического класса «'+AttrStr+'»!'),
        'Предупреждение',mb_OK+mb_IconHand);
      Exit;
    end else LexCodeLR[LexClass[Lex].LexCode]:=NumColLR;
  end;
  //загрузка таблицы разбора
  for i:=1 to RootNode.ChildNodes.Count - 1 do
  begin
    DataNode:=RootNode.ChildNodes[i];
    AttrStr:=VarToStr(DataNode.Attributes['NSost']);
    State:=StrToInt(AttrStr);
    for j:=0 to DataNode.ChildNodes.Count - 1 do
    begin
      TmpNode:=DataNode.ChildNodes[j];
      AttrStr:=VarToStr(TmpNode.Attributes['ColNum']);
      TmpInt:=StrToInt(AttrStr); //столбец в ТР
      AttrStr:=VarToStr(TmpNode.Attributes['ElType']);
      LRTbl[State,TmpInt].ElType:=StrToInt(AttrStr);
      AttrStr:=VarToStr(TmpNode.Attributes['ElPar']);
      LRTbl[State,TmpInt].ElPar:=StrToInt(AttrStr);
      AttrStr:=VarToStr(TmpNode.Attributes['Left']);
      if AttrStr <> '' then
      begin //поиск кода лексемы
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
  OpenDialog1.Title:='Загрузка LL-таблицы разбора';
  OpenDialog1.DefaultExt:='xml';
  OpenDialog1.Filter:='xml-файлы|*.xml';
  Direct:=ExtractFilePath(Application.ExeName)+'TESTS\';
  if not DirectoryExists(Direct) then CreateDir(Direct);
  OpenDialog1.InitialDir:=Direct;
  OpenDialog1.FileName:='';
  if OpenDialog1.Execute then
    try
      XMLDoc.LoadFromFile(OpenDialog1.FileName);
      XMLDoc.Active:=true;
    except
      Application.MessageBox('В файле нет нужных данных, возможно, файл поврежден!',
        'Загрузка LL-таблицы разбора',mb_IconHand+mb_Ok);
      Exit;
    end;
  RootNode:=XMLDoc.DocumentElement;
  if RootNode.NodeName <> 'LL_Table' then
  begin
    Application.MessageBox('В файле нет нужных данных, возможно, файл поврежден!',
      'Загрузка LL-таблицы разбора',mb_OK+mb_IconHand);
    Exit;
  end;
  //загрузка таблицы разбора
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
      //поиск лексемы терминала и определение его кода
      Lex:=Low(tLexCode);
      LexHigh:=High(tLexCode);
      while Lex <= LexHigh do
      begin
        if LexClass[Lex].LexName = AttrStr then
          Break;
        Lex:=succ(Lex);
      end;
      if Lex > LexHigh then //не найдена
      begin
        Application.MessageBox(PChar('В списке лексических классов не найдено'+
          ' обозначение лексического класса «'+AttrStr+'»!'),
          'Предупреждение',mb_OK+mb_IconHand);
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
    Application.MessageBox('Отсутствует таблица разбора! Надо загрузить!',
      'Предупреждение',mb_OK+mb_IconHand);
    btnLoadXML.SetFocus;
    Exit;
  end;
  if SUT_LL then
  begin
    lblZagRez.Caption:='Трехадресные команды';
    for i:=0 to NextInstr-1 do
      memToken.Lines.Add(OutInstr(i));
    OutDataMem;
    memError.Lines.Clear;
    memError.Lines.Add('СУ-трансляция успешно завершена');
  end;
end;

procedure TfrmMainSUT.REdProgChange(Sender: TObject);
begin
  StBarProg.Panels[2].Text:=' Изменения: Есть';
  btnScan.Enabled:=not(Trim(REdProg.Text) = '');
  ChangeProg:=true;
  if REdProg.Text <> '' then SelectLexemes;
end;

procedure TfrmMainSUT.REdProgKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  StBarProg.Panels[0].Text:=' Строка: '+IntToStr(REdProg.CaretPos.Y+1);
  StBarProg.Panels[1].Text:=' Позиция в строке: '+IntToStr(REdProg.CaretPos.X+1);
end;

procedure TfrmMainSUT.REdProgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  StBarProg.Panels[0].Text:=' Строка: '+IntToStr(REdProg.CaretPos.Y+1);
  StBarProg.Panels[1].Text:=' Позиция в строке: '+IntToStr(REdProg.CaretPos.X+1);
end;

end.
