CURRENT_DATE = $(shell date +%Y-%m-%d-%H-%M-%S )

.PHONY: deploy
deploy:
	@kubectl apply -f manifests/secret.yaml \
		-f manifests/pvc.yaml \
		-f manifests/deployment.yaml \
		-f manifests/service.yaml \
		-f manifests/cronjob.yaml

.PHONY: backup
backup:
	@kubectl create job --from=cronjob/backup-mysql-example manually-triggered-mysql-backup-$(CURRENT_DATE)

.PHONY: restore
restore:
	@kubectl apply -f manifests/restore.yaml

.PHONY: node-pool-with-proper-scope
node-pool-with-proper-scope:
	@gcloud container node-pools create gcs-write-pool \
		--scopes=https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_write
