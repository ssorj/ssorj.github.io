.PHONY: render clean

render: preview_url := "file://${PWD}/_preview"
render: clean
	transom render --force --site-url "${preview_url}" _input _preview
	transom render --force --site-url "http://www.ssorj.net" _input .
	@echo "See the output at ${preview_url}/index.html"

clean:
	rm -rf _preview
