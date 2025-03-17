#define _NO_BYTETYPES 
#include <Windows.h>
#include "Texture.h"
#include <iostream>

using namespace std;

wstring stringToWideString(const string& str) {
    if (str.empty()) return wstring();

    // ����������� ������� ������ ��� ������� ��������
    int size = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, nullptr, 0);
    if (size == 0) {
        cerr << "Failed to convert string to wide string!" << endl;
        return wstring();
    }

    // ��������� ������ ��� ������� ��������
    wstring wideStr(size, 0);
    MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, &wideStr[0], size);

    return wideStr;
}

bool Texture::load(string filename) {
    // ��������� ����� �����������
    ILuint imageID;
    ilGenImages(1, &imageID);
    ilBindImage(imageID);

    // �������������� ����� ����� � ������� �������
    wstring _filenname = wstring(filename.begin(), filename.end());
    const wchar_t* wfilename = _filenname.c_str();
    //wstring wideFilename = stringToWideString(filename);

    // �������� �����������
    if (!ilLoadImage(wfilename)) {
        cerr << "Failed to load texture: " << filename << endl;
        ilDeleteImages(1, &imageID);
        return false; // �������� �� �������
    }

    // ����������� ����������� � RGBA
    if (!ilConvertImage(IL_RGBA, IL_UNSIGNED_BYTE)) {
        cerr << "Failed to convert texture: " << filename << endl;
        ilDeleteImages(1, &imageID);
        return false; // ����������� �� �������
    }

    // ��������� ������ �����������
    int width = ilGetInteger(IL_IMAGE_WIDTH);
    int height = ilGetInteger(IL_IMAGE_HEIGHT);
    unsigned char* data = ilGetData();

    // �������� ��������
    glGenTextures(1, &texIndex);
    glBindTexture(GL_TEXTURE_2D, texIndex);

    // ��������� ���������� ��������
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    // �������� ������ ��������
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    glGenerateMipmap(GL_TEXTURE_2D);

    auto err = glGetError();
    if (err != GL_NO_ERROR) {
        cout << "ERR: " << glewGetErrorString(err) << "\n";
    }

    // �������� ������ OpenGL
    err = glGetError();
    if (err != GL_NO_ERROR) {
        cerr << "OpenGL error after loading texture: " << glewGetErrorString(err) << endl;
        ilDeleteImages(1, &imageID);
        return false; // ������ OpenGL
    }

    // ������������ �������� DevIL
    ilDeleteImages(1, &imageID);

    // ������� ��������
    // glBindTexture(GL_TEXTURE_2D, 0);

    cout << "Texture successfully loaded: " << filename << endl;
    return true; // �������� �������
}

void Texture::bind(GLenum texUnit) {
    // ��������� ����������� �����
    glActiveTexture(texUnit);
    auto err = glGetError();
    if (err != GL_NO_ERROR) {
        cout << "ERR 0: " << glewGetErrorString(err) << "\n";
    }
    // �������� ��������
    glBindTexture(GL_TEXTURE_2D, texIndex);

    err = glGetError();
    if (err != GL_NO_ERROR) {
        cout << "ERR 1: " << glewGetErrorString(err) << "\n";
    }
}