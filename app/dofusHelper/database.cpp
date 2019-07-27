#include "Database.h"


Database::Database() : QObject (nullptr)
{

}

void Database::connectToDataBase() {
    this->openDataBase();
}

bool Database::openDataBase() {
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setHostName("dofusDb");
    db.setDatabaseName("C:/Users/Benjamin/Documents/apps/dofus professions helper/db/dofus.db");
    if(db.open()){
        return true;
    } else {
        return false;
    }
}

void Database::closeDataBase() {
    db.close();

}

std::vector<Item*> Database::fetchFromDatabase(const int levelLow, const int levelHigh, const QString &profession) {
    QString types = "";
    if (profession == "Artificier") {
        types = "(type = 'Bouclier' OR type = 'Trophée')";
    } else if (profession == "Carver") {
        types = "(type = 'Arc' OR type = 'Baguette' OR type = 'Bâton')";
    } else if (profession == "Jeweller") {
        types = "(type = 'Anneau' OR type = 'Amulette')";
    } else if (profession == "Shoemaker") {
        types = "(type = 'Ceinture' OR type = 'Bottes')";
    } else if (profession == "Smith") {
        types = "(type = 'Hache' OR type = 'Épée' OR type = 'Dague' OR type = 'Marteau' OR type = 'Pelle' OR type = 'Faux' OR type = 'Pioche')";
    } else if (profession == "Tailor") {
        types = "(type = 'Chapeau' OR type = 'Cape')";
    }
    QSqlQuery query;
    if(!query.exec( "SELECT * FROM equipments WHERE (level BETWEEN " + QString::number(levelLow) + " AND " + QString::number(levelHigh) + ") AND " + types + " ORDER BY level;"
                    )){

        qDebug() << query.lastError();
        return std::vector<Item*>();
    } else {
        std::vector<Item*> items = std::vector<Item*>();
        while (query.next()) {
                Item *item = new Item();
                item->name = query.value(1).toString();
                item->level = query.value(2).toInt();
                QStringList splitRecipe = query.value(4).toString().split(",");
                for (QString ingredient : splitRecipe) {
                    QStringList split = ingredient.split(":");
                    item->recipe.insert(split[0], split[1].toInt());
                }
                items.push_back(item);
            }
        return items;
    }
}
