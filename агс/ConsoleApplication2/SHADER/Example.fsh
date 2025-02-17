#version 330 core 

uniform vec4 color1;
uniform vec4 color2;
uniform vec4 color3;

in vec2 position; 
out vec4 fragColor;

void main()
{
    float gradient = position.y + 0.5; 
    fragColor = color1 * gradient + color2 * (1.0 - gradient) + color3 * (1.0 - 2 * gradient);
}
