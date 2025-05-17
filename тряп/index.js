class Enum {
    constructor(keys) {
        let i = 0
        for (let key of keys) {
            this[key] = i
            i++
        }
        Object.freeze(this)
    }

    getKey(value) {
        for (let key in this)
            if (this[key] === value)
                return key
        return null
    }
}

class Scanner {

    constructor(code) {
        
        this.isLexAnalysisCompleted = false
        this.isErrorFound = false

        codeEditor.setValue(code);
        resultArea.setValue('')

        this.buffer = code.split('')

        while (!this.isLexAnalysisCompleted)
            this.lexicalAnalyzer()

        if (!this.isErrorFound) {
            resultArea.setValue(this.getTokenList())
            resultAreaLegend('Список токенов')
        }

    }

    tokenList = []
    // stack = []
    f = 0 // позиция первого символа лексемы
    r = 0 // перемещается в процессе распознавания

    // КЛЮЧЕВЫЕ СЛОВА
    keywords = [
        { lex: 'Program',       name: 'Program'     }, // Код: 1
        { lex: 'endProg',    name: 'endProg'  }, // Код: 2
        { lex: 'begin',     name: 'begin'   }, // Код: 3
        { lex: 'end',       name: 'end'     }, // Код: 4
        { lex: 'break',     name: 'break'   }, // Код: 5
        { lex: 'repeat', name: 'repeat' },      // Код: 6
        { lex: 'until', name: 'until' },         // Код: 7
        { lex: 'not',       name: 'not'     }, // Код: 8
    ]

    // ИДЕНТИФИКАТОРЫ
    cats = new Enum(['PROG_NAME', 'TYPE', 'VAR'])
    types = new Enum(['INTEGER', 'REAL', 'BOOL', 'STR'])
    
    identifiers = [
        { lex: 'integer',     cat: this.cats['TYPE'], type: this.types['INTEGER'], size: 4 },
        { lex: 'real',   cat: this.cats['TYPE'], type: this.types['REAL'], size: 8 },
        { lex: 'bool', cat: this.cats['TYPE'], type: this.types['BOOL'], size: 1 },
        { lex: 'string',  cat: this.cats['TYPE'], type: this.types['STR'] },
    ]

    // КОНСТАНТЫ
    constants = []

