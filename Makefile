.PHONY: appImage appAPIshell appSuperuser appRunTests databaseImage databaseApplyMigration databaseCreateMigratePolls databaseViewMigratePollsSQL databaseClean djangoFindAdminTemplates

DJANGO_PATH := $(shell python3 -c 'import django; print(django.__path__)' | sed "s/[][]//g")

# sudo to override permission errors on mounted PostgreSQL docker volume
appImage:
	sudo docker-compose build app

appAPIshell:
	docker-compose exec app bash -c "python3 manage.py shell"

appSuperuser:
	docker-compose exec app bash -c "python3 manage.py createsuperuser"

appRunTests:
	docker-compose exec app bash -c "python3 manage.py test polls"

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

djangoFindAdminTemplates:
	@echo $(DJANGO_PATH)/contrib/admin/templates/admin/base_site.html
