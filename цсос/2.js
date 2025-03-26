const sos = [
    [1.000000, 1.645791, 1.000000, 1.000000, 1.709998, 0.986794],
    [1.000000, 1.610917, 1.000000, 1.000000, 1.707091, 0.945513],
    [1.000000, 1.517527, 1.000000, 1.000000, 1.694756, 0.836542],
    [1.000000, 1.335804, 1.000000, 1.000000, 0.607705, 0.975460],
    [1.000000, 1.103089, 1.000000, 1.000000, 0.462369, 0.892830],
    [1.000000, 0.924126, 1.000000, 1.000000, 0.010303, 0.624693],
    [1.000000, 0.840791, 1.000000, 1.000000, 0.509953, -0.236486],
]

g = 0.1517 //коэф усиления

class DirectFormFilter {
    constructor(b,a) {
        this.b = b
        this.a = a
        this.xBuffer = new Array(b.length).fill(0)
        this.yBuffer = new Array(a.length - 1).fill(0)
    }

    process(input) {
        let output = 0;

        // Обновление буфера входных данных
        this.xBuffer.unshift(input);
        this.xBuffer.pop();

        // Вычисление выходного значения
        for (let i = 0; i < this.b.length; i++) {
            output += this.b[i] * this.xBuffer[i];
        }
        for (let i = 1; i < this.a.length; i++) {
            output -= this.a[i] * this.yBuffer[i - 1];
        }
        output /= this.a[0];

        // Обновление буфера выходных данных
        this.yBuffer.unshift(output);
        this.yBuffer.pop();

        return output;
    }
}

class SOSFilter {
    constructor(sos,g) {
        this.sections = sos.map(section => new DirectFormFilter(section.slice(0,3), section.slice(3)))
        this.g = g
    }

    process(input) {
        let output = input
        for(const section of this.sections) {
            output = section.process(output)
        }
        return output * this.g
    }
}

const sosFilter = new SOSFilter(sos,g)
const inputSignal = [1, ...new Array(99).fill(0)]
const outputSignal = inputSignal.map(sample => sosFilter.process(sample))
console.log(outputSignal)

