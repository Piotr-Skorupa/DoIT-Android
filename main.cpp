#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>
#include "todolistviewmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("ScorpionDev");
    QCoreApplication::setOrganizationDomain("https://piotr-skorupa.github.io/projects/");

    QGuiApplication app(argc, argv);

    qmlRegisterType<ToDoModel>("ToDo", 1, 0, "ToDoModel");
    ToDoListViewModel toDoViewModel;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("ToDoListViewModelContext", &toDoViewModel);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(url);
    view.rootContext()->setContextProperty("ToDoListViewModelContext", &toDoViewModel);
    view.show();

    return app.exec();
}
