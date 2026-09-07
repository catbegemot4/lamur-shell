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
    const QUrl localUrl = QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/../qml/Main.qml");

    // Try loading from resources first
    engine.load(url);

    // If resource load failed, fall back to loading QML from the filesystem (useful during development)
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load" << url << "- falling back to local QML:" << localUrl;
        engine.load(localUrl);
    }

    // If still empty, exit with error
    if (engine.rootObjects().isEmpty()) {
        QCoreApplication::exit(-1);
        return -1;
    }

    return app.exec();
}
