# Deliberation-etherpad

Provides the etherpad service that creates etherpads to embed in the study

Note that the etherpad api key is set in a file, not from an environment variable, and so it is packaged up with the service when the container is built and pushed to the repo. This is dumb, as it exposes the key and means that every user of the image has to use that key...
