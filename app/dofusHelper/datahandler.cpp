#include "datahandler.h"

dataHandler::dataHandler(QObject *parent) : QObject(parent)
{
    db = new Database();
    db->connectToDataBase();
    ingredients = QMap<QString, int>();
}


void dataHandler::updateItemData(const int levelLow, const int levelHigh, const QString &profession) {
    curProfession = profession;
    curLow = levelLow;
    curHigh = levelHigh;
    items = db->fetchFromDatabase(levelLow, levelHigh, profession);
}


void dataHandler::updateIngredientsData(const QList<QString> names, const QList<int> qties) {
    ingredients = QMap<QString, int>();
    for (int i = 0; i < names.length(); ++i) {
        QMap<QString, int> recipe = getRecipeFromName(names[i]);
        for (auto resource : recipe.keys()) {
            if (!ingredients.contains(resource)) {
                ingredients.insert(resource, recipe[resource]*qties[i]);
            } else {
                ingredients[resource] += recipe[resource]*qties[i];
            }
        }

    }
}


QList<QString> dataHandler::itemNames() {
    QList<QString> itemNames = QList<QString>();
    for (Item* item : items) {
        itemNames.append(item->name);
    }
    return itemNames;
}


QList<int> dataHandler::itemLevels() {
    QList<int> itemlvls = QList<int>();
    for (Item* item : items) {
        itemlvls.append(item->level);
    }
    return itemlvls;
}

QMap<QString, int> dataHandler::getRecipeFromName(QString name) {
    for (Item* item : items) {
        if (item->name == name) {
            return item->recipe;
        }
    }
    return QMap<QString,int>();
}
