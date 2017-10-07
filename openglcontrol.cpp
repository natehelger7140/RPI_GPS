#include "openglcontrol.h"
#include <QOpenGLContext>
#include <QQuickWindow>
#include <iostream> //for cout debugging

void OpenGLControl::paint()
{
    QOpenGLContext *c = ourwindow->openglContext();
    QOpenGLFunctions_1_1 *f = c->versionFunctions<QOpenGLFunctions_1_1>();
    f->initializeOpenGLFunctions();
    //f->glClearColor( red, green, blue, 1.0f);
    f->glClearColor(0.22f,0.2858f,0.16f , 1.0f);
    f->glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    f->glCullFace(GL_BACK);
    f->glClear(GL_COLOR_BUFFER_BIT);
    ourwindow->resetOpenGLState();
    std::cout << "." << std::flush;
}

OpenGLControl::OpenGLControl()
{
}

OpenGLControl::~OpenGLControl()
{
}


