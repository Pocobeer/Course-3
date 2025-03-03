#include "GL/glew.h"
#include "Shader.h"
#include <fstream>
#include <sstream>
#include <iostream>
#include <vector>

using namespace std;

GLuint Shader::currentProgram = 0;

bool Shader::load(string vertexShaderFilename, string fragmentShaderFilename) {
	// �������� ������������ ���������� � ������������ ��������
	GLuint vertexShaderID = createShaderObject(GL_VERTEX_SHADER, vertexShaderFilename);
	GLuint fragmentShaderID = createShaderObject(GL_FRAGMENT_SHADER, fragmentShaderFilename);

	// �������� ���������������� ��������
	program = glCreateProgram();
	glAttachShader(program, vertexShaderID);
	glAttachShader(program, fragmentShaderID);
	glLinkProgram(program);


	// �������� ���������
	GLint linkStatus;
	int infoLogLength;

	glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
	glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLogLength);

	if (linkStatus == GL_FALSE && infoLogLength > 0) {
		vector<char> errorMessage(infoLogLength + 1);
		glGetProgramInfoLog(program, infoLogLength, NULL, errorMessage.data());
		cerr << "PROGRAM LINKING ERROR:\n" << errorMessage.data() << endl;

		glDeleteProgram(program);
		program = 0;
		return false;
	}

	// ������������ ������������ ��������
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

void Shader::setUniform(std::string name, int value) {
	//if (program != currentProgram) activate();
	glUniform1i(getUniformLocation(name), value);
}

void Shader::setUniform(std::string name, float value) {
	//if (program != currentProgram) activate();
	glUniform1f(getUniformLocation(name), value);
}

void Shader::setUniform(std::string name, glm::vec2& value) {
	//if (program != currentProgram) activate();
	glUniform2fv(getUniformLocation(name), 1, &value[0]);
}

void Shader::setUniform(std::string name, glm::vec4& value) {
	//if (program != currentProgram) activate();
	glUniform4fv(getUniformLocation(name), 1, &value[0]);
}

void Shader::setUniform(string name, glm::mat4& value) {
	//if (program != currentProgram) activate();
	glUniformMatrix4fv(getUniformLocation(name), 1, GL_FALSE, &value[0][0]);
}

GLuint Shader::getUniformLocation(string name) {
	auto obj = uniforms.find(name);
	if (obj != uniforms.end()) {
		return obj->second;
	}

	GLuint location = glGetUniformLocation(program, name.c_str());

	if (location == GL_INVALID_OPERATION || location < 0) {
		cout << "Uniform '" << name << "' not found" << endl;
	}
	uniforms[name] = location;
	return location;
}

GLuint Shader::createShaderObject(GLenum shaderType, string filename) {
	// ������ ����� �������
	fstream fileStream(filename);

	stringstream buffer;
	buffer << fileStream.rdbuf();
	string code = buffer.str();
	fileStream.close();

	// �������� ���������� �������
	GLuint shaderID = glCreateShader(shaderType);

	// ���������� �������
	const char* source = code.c_str();
	glShaderSource(shaderID, 1, &source, NULL);
	glCompileShader(shaderID);

	// �������� ���������
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