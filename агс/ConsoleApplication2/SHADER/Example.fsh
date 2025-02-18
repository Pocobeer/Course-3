#version 330 core 

uniform vec4 color1;
uniform vec4 color2;
uniform vec4 color3;

in vec2 fragPosition; 

out vec4 fragColor;

void main()
{
    vec4 col = color1;
    if (fragPosition.y < 0.16) 
    {
        col = color2;
    }
    if (fragPosition.y < -0.17)
    {
        col = color3;
    }
    fragColor = col;
}
