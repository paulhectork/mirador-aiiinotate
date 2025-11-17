# mirador-aiiinotate

This repo contains an example of an integration of [aiiinotate](https://github.com/Aikon-platform/aiiinotate) with [mirador 4](https://github.com/ProjectMirador/mirador), using [mirador-annotations-editor](https://github.com/TETRAS-IIIF/mirador-annotation-editor/stargazers).

This reference implementation can be used in 2 ways:
- dev, or local usage
- prod, using Docker containers.

---

## Dev / local usage

```bash
# clone the repo and cd in it
git clone git@github.com:paulhectork/mirador-aiiinotate.git
cd mirador-aiiinotate

# setup your .env
cp .env.template .env
# here, you should manually complete your .env to your requirements

# install mongodb
bash scripts/setup_mongodb.sh

# setup the apps
npm run setup

# build and serve mirador
npm run start-dev
```

--- 

## Prod / docker usage

1. Install [Docker](https://docs.docker.com/engine/install/)
2. Setup your docker
```bash
# clone the repo and cd in it
git clone git@github.com:paulhectork/mirador-aiiinotate.git
cd mirador-aiiinotate

# setup your .env
cp .env.template .env
# here, you should manually complete your .env to your requirements

# build your docker images and serve your app
cd docker
bash docker.sh build
# after a first build, if your app has not changed, you can just serve the image you build before:
bash docker.sh start
```

---

## License 

GNU GPL 3.0
