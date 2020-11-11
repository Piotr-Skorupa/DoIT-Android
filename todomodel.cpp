#include "todomodel.h"
#include <QDebug>
#include <algorithm>

ToDoModel::ToDoModel(QObject *parent)
    : QAbstractListModel(parent)
    , items{Task("Przykładowe zadanie", false)}
{
}

int ToDoModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return items.count();
}

QVariant ToDoModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    Task element = items[index.row()];
    switch (role)
    {
    case DoneRole:
        return element.done;
    case DescriptionRole:
        return element.description;
    case UuidRole:
        return element.uuid.toString();
    case ColorRole:
        return element.color;
    }

    return QVariant();
}

void ToDoModel::add(const QString& description, bool done)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    Task task(description, done);
    items.append(task);
    endInsertRows();
}

void ToDoModel::updateTask(const QString& uuid, const QString& description, bool done, QColor color)
{
    qDebug() << "Update uuid: " << uuid;
    Task task(uuid, "", false);
    int index = items.indexOf(task);
    items[index].description = description;
    items[index].done = done;
    items[index].color = color;
}

void ToDoModel::updateTaskColor(const QString& uuid, QColor color)
{
    qDebug() << "Update uuid: " << uuid;
    Task task(uuid, "", false);
    int index = items.indexOf(task);
    beginResetModel();
    items[index].color = color;
    endResetModel();
}


void ToDoModel::removeTask(const QString& uuid)
{
    qDebug() << "Remove uuid: " << uuid;

    Task task(uuid, "", false);
    int index = items.indexOf(task);
    beginRemoveRows(QModelIndex(), index, index);
    items.removeAt(index);
    endRemoveRows();

    qDebug() << "After remove:";
    printItems();
}

bool ToDoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value)
    {
        switch (role)
        {
        case DoneRole:
            items[index.row()].done = value.Bool;
        case DescriptionRole:
            items[index.row()].description = value.String;
        case UuidRole:
            items[index.row()].uuid.toString() = value.String;
        case ColorRole:
            items[index.row()].color = value.Color;
        }
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags ToDoModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> ToDoModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DoneRole] = "done";
    roles[DescriptionRole] = "description";
    roles[UuidRole] = "uuid";
    roles[ColorRole] = "color";
    return roles;
}

void ToDoModel::printItems()
{
    std::for_each(items.begin(), items.end(), [](const Task& element)
    {
       qDebug() << "Task {" << element.uuid.toString() << ", " << element.description << ", "
                << element.done << ", " << element.color.name() << "}";
    });
}

std::string ToDoModel::listToString() const
{
    std::string result{};

    result += "LISTA ZADAŃ:\n";

    int number{1};
    for (const auto & task : items)
    {
        result += std::to_string(number++) + ". " + task.description.toStdString() +
                (task.color.name() != TASK_DEFAULT_COLOR ? (" " + task.color.name().toStdString()) : "") + (task.done ? " OK\n": "\n");
    }

    return result;
}

void ToDoModel::updateFromStringList(QList<QString>& listString)
{
    if (listString.front() != "LISTA ZADAŃ:")
    {
        qDebug() << "Can not load from file. Bad file format.";
        return;
    }
    listString.pop_front();

    beginResetModel();
    items.clear();
    for (auto& qLine : listString)
    {
        auto line = qLine.toStdString();
        qDebug() << "Line: " << line.c_str();

        std::string counterPattern{". "};
        auto numberIndex = line.find(counterPattern);
        if (numberIndex != std::string::npos)
        {
            line.erase(0, numberIndex + counterPattern.length());
            qDebug() << "Line without counter: " << line.c_str();
            std::string colorStartPattern{"#"};
            auto colorIndex = line.find(colorStartPattern);
            std::string donePattern{"OK"};
            if(colorIndex == std::string::npos)
            {
                qDebug() << "There is no color pattern!";
                auto doneIndex = line.find(donePattern);
                if (doneIndex == std::string::npos)
                {
                    Task task(QString::fromStdString(line), false);
                    items.append(task);
                }
                else
                {
                    auto description = line.substr(0, doneIndex);
                    Task task(QString::fromStdString(description), true);
                    items.append(task);
                }
            }
            else
            {
               qDebug() << "There is color pattern!";
               auto description = line.substr(0, colorIndex);
               auto color = line.substr(colorIndex, 7);
               qDebug() << "Color pattern: " << color.c_str();
               auto doneIndex = line.find(donePattern);
               if (doneIndex == std::string::npos)
               {
                   Task task(QString::fromStdString(description), false, QString::fromStdString(color));
                   items.append(task);
               }
               else {
                   Task task(QString::fromStdString(description), true, QString::fromStdString(color));
                   items.append(task);
               }

            }
        }
    }
    endResetModel();
}
