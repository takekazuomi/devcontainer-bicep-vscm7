help::	## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

up:: 	## up serve
	@docker run --rm --init --name marp -v ${PWD}/docs:/home/marp/app -e LANG=${LANG} -p 8081:8080 -p 37717:37717 marpteam/marp-cli -s --allow-local-files .

down::	## stop
	@docker stop marp

pdf::	## pdf
	@mkdir -p docs/tmp; \
	docker run --rm --init -u `id -u ${USER}` \
		-v ${PWD}/docs:/home/marp/app/ -e LANG=${LANG} \
		marpteam/marp-cli \
		20201194-vscode-meetup7-bicep-devcon.md \
		-o tmp/20201194-vscode-meetup7-bicep-devcon.pdf \
		--pdf --allow-local-files

marp::	## marp-cli
	@docker run --rm --init -u `id -u ${USER}` \
		-v ${PWD}/docs:/home/marp/app/ -e LANG=${LANG} \
		marpteam/marp-cli
