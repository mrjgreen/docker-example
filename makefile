DOCKERREPO=prod-1.joeg.co.uk:5000
APPLICATION=dockerexample

all: build install run

build:
	docker-compose build
	docker-compose run api npm install
	docker-compose run ui npm install

build-prod:
	docker-compose build
	docker-compose run api npm install
	docker-compose run ui npm install
	docker-compose -f docker-compose.yml -f docker-compose.build.prod.yml run ui npm run build
	# We use the build docker file here and only here to correctly tag our images
	docker-compose -f docker-compose.prod.yml build

test:
	docker-compose exec api npm test
	docker-compose exec ui npm test

run:
	docker-compose up

publish:
	docker-compose -f docker-compose.prod.yml push

deploy:
	scp docker-compose.prod.yml root@prod-1.joeg.co.uk:/srv/
	ssh root@prod-1.joeg.co.uk docker-compose -f /srv/docker-compose.prod.yml pull
	ssh root@prod-1.joeg.co.uk docker-compose -f /srv/docker-compose.prod.yml up -d


#################################
# Tasks required for ci steps
#################################

ci-build: build-prod

ci-publish: publish

ci-deploy: deploy

.PHONY: build install install-prod run stop test publish deploy ci ci-publish ci-deploy ci-build
