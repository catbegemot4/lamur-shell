#include "appmodel.h"
#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>

AppModel::AppModel(QObject *parent)
    : QAbstractListModel(parent)
{
    reload();
}

int AppModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_apps.size();
}

QVariant AppModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_apps.size()) return {};
    const AppEntry &e = m_apps.at(index.row());
    switch (role) {
    case IdRole: return e.id;
    case NameRole: return e.name;
    case IconRole: return e.icon;
    case ExecRole: return e.exec;
    case IsDockRole: return e.isDock;
    default: return {};
    }
}

QHash<int, QByteArray> AppModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[ExecRole] = "exec";
    roles[IsDockRole] = "isDock";
    return roles;
}

QVariantList AppModel::getAllApps() const
{
    QVariantList list;
    for (const auto &e : m_apps) {
        QVariantMap m;
        m["id"] = e.id;
        m["name"] = e.name;
        m["icon"] = e.icon;
        m["exec"] = e.exec;
        m["isDock"] = e.isDock;
        list.append(m);
    }
    return list;
}

QVariantList AppModel::search(const QString &query) const
{
    QVariantList list;
    if (query.trimmed().isEmpty()) return list;
    const QString q = query.trimmed().toLower();
    for (int i = 0; i < m_apps.size(); ++i) {
        const AppEntry &e = m_apps.at(i);
        if (e.name.toLower().contains(q)) {
            QVariantMap m;
            m["index"] = i;
            m["id"] = e.id;
            m["name"] = e.name;
            m["icon"] = e.icon;
            m["exec"] = e.exec;
            list.append(m);
        }
    }
    return list;
}

void AppModel::launchApp(int index)
{
    if (index < 0 || index >= m_apps.size()) return;
    const AppEntry &e = m_apps.at(index);
    qDebug() << "Launching app:" << e.name << "exec=" << e.exec;
    // For now just log. In future, integrate platform-specific launching.
}

void AppModel::moveApp(int from, int to)
{
    if (from == to) return;
    if (from < 0 || from >= m_apps.size()) return;
    if (to < 0) to = 0;
    if (to >= m_apps.size()) to = m_apps.size()-1;

    beginResetModel();
    AppEntry e = m_apps.at(from);
    m_apps.remove(from);
    m_apps.insert(to, e);
    endResetModel();
    persist();
}

void AppModel::save()
{
    persist();
}

void AppModel::reload()
{
    // try to load from disk
    QString dir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dir);
    QString path = dir + QDir::separator() + "apps.json";
    QFile f(path);
    if (f.open(QIODevice::ReadOnly)) {
        QByteArray data = f.readAll();
        f.close();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (doc.isArray()) {
            m_apps.clear();
            QJsonArray arr = doc.array();
            for (const QJsonValue &v : arr) {
                if (!v.isObject()) continue;
                QJsonObject o = v.toObject();
                AppEntry e;
                e.id = o.value("id").toString();
                e.name = o.value("name").toString();
                e.icon = o.value("icon").toString();
                e.exec = o.value("exec").toString();
                e.isDock = o.value("isDock").toBool(false);
                m_apps.append(e);
            }
            beginResetModel(); endResetModel();
            return;
        }
    }
    // otherwise load defaults
    loadDefaults();
    persist();
}

void AppModel::loadDefaults()
{
    m_apps.clear();
    auto add = [&](const QString &id, const QString &name, const QString &icon, bool dock=false){
        AppEntry e; e.id = id; e.name = name; e.icon = icon; e.exec = QString(); e.isDock = dock; m_apps.append(e);
    };
    add("phone","Phone","qrc:/resources/icons/phone.svg", true);
    add("messages","Messages","qrc:/resources/icons/messages.svg", true);
    add("safari","Safari","qrc:/resources/icons/safari.svg", true);
    add("settings","Settings","qrc:/resources/icons/settings.svg");
    add("notes","Notes","qrc:/resources/icons/dock1.svg");
    add("files","Files","qrc:/resources/icons/dock2.svg");
    add("camera","Camera","qrc:/resources/icons/dock3.svg");
    add("music","Music","qrc:/resources/icons/dock4.svg");
    beginResetModel(); endResetModel();
}

void AppModel::persist()
{
    QString dir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dir);
    QString path = dir + QDir::separator() + "apps.json";
    QFile f(path);
    if (!f.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to write" << path;
        return;
    }
    QJsonArray arr;
    for (const AppEntry &e : qAsConst(m_apps)) {
        QJsonObject o;
        o["id"] = e.id;
        o["name"] = e.name;
        o["icon"] = e.icon;
        o["exec"] = e.exec;
        o["isDock"] = e.isDock;
        arr.append(o);
    }
    QJsonDocument doc(arr);
    f.write(doc.toJson());
    f.close();
}
