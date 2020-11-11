#ifndef TODOMODEL_H
#define TODOMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QDebug>
#include <QUuid>
#include <QColor>

constexpr auto TASK_DEFAULT_COLOR = "#0000ff";

struct Task
{

    Task(const QString& description, bool done)
        : uuid(QUuid::createUuid()), description(description), done(done), color(TASK_DEFAULT_COLOR)
    {
    }

    Task(const QString& description, bool done, QString colorName)
        : uuid(QUuid::createUuid()), description(description), done(done), color(colorName)
    {
    }

    Task(const QString& uuid, const QString& description, bool done)
        : uuid(uuid), description(description), done(done), color(TASK_DEFAULT_COLOR)
    {
    }


    QUuid uuid;
    QString description;
    bool done;
    QColor color;

    friend bool operator==(const Task& lhs, const Task& rhs);
};

inline bool operator==(const Task& lhs, const Task& rhs)
{
    return lhs.uuid == rhs.uuid;
}

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
    void updateFromStringList(QList<QString>& listString);

    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    QHash<int, QByteArray> roleNames() const override;

private:
    QList<Task> items;

    void printItems();
};

#endif // TODOMODEL_H
