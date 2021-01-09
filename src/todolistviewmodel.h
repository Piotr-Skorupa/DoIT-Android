#ifndef TODOLISTVIEWMODEL_H
#define TODOLISTVIEWMODEL_H

#include <QObject>

#include "todomodel.h"

class ToDoListViewModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ToDoModel * model READ getModel CONSTANT)
    Q_PROPERTY(QString currentList READ getCurrentList CONSTANT)

public:
    explicit ToDoListViewModel(QObject * parent = nullptr);

    Q_INVOKABLE void addElement();
    Q_INVOKABLE void updateTask(const QString& uuid, const QString& description, bool done, QColor color);
    Q_INVOKABLE void updateTaskColor(const QString& uuid, QColor color);
    Q_INVOKABLE void removeElement(const QString& uuid);
    Q_INVOKABLE void saveToFile(const QString& path);
    Q_INVOKABLE void loadFromFile(const QString& path);
    Q_INVOKABLE void send(const QString& path);
    Q_INVOKABLE void changeListName(const QString& newName);
    Q_INVOKABLE void sort();

    ToDoModel * getModel();
    QString getCurrentList() const;

signals:
    void currentListChange(const QString& newName);
    void loadingFileError();
public slots:

private:
    ToDoModel model;
    QString currentListFile;

    void getRealPathFromAndroidURI(const QString& path);
    void showAlertDialog(const QString& message);
};

#endif // TODOLISTVIEWMODEL_H
