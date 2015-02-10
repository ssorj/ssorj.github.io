.PHONY: render

render:
	PYTHONPATH=_python _scripts/render "file://${PWD}/_preview" _input _preview
	PYTHONPATH=_python _scripts/render "http://www.ssorj.net" _input .
