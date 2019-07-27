#ifndef DATARECEIVER_H
#define DATARECEIVER_H

#include <QQuickItem>
#include <QList>
#include<QString>

class DataReceiver : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY (QList<int> qties READ qties WRITE setQties NOTIFY qtiesChanged)
    Q_PROPERTY (QList<QString> names READ names WRITE setNames NOTIFY namesChanged)
    QList<int> m_qties;
    QList<QString> m_names;
public:
    DataReceiver(QQuickItem *parent = 0) {}

    QList<int> qties() const
        {
            return m_qties;
        }
    QList<QString> names() const
        {
            return m_names;
        }

    public slots:
        void setQties (QList<int> arg)
        {
            if (m_qties != arg) {
                m_qties = arg;
                emit qtiesChanged (arg);
            }
        }
        void setNames (QList<QString> arg)
        {
            if (m_names != arg) {
                m_names = arg;
                emit namesChanged (arg);
            }
        }

    signals:
        void qtiesChanged (QList<int> arg);
        void namesChanged (QList<QString> arg);
};

#endif // DATARECEIVER_H
