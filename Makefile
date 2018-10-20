.PHONY: appImage appAPIshell appSuperuser databaseImage databaseApplyMigration databaseCreateMigratePolls databaseViewMigratePollsSQL databaseClean

appImage: databaseClean
	docker-compose build app

appAPIshell:
	docker-compose exec app bash -c "python3 manage.py shell"

appSuperuser:
	docker-compose exec app bash -c "python3 manage.py createsuperuser"

databaseImage: databaseClean
	docker-compose build postgres

# uses the Django INSTALLED_APPS setting and creates any necessary database tables according to the database settings in your mysite/settings.py
databaseApplyMigration:
	docker-compose exec app bash -c "python3 manage.py migrate"

# create a migration and database schema update after changing the Polls app models
databaseCreateMigratePolls:
	docker-compose exec app bash -c "python3 manage.py makemigrations polls"

# view existing migration as a SQL statement
databaseViewMigratePollsSQL:
	docker-compose exec app bash -c "python3 manage.py sqlmigrate polls $${MIGRATION_ID}"

databaseClean:
	sudo rm -rf ./docker/postgres/pgdata
