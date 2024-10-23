#include "Display.h"


// ��������� ���������� ��� �������� FPS
static int frameCount = 0;                // ���������� ������
static float fps = 0.0f;                  // ������� FPS
static LARGE_INTEGER frequency;            // ������� �������
static LARGE_INTEGER lastTime;             // ����� ���������� ���������� FPS

// ������� ��� ��������� �������� ����
void reshape(int w, int h) {
    glViewport(0, 0, (GLsizei)w, (GLsizei)h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(25.0, (float)w / h, 0.2, 70.0);
}

// ������� ���������� ��� ����������� ����
void display(void) {
    // ������������� ������� ������� ��� ������ ������
    if (frameCount == 0) {
        QueryPerformanceFrequency(&frequency);
        QueryPerformanceCounter(&lastTime);
    }

    // ��������� ������� ������
    frameCount++;

    // �������� ������� �����
    LARGE_INTEGER currentTime;
    QueryPerformanceCounter(&currentTime);

    // ��������� ��������� �����
    float deltaTime = static_cast<float>(currentTime.QuadPart - lastTime.QuadPart) / frequency.QuadPart;

    // ���� ������ ���� �������, ��������� FPS
    if (deltaTime >= 1.0f) {
        fps = frameCount / deltaTime;  // ������������ FPS
        frameCount = 0;                 // ���������� ������� ������
        lastTime = currentTime;         // ��������� ����� ���������� ����������
    }

    // ��������� ��������� ����
    char title[50];
    sprintf_s(title, "Laba_08 - FPS: %.2f", fps);
    glutSetWindowTitle(title);

    // ������� ������
    glClearColor(0.00, 0.00, 0.00, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);



    camera.apply();

    lights[0].apply();
    renderScene();

    if (meshLoaded) {
        mesh->draw(); // �������� ����� draw � ������� mesh
        //cout << "mdksw" << endl;
    }
    else {
        //cout << "mesh not loaded" << endl;
    }

    // ������ �������� � ������ ������
    glutSwapBuffers();
}

