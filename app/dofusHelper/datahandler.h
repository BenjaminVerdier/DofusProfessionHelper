#ifndef DATAHANDLER_H
#define DATAHANDLER_H

#include <QObject>
#include <QString>
#include <QMap>

#include "database.h"

class dataHandler : public QObject
{
    Q_OBJECT
public:
    explicit dataHandler(QObject *parent = nullptr);

signals:

public slots:
    void updateItemData(const int levelLow, const int levelHigh, const QString &profession);
    void updateIngredientsData(const QList<QString> names, const QList<int> qties);
    QList<QString> itemNames();
    QList<int> itemLevels();
    QList<QString> ingredientNames() {return ingredients.keys();}
    QList<int> ingredientQties() {return ingredients.values();}

private:

    std::vector<Item*> items;
    Database* db;
    QString curProfession;
    int curLow, curHigh;
    QMap<QString, int> ingredients;

    QMap<QString, int> getRecipeFromName(QString);
};


QString qmapToCsv(QMap<QString,int> map);

#endif // DATAHANDLER_H
