all:
	@echo "Deploy..."
	@git add --all 
	@git commit -am "deploy"
	@git push

