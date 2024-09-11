const dino = document.getElementById("dino");
const cactus = document.getElementById("cactus");
const scoreElement = document.getElementById("score");
const bestScoreElement = document.getElementById("bestScore");
let score = 0;
let bestScore = localStorage.getItem('bestScore') ? parseInt(localStorage.getItem('bestScore')) : 0;

// Отображаем лучший результат
bestScoreElement.innerText = `Лучший результат: ${bestScore}`;

// Увеличиваем счет каждую секунду
setInterval(function () {
    
    scoreElement.innerText = `Счет: ${score}`;
    score++;
    // Сохраняем лучший результат
    if (score > bestScore) {
        bestScore = score;
        localStorage.setItem('bestScore', bestScore);
        bestScoreElement.innerText = `Лучший результат: ${bestScore}`;
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
    let dinoTop = parseInt(window.getComputedStyle(dino).getPropertyValue("top"));
    let cactusLeft = parseInt(window.getComputedStyle(cactus).getPropertyValue("left"));

    if (cactusLeft < 50 && cactusLeft > 0 && dinoTop >= 140) {
        alert("Game Over! Ваш счет: " + score);
        score = 0; // Сбрасываем текущий счет
        scoreElement.innerText = `Счет: ${score}`;
    }
}, 10);

document.addEventListener("keydown", function (event) {
    jump();
});
