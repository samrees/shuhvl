# shuhvl

This is a project to recreate a tool I've had in one form or another for a while.
Its job is be installed on the computers of a bunch of people who need tools, pointed
to a specific upstream update repository, and give them an easily discoverable,
self-documented hammer for getting things done.

All real work is handled in containers, and which volumes and environmental variables
are passed through to the containers is configured by the upstream.

The key bit about this tool is that it is evergreen. Whatever the maintainers of your
copy of shuhvl load into the upstream, all users will get automatically without any
work. So one install gets people a slowly growing, curated toolbox.

## This is not finished

`curl -s https://raw.githubusercontent.com/samrees/shuhvl/initial-development/shuhvl | bash -s install samrees/shuhvl yolo`
