#pragma once

#include <QAbstractListModel>
#include <QVector>

struct AppEntry {
    QString id;
    QString name;
    QString icon; // resource path
    QString exec;
    bool isDock = false;
};

class AppModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles { IdRole = Qt::UserRole + 1, NameRole, IconRole, ExecRole, IsDockRole };
    explicit AppModel(QObject *parent = nullptr);

    // Basic model
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariantList getAllApps() const;
    Q_INVOKABLE QVariantList search(const QString &query) const;
    Q_INVOKABLE void launchApp(int index);
    Q_INVOKABLE void moveApp(int from, int to);
    Q_INVOKABLE void save();
    Q_INVOKABLE void reload();

private:
    QVector<AppEntry> m_apps;
    void loadDefaults();
    void persist();
};
