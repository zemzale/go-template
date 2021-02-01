PROJECT_NAME := "<project-name>"
PKG := "<project-path>"
MIGRATION_NAME := ""

.PHONY: all build lint test clean coverage coverhtml dep vet test-all dev test-integration

all: build

build: 
	@go build -o bin/${PROJECT_NAME} -v cmd/*.go

test-all: lint test vet cilint test-integration

lint:
	@golint -set_exit_status ./...

test:
	@go test -short -tags=unit ./...

test-integration:
	@go test -short -tags=integration ./...

vet:
	@go vet ./...

cilint:
	@golangci-lint run

clean:
	@rm -rf ${PROJECT_NAME}

coverage: ## Generate global code coverage report
	./coverage.sh;

coverhtml: ## Generate global code coverage report in HTML
	./coverage.sh html;

dep: 
	@go mod download
	@go get -u golang.org/x/lint/golint
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.33.0

docker-build:
	@docker-compose build

docker-run:
	@docker-compose up -d

docker-logs:
	@docker-compose logs -f backend

docker-down:
	@docker-compose down

db-up:
	@migrate -database "postgres://crosschem:crosschem@localhost:5432/crosschem-local?sslmode=disable" -path db/migrations up

db-down:
	@migrate -database "postgres://crosschem:crosschem@localhost:5432/crosschem-local?sslmode=disable" -path db/migrations down 

db-create-migration:
	@migrate create -ext sql -dir db/migrations -seq ${MIGRATION_NAME}
