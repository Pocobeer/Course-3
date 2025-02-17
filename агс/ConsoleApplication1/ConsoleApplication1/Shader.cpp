#include "GL/glew.h"
#include "Shader.h"
#include <fstream>
#include <sstream>
#include <iostream>
#include <vector>

using namespace std;

bool Shader::load(string vertexShaderFilename, string fragmentShaderFilename) {
	// Создание дескрипторов вершинного и фрагментного шейдеров
	GLuint vertexShaderID = createShaderObject(GL_VERTEX_SHADER, vertexShaderFilename);
	GLuint fragmentShaderID = createShaderObject(GL_FRAGMENT_SHADER, fragmentShaderFilename);

	// Привязка скомпилированных шейдеров
	program = glCreateProgram();
	glAttachShader(program, vertexShaderID);
	glAttachShader(program, fragmentShaderID);
	glLinkProgram(program);


	// Проверка программы
	GLint linkStatus;
	int infoLogLength;

	glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
	glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLogLength);

	if (linkStatus == GL_FALSE && infoLogLength > 0) {
		vector<char> errorMessage(infoLogLength + 1);
		glGetProgramInfoLog(program, infoLogLength, NULL, errorMessage.data());
		cout << "PROGRAM LINKING ERROR:\n" << errorMessage.data() << endl;

		glDeleteProgram(program);
		program = 0;
		return false;
	}

	// Освобождение дескрипторов шейдеров
	glDeleteShader(vertexShaderID);
	glDeleteShader(fragmentShaderID);

	return true;
}

void Shader::activate() {
	glUseProgram(program);
}

void Shader::deactivate() {
	glUseProgram(0);
}

GLuint Shader::createShaderObject(GLenum shaderType, string filename) {
	// Чтение файла шейдера
	fstream fileStream(filename);

	stringstream buffer;
	buffer << fileStream.rdbuf();
	string code = buffer.str();
	fileStream.close();

	// Создание шейдерного объекта
	GLuint shaderID = glCreateShader(shaderType);

	// Компиляция шейдера
	const char* source = code.c_str();
	glShaderSource(shaderID, 1, &source, NULL);
	glCompileShader(shaderID);

	// Проверка программы
	GLint compileStatus;
	int infoLogLength;

	glGetShaderiv(shaderID, GL_COMPILE_STATUS, &compileStatus);
	glGetShaderiv(shaderID, GL_INFO_LOG_LENGTH, &infoLogLength);

	if (compileStatus == GL_FALSE && infoLogLength > 0) {
		vector<char> errorMessage(infoLogLength + 1);
		glGetShaderInfoLog(shaderID, infoLogLength, NULL, errorMessage.data());

		string type = (shaderType == GL_VERTEX_SHADER)
			? "VERTEX" : "FRAGMENT";
		cerr << "[" << type << " SHADER] COMPILATION ERROR ("
			<< filename << "):\n" << errorMessage.data() << endl;

		glDeleteShader(shaderID);
		return 0;
	}

	return shaderID;
}