    jumpTable = [
        // 0    1    2    3    4    5    6    7    8    9   10  11   12   13   14   15   16   17   18   19  
        [ -1, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], //  0 ;
        [ -2, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], //  1 ,
        [ -3, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], //  2 [
        [ -4, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], //  3 ]
        [ -5, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], //  4 (
        [ -6, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], //  5 )
        [ -7, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11,  14, -94, -25, -95, -94, -26,  19 ], //  6 .
        [ -8, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25,  17, -94, -26,  19 ], //  7 +
        [ -9, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25,  17, -94, -26,  19 ], //  8 -
        [  1, -10, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], //  9 |
        [-11, -91, -92, -14, -16, -93, -20, -21, -22,  12,  10, 12,  11, -24, -94, -25, -95, -94, -26,  19 ], // 10 *
        [  9, -91, -92, -14, -16, -93, -20, -21, -22,  10,  10, 11, -23, -24, -94, -25, -95, -94, -26,  19 ], // 11 /
        [  2, -91, -13, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 12 &
        [  3, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 13 <
        [  4, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 14 >
        [  5, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 15 !
        [  6, -91, -92, -15, -17, -18, -19, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 16 =
        [  7, -91, -92, -14, -16, -93, -20,   7, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 17 l буква
        [ 13, -91, -92, -14, -16, -93, -20,   7, -22, -12,  10, 11,  11,  13,  15,  15,  18,  18,  18,  19 ], // 18 d цифра 
        [  8, -91, -92, -14, -16, -93, -20, -21,   8, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 19 space
        [  8, -91, -92, -14, -16, -93, -20, -21,   8, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 20 tab
        [  8, -91, -92, -14, -16, -93, -20, -21,   8, -12, -23, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 21 line feed
        [ 19, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26, -27 ], // 22 "
        [  7, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11,  16, -94,  16, -95, -94, -26,  19 ], // 23 e
        [-90, -91, -92, -14, -16, -93, -20, -21, -22, -12,  10, 11,  11, -24, -94, -25, -95, -94, -26,  19 ], // 24 другие символы
    ]

    stateAndToken = [
        { state: -1,  code: 11, attr: 0, name: 'enter'   , ret: 0 }, // ;
        { state: -2,  code: 12, attr: 0, name: ','   , ret: 0 }, // ,
        { state: -3,  code: 13, attr: 0, name: '['   , ret: 0 }, // [
        { state: -4,  code: 14, attr: 0, name: ']'   , ret: 0 }, // ]
        { state: -5,  code: 15, attr: 0, name: '('   , ret: 0 }, // (
        { state: -6,  code: 16, attr: 0, name: ')'   , ret: 0 }, // )
        { state: -7,  code: 17, attr: 0, name: '.'   , ret: 0 }, // .
        { state: -8,  code: 18, attr: 0, name: 'add' , ret: 0 }, // +
        { state: -9,  code: 18, attr: 1, name: 'add' , ret: 0 }, // -
        { state: -10, code: 18, attr: 2, name: 'add' , ret: 0 }, // ||
        { state: -11, code: 19, attr: 0, name: 'mul' , ret: 0 }, // *
        { state: -12, code: 19, attr: 1, name: 'mul' , ret: 1 }, // /
        { state: -13, code: 19, attr: 2, name: 'mul' , ret: 0 }, // &&
        { state: -14, code: 20, attr: 0, name: 'rel' , ret: 1 }, // <
        { state: -15, code: 20, attr: 1, name: 'rel' , ret: 0 }, // <=
        { state: -16, code: 20, attr: 2, name: 'rel' , ret: 1 }, // >
        { state: -17, code: 20, attr: 3, name: 'rel' , ret: 0 }, // >=
        { state: -18, code: 20, attr: 4, name: 'rel' , ret: 0 }, // !=
        { state: -19, code: 20, attr: 5, name: 'rel' , ret: 0 }, // ==
        { state: -20, code: 10, attr: 0, name: '='   , ret: 1 }, // =
        { state: -21, code: 21, attr: 0, name: 'id'  , ret: 1 }, // идент
        { state: -22, code: 24, attr: 0, name: 'sp'  , ret: 1 }, // пробел
        { state: -23, code: 25, attr: 0, name: 'com' , ret: 0 }, // комментарий
        { state: -24, code: 22, attr: 0, name: 'num' , ret: 1 }, // цел. число
        { state: -25, code: 22, attr: 1, name: 'num' , ret: 1 }, // вещ. число
        { state: -26, code: 22, attr: 2, name: 'num' , ret: 1 }, // вещ. число c e
        { state: -27, code: 23, attr: 0, name: 'str' , ret: 0 }, // строка "
    ]

    error_codes = [
        { code: -90, desc: "Лексема не может начинаться с данного символа" },
        { code: -91, desc: "Ожидается символ '|'" },
        { code: -92, desc: "Ожидается символ '&'" },
        { code: -93, desc: "Ожидается символ '='" },
        { code: -94, desc: "Ожидается число" },
        { code: -95, desc: "Ожидается число, '+' или '-'" },
    ]

    lexicalAnalyzer() {

        let state = 0       // Начальное состояние автомата
        this.r = this.f     // Первый символ лексемы

        while (true) {
            
            // пока не конечное состояние
            while (state >= 0) {

                // номер строки табл. переходов (23, если 'e')
                let jumpTableRowNum = (
                    (state === 13 || state === 15)
                    && this.buffer[this.r] === 'e'
                )
                    ? 23
                    : this.NomStrOfTP(this.buffer[this.r])

                // следующее состояние
                state = this.jumpTable[jumpTableRowNum][state]
                
                if (state >= 0) this.r++ // следующий входной символ
            }
            // отработаны пробелы и т.п.
            if (state == -22) {
                this.f = this.r // 1-ый символ след. лексемы с учетом возврата одного символа
                state = 0
            }
            //отработаны комментарии
            else if (state == -23) {
                this.f = this.r // 1-ый символ след. лексемы с учетом возврата одного символа
                this.r = this.f + 1
                state = 0
            }
            else break
        }

        let token = {}
        let lexeme
        let strNum
        let foundToken
        
        switch (state) {

            // -1..-20
            case /^-(1?[0-9]|20)$/.test(state) && state:
                foundToken = this.stateAndToken.find(obj => obj.state === state)
                token.code = foundToken.code
                token.attr = foundToken.attr
                token.name = foundToken.name
                token.posStart = this.f
                
                if (foundToken.ret === 1) {
                    this.f = this.r
                    this.r--
                }
                else this.f = this.r + 1
                
                token.posEnd = this.r
                break
                
            // КЛЮЧЕВОЕ СЛОВО ИЛИ ИДЕНТИФИКАТОР
            case -21:
                lexeme = this.buffer.slice(this.f, this.r).join('')
                strNum = this.keywords.findIndex(obj => obj.lex === lexeme)

                // КЛЮЧЕВОЕ СЛОВО
                if (strNum != -1) {
                    token.code = strNum + 1
                    token.attr = 0
                    token.name = this.keywords[strNum].name

                    if (token.code === 2) // endMyC
                        this.isLexAnalysisCompleted = true
                }
                // ИДЕНТИФИКАТОР
                else {
                    foundToken = this.stateAndToken.find(obj => obj.state === state)
                    if (lexeme === "True" || lexeme === "False"){
                        strNum = this.constants.findIndex(obj => obj.lex === lexeme)
                        if (strNum === -1)
                            strNum = this.constants.push({ lex: lexeme, cat: this.cats['VAR'], type: this.types['BOOL'] }) - 1
                        token.name = "num"
                        }
                    else{
                        strNum = this.identifiers.findIndex(id => id.lex === lexeme)
                        if (strNum === -1)
                            strNum = this.identifiers.push({ lex: lexeme }) - 1
                        token.name = foundToken.name
                        }
                    token.code = foundToken.code
                    token.attr = strNum
                }
                token.posStart = this.f
                token.posEnd = this.r - 1
                this.f = this.r // возврат = 1, начало след. лексемы
                break
            
            // числа
            case -24:
            case -25:
            case -26:
                lexeme = + this.buffer.slice(this.f, this.r).join('')
                strNum = this.searchConst(lexeme, state)
                foundToken = this.stateAndToken.find(obj => obj.state === state)
                token.code = foundToken.code
                token.attr = strNum
                token.name = foundToken.name
                token.posStart = this.f
                token.posEnd = this.r - 1
                this.f = this.r // возврат = 1, начало след. лексемы
                break
            
            // строка
            case -27:
                lexeme = this.buffer.slice(this.f + 1, this.r).join('')
                strNum = this.searchConst(lexeme, state)
                foundToken = this.stateAndToken.find(obj => obj.state === state)
                token.code = foundToken.code
                token.attr = strNum
                token.name = foundToken.name
                token.posStart = this.f
                token.posEnd = this.r
                this.f = this.r + 1 // следующая лексема
                break

            case -90:
            case -91:
            case -92:
            case -93:
            case -94: 
            case -95:
                
                let coord = this.coordsByIndex(this.r)
                resultArea.setValue(
                    `Обнаружена лексическая ошибка!\n` +
                    `${this.error_codes.find(e => e.code === state).desc}\n` +
                    `Строка: ${coord.line}, cтолбец: ${coord.ch}`
                )
                this.isLexAnalysisCompleted = true
                this.isErrorFound = true
                break
        }

        this.tokenList.push(token)
    }

    // Номер строки в таблице переходов для символа
    NomStrOfTP(symbol) {
        switch (symbol) {
            case undefined: return 24
            case ';': return 0
            case ',': return 1
            case '[': return 2
            case ']': return 3
            case '(': return 4
            case ')': return 5
            case '.': return 6
            case '+': return 7
            case '-': return 8
            case '|': return 9
            case '*': return 10
            case '/': return 11
            case '&': return 12
            case '<': return 13
            case '>': return 14
            case '!': return 15
            case '=': return 16
            case /[a-zA-Z]/.test(symbol) && symbol:
                return 17
            case /[0-9]/.test(symbol) && symbol:
                return 18
            case ' ': return 19
            case '\t': return 20
            case '\r': return 21
            case '\n': return 0
            case '"': return 22
            default: return 24
        }
    }

    // Поиск константы и, при необходимости, вставка. Возвращает номер строки
    searchConst(lex, state) {
        let lexId = this.constants.findIndex(obj => obj.lex === lex)
        if (lexId == -1) {
            switch (state) {
                // целое число
                case -24:
                    return this.constants.push({ lex: lex, cat: this.cats['VAR'], type: this.types['INT'] }) - 1
                // веществ. числа
                case -25:
                case -26:
                    return this.constants.push({ lex: lex, cat: this.cats['VAR'], type: this.types['FLOAT'] }) - 1
                // строка
                case -27:
                    return this.constants.push({ lex: lex, cat: this.cats['VAR'], type: this.types['STR'] }) - 1
            }
        }
        else return lexId
    }
    
    // Получить список токенов
    getTokenList() {
        return this.tokenList.map(token =>  {
            let name = `${token.name},`.padEnd(10)
            let attr = token.attr.toString().padStart(2)
            let lex = ''
            if (token.code == 21){
                if (token.name === "num") lex = ' ' + this.constants[token.attr].lex 
                else lex = ' ' + this.identifiers[token.attr].lex
            }
            else if (token.code == 22 || token.code == 23)
                lex = ' ' + this.constants[token.attr].lex
            return `<${name} ${attr}>${lex}`
        }
        ).join('\n')
    }

    getBuffer() {
        return this.buffer.map(char => {
            if (char === '\r') return '\\r'
            if (char === '\n') return '\\n'
            if (char === '\t') return '\\t'
            return char;
        }).join('')
    }

    coordsByIndex (index) {
        const lines = this.buffer.join('').split('\r\n')
        let totalLength = 0
        let line = 0
        while (totalLength + lines[line].length <= index) {
          totalLength += lines[line].length + 2
          line++
        }
        const character = index - totalLength
        return {line: line + 1, ch: character + 1}
    }
}

let scanner

const codeEditor = CodeMirror.fromTextArea(document.getElementById('code-editor'), {
    lineNumbers: true,
    scrollbarStyle: "overlay",
    lineSeparator: "\r\n"
})
const resultArea = CodeMirror.fromTextArea(document.getElementById('result-area'), {
    lineWrapping: true,
    mode: null,
    scrollbarStyle: "overlay"
})

const resultAreaLegend = text => document.querySelector('#editor3 legend').innerText = text

function listenButtons() {

    document.getElementById('scan').addEventListener('click', () =>
        scanner = new Scanner(codeEditor.getValue())
    )

    document.getElementById('btn-buffer').addEventListener('click', () => {
        resultAreaLegend('Буфер')
        resultArea.setValue(scanner.getBuffer())
    })

    document.getElementById('btn-tokens').addEventListener('click', () => {
        resultAreaLegend('Список токенов')
        resultArea.setValue(scanner.getTokenList())
    })

    document.getElementById('btn-identifiers').addEventListener('click', () => {
        resultAreaLegend('Идентификаторы')
        resultArea.setValue(scanner.identifiers.map(elem => {
            let lex = elem.lex.padEnd(7)
            let cat = scanner.cats.getKey(elem.cat)
            let type = scanner.types.getKey(elem.type)
            return `lex: ${lex}\tcat: ${cat}\ttype: ${type}\n`;
        }).join(''))
    })

    document.getElementById('btn-constants').addEventListener('click', () => {
        resultAreaLegend('Константы')
        resultArea.setValue(JSON.stringify(scanner.constants, null, 2))
    })
}

// Открыть файл
let currentFileName;
document.getElementById('file-input').addEventListener('change', function () {
    const file = this.files[0]
    currentFileName = file.name
    const reader = new FileReader()
    reader.onload = function (e) {
        const text = e.target.result
        if (text) {
            scanner = new Scanner(text);
            ['#download', '#scan', '#dropdown']
                .forEach(id => document.querySelector(id).removeAttribute('disabled'));
            listenButtons()
        }
        else {
            resultArea.setValue('Пустой файл!')
        }
    }
    reader.readAsText(file)

})

// Отображать позицию курсора
codeEditor.on('cursorActivity', () => {
    const cursor = codeEditor.getCursor()
    document.getElementById('line').innerText = cursor.line + 1
    document.getElementById('column').innerText = cursor.ch + 1
})

// Сохранить файл
const saveFile = () => {
    var blob = new Blob([codeEditor.getValue()], { type: 'text/plain' });
    var link = document.createElement('a')
    link.download = currentFileName
    link.href = URL.createObjectURL(blob)
    link.onclick = function () {
        requestAnimationFrame(function () {
            URL.revokeObjectURL(link.href)
            link.removeAttribute('href')
        })
    }
    link.click()
}

document.getElementById('download').addEventListener('click', () => saveFile())
document.addEventListener('keydown', event => {
    if (event.ctrlKey && event.key === 's') {
        event.preventDefault(); 
        saveFile()
    }
})

let prefersDark = matchMedia('(prefers-color-scheme: dark)');
prefersDark.addEventListener('change', () => setTheme());

// Загрузить и установить цветовую схему
function setTheme(theme) {

    // Если theme не передан
    if (typeof theme == 'undefined') {
        // Получить 'system', 'light' или 'dark' из localStorage
        theme = localStorage.getItem('theme');
        // Если там пусто ('null'), то установить 'system'
        theme ??= 'system';
    }

    // Установить тему в localStorage
    localStorage.setItem('theme', theme);

    if (theme === 'system') {
        if (prefersDark.matches) {
            document.documentElement.className = 'dark';
            [codeEditor, resultArea].forEach(editor => editor.setOption('theme', 'ctp-mocha'));
        } else {
            document.documentElement.className = 'light';
            [codeEditor, resultArea].forEach(editor => editor.setOption('theme', 'default'));
        }
    } else {
        document.documentElement.className = theme;
        [codeEditor, resultArea]
            .forEach(editor => editor.setOption('theme',
                (theme == 'dark') ? 'ctp-mocha' : 'default'
            ))
    }

    // Указать тему в настройках
    document.getElementById(theme).checked = true;
}

// Установить тему при загрузке страницы
setTheme()

// При нажатии кнопки 'Cохранить' в настройках
document.getElementById('apply').addEventListener('click', () => {
    // Получить выбранную радио-кнопку
    const radioValue = document.querySelector('input[name="theme"]:checked')
    // Установить тему
    if (radioValue) setTheme(radioValue.value)
})
