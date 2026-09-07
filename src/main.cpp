#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "appmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterUncreatableType<AppModel>("Lamur", 1, 0, "AppModel", "Use the appModel context property");

    QQmlApplicationEngine engine;

    AppModel model;
    engine.rootContext()->setContextProperty("appModel", &model);

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl){
        if (!obj && url == objUrl) QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
