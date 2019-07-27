#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "Database.h"
#include "listmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    listModel* myModel = new listModel();
    engine.rootContext()->setContextProperty("myModel",myModel);

    engine.load(url);

    return app.exec();
}
