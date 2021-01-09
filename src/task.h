#ifndef TASK_H
#define TASK_H

#include <QColor>
#include <QString>
#include <QUuid>

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
    friend bool operator<(const Task& lhs, const Task& rhs);
};

inline bool operator==(const Task& lhs, const Task& rhs)
{
    return lhs.uuid == rhs.uuid;
}

inline bool operator<(const Task& lhs, const Task& rhs)
{
    return lhs.color.name() < rhs.color.name();
}

#endif // TASK_H
