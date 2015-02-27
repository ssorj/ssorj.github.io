.PHONY: render

render: preview_url := "file://${PWD}/_preview"
render:
	PYTHONPATH=_python _scripts/render "${preview_url}" _input _preview
	PYTHONPATH=_python _scripts/render "http://www.ssorj.net" _input .
	@echo "See the output at ${preview_url}/index.html"
