docker run -it --rm -p 80:4000  -v ${PWD}/docs:/docs --name=ka-api-docs-prod kenoantigen/ka-api-docs /bin/bash
# now do 'jekyll serve'

