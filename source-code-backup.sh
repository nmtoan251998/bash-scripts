#!/bin/bash

echo -e '\n\n'
echo -e '\t\t\t\t****************************************'
echo -e '\t\t\t\t*                                      *'
echo -e '\t\t\t\t*      |\   |  ----     _     _____    *'
echo -e '\t\t\t\t*      | \  | /    \   / \      |      *'
echo -e '\t\t\t\t*      |  \ | \    /  /___\     |      *'
echo -e '\t\t\t\t*      |   \|  ----  /     \    |      *'
echo -e '\t\t\t\t*                                      *'
echo -e '\t\t\t\t****************************************'
echo -e '\n'

CURRENT_DIR=$(pwd)

BACKUP_DIR=$CURRENT_DIR/backup
BACKEND_DIR=$BACKUP_DIR/backend
FRONTEND_DIR=$BACKUP_DIR/frontend
UI_DESIGN_DIR=$BACKUP_DIR/ui-design
RESOURCES_DIR=$BACKUP_DIR/resources

ZIP_FILE_NAME="knowllipop-source-code-v01-full.zip"
BACKEND_ZIP_FILE_NAME="backend.zip"
FRONTEND_ZIP_FILE_NAME="frontend.zip"
UI_DESIGN_ZIP_FILE_NAME="ui-design.zip"
RESOURCES_ZIP_FILE_NAME="resources.zip"

GDRIVE_BACKUP_FOLDER_NAME="SourceCodeV01_Unreleased"
GDRIVE_FOLDER_ID=1veBEQFH-fV6A5khGOTvjrwl5ZNgIEg8h
GDRIVE_ID_CONTAINER_FILE_NAME=gdrive-backup-folder-id.txt


echo '1. Clean files in existed backup folders'
rm -rf $BACKUP_DIR
echo 'Current directory: '$CURRENT_DIR

echo 'Complete deleting existed backup data in local machine (1/6)'

echo -e '\n2. Create backup folders'
mkdir $BACKUP_DIR
echo '2.1. Created backup folder, path: '$BACKUP_DIR
mkdir -p $BACKEND_DIR
echo '2.2. Created backend folder, path: '$BACKEND_DIR
mkdir -p $FRONTEND_DIR
echo '2.3. Created frontend folder, path: '$FRONTEND_DIR
mkdir -p $UI_DESIGN_DIR
echo '2.4. Created ui-design folder, path: '$UI_DESIGN_DIR
mkdir -p $RESOURCES_DIR
echo '2.5. Created resources folder, path: '$RESOURCES_DIR

echo 'Complete creating folder for storing backup source code (2/6)'

echo -e '\n3. Download source codes from gitlab'
git config --global credential.helper store
echo '3.1. Download source from backend repository'
git clone https://gitlab.com/knowllipop/backend.git $BACKEND_DIR
echo '3.2. Download source from frontend repository'
git clone https://gitlab.com/knowllipop/frontend.git $FRONTEND_DIR
echo '3.3. Download source from ui-design repository'
git clone https://gitlab.com/knowllipop/ui-design.git $UI_DESIGN_DIR
echo '3.4. Download source from resources repository'
git clone https://gitlab.com/knowllipop/resources.git $RESOURCES_DIR

echo 'Completed downloading source code from gitlab (3/6)'

echo -e '\n4. Zip source code'
echo '4.1. Zip all files'
cd $BACKUP_DIR && zip -r $ZIP_FILE_NAME backend frontend ui-design resources
echo '4.2. Zip backend files'
cd $BACKUP_DIR && zip -r $BACKEND_ZIP_FILE_NAME backend
echo '4.3. Zip frontend files'
cd $BACKUP_DIR && zip -r $FRONTEND_ZIP_FILE_NAME frontend
echo '4.4. Zip ui-design files'
cd $BACKUP_DIR && zip -r $UI_DESIGN_ZIP_FILE_NAME ui-design
echo '4.5. Zip resources files'
cd $BACKUP_DIR && zip -r $RESOURCES_ZIP_FILE_NAME resources

echo -e '\nZipped all file to '$BACKUP_DIR/$ZIP_FILE_NAME
echo 'Zipped backend source code to '$BACKUP_DIR/$BACKEND_ZIP_FILE_NAME
echo 'Zipped frontend source code to '$BACKUP_DIR/$FRONTEND_ZIP_FILE_NAME
echo 'Zipped UI design files to '$BACKUP_DIR/$UI_DESIGN_ZIP_FILE_NAME
echo 'Zipped resouces to '$BACKUP_DIR/$RESOURCES_ZIP_FILE_NAME

echo 'Completed zipping files (4/6)'

echo -e '5. Delete existed folder in Google drive'
while read -ra LINE
do
        GDRIVE_EXISTED_BACKUP_FOLDER_ID="${LINE[0]}";
done < "$CURRENT_DIR/$GDRIVE_ID_CONTAINER_FILE_NAME"
echo 'Deleted folder with id: '$GDRIVE_EXISTED_BACKUP_FOLDER_ID
gdrive delete $GDRIVE_EXISTED_BACKUP_FOLDER_ID --recursive
echo 'Completed deleting backup folders in Google drive (5/6)'


echo -e '\n6. Upload file to Google drive'
gdrive mkdir $GDRIVE_BACKUP_FOLDER_NAME --parent $GDRIVE_FOLDER_ID | cut -d ' ' -f2 > $CURRENT_DIR/$GDRIVE_ID_CONTAINER_FILE_NAME
while read -ra LINE
do
        GDRIVE_BACKUP_FOLDER_ID="${LINE[0]}";
done < "$CURRENT_DIR/$GDRIVE_ID_CONTAINER_FILE_NAME"
echo 'Backup folde name: '$GDRIVE_BACKUP_FOLDER_NAME
echo 'Backup folder id: '$GDRIVE_BACKUP_FOLDER_ID
echo '6.1. Upload full zip file'
gdrive upload --parent $GDRIVE_BACKUP_FOLDER_ID $BACKUP_DIR/$ZIP_FILE_NAME
echo '6.2. Upload backend zip file'
gdrive upload --parent $GDRIVE_BACKUP_FOLDER_ID $BACKUP_DIR/$BACKEND_ZIP_FILE_NAME
echo '6.3. Upload frontend zip file'
gdrive upload --parent $GDRIVE_BACKUP_FOLDER_ID $BACKUP_DIR/$FRONTEND_ZIP_FILE_NAME
echo '6.4. Upload ui-design zip file'
gdrive upload --parent $GDRIVE_BACKUP_FOLDER_ID $BACKUP_DIR/$UI_DESIGN_ZIP_FILE_NAME
echo '6.5. Upload resources zip file'
gdrive upload --parent $GDRIVE_BACKUP_FOLDER_ID $BACKUP_DIR/$RESOURCES_ZIP_FILE_NAME

echo 'Completed uploading files to Google drive backup folders (6/6)'


