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
#include <QStandardPaths>


const QString DOWNLOAD_DIR = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
const QString SEP = "/";
const QString FILE_TYPE = ".txt";
const QString DEFAULT_FILENAME = "Lista";
const QString DEFAULT_FILENAME_PATH = DOWNLOAD_DIR + SEP + DEFAULT_FILENAME + FILE_TYPE;

ToDoListViewModel::ToDoListViewModel(QObject * parent)
    : QObject(parent)
    , currentListFile(DEFAULT_FILENAME_PATH)
{
    QFile startingFile(currentListFile);
    model.currentList = DEFAULT_FILENAME;
    if (QFile::exists(startingFile.fileName()))
    {
        qDebug() << "Default file exists! Loading.";
        loadFromFile(startingFile.fileName());
    }
    else
    {
        qDebug() << "Default file does not exist. Creating.";
        model.add("Przykładowe zadanie 1", true);
        model.add("Przykładowe zadanie 2", false);
        saveToFile(startingFile.fileName());
    }
}

ToDoModel * ToDoListViewModel::getModel()
{
    return &model;
}

QString ToDoListViewModel::getCurrentList() const
{
    return model.currentList;
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

void ToDoListViewModel::changeListName(const QString & newName)
{
    qDebug() << "Changing list name to: " << newName;
    model.currentList = newName;
    currentListFile = DOWNLOAD_DIR + SEP + newName + FILE_TYPE;
}

void ToDoListViewModel::saveToFile(const QString& path)
{
    QString readyPath{path};
    if (path.isEmpty())
    {
        readyPath = currentListFile;
    }

    qDebug() << "Saving to file: " << readyPath;
    QFile file(readyPath);

    if (!file.open(QIODevice::ReadWrite | QIODevice::Truncate)) {
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
    qDebug() << "Loading from file " << QFile::decodeName(path.toStdString().c_str());
    QFile file(path);

    if (path.isEmpty() or !file.open(QIODevice::ReadOnly))
    {
        qDebug() << "Can not read from file";
        return;
    }

    // Example Android URI:
    // content://com.android.providers.downloads.documents/document/12
    // But sometimes we can get real raw path:
    // content://com.android.providers.downloads.documents/document/raw:/storage/emulated/0/Download/Nowa lista.txt
    const std::string rawPattern{"raw:"};
    if (path.contains(rawPattern.c_str()))
    {
        auto pathStd = path.toStdString();
        auto index = pathStd.find(rawPattern);
        if (index != std::string::npos)
        {
            pathStd.erase(0, index + rawPattern.length());
        }
    }

    QTextStream in(&file);
    QList<QString> listString;
    QString line{"text just for not empty at the begin"};
    while(not line.isEmpty())
    {
        line = in.readLine();
        listString.append(line);
    }
    file.close();

    const bool updated = model.updateFromStringList(listString);
    if (updated)
    {
        currentListFile = DOWNLOAD_DIR + SEP + model.currentList + FILE_TYPE;
        qDebug() << "New current file path: " << currentListFile;

        emit currentListChange(model.currentList);
    }
    else
    {
        emit loadingFileError();
    }
}

void ToDoListViewModel::send(const QString& path)
{
    QString readyPath{path};
    if (path.isEmpty())
    {
        readyPath = currentListFile;
    }

    qDebug() << "Sending list: " << readyPath;
    saveToFile(readyPath);

    QAndroidJniObject javaShareFile = QAndroidJniObject::fromString(readyPath);
    QAndroidJniObject::callStaticMethod<void>(
        "org/qtproject/example/activityhandler/ShareComponent",
        "share",
        "(Landroid/content/Context;Ljava/lang/String;)V",
        QtAndroid::androidContext().object(),
        javaShareFile.object<jstring>());
}

void ToDoListViewModel::sort()
{
    model.sortList();
}

void ToDoListViewModel::getRealPathFromAndroidURI(const QString& path)
{
    //TODO: How to get real filename from android filedialog url ????

    QAndroidJniObject javaPath = QAndroidJniObject::fromString(path);
    QAndroidJniObject::callStaticMethod<void>(
        "org/qtproject/example/activityhandler/FilePathResolver",
        "resolve",
        "(Landroid/content/Context;Ljava/lang/String;)V",
        QtAndroid::androidContext().object(),
        javaPath.object<jstring>());
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
