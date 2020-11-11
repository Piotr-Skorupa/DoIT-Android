#include "todolistviewmodel.h"
#include <QDebug>
#include <fstream>
#include <QFile>
#include <QTextStream>
#include <QDataStream>
#include <QtAndroidExtras/QtAndroid>
#include <QtAndroidExtras/QAndroidJniObject>
#include <QtAndroidExtras/QAndroidIntent>
#include <QtAndroidExtras/QAndroidActivityResultReceiver>

ToDoListViewModel::ToDoListViewModel(QObject * parent)
    : QObject(parent)
{
}

ToDoModel * ToDoListViewModel::getModel()
{
    return &model;
}

void ToDoListViewModel::addElement()
{
    model.add("", false);
}

void ToDoListViewModel::updateTask(const QString& uuid, const QString& description, bool done, QColor color)
{
    model.updateTask(uuid, description, done, color);
}

void ToDoListViewModel::updateTaskColor(const QString& uuid, QColor color)
{
    model.updateTaskColor(uuid, color);
}

void ToDoListViewModel::removeElement(const QString& uuid)
{
    model.removeTask(uuid);
}

void ToDoListViewModel::saveToFile(const QString& path)
{
    qDebug() << "Saving to file: " << path;
    QFile file(path);

    if (!file.open(QIODevice::ReadWrite | QIODevice::Truncate | QIODevice::Text)) {
        qDebug() << "Can not override/write to file";
        return;
    }

    QTextStream out(&file);
    out << QString::fromStdString(model.listToString());
    file.close();
}

void ToDoListViewModel::loadFromFile(const QString& path)
{
    qDebug() << "Loading from file " << path;
    QFile file(path);

    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Can not read from file";
        return;
    }

    QTextStream in(&file);
    QList<QString> listString;
    QString line{"not empty at the begin xD"};
    while(not line.isEmpty())
    {
        line = in.readLine();
        listString.append(line);
    }
    file.close();

    model.updateFromStringList(listString);
}

void ToDoListViewModel::send(const QString& path)
{
    qDebug() << "Sending list: " << path;

    QAndroidJniObject javaShareFile = QAndroidJniObject::fromString(path);
    QAndroidJniObject::callStaticMethod<void>(
        "org/qtproject/example/activityhandler/ShareComponent",
        "share",
        "(Landroid/content/Context;Ljava/lang/String;)V",
        QtAndroid::androidContext().object(),
        javaShareFile.object<jstring>());
}

[[deprecated("Not working for this moment")]]
void ToDoListViewModel::showAlertDialog(const QString& message)
{
    // TODO: Find out why AlertDialog from Android is not creating.

    QAndroidJniObject javaDialog = QAndroidJniObject::fromString(message);
    QAndroidJniObject::callStaticMethod<void>(
        "org/qtproject/example/activityhandler/AlertDialogComponent",
        "show",
        "(Landroid/content/Context;Ljava/lang/String;)V",
        QtAndroid::androidContext().object(),
        javaDialog.object<jstring>());
}
