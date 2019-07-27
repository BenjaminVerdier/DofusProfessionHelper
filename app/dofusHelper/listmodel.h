#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QString>

#include <database.h>

class listModel : public QAbstractListModel
{
    Q_OBJECT

public:

    enum Roles {
            NameRole = Qt::UserRole + 1,
            LevelRole
        };

    explicit listModel(QObject *parent = nullptr);
    ~listModel() override;

    QHash<int, QByteArray> roleNames() const override;

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Row Insertion / Deletion Functions
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

public slots:
    void updateData(const int levelLow, const int levelHigh, const QString &profession);
    void saveResourceList(QList<QString>, QList<int>);

private:
    std::vector<Item*> items;
    Database* db;

    QMap<QString, int> getRecipeFromName(QString);
};

QString qmapToCsv(QMap<QString,int> map);

#endif // LISTMODEL_H
