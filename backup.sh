#!/bin/bash

# Количество дней хранения резервных копий
DAYS_TO_KEEP=3

# Указываем путь к папкам и файлам, которые необходимо архивировать
FOLDERS=(/var/adm/folder1 /var/adm/folder2)

# Указываем путь, где будут сохранены резервные копии
BACKUP_DIR="/var/backup"

# Создаем каталог для резервных копий, если его нет
mkdir -p "$BACKUP_DIR"

# Текущая дата для именования архивов
CURRENT_DATE=$(date +"%d.%m.%Y-%H:%M:%S")

# Создаем архивы папок
for FOLDER in "${FOLDERS[@]}"
do
    if [ -d "$FOLDER" ]; then
        echo "Backupping $FOLDER"
        # Получаем имя папки
        FOLDER_NAME=$(basename "$FOLDER")
        # Архивируем содержимое папки
        tar -cjf "$BACKUP_DIR/$FOLDER_NAME"_"$CURRENT_DATE".tbz -C "$FOLDER" .
    else
        echo "Папка $FOLDER не найдена, пропуск."
    fi
done

# После создания всех архивов скрипт назначает им права доступа 700.
chmod -R 700 "$BACKUP_DIR"

# Скрипт переходит в основную папку бэкапов и удаляет все архивы, которые были изменены более $DAYS_TO_KEEP дней назад.
cd "$BACKUP_DIR"
find . -maxdepth 1 -type f -mtime +$DAYS_TO_KEEP -print0 | xargs -0 --no-run-if-empty rm -f

# Оповещение о завершении
echo "Резервное копирование и сжатие завершены."