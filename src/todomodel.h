#ifndef TODOMODEL_H
#define TODOMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QDebug>
#include "task.h"

class ToDoModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit ToDoModel(QObject *parent = nullptr);

    enum {
        DoneRole = Qt::UserRole,
        DescriptionRole,
        UuidRole,
        ColorRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    void add(const QString& description, bool done);
    void updateTask(const QString& uuid, const QString& description, bool done, QColor color);
    void updateTaskColor(const QString& uuid, QColor color);
    void removeTask(const QString& uuid);
    std::string listToString() const;
    bool updateFromStringList(QList<QString>& listString);
    void sortList();

    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    QHash<int, QByteArray> roleNames() const override;

public:
    QString currentList;
private:
    QList<Task> items;
    void printItems();
};

#endif // TODOMODEL_H
