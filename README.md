# deliberation-infrastructure

Deployment scripts for deliberation services using terraform

## Services

We have several services that have their own infrastructure:

- **experiment** is the empirica app experiment/study/lab that collects data from participants. We may spool up multiple versions of the study down the road when we have multiple researchers using the platform simultaneously and we want to be able to separate the different co-occurring batches, or even shut down this part of the infrastructure. we'll want to be able to set up and take down a 'test' environment

- **scheduler** is the empirica app that helps participants sign up for slots on mturk
- **video-coding** is the empirica app that we use to collect data from all of the videos

These are

## Shared infrastructure

There is some shared infrastructure between the different services:

- **efs** filestore is shared by the experiment, the scheduler, and the coding platform, and records information about the participants and the studies.

## Replications

- Testing vs production environment
- Replicate in different regions (US, EU, India, etc.)
- Spool up multiple experiment services if we are running different experiments simultaneously.
- Spool up an experiment service explicitly for community groups to use

Todo:

- set up each app with its own app name
- move security groups for each resource into the file with the resource itself
- have only one efs per region
- combine the ecsservice and taskdefinition files
