#include <QMap>
#include <QFileDialog>

#include "listmodel.h"

listModel::listModel(QObject *parent)
    : QAbstractListModel(parent)
{
    db = new Database();
    db->connectToDataBase();
}

listModel::~listModel() {
    db->closeDataBase();
}

QVariant listModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
    return QVariant();
}

QHash<int, QByteArray> listModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[LevelRole] = "level";
    return roles;
}

int listModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return items.size();
}

QVariant listModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    Item* curItem = items[index.row()];
    if (role == NameRole) {
        return curItem->name;
    } else {
        return curItem->level;
    }
}

void listModel::updateData(const int levelLow, const int levelHigh, const QString &profession) {
    curProfession = profession;
    curLow = levelLow;
    curHigh = levelHigh;
    if (items.size()>0)
        removeRows(0, items.size());
    items = db->fetchFromDatabase(levelLow, levelHigh, profession);
    if (items.size()>0)
        insertRows(0, items.size());
}


bool listModel::insertRows(int row, int count, const QModelIndex &parent) {
    beginInsertRows(QModelIndex(), row, row+count-1);
    endInsertRows();
    return true;
}
bool listModel::removeRows(int row, int count, const QModelIndex &parent) {
    beginRemoveRows(QModelIndex(), row, row+count-1);
    endRemoveRows();
    return true;
}

void listModel::saveResourceList(QList<QString> names, QList<int> qties) {
    QMap<QString, int>ingredients = QMap<QString, int>();
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
    QString csv = qmapToCsv(ingredients);
    QString filename = curProfession + "_" + QString::number(curLow) + "_" + QString::number(curHigh) + ".csv";
    QFile file(filename);
    file.open(QIODevice::WriteOnly);
    QTextStream outstream(&file);
    outstream << csv;
    file.close();

}

QMap<QString, int> listModel::getRecipeFromName(QString name) {
    for (Item* item : items) {
        if (item->name == name) {
            return item->recipe;
        }
    }
}

QString qmapToCsv(QMap<QString,int> map) {
    QString csvContent = "";
    for (QString key : map.keys()) {
        csvContent.append(key + "," + QString::number(map[key]) + "\n");
    }
    return csvContent;
}
