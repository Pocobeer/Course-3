const dino = document.getElementById("dino");
const dinoimg = document.getElementById("dinoImg");
const cactus = document.getElementById("cactus");
const ptic_1 = document.getElementById("ptic_1");
const apple = document.getElementById("apple");
const scoreElement = document.getElementById("score");
const bestScoreElement = document.getElementById("bestScore");
const pticImg = document.getElementById("pticImg");
let score = 0;
let bestScore = localStorage.getItem('bestScore') ? parseInt(localStorage.getItem('bestScore')) : 0;
let timer = setInterval(getItem, 1000);
let timer2 = setInterval(changeImg, 400);
let isGameActive = true; 
// Отображаем лучший результат
bestScoreElement.innerText = `Лучший результат: ${bestScore}`;

//
scoreInterval = setInterval(function () {
    if (isGameActive) {
        scoreElement.innerText = `Счет: ${score}`;
        score++;
        // Сохраняем лучший результат
        if (score > bestScore) {
            bestScore = score;
            localStorage.setItem('bestScore', bestScore);
            bestScoreElement.innerText = `Лучший результат: ${bestScore}`;
        }
    }
}, 1000);
 
function jump() {
    if (dino.classList != "jump") {
        dino.classList.add("jump");
        setTimeout(function () {
            dino.classList.remove("jump");
        }, 300);
    }
}



let isAlive = setInterval(function () {
    if(!isGameActive) return;
    let dinoTop = parseInt(window.getComputedStyle(dino).getPropertyValue("top"));
    let cactusLeft = parseInt(window.getComputedStyle(cactus).getPropertyValue("left"));
    let ptic_1Left = parseInt(window.getComputedStyle(ptic_1).getPropertyValue("left"));
    let appleLeft = parseInt(window.getComputedStyle(apple).getPropertyValue("left"));

    if(appleLeft < 50 && appleLeft > 10 && dinoTop >= 140){
        apple.style.display = "none";
        score+=10
    }

    if (((cactusLeft < 50 && cactusLeft > 10 && dinoTop >= 140)) || (ptic_1Left < 50 && ptic_1Left > 10 && dinoTop >= 90 && dinoTop <= 160)) {
        isGameActive = false;
        createModal();
        modal.style.display = "block";
        cactus.style.animation = "none";
        ptic_1.style.animation = "none";
        apple.style.animation = "none";
        cactus.style.display = "none";
        ptic_1.style.display = "none";
        apple.style.display = "none";
    }

}, 10);

document.addEventListener("keydown", function (event) {
    if(event.code == "Space"){
        dinoimg.src = "images/dino.png";
        dinoimg.style.height = "50px";
        dino.style.top = "150px";
        jump();
    }
});

document.addEventListener("keydown", function (event) {
    if (event.code == "ArrowDown"){
        dinoimg.src = "images/dino_down.png";
        dinoimg.style.height = "30px";
        dino.style.top = "170px";
    }
});

document.addEventListener("keyup", function (event) {
    if (event.code == "ArrowDown"){
        dinoimg.src = "images/dino.png";
        dinoimg.style.height = "50px";
        dino.style.top = "150px";
    }
});

function changeImg() {

    if(pticImg.src == "http://127.0.0.1:5500/images/ptic_1.png"){
        pticImg.src = "http://127.0.0.1:5500/images/ptic_2.png";
    }
    else if(pticImg.src == "http://127.0.0.1:5500/images/ptic_2.png"){
        pticImg.src = "http://127.0.0.1:5500/images/ptic_1.png";
    }
}

function getRandomInt(max) {
    return Math.floor(Math.random() * max);
}

function getItem(){
    if(!isGameActive) return;
    let num = getRandomInt(100);
    if (num <= 60){
        cactus.style.display = "block";
        ptic_1.style.display = "none";
        apple.style.display = "none";
    }
    if (num > 60 && num <= 95){
        ptic_1.style.display = "block";
        cactus.style.display = "none";
        apple.style.display = "none";
    }
    if(num > 95){
        apple.style.display = "block";
        cactus.style.display = "none";
        ptic_1.style.display = "none";
    }
}

function upperChild(parent, child) {
    parent.appendChild(child);
}
function createModal(){
    const modal = document.createElement('div');
        modal.id = 'modal';
        modal.className = 'modal';

        const modalContent = document.createElement('div');
        modalContent.className = 'modal-content';

        const message = document.createElement('p');
        message.id = 'gameOverMessage';
        if(score == 0){
            message.innerText = 'Game Over! Ваш счет:' + score;
        }else{
            message.innerText = 'Game Over! Ваш счет: ' + (score-1);
        }
        const restartButton = document.createElement('button');
        restartButton.id = 'restartButton';
        restartButton.innerText = 'Начать новую игру';

        //upperChild(modalContent, closeButton);
        upperChild(modalContent, message);
        upperChild(modalContent, restartButton);
        upperChild(modal, modalContent);

        restartButton.onclick = function() {
            document.getElementById("modal").style.display = "none";
            score = 0; // Сбрасываем счет
            scoreElement.innerText = `Счет: ${score}`;
            isGameActive = true; // Восстанавливаем игру
            cactus.style.animation = "block 1s infinite linear"
            ptic_1.style.animation = "block 1s infinite linear"
            apple.style.animation = "block 1s infinite linear"
            modal.remove();
        };

        upperChild(document.getElementById('container'), modal);

}   