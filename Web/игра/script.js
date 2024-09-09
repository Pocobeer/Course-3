const cactus = document.querySelector('#cactus');

document.addEventListener('keydown', event => {
    move();
});

function move() {
    if (!cactus.classList.contains('move')) {
        cactus.classList.add('move');
    }
}

const dino = document.querySelector('#dino');

document.addEventListener('keydown', event => {
    jump(event);
});

function jump(event) {
    if (!(event.code === 'Space')) {
        return;
    }
    if (!dino.classList.contains('jump')) {
        dino.classList.add('jump');
        setTimeout(function() {dino.classList.remove('jump')}, 2000);
    }
}

function isCrashed() {
    let dinoPosition = dino.getBoundingClientRect();
    let cactusPosition = cactus.getBoundingClientRect();

    return dinoPosition.right > cactusPosition.left && dinoPosition.left < cactusPosition.right && dinoPosition.bottom > cactusPosition.top;
}

setInterval(() => {
    if (isCrashed()) {
        alert('Game Over!');
    }
})
