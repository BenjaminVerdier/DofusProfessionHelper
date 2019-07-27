#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSql>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlDatabase>
#include <QSqlResult>
#include <QString>
#include <QDebug>
#include <QMap>
#include <vector>

class Item {
public:
    QString name;
    int level;

    QMap<QString, int> recipe;

    Item(QString nm = "", int lvl = 0, QMap<QString, int> r = QMap<QString, int>()) {
        name = nm;
        level = lvl;
        recipe = r;
    }
};

class Database : public QObject
{
    Q_OBJECT
public:
    Database();
    void connectToDataBase();
    void closeDataBase();

private:
    QSqlDatabase db;

    bool openDataBase();

public slots:
    std::vector<Item*> fetchFromDatabase(const int levelLow, const int levelHigh, const QString &profession);

};

#endif // DATABASE_H